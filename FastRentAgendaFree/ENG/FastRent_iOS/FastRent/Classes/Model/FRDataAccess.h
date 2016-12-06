//
//  FRDataAccess.h
//  FastRent
//
//  Created by Joysonic on 2/29/16.
//  Copyright © 2016 Marvin Avila Kotliarov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FRSchemaProtocol.h"

//commons columns name
#define COLUMN_NAME_NAME @"name"
#define COLUMN_NAME_FULLNAME @"full_name"
#define COLUMN_NAME_PICTURE @"picture"
#define COLUMN_NAME_PHONE @"phone"
#define COLUMN_NAME_CELL_PHONE @"cell_phone"
#define COLUMN_NAME_EMAIL @"email"
#define COLUMN_NAME_DESCRIPTION @"description"
#define COLUMN_NAME_PRICE @"price"

@interface FRDataAccess : NSObject <FRSchemaProtocol>

+ (instancetype) existInDBbyIdentifier:(NSInteger) aDBIdentifier;
+ (BOOL) removeFromDB:(NSInteger) aIdentifer;
+ (NSMutableArray*) getListOfObjets;
- (BOOL) updateToDB;
+ (int) addToDB:(id<FRSchemaProtocol>) aObjectToAdd;
+ (instancetype) getByField:(NSString*) aColumnName value:(id) aValue;
+ (NSMutableArray*) getListByField:(NSString*) aColumnName value:(id) aValue;

@end