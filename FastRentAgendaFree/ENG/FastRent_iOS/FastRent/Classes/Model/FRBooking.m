//
//  FRBooking.m
//  FastRent
//
//  Created by Joysonic on 3/3/16.
//  Copyright © 2016 Marvin Avila Kotliarov. All rights reserved.
//

#import "FRBooking.h"
#import "FRGlobals.h"
#import "FRDBUtils.h"
#import "NSDate+FSExtension.h"
#import "FRState.h"

#define DB_BOOKING_TABLE_NAME @"fr_booking"
#define DB_BOOKING_IDENTIFIER @"booking_id"
#define DB_BOOKING_STATUS @"status"
//#define DB_BOOKING_STATE_ID @"state_id"
#define DB_BOOKING_ARRIVE_DATE @"arrive_date"
#define DB_BOOKING_DEPARTURE_DATE @"departure_date"
#define DB_BOOKING_CLIENT_ID @"client_id"
#define DB_BOOKING_CLIENT_DESCRIPTION @"client_description"
#define DB_BOOKING_STAY_MONT @"stay_month"
#define DB_BOOKING_COMISSION_TYPE @"commission_type"
#define DB_BOOKING_PAY_COMISSION_TO @"pay_commission_to"
#define DB_BOOKING_COMISSION_PRICE @"commission_price"
#define DB_BOOKING_EXTRA_INCOME @"extra_income"
#define DB_BOOKING_EXTRA_INCOME_DESCRIPTION @"extra_income_description"

@interface FRBooking ()

@end

@implementation FRBooking

@synthesize bookingTotal = _bookingTotal;
@synthesize bookingAccountingDescription = _bookingAccountingDescription;

- (instancetype) init
{
    if (!(self = [super init]))
        return nil;
    
    _bookingStatus = BookingStatusPending;
    
    _bookingTotal = 0;
    _bookingRentTotal = 0;
    _bookingPayFeeTotal = 0;
    _bookingEarnFeeTotal = 0;
    _updateOption = UpdateOptionNone;
    
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    
    FRBooking *newBooking = [FRBooking new];
    
    newBooking.bookingDBId = self.bookingDBId;
    newBooking.bookingStatus = self.bookingStatus;
    newBooking.bookingStateId = self.bookingStateId;
    newBooking.bookingDescription = [self.bookingDescription copy];
    newBooking.bookingArriveDate = [self.bookingArriveDate copy];
    newBooking.bookingDepartureDate = [self.bookingDepartureDate copy];
    newBooking.bookingClientId = self.bookingClientId;
    newBooking.bookingClientDescription = [self.bookingClientDescription copy];
    newBooking.bookingStayMonth = self.bookingStayMonth;
    newBooking.bookingPrice = [self.bookingPrice copy];
    newBooking.bookingComissionType = self.bookingComissionType;
    newBooking.bookingPayComissionTo = [self.bookingPayComissionTo copy];
    newBooking.bookingComissionPrice = [self.bookingComissionPrice copy];
    newBooking.bookingExtraIncome = [self.bookingExtraIncome copy];
    newBooking.bookingExtraIncomeDescription = [self.bookingExtraIncomeDescription copy];
    newBooking.updateOption = self.updateOption;
    
    return newBooking;
}

#pragma mark - FRSchemaProtocol
+ (NSString*) getColumnIdentifierName
{
    return DB_BOOKING_IDENTIFIER;
}

- (NSDictionary*) getSchemaDataToAdd
{
    NSMutableDictionary *_dictionaryArgs = [NSMutableDictionary dictionary];
    
    //[_dictionaryArgs setObject:[NSNumber numberWithInt:self.bookingDBId] forKey:DB_BOOKING_IDENTIFIER];
    [_dictionaryArgs setObject:[NSNumber numberWithInt:self.bookingStatus] forKey:DB_BOOKING_STATUS];
    [_dictionaryArgs setObject:[NSNumber numberWithInteger:self.bookingStateId] forKey:DB_BOOKING_STATE_ID];
    
    if (self.bookingDescription != nil)
        [_dictionaryArgs setObject:self.bookingDescription forKey:COLUMN_NAME_DESCRIPTION];
    
    if (self.bookingArriveDate != nil)
        [_dictionaryArgs setObject:self.bookingArriveDate forKey:DB_BOOKING_ARRIVE_DATE];
    
    if (self.bookingDepartureDate != nil)
        [_dictionaryArgs setObject:self.bookingDepartureDate forKey:DB_BOOKING_DEPARTURE_DATE];
    
    if (self.bookingClientId > 0)
        [_dictionaryArgs setObject:[NSNumber numberWithInteger:self.bookingClientId] forKey:DB_BOOKING_CLIENT_ID];
    
    if (self.bookingClientDescription != nil)
        [_dictionaryArgs setObject:self.bookingClientDescription forKey:DB_BOOKING_CLIENT_DESCRIPTION];
    
    [_dictionaryArgs setObject:[NSNumber numberWithBool:self.bookingStayMonth] forKey:DB_BOOKING_STAY_MONT];
    
    if (self.bookingPrice != nil)
        [_dictionaryArgs setObject:self.bookingPrice forKey:COLUMN_NAME_PRICE];
    
    [_dictionaryArgs setObject:[NSNumber numberWithInteger:self.bookingComissionType] forKey:DB_BOOKING_COMISSION_TYPE];
    
    if (self.bookingPayComissionTo != nil)
        [_dictionaryArgs setObject:self.bookingPayComissionTo forKey:DB_BOOKING_PAY_COMISSION_TO];

    if (self.bookingComissionPrice != nil)
        [_dictionaryArgs setObject:self.bookingComissionPrice forKey:DB_BOOKING_COMISSION_PRICE];

    if (self.bookingExtraIncome != nil)
        [_dictionaryArgs setObject:self.bookingExtraIncome forKey:DB_BOOKING_EXTRA_INCOME];

    if (self.bookingExtraIncomeDescription != nil)
        [_dictionaryArgs setObject:self.bookingExtraIncomeDescription forKey:DB_BOOKING_EXTRA_INCOME_DESCRIPTION];
    
    return _dictionaryArgs;
}

- (NSDictionary*) getSchemaDataToUpdate
{
    return [self getSchemaDataToAdd];
}

+ (instancetype) createDataFromResultSet:(FMResultSet*) aResultSet
{
    FRBooking *_booking = [[FRBooking alloc] init];
    
    [_booking setBookingDBId:[aResultSet intForColumn:DB_BOOKING_IDENTIFIER]];
    [_booking setBookingStatus:[aResultSet intForColumn:DB_BOOKING_STATUS]];
    [_booking setBookingStateId:[aResultSet intForColumn:DB_BOOKING_STATE_ID]];
    [_booking setBookingDescription:[aResultSet stringForColumn:COLUMN_NAME_DESCRIPTION]];
    [_booking setBookingArriveDate:[aResultSet dateForColumn:DB_BOOKING_ARRIVE_DATE]];
    [_booking setBookingDepartureDate:[aResultSet dateForColumn:DB_BOOKING_DEPARTURE_DATE]];
    [_booking setBookingClientId:[aResultSet intForColumn:DB_BOOKING_CLIENT_ID]];
    [_booking setBookingClientDescription:[aResultSet stringForColumn:DB_BOOKING_CLIENT_DESCRIPTION]];
    [_booking setBookingStayMonth:[aResultSet boolForColumn:DB_BOOKING_STAY_MONT]];
    [_booking setBookingPrice:[NSNumber numberWithFloat:[aResultSet doubleForColumn:COLUMN_NAME_PRICE]]];

    [_booking setBookingComissionType:[aResultSet intForColumn:DB_BOOKING_COMISSION_TYPE]];
    [_booking setBookingPayComissionTo:[aResultSet stringForColumn:DB_BOOKING_PAY_COMISSION_TO]];
    [_booking setBookingComissionPrice:[NSNumber numberWithFloat:[aResultSet doubleForColumn:DB_BOOKING_COMISSION_PRICE]]];
    [_booking setBookingExtraIncome:[NSNumber numberWithFloat:[aResultSet doubleForColumn:DB_BOOKING_EXTRA_INCOME]]];
    [_booking setBookingExtraIncomeDescription:[aResultSet stringForColumn:DB_BOOKING_EXTRA_INCOME_DESCRIPTION]];
    
//    if ([_booking.bookingDepartureDate compare:[NSDate date].fs_dateByIgnoringTimeComponents] != NSOrderedDescending) {
//        
//        if (_booking.bookingStatus == BookingStatusConfirmed) {
//            
//            if (_booking.bookingComissionType != FeeOptionTypeNone) {
//                
//                _booking.bookingStatus = BookingStatusPending;
//            }
//            else {
//                
//                _booking.bookingStatus = BookingStatusFinished;
//            }
//        }
//        else if (_booking.bookingComissionType == FeeOptionTypeNone) {
//                
//            _booking.bookingStatus = BookingStatusFinished;
//        }
//    }
    
    return _booking;
}

+ (NSString*) getTableName
{
    return DB_BOOKING_TABLE_NAME;
}

- (NSInteger) getDBIdentifer
{
    return  self.bookingDBId;
}

+ (NSMutableArray*) getListOfObjets
{
    FMDatabase *_database = [[FRDBUtils sharedFRDBUtils] getLocalDB];
    NSMutableArray *_result = [[NSMutableArray alloc] initWithCapacity:10];
    if (![_database open])
    {
        NSLog(@"Problems to open DB, please check");
        return nil;
    }
    
    FMDBQuickCheck(![_database hasOpenResultSets])
    
    FMResultSet *_resultSet = [_database executeQuery:[NSString stringWithFormat:@"select * from %@ ORDER BY %@ ASC", [[self class] getTableName], DB_BOOKING_DEPARTURE_DATE]];
    while ([_resultSet next]) {
        FRDataAccess* _objectData = [[self class] createDataFromResultSet:_resultSet];
        [_result addObject:_objectData];
    }
    
    // close the result set.
    // it'll also close when it's dealloc'd, but we're closing the database before
    // the autorelease pool closes, so sqlite will complain about it.
    [_resultSet close];
    [_database close];
    
    return _result;
}

+ (NSMutableArray*) getListByField:(NSString*) aColumnName value:(id) aValue
{
    FMDatabase *_database = [[FRDBUtils sharedFRDBUtils] getLocalDB];
    NSMutableArray *_result = [[NSMutableArray alloc] initWithCapacity:10];
    //    FRDataAccess *_result = nil;
    if (![_database open])
    {
        NSLog(@"Problems to open DB, please check");
        return nil;
    }
    
    FMDBQuickCheck(![_database hasOpenResultSets])
    
//    NSLog(@"%s execute over class: %@", __FUNCTION__, NSStringFromClass([self class]));
    
    FMResultSet *_resultSet = [_database executeQuery:[NSString stringWithFormat:@"select * from %@ where %@ = ? ORDER BY %@ ASC", [[self class] getTableName], aColumnName, DB_BOOKING_DEPARTURE_DATE], aValue];
    while ([_resultSet next]) {
        FRDataAccess* _objectData = [[self class] createDataFromResultSet:_resultSet];
        [_result addObject:_objectData];
    }
    
    // close the result set.
    // it'll also close when it's dealloc'd, but we're closing the database before
    // the autorelease pool closes, so sqlite will complain about it.
    [_resultSet close];
    [_database close];
    
    return _result;
}

- (BookingStatus)bookingStatus {
    
    if ([self.bookingDepartureDate.fs_dateByIgnoringTimeComponents compare:[NSDate date].fs_dateByIgnoringTimeComponents] != NSOrderedDescending) {
        
        if (_bookingStatus == BookingStatusPrebooking) {
            
            return BookingStatusPrebooking;
        }
        
        if (_bookingStatus == BookingStatusConfirmed) {
            
            if (_bookingComissionType != FeeOptionTypeNone) {
                
                _bookingStatus = BookingStatusPending;
            }
            else {
                
                _bookingStatus = BookingStatusFinished;
            }
        }
        else if (self.bookingComissionType == FeeOptionTypeNone) {
            
            _bookingStatus = BookingStatusFinished;
        }
    }
    
    return _bookingStatus;
}

- (NSString *)bookingStatusDescription {
    
    return [FRBooking stringForBookingStatus:self.bookingStatus];
}

+ (NSString *)stringForBookingStatus:(BookingStatus)bookingStatus {
    
    switch (bookingStatus) {
        case BookingStatusPrebooking:
            return @"Prereserva";
            break;
        case BookingStatusConfirmed:
            return @"Confirmada";
            break;
        case BookingStatusPending:
            return @"Pendiente";
            break;
        case BookingStatusFinished:
            return @"Terminada";
            break;
        default:
            break;
    }
    
    return nil;
}

- (void)calculateAccounting {
    
//    FRState *state = [FRState getByField:[FRState getColumnIdentifierName] value:[NSNumber numberWithInt:self.bookingStateId]];
    
    NSInteger nightsCount = [self.bookingDepartureDate fs_daysFrom:self.bookingArriveDate];
    _bookingTotal = nightsCount * [self.bookingPrice floatValue];
    _bookingRentTotal = _bookingTotal;
    _bookingAccountingDescription = _bookingTotal > 0 ? [NSString stringWithFormat:@"$%.2f", _bookingTotal] : @"";
    
    if (self.bookingExtraIncome != nil && [self.bookingExtraIncome floatValue] > 0) {
        
        _bookingTotal += [self.bookingExtraIncome floatValue];
        _bookingExtraIncome = self.bookingExtraIncome;
        _bookingAccountingDescription = [_bookingAccountingDescription stringByAppendingFormat:@" + $%.2f", [self.bookingExtraIncome floatValue]];
    }
    
    if (![[NSString stringWithFormat:@"$%.2f", _bookingTotal] isEqualToString:_bookingAccountingDescription]) {
        
        _bookingAccountingDescription = [[NSString stringWithFormat:@"$%.2f = ", _bookingTotal] stringByAppendingString:_bookingAccountingDescription];
    }
    else {
        
        _bookingAccountingDescription = [NSString stringWithFormat:@"$%.2f cobro renta", _bookingTotal];
    }
}

- (float)bookingTotal {
    
    [self calculateAccounting];
    
    return _bookingTotal;
}

- (NSString *)bookingAccountingDescription {
    
    [self calculateAccounting];
    
    return _bookingAccountingDescription;
}

@end
