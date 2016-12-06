//
//  FRAccount.h
//  FastRent
//
//  Created by Joysonic on 2/29/16.
//  Copyright © 2016 Marvin Avila Kotliarov. All rights reserved.
//

#include "FRDataAccess.h"

@interface FRAccount : FRDataAccess

@property (nonatomic, assign) NSInteger accountDBId;
@property (nonatomic, strong) NSString* accountFullName;
@property (nonatomic, strong) NSString* accountPicture;
@property (nonatomic, strong) NSString* accountPhone;
@property (nonatomic, strong) NSString* accountCellPhone;
@property (nonatomic, strong) NSString* accountEmail;
@property (nonatomic, strong) NSString* accountEmail1;
@property (nonatomic, strong) NSString* accountPromotionURLs;
@property (nonatomic, assign) BOOL accountIsAppAccount;

+ (instancetype) getAppAccount;
+ (NSMutableArray*) getListExceptLocalUser;
@end