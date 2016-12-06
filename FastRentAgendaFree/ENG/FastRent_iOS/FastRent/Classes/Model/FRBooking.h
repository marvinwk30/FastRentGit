//
//  FRBooking.h
//  FastRent
//
//  Created by Joysonic on 3/3/16.
//  Copyright © 2016 Marvin Avila Kotliarov. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FRDataAccess.h"
#import "Types.h"

typedef NS_ENUM(NSInteger, UpdateOption) {
    UpdateOptionNone,
    UpdateOptionAdd,
    UpdateOptionModify,
    UpdateOptionDelete,
};

#define DB_BOOKING_STATE_ID @"state_id"

@interface FRBooking : FRDataAccess <NSCopying>

@property (nonatomic, assign) NSInteger bookingDBId;
@property (nonatomic, assign) BookingStatus bookingStatus;
@property (nonatomic, assign) NSInteger bookingStateId;
@property (nonatomic, strong) NSString* bookingDescription;
@property (nonatomic, strong) NSDate* bookingArriveDate;
@property (nonatomic, strong) NSDate* bookingDepartureDate;
@property (nonatomic, assign) NSInteger bookingClientId;
@property (nonatomic, strong) NSString* bookingClientDescription;
@property (nonatomic, assign) BOOL bookingStayMonth;
@property (nonatomic, strong) NSNumber* bookingPrice;
@property (nonatomic, assign) FeeOption bookingComissionType;
@property (nonatomic, strong) NSString* bookingPayComissionTo;
@property (nonatomic, strong) NSNumber* bookingComissionPrice;
@property (nonatomic, strong) NSNumber* bookingExtraIncome;
@property (nonatomic, strong) NSString* bookingExtraIncomeDescription;

@property (nonatomic, readonly) NSString *bookingStatusDescription;

+ (NSString *)stringForBookingStatus:(BookingStatus)bookingStatus;

@property (nonatomic, readonly) float bookingTotal;
@property (nonatomic, readonly) float bookingRentTotal;
@property (nonatomic, readonly) float bookingPayFeeTotal;
@property (nonatomic, readonly) float bookingEarnFeeTotal;
@property (nonatomic, readonly) NSString *bookingAccountingDescription;
@property (nonatomic, assign) UpdateOption updateOption;

@end
