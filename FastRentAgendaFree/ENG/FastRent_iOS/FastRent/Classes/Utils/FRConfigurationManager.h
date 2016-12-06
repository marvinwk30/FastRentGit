//
//  FRConfigurationManager.h
//  Rent House Agenda
//
//  Created by Marvin Avila Kotliarov on 4/13/16.
//  Copyright © 2016 Marvin Avila Kotliarov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum {
    SecurityBadDeviceIdErrorType,
    SecurityBadPasswordErrorType,
    SecurityEmptyPasswordErrorType,
    SecurityActivationDateType,
} ValidateSecurityErrorType;

#define APPLY_SECURITY_POLICY NO
#define APPLY_ACTIVATION_DATE YES

#define ACTIVATION_PERIOD_IN_DAYS 30

@class FRBooking;

@interface FRConfigurationManager : NSObject

+ (instancetype)sharedInstance;

@property (nonatomic, readonly) NSString *deviceIdSecretWord;
@property (nonatomic, readonly) NSString *activationDate;
@property (nonatomic, readonly) NSString *appSecretWord;
@property (nonatomic) BOOL allowCheckPassword;

- (void)updateAppSecretWord:(NSString *)secretWord;
- (BOOL)checkAppSecretWord:(NSString *)secretWord error:(NSError **)error;
- (void)removeAppSecretWord;

- (BOOL)checkDeviceId:(NSError **)error;
- (void)updateDeviceIdWord:(NSString *)deviceIdWord;
- (void)removeDeviceId;

- (BOOL)fireActivationDate:(NSError **)error;
- (void)setActivationDate;
- (void)removeActiovationDate;

@end
