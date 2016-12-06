//
//  FRNotificationManager.m
//  Rent House Agenda
//
//  Created by Marvin Avila Kotliarov on 9/13/16.
//  Copyright © 2016 Marvin Avila Kotliarov. All rights reserved.
//

#import "FRNotificationManager.h"
#import "FRBooking.h"
#import "FRState.h"
#import "NSDate+FSExtension.h"
#import "AppDelegate.h"
#import "UICKeyChainStore.h"
#import "FRGlobals.h"
#import "FRLanguage.h"

#define APP_REGISTER_LOCAL_NOTIFICATIONS_KEY @"APP_Register_Local_Notifications_Key"
#define SCHEDULED_NOTIFICATIONS_KEY @"Scheduled_Notifications_Key"

@implementation FRNotificationManager

+ (instancetype)sharedInstance
{
    static id instance;
    static dispatch_once_t fs_sharedDateFormatter_onceToken;
    dispatch_once(&fs_sharedDateFormatter_onceToken, ^{
        instance = [[FRNotificationManager alloc] init];
    });
    return instance;
}

- (instancetype)init {
    
    if (!(self = [super init]))
        return nil;
    
    _notifiedBookings = [[NSMutableArray alloc] init];
    
    return self;
}

- (BOOL)registeredForLocalNotifications {
    
    NSString *strValue = [UICKeyChainStore stringForKey:APP_REGISTER_LOCAL_NOTIFICATIONS_KEY];
    
    return strValue == nil ? NO : (BOOL)[strValue intValue];
}

- (void)setRegisteredForLocalNotifications:(BOOL)value {
    
    [UICKeyChainStore setString:[NSString stringWithFormat:@"%d", value] forKey:APP_REGISTER_LOCAL_NOTIFICATIONS_KEY];
}

- (UILocalNotification *)notificationForBooking:(FRBooking *)booking {
    
    if (![self.notifiedBookings count])
        return nil;
    
    for (UILocalNotification *n in self.notifiedBookings) {
        
        NSNumber *dbId = [n.userInfo objectForKey:NOTIFICATION_BOOKING_DBID_KEY];
        
        if ([dbId integerValue] == booking.bookingDBId)
            return n;
    }
    
    return nil;
}

- (UILocalNotification *)localNotificationForBooking:(FRBooking *)booking {
    
    if (![[[UIApplication sharedApplication] scheduledLocalNotifications] count])
        return nil;
    
    for (UILocalNotification *ln in [[UIApplication sharedApplication] scheduledLocalNotifications]) {
        
        NSInteger dbId = [[ln.userInfo objectForKey:NOTIFICATION_BOOKING_DBID_KEY] integerValue];
        
        if (dbId == booking.bookingDBId)
            return ln;
    }
    
    return nil;
    
}

- (BOOL)deleteNotificationForBooking:(FRBooking *)booking {
    
    UILocalNotification *n = [self notificationForBooking:booking];
    UILocalNotification *localNotification = [self localNotificationForBooking:booking];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = LOG_DATE_FORMAT;
    
    if (n != nil) {
        
        if (booking.bookingStatus == BookingStatusFinished || [booking.bookingArriveDate.fs_dateByIgnoringTimeComponents compare:n.fireDate.fs_dateByIgnoringTimeComponents] != NSOrderedSame || [booking.bookingDepartureDate.fs_dateByIgnoringTimeComponents compare:n.fireDate.fs_dateByIgnoringTimeComponents] != NSOrderedSame) {
            
            [self.notifiedBookings removeObject:n];
            //self.scheduledNotifications--;
//            NSLog(@"Deleted notification:%@ %@ %d local:%d", [df stringFromDate:n.fireDate], n.alertBody, (int)self.notifiedBookings.count, (int)[[UIApplication sharedApplication] scheduledLocalNotifications].count);
            n = nil;
        }
    }
    
    if (localNotification) {
        
        if (booking.bookingStatus == BookingStatusFinished || [booking.bookingArriveDate.fs_dateByIgnoringTimeComponents compare:localNotification.fireDate.fs_dateByIgnoringTimeComponents] != NSOrderedSame || [booking.bookingDepartureDate.fs_dateByIgnoringTimeComponents compare:localNotification.fireDate.fs_dateByIgnoringTimeComponents] != NSOrderedSame) {
            
            [[UIApplication sharedApplication] cancelLocalNotification:localNotification];
//            NSLog(@"Deleted local notification:%@ %@ %d local:%d", [df stringFromDate:localNotification.fireDate], localNotification.alertBody, (int)self.notifiedBookings.count, (int)[[UIApplication sharedApplication] scheduledLocalNotifications].count);
        }
    }
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = self.notifiedBookings.count; //OJO
    
    return n == nil;
}

- (void)scheduleNotificationsForBooking:(FRBooking *)booking {
    
    if (![self deleteNotificationForBooking:booking])
        return;
    
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = LOG_DATE_FORMAT;
    
    if (([booking.bookingArriveDate.fs_dateByIgnoringTimeComponents compare:[[NSDate date].fs_dateByIgnoringTimeComponents fs_dateByAddingHours:24]]  != NSOrderedAscending || ([booking.bookingArriveDate.fs_dateByIgnoringTimeComponents compare:[NSDate date].fs_dateByIgnoringTimeComponents] == NSOrderedSame))) {
        
        localNotification.fireDate =  [booking.bookingArriveDate.fs_dateByIgnoringTimeComponents fs_dateByAddingHours:9];
        //localNotification.fireDate = [[NSDate date].fs_dateByIgnoringTimeComponents fs_dateByAddingHours:9];
        localNotification.alertBody = LANG_NOTIFICATION_GUESTS_CHECKIN;
        localNotification.soundName = UILocalNotificationDefaultSoundName;
        localNotification.timeZone = [NSTimeZone defaultTimeZone];
        localNotification.userInfo = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:booking.bookingDBId], NOTIFICATION_BOOKING_DBID_KEY, nil];
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
        NSLog(@"Added notification:%@ %@ local:%d sch:%d", [df stringFromDate:localNotification.fireDate], localNotification.alertBody, (int)self.notifiedBookings.count, (int)[[UIApplication sharedApplication] scheduledLocalNotifications].count);
    }
    else if (([booking.bookingDepartureDate.fs_dateByIgnoringTimeComponents compare:[[NSDate date].fs_dateByIgnoringTimeComponents fs_dateByAddingHours:24]] != NSOrderedAscending || [booking.bookingDepartureDate.fs_dateByIgnoringTimeComponents compare:[NSDate date].fs_dateByIgnoringTimeComponents] == NSOrderedSame)) {
        
        localNotification.fireDate =  [booking.bookingDepartureDate.fs_dateByIgnoringTimeComponents fs_dateByAddingHours:9];
        //localNotification.fireDate = [[NSDate date].fs_dateByIgnoringTimeComponents fs_dateByAddingHours:9];
        localNotification.alertBody = LANG_NOTIFICATION_GUESTS_CHECKOUT;
        localNotification.soundName = UILocalNotificationDefaultSoundName;
        localNotification.timeZone = [NSTimeZone defaultTimeZone];
        localNotification.userInfo = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:booking.bookingDBId], NOTIFICATION_BOOKING_DBID_KEY, nil];
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
        NSLog(@"Added notification:%@ %@ local:%d sch:%d", [df stringFromDate:localNotification.fireDate], localNotification.alertBody, (int)self.notifiedBookings.count, (int)[[UIApplication sharedApplication] scheduledLocalNotifications].count);
    }
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = self.notifiedBookings.count;
}

- (void)confirmNotification:(UILocalNotification *)notification {
    
    FRBooking *b = [FRBooking getByField:[FRBooking getColumnIdentifierName] value:[notification.userInfo objectForKey:NOTIFICATION_BOOKING_DBID_KEY]];
    if (![self notificationForBooking:b]) {
        
        [self.notifiedBookings addObject:notification];
        [UIApplication sharedApplication].applicationIconBadgeNumber = self.notifiedBookings.count;
        //self.scheduledNotifications++;
    }
}

- (void)scheduleNotifications {
    
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    //self.scheduledNotifications = 0;
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    [[FRBooking getListOfObjets] enumerateObjectsUsingBlock:^(FRBooking * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [self scheduleNotificationsForBooking:obj];
    }];
}

@end
