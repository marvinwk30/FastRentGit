//
//  Types.h
//  Inmobile
//
//  Created by Marvin Avila Kotliarov on 12/20/15.
//  Copyright © 2015 Marvin Avila Kotliarov. All rights reserved.
//

#ifndef Types_h
#define Types_h

typedef NS_ENUM (NSInteger, EBookingStatus)
{
    EBS_NONE = -1,
    EBS_FREE = 1,
    EBS_BUSY = 2,
    EBS_PENDING = 3,
};

typedef NS_ENUM (NSInteger, BookingStatus)
{
    BookingStatusPrebooking = 0,
    BookingStatusConfirmed = 1,
    BookingStatusPending = 2,
    BookingStatusFinished = 3,
};

typedef NS_ENUM (NSInteger, EBookingComissionType)
{
    EBCT_NONE = -1,
    EBCT_PAY = 1,
    EBCT_CHARGE = 2,
};

typedef NS_ENUM (NSInteger, HostingOperation)
{
    HostingOperationTypeList,
    HostingOperationTypeSelectSimple,
    HostingOperationTypeSelectMultiple,
};

typedef NS_ENUM (NSInteger, FeeOption) {
    
    FeeOptionTypeNone,
    FeeOptionTypePay,
    FeeOptionTypeCharge,
};

typedef NS_ENUM (NSInteger, HostingType) {
    
    HostingTypeNone = -1,
    HostingTypeExternal = 0,
    HostingTypeOwn = 1,
};

typedef NS_ENUM (NSInteger, TaskRemainingType) {
    
    TaskRemainingTypeFilter,
    TaskRemainingTypeNotification,
};

typedef enum {
    HostingEmptyNameErrorType,
    HostingEmptyRoomsCountErrorType,
    HostingEmptyNightPriceErrorType,
    HostingEmptyOwnerErrorType,
} ValidateHostingErrorType;

typedef enum {
    BookingEmptyHostNameErrorType,
    BookingEmptyDateErrorType,
    BookingEmptyClientInfoErrorType,
    BookingEmptyPriceErrorType,
    BookingEmptyFeeDescriptionErrorType,
    BookingEmptyFeePriceErrorType,
} ValidatevBookingErrorType;

typedef enum {
    OwnerEmptyNameErrorType,
}ValidateOwnerErrorType;

#endif /* Types_h */
