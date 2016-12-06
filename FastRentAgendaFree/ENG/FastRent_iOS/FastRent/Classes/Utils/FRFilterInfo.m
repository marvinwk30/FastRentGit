//
//  FRFilterInfo.m
//  FastRent
//
//  Created by Marvin Avila Kotliarov on 4/6/16.
//  Copyright © 2016 Marvin Avila Kotliarov. All rights reserved.
//

#import "FRFilterInfo.h"
#import "NSDate+FSExtension.h"

@implementation FRFilterInfo

- (id)init {
    
    if (!(self = [super init]))
        return nil;
    
    _bookingStatusInfo = [NSMutableArray arrayWithObjects:[NSNumber numberWithInt:BookingStatusPrebooking], [NSNumber numberWithInt:BookingStatusConfirmed], [NSNumber numberWithInt:BookingStatusPending], nil];
    
    _checkInDate = [[NSDate date].fs_dateByIgnoringTimeComponents fs_firstDayOfMonth];
    _checkOutDate = [[NSDate date].fs_dateByIgnoringTimeComponents fs_lastDayOfMonth];
    
//    _selectedHosting = nil;
    
    return self;
}

@end
