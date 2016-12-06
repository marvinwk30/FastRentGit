//
//  FRNotificationManager.h
//  Rent House Agenda
//
//  Created by Marvin Avila Kotliarov on 9/13/16.
//  Copyright © 2016 Marvin Avila Kotliarov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define NOTIFICATION_BOOKING_DBID_KEY @"NotificationBookingDBIDKey"
#define NOTIFICATION_BOOKING_HOST_KEY @"NotificationBookingHostKey"

@class FRBooking;

@interface FRNotificationManager : NSObject

+ (instancetype)sharedInstance;

@property (nonatomic) BOOL registeredForLocalNotifications;

@property (nonatomic, readonly) NSMutableArray <UILocalNotification *> *notifiedBookings;
- (void)scheduleNotificationsForBooking:(FRBooking *)booking;
- (BOOL)deleteNotificationForBooking:(FRBooking *)booking;
- (void)confirmNotification:(UILocalNotification *)notification;
- (void)scheduleNotifications;

@end
