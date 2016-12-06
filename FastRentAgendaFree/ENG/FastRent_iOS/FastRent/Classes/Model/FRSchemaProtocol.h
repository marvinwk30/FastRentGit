//
//  FRSchemaProtocol.h
//  FastRent
//
//  Created by Joysonic on 2/29/16.
//  Copyright © 2016 Marvin Avila Kotliarov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"

#ifndef FRSchemaProtocol_h
#define FRSchemaProtocol_h

@protocol FRSchemaProtocol <NSObject>

+ (NSString*) getColumnIdentifierName;
- (NSDictionary*) getSchemaDataToAdd;
- (NSDictionary*) getSchemaDataToUpdate;
+ (instancetype) createDataFromResultSet:(FMResultSet*) aResultSet;
+ (NSString*) getTableName;
- (NSInteger) getDBIdentifer;

@end

#endif /* FRSchemaProtocol_h */
