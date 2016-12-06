//
//  FRConfigurationManager.m
//  Rent House Agenda
//
//  Created by Marvin Avila Kotliarov on 4/13/16.
//  Copyright © 2016 Marvin Avila Kotliarov. All rights reserved.
//

#import "FRConfigurationManager.h"
#import <zlib.h>
#import <CommonCrypto/CommonHMAC.h>
#import "UICKeyChainStore.h"
#import "FRBooking.h"
#import "FRState.h"
#import "NSDate+FSExtension.h"
#import "AppDelegate.h"
#import "FRGlobals.h"
#import "FRLanguage.h"
#import "FRDBUtils.h"

NSString* const SecurityErrorDomain = @"ValidateSecurityErrorDomain";

//#define DB_DEFAULT_SECRET_WORD @"!TB+UQEQeA,t"
#define APP_DEFAULT_SECRET_WORD @"123456"

//#define DEVICE_ID_WORD @"89a05683d1f9ffa6ceb125fed45af71379f02dc0" //Kevin iPhone 5

//#define DEVICE_ID_WORD @"2f9b9b6121b98a0835b4f434ca417273bd7463f4" //Tata iPhone 5
#define DEVICE_ID_WORD @"9fa8a1d308c3cb918977d63de2d2aab5b83383b5" //Tato iPhone 5
//#define DEVICE_ID_WORD @"22e4c8f26454b9abf4e7ecae3bb4706356c187aa" //Tato iPhone 5S

//#define DEVICE_ID_WORD @"0d181f5310ece9319d4056387a55c935b19aa22f" //iPhone 6 Pablo
//#define DEVICE_ID_WORD @"9fa8a1d308c3cb918977d63de2d2aab5b83383b5" //Iphone 4 Pablo

//#define DB_DEFAULT_SECRET_KEY @"DB_Secret_Key"
#define APP_DEFAULT_SECRET_KEY @"APP_Secret_Key"
#define DEVICE_ID_SECRET_KEY @"DEVICE_ID_Secret_Key"
#define APP_CHECK_PASSWORD_KEY @"APP_Check_Password_Key"
#define APP_ACTIVATION_DATE_KEY @"APP_Activation_Date_Key"
//#define APP_REGISTER_LOCAL_NOTIFICATIONS_KEY @"APP_Register_Local_Notifications_Key"
//#define SCHEDULED_NOTIFICATIONS_KEY @"Scheduled_Notifications_Key"

@interface FRConfigurationManager ()

//@property (nonatomic, strong) NSString *dbSecretWord;
@property (nonatomic, strong) NSString *appSecretWord;

@end

@implementation FRConfigurationManager

#pragma mark - View lifecycle

+ (instancetype)sharedInstance
{
    static id instance;
    static dispatch_once_t fs_sharedDateFormatter_onceToken;
    dispatch_once(&fs_sharedDateFormatter_onceToken, ^{
        instance = [[FRConfigurationManager alloc] init];
    });
    return instance;
}

#pragma mark - Private

-(NSString *) hashString :(NSString *) data withSalt: (NSString *) salt {
    
    const char *cKey  = [salt cStringUsingEncoding:NSUTF8StringEncoding];
    const char *cData = [data cStringUsingEncoding:NSUTF8StringEncoding];
    unsigned char cHMAC[CC_SHA256_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA256, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    
    NSString *hash;
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA256_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", cHMAC[i]];
    hash = output;
    return hash;
}

- (NSString *)crc32String {
    
    NSArray *_paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *_documentsDirectory = [_paths objectAtIndex:0];
    NSString *_dbPath =  [_documentsDirectory stringByAppendingPathComponent:DB_FILE_NAME];
    
    NSData *_data = [NSData dataWithContentsOfFile:_dbPath];
    unsigned long result = crc32(0, _data.bytes, _data.length);

    return [NSString stringWithFormat:@"%ld", result];
}

#pragma mark - Getters and Setters

- (NSString *)appSecretWord {
    
    return [UICKeyChainStore stringForKey:APP_DEFAULT_SECRET_KEY];
}

- (NSString *)deviceIdSecretWord {
    
    return [UICKeyChainStore stringForKey:DEVICE_ID_SECRET_KEY];
}

- (NSString *)activationDate {
    
    return [UICKeyChainStore stringForKey:APP_ACTIVATION_DATE_KEY];
}

#pragma mark - Public

- (BOOL)allowCheckPassword {
    
    NSString *strValue = [UICKeyChainStore stringForKey:APP_CHECK_PASSWORD_KEY];
    
    return strValue == nil ? YES : (BOOL)[strValue intValue];
}

- (void)setAllowCheckPassword:(BOOL)value {
    
    [UICKeyChainStore setString:[NSString stringWithFormat:@"%d", value] forKey:APP_CHECK_PASSWORD_KEY];
}

- (void)updateAppSecretWord:(NSString *)secretWord {
    
    [UICKeyChainStore setString:[self hashString:secretWord?:APP_DEFAULT_SECRET_WORD withSalt:self.deviceIdSecretWord] forKey:APP_DEFAULT_SECRET_KEY];
}

- (BOOL)checkAppSecretWord:(NSString *)secretWord error:(NSError **)error {
    
    if (![self checkDeviceId:error]) {
        
        return NO;
    }
    
    if (self.appSecretWord == nil) {
        
        if (error) {
            *error = [NSError errorWithDomain:SecurityErrorDomain code:SecurityEmptyPasswordErrorType userInfo:[NSDictionary dictionaryWithObjectsAndKeys:LANG_ERROR_NOT_SAVED_PASSWORD, NSLocalizedDescriptionKey, nil]];
        }
        
        return NO;
    }
    
    if (![self.appSecretWord isEqualToString:[self hashString:secretWord withSalt:self.deviceIdSecretWord]]) {
        
        if (error) {
            *error = [NSError errorWithDomain:SecurityErrorDomain code:SecurityBadPasswordErrorType userInfo:[NSDictionary dictionaryWithObjectsAndKeys:LANG_ERROR_WRONG_PASSWORD, NSLocalizedDescriptionKey, nil]];
        }
        
        return NO;
    }
    
    return YES;
}

- (void)removeAppSecretWord {
    
    [UICKeyChainStore removeItemForKey:APP_DEFAULT_SECRET_KEY];
}

- (BOOL)checkDeviceId:(NSError **)error {
    
    BOOL ret = self.deviceIdSecretWord != nil && [self.deviceIdSecretWord isEqualToString:DEVICE_ID_WORD];
    
    if (!ret) {
        
        if (error) {
            
            *error = [NSError errorWithDomain:SecurityErrorDomain code:SecurityBadDeviceIdErrorType userInfo:[NSDictionary dictionaryWithObjectsAndKeys:LANG_ERROR_DEVICE_CHECK, NSLocalizedDescriptionKey, nil]];
        }
    }
    
    return ret;
}

- (void)updateDeviceIdWord:(NSString *)deviceIdWord {
        
        [UICKeyChainStore setString:deviceIdWord?:DEVICE_ID_WORD forKey:DEVICE_ID_SECRET_KEY];
}

- (void)removeDeviceId {
    
    [UICKeyChainStore removeItemForKey:DEVICE_ID_SECRET_KEY];
}

- (BOOL)fireActivationDate:(NSError **)error {
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = ACTIVATION_DATE_FORMAT;
    NSDate *d = [df dateFromString:self.activationDate];
    
    BOOL ret = self.activationDate != nil && [[d.fs_dateByIgnoringTimeComponents fs_dateByAddingDays:ACTIVATION_PERIOD_IN_DAYS] compare:[NSDate date].fs_dateByIgnoringTimeComponents] != NSOrderedDescending;
    
    if (ret) {
        
        if (error) {
            
            *error = [NSError errorWithDomain:SecurityErrorDomain code:SecurityActivationDateType userInfo:[NSDictionary dictionaryWithObjectsAndKeys:LANG_ERROR_TRIAL_EXPIRED, NSLocalizedDescriptionKey, nil]];
        }
    }
    
    return ret;
}

- (void)setActivationDate {
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = ACTIVATION_DATE_FORMAT;
    [UICKeyChainStore setString:[df stringFromDate:[NSDate date]] forKey:APP_ACTIVATION_DATE_KEY];
}

- (void)removeActiovationDate {
    
    [UICKeyChainStore removeItemForKey:APP_ACTIVATION_DATE_KEY];
}

@end
