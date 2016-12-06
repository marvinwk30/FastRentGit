//
//  FRAccount.m
//  FastRent
//
//  Created by Joysonic on 2/29/16.
//  Copyright © 2016 Marvin Avila Kotliarov. All rights reserved.
//

#define DB_ACCOUNT_TABLE_NAME @"fr_account"
#define DB_ACCOUNT_IDENTIFIER @"account_id"
#define DB_ACCOUNT_EMAIL1 @"email1"
#define DB_ACCOUNT_PROMOTION_URLS @"promtion_urls"
#define DB_ACCOUNT_IS_APP_ACCOUNT @"isAppAccount"

#import "FRAccount.h"
#import "FRDBUtils.h"

@implementation FRAccount

- (instancetype) init
{
    if (!(self = [super init]))
        return nil;
    
    return self;
}

#pragma mark - FRSchemaProtocol
+ (NSString*) getColumnIdentifierName
{
    return DB_ACCOUNT_IDENTIFIER;
}

- (NSDictionary*) getSchemaDataToAdd
{
    NSMutableDictionary *_dictionaryArgs = [NSMutableDictionary dictionary];
    if (self.accountFullName != nil)
        [_dictionaryArgs setObject:self.accountFullName forKey:COLUMN_NAME_FULLNAME];
    if (self.accountPicture != nil)
        [_dictionaryArgs setObject:self.accountPicture forKey:COLUMN_NAME_PICTURE];
    
    if (self.accountPhone != nil)
        [_dictionaryArgs setObject:self.accountPhone forKey:COLUMN_NAME_PHONE];
    
    if (self.accountCellPhone != nil)
        [_dictionaryArgs setObject:self.accountCellPhone forKey:COLUMN_NAME_CELL_PHONE];

    if (self.accountEmail != nil)
        [_dictionaryArgs setObject:self.accountEmail forKey:COLUMN_NAME_EMAIL];
    
    if (self.accountEmail1 != nil)
        [_dictionaryArgs setObject:self.accountEmail1 forKey:DB_ACCOUNT_EMAIL1];
    
    if (self.accountPromotionURLs != nil)
        [_dictionaryArgs setObject:self.accountPromotionURLs forKey:DB_ACCOUNT_PROMOTION_URLS];
    
    [_dictionaryArgs setObject:[NSNumber numberWithBool:self.accountIsAppAccount] forKey:DB_ACCOUNT_IS_APP_ACCOUNT];
    
    return _dictionaryArgs;
}

- (NSDictionary*) getSchemaDataToUpdate
{
    return [self getSchemaDataToAdd];
}

+ (instancetype) createDataFromResultSet:(FMResultSet*) aResultSet
{
    FRAccount *_account = [[FRAccount alloc] init];
    
    [_account setAccountDBId:[aResultSet intForColumn:DB_ACCOUNT_IDENTIFIER]];
    [_account setAccountFullName:[aResultSet stringForColumn:COLUMN_NAME_FULLNAME]];
    [_account setAccountPicture:[aResultSet stringForColumn:COLUMN_NAME_PICTURE]];
    [_account setAccountPhone:[aResultSet stringForColumn:COLUMN_NAME_PHONE]];
    [_account setAccountCellPhone:[aResultSet stringForColumn:COLUMN_NAME_CELL_PHONE]];
    [_account setAccountEmail:[aResultSet stringForColumn:COLUMN_NAME_EMAIL]];
    [_account setAccountEmail1:[aResultSet stringForColumn:DB_ACCOUNT_EMAIL1]];
    [_account setAccountPromotionURLs:[aResultSet stringForColumn:DB_ACCOUNT_PROMOTION_URLS]];
    [_account setAccountIsAppAccount:[aResultSet boolForColumn:DB_ACCOUNT_IS_APP_ACCOUNT]];
    return _account;
}

+ (NSString*) getTableName
{
    return DB_ACCOUNT_TABLE_NAME;
}

- (NSInteger) getDBIdentifer
{
    return  self.accountDBId;
}

#pragma mark -
#pragma mark Custom Data Access Methods

+ (instancetype) getAppAccount
{
    FMDatabase *_database = [[FRDBUtils sharedFRDBUtils] getLocalDB];
    FRAccount *_result = nil;
    if (![_database open])
    {
        NSLog(@"Problems to open DB, please check");
        return _result;
    }
    
    FMDBQuickCheck(![_database hasOpenResultSets])
    
    FMResultSet *_resultSet = [_database executeQuery:[NSString stringWithFormat:@"select * from %@ where %@ = ?", [FRAccount getTableName], DB_ACCOUNT_IS_APP_ACCOUNT], [NSNumber numberWithBool:TRUE]];
    while ([_resultSet next]) {
        _result = [FRAccount createDataFromResultSet:_resultSet];
    }
    
    // close the result set.
    // it'll also close when it's dealloc'd, but we're closing the database before
    // the autorelease pool closes, so sqlite will complain about it.
    [_resultSet close];
    [_database close];
    
    return _result;
}

+ (NSMutableArray*) getListExceptLocalUser
{
    FMDatabase *_database = [[FRDBUtils sharedFRDBUtils] getLocalDB];
    NSMutableArray *_result = [[NSMutableArray alloc] initWithCapacity:10];
    if (![_database open])
    {
        NSLog(@"Problems to open DB, please check");
        return FALSE;
    }
    
    FMDBQuickCheck(![_database hasOpenResultSets])
    
    FMResultSet *_resultSet = [_database executeQuery:[NSString stringWithFormat:@"select * from %@ WHERE %@ = ? ORDER BY %@ ASC", [[self class] getTableName], DB_ACCOUNT_IS_APP_ACCOUNT, [[self class] getColumnIdentifierName]], [NSNumber numberWithBool:FALSE]];
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

@end
