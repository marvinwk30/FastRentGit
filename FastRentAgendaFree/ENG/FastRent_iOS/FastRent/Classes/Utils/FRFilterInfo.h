//
//  FRFilterInfo.h
//  FastRent
//
//  Created by Marvin Avila Kotliarov on 4/6/16.
//  Copyright © 2016 Marvin Avila Kotliarov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Types.h"
#import "FRState.h"

@interface FRFilterInfo : NSObject

@property (nonatomic, strong) NSMutableArray<NSNumber *> *bookingStatusInfo;
@property (nonatomic, copy) NSDate *checkInDate;
@property (nonatomic, copy) NSDate *checkOutDate;
//@property (nonatomic, strong) FRState *selectedHosting;
@property (nonatomic, strong) NSMutableArray<FRState *> *selectedHostings;

@end
