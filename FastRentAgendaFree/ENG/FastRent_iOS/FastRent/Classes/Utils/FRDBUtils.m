//
//  FRDBUtils.m
//  FastRent
//
//  Created by Joysonic on 2/29/16.
//  Copyright © 2016 Marvin Avila Kotliarov. All rights reserved.
//

#import "FRDBUtils.h"
#import "FMDB.h"

#define DB_CURRENT_USER_VERSION 1

#define SHOW_TRACE_EXEC NO
#define SHOW_ERRORS_LOGS NO

@interface FRDBUtils ()

@property (nonatomic, strong) FMDatabase *localDB;
@property (nonatomic, strong) FMDatabaseQueue *localQueueDB;

@end

@implementation FRDBUtils

+ (FRDBUtils*) sharedFRDBUtils {
    
    static FRDBUtils* instance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        instance = [[FRDBUtils alloc] init];
    });
    
    return instance;
}

#pragma mark -DB Path
+ (NSString*) getDBPath {
    
    NSString *_documentsDir = nil;
    NSString *_databasePath = @"";
    // Get the path to the documents directory and append the databaseName
    NSArray *_documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    _documentsDir = [_documentPaths objectAtIndex:0];
    _databasePath = [_documentsDir stringByAppendingPathComponent:DB_FILE_NAME];
    
    // Check if the SQL database has already been saved to the users phone, if not then copy it over
    BOOL _isSucceeded;
    
    // Create a FileManager object, we will use this to check the status
    // of the database and to copy it over if required
    NSFileManager *_fileManager = [NSFileManager defaultManager];
    
    NSLog(@"Database path %@", _databasePath);
    
    // Check if the database has already been created in the users filesystem
    _isSucceeded = [_fileManager fileExistsAtPath:_databasePath];
    
    // If the database already exists then return without doing anything
    if(_isSucceeded) {
        NSLog(@"Database readed from old file system information");
        return _databasePath;
    }
    
    NSLog(@"Database readed from initial state");
    
    // If not then proceed to copy the database from the application to the users filesystem
    
    // Get the path to the database in the application packaged
    NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:DB_FILE_NAME];
    
    NSError *_error = nil;
    //create a Application Support Directory
    [_fileManager createDirectoryAtPath:_documentsDir withIntermediateDirectories:FALSE attributes:Nil error:&_error];
    if (_error != nil && _error.code == 516){
        NSLog(@"Folder exist, error: %@", _error);
    }
    
    _error = nil;
    // Copy the database from the package to the users filesystem
    [_fileManager copyItemAtPath:databasePathFromApp toPath:_databasePath error:&_error];
    
    if (_error != nil){
        NSLog(@"Error importing new database for application %@", _error);
        return @"";
    }
    
    return _databasePath;
}

- (FMDatabase*) getLocalDB {
    
    if (_localDB == nil)
    {
        _localDB = [FMDatabase databaseWithPath:[[FRDBUtils getDBPath] copy]];
        [_localDB setTraceExecution:SHOW_TRACE_EXEC];
        [_localDB setLogsErrors:SHOW_ERRORS_LOGS];
    }
    return _localDB;
}

- (void) checkAndAlter
{
    [_localDB open];
    
    int _userVersion = [_localDB userVersion];
    NSLog(@"User version of DB: %d", _userVersion);
    if (_userVersion < DB_CURRENT_USER_VERSION)
    {
        [_localDB setUserVersion:DB_CURRENT_USER_VERSION]; //set 1 for initial state of DB. veriy userVersion of DB to check versions and alter DB when update the application
        
        //alter DB here un future
        
        NSLog(@"User version updated to of DB: %d", [_localDB userVersion]);
    }
    else if (_userVersion == DB_CURRENT_USER_VERSION)
    {
        NSLog(@"User version of DB: %d, is updated", _userVersion);
    }
    else
    {
        NSLog(@"User version of DB: %d, is unknown", _userVersion);
    }
    [_localDB close];
}

- (FMDatabaseQueue*) getLocalQueueDB {
    
    if (_localQueueDB == nil)
    {
        _localQueueDB = [[FMDatabaseQueue databaseQueueWithPath:[FRDBUtils getDBPath]] copy];
    }
    return _localQueueDB;
}

@end