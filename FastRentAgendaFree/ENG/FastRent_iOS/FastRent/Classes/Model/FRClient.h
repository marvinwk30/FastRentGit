//
//  FRClient.h
//  FastRent
//
//  Created by Joysonic on 3/1/16.
//  Copyright © 2016 Marvin Avila Kotliarov. All rights reserved.
//

#import "FRDataAccess.h"

@interface FRClient : FRDataAccess

@property (nonatomic, assign) NSInteger clientDBId;
@property (nonatomic, strong) NSString* clientFullName;
@property (nonatomic, strong) NSString* clientPhone;
@property (nonatomic, strong) NSString* clientCellPhone;
@property (nonatomic, strong) NSString* clientEmail;
@property (nonatomic, strong) NSString* clientIdentifierNumber;
@property (nonatomic, strong) NSString* clientNationality;
@property (nonatomic, strong) NSDate* clientBornDate;
@property (nonatomic, strong) NSString* clientDisciplineAttention;
@property (nonatomic, strong) NSString* clientSpecialAttention;

@end
