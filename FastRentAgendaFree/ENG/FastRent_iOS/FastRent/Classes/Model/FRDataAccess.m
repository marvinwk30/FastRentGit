//
//  FRDataAccess.m
//  FastRent
//
//  Created by Joysonic on 2/29/16.
//  Copyright © 2016 Marvin Avila Kotliarov. All rights reserved.
//

#import "FRDataAccess.h"
#import "FRDBUtils.h"
#import "FRConfigurationManager.h"

@implementation FRDataAccess

- (instancetype) init
{
    if (!(self = [super init]))
        return nil;
    
    return self;
}

//probar [self class]

+ (instancetype) existInDBbyIdentifier:(NSInteger) aDBIdentifier
{
    FMDatabase *_database = [[FRDBUtils sharedFRDBUtils] getLocalDB];
    FRDataAccess *_result = nil;
    if (![_database open])
    {
        NSLog(@"Problems to open DB, please check");
        return _result;
    }
    
    FMDBQuickCheck(![_database hasOpenResultSets])
    
//    NSLog(@"%s execute over class: %@", __FUNCTION__, NSStringFromClass([self class]));
    
    FMResultSet *_resultSet = [_database executeQuery:[NSString stringWithFormat:@"select * from %@ where %@ = ?", [[self class] getTableName], [[self class] getColumnIdentifierName]], [NSNumber numberWithInteger:aDBIdentifier]];
    while ([_resultSet next]) {
        _result = [[self class] createDataFromResultSet:_resultSet];
    }
    
    // close the result set.
    // it'll also close when it's dealloc'd, but we're closing the database before
    // the autorelease pool closes, so sqlite will complain about it.
    [_resultSet close];
    [_database close];
    
    return _result;
}

+ (instancetype) getByField:(NSString*) aColumnName value:(id) aValue {
    
    NSArray *resArr = [self getListByField:aColumnName value:aValue];
    
    if (resArr != nil && resArr.count > 0) {
        
        return [resArr objectAtIndex:0];
    }
    
    return nil;
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
    
    FMResultSet *_resultSet = [_database executeQuery:[NSString stringWithFormat:@"select * from %@ where %@ = ?", [[self class] getTableName], aColumnName], aValue];
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

+ (BOOL) removeFromDB:(NSInteger) aIdentifer;
{
    FMDatabase *_database = [[FRDBUtils sharedFRDBUtils] getLocalDB];
    BOOL _result = FALSE;
    if (![_database open])
    {
        NSLog(@"Problems to open DB, please check");
        return FALSE;
    }
    
    FMDBQuickCheck(![_database hasOpenResultSets])
    
    NSMutableDictionary *_dictionaryArgs = [NSMutableDictionary dictionary];
    [_dictionaryArgs setObject:[NSNumber numberWithInteger:aIdentifer] forKey:[[self class] getColumnIdentifierName]];
    
    NSString* _sql = [NSString stringWithFormat:@"delete from %@ where %@ = :%@",
                      [[self class] getTableName], [[self class] getColumnIdentifierName],[[self class] getColumnIdentifierName]];
    _result = [_database executeUpdate:_sql withParameterDictionary:_dictionaryArgs];
    
    // close the result set.
    // it'll also close when it's dealloc'd, but we're closing the database before
    // the autorelease pool closes, so sqlite will complain about it.
    
    [_database close];
    
//    [[FRConfigurationManager sharedInstance] updateDbSecretWord];
    
    return _result;
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
    
    FMResultSet *_resultSet = [_database executeQuery:[NSString stringWithFormat:@"select * from %@ ORDER BY %@ ASC", [[self class] getTableName], [[self class] getColumnIdentifierName]]];
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

- (BOOL) updateToDB
{
    FMDatabase *_database = [[FRDBUtils sharedFRDBUtils] getLocalDB];
    if (![_database open])
    {
        NSLog(@"Problems to open DB, please check");
        return FALSE;
    }
    
    FMDBQuickCheck(![_database hasOpenResultSets])
    
    NSMutableDictionary *_dictionaryArgs = [NSMutableDictionary dictionaryWithDictionary:[self getSchemaDataToUpdate]];
    
    NSString* _initialSQL = [NSString stringWithFormat:@"update %@ set ", [[self class] getTableName]];
    NSString* _closeSQL = [NSString stringWithFormat:@" where %@ = :%@", [[self class] getColumnIdentifierName], [[self class] getColumnIdentifierName]];
    NSInteger _countKeys = [[_dictionaryArgs allKeys] count];
    NSMutableString* _columnsNameAndSetSQL = [NSMutableString stringWithString:@""];
    
    for (NSString* _columnKey in [_dictionaryArgs allKeys]) {
        [_columnsNameAndSetSQL appendFormat:@"%@ = :%@", _columnKey, _columnKey];
        if (--_countKeys != 0)
        {
            [_columnsNameAndSetSQL appendString:@", "];
        }
    }
    
    //set db identifier to properties's dictionary
    [_dictionaryArgs setObject:[NSNumber numberWithInteger:[self getDBIdentifer]] forKey:[[self class] getColumnIdentifierName]];
    
    NSMutableString* _completeSQL = [NSMutableString stringWithString:_initialSQL];
    [_completeSQL appendString:_columnsNameAndSetSQL];
    [_completeSQL appendString:_closeSQL];
    
    FMDBQuickCheck([_database executeUpdate:_completeSQL withParameterDictionary:_dictionaryArgs]);
    
    // close the result set.
    // it'll also close when it's dealloc'd, but we're closing the database before
    // the autorelease pool closes, so sqlite will complain about it.
    [_database close];
    
//    [[FRConfigurationManager sharedInstance] updateDbSecretWord];
    
    return TRUE;
}

+ (int) addToDB:(id<FRSchemaProtocol>) aObjectToAdd
{
    FMDatabase *_database = [[FRDBUtils sharedFRDBUtils] getLocalDB];
    if (![_database open])
    {
        NSLog(@"Problems to open DB, please check");
        return NO;
    }
    
    FMDBQuickCheck(![_database hasOpenResultSets])
    
    NSMutableDictionary *_dictionaryArgs = [NSMutableDictionary dictionaryWithDictionary:[aObjectToAdd getSchemaDataToAdd]];
    
    NSString* _initialSQL = [NSString stringWithFormat:@"insert into %@ (", [[aObjectToAdd class] getTableName]];
    NSString* _middleSQL = @") values (";
    NSString* _closeSQL = @") ";
    NSInteger _countKeys = [[_dictionaryArgs allKeys] count];
    
    NSMutableString* _columnsNameSQL = [NSMutableString stringWithString:@""];
    NSMutableString* _columnsNameSetSQL = [NSMutableString stringWithString:@""];
    
    for (NSString* _columnKey in [_dictionaryArgs allKeys]) {
        [_columnsNameSQL appendString:_columnKey];
        [_columnsNameSetSQL appendString:[NSString stringWithFormat:@":%@", _columnKey]];
        if (--_countKeys != 0)
        {
            [_columnsNameSQL appendString:@", "];
            [_columnsNameSetSQL appendString:@", "];
        }
    }
    
    NSMutableString* _completeSQL = [NSMutableString stringWithString:_initialSQL];
    [_completeSQL appendString:_columnsNameSQL];
    [_completeSQL appendString:_middleSQL];
    [_completeSQL appendString:_columnsNameSetSQL];
    [_completeSQL appendString:_closeSQL];
    
    FMDBQuickCheck([_database executeUpdate:_completeSQL withParameterDictionary:_dictionaryArgs]);
    int ret = (int)_database.lastInsertRowId;
//    FMResultSet *_resultSet = [_database executeQuery:_completeSQL withParameterDictionary:_dictionaryArgs];
//    int totalCount = [_resultSet intForColumn:[[self class] getColumnIdentifierName]];
//    if ([_resultSet next]) {
//        totalCount = [_resultSet intForColumn:[[self class] getColumnIdentifierName]];
//    }
    
    // close the result set.
    // it'll also close when it's dealloc'd, but we're closing the database before
    // the autorelease pool closes, so sqlite will complain about it.
//    [_resultSet close];
    
    // close the result set.
    // it'll also close when it's dealloc'd, but we're closing the database before
    // the autorelease pool closes, so sqlite will complain about it.
    [_database close];
    
//    [[FRConfigurationManager sharedInstance] updateDbSecretWord];
    return ret;
}


#pragma mark - FRSchemProtocol
+ (NSString*) getColumnIdentifierName
{
    @throw @"This class is abstract please use childs";
}

- (NSDictionary*) getSchemaDataToAdd
{
    @throw @"This class is abstract please use childs";
}

- (NSDictionary*) getSchemaDataToUpdate
{
    @throw @"This class is abstract please use childs";
}

+ (instancetype) createDataFromResultSet:(FMResultSet*) aResultSet
{
    @throw @"This class is abstract please use childs";
}

+ (NSString*) getTableName
{
    @throw @"This class is abstract please use childs";
}

- (NSInteger) getDBIdentifer
{
    @throw @"This class is abstract please use childs";
}

@end
