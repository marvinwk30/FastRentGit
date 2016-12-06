//
//  FRState.h
//  FastRent
//
//  Created by Joysonic on 3/1/16.
//  Copyright © 2016 Marvin Avila Kotliarov. All rights reserved.
//

#import "FRDataAccess.h"

@interface FRState : FRDataAccess

@property (nonatomic, assign) NSInteger stateDBId;
@property (nonatomic, strong) NSString* stateName;
@property (nonatomic, assign) NSInteger stateRooms;
@property (nonatomic, strong) NSNumber* stateNightPrice;
@property (nonatomic, strong) NSString* statePhotos;
@property (nonatomic, assign) BOOL stateOwn;
@property (nonatomic, strong) NSString* stateAddress;
@property (nonatomic, assign) NSInteger stateOwnerId; //-1
@property (nonatomic, strong) NSString* stateAccountDescription;

@property (nonatomic, strong) NSString* statePhone;
@property (nonatomic, strong) NSString* stateCellPhone;

@end