//
//  FRDBUtils.h
//  FastRent
//
//  Created by Joysonic on 2/29/16.
//  Copyright © 2016 Marvin Avila Kotliarov. All rights reserved.
//

#import <Foundation/Foundation.h>

#define FMDBQuickCheck(SomeBool) { if (!(SomeBool)) { NSLog(@"Failure on line %d", __LINE__); abort(); } }

#define DB_FILE_NAME @"frdata_db.sqlite"

@class FMDatabase, FMDatabaseQueue;

@interface FRDBUtils : NSObject

+ (FRDBUtils*) sharedFRDBUtils;
- (void) checkAndAlter;
+ (NSString*) getDBPath;
- (FMDatabase*) getLocalDB;
- (FMDatabaseQueue*) getLocalQueueDB;

@end