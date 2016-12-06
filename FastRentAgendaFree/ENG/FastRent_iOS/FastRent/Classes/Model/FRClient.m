//
//  FRClient.m
//  FastRent
//
//  Created by Joysonic on 3/1/16.
//  Copyright © 2016 Marvin Avila Kotliarov. All rights reserved.
//

#define DB_CLIENT_TABLE_NAME @"fr_client"
#define DB_CLIENT_IDENTIFIER @"client_id"
#define DB_CLIENT_NUMBER_IDENTIFIER @"number_identifier"
#define DB_CLIENT_NATIONALITY @"nationality"
#define DB_CLIENT_DATE_BORN @"date_born"
#define DB_CLIENT_DISCIPLINE_ATTENTION @"discipline_attention"
#define DB_CLIENT_SPECIAL_ATTENTION @"special_attention"

#import "FRClient.h"

@implementation FRClient

- (instancetype) init
{
    if (!(self = [super init]))
        return nil;
    
    return self;
}

#pragma mark - FRSchemaProtocol
+ (NSString*) getColumnIdentifierName
{
    return DB_CLIENT_IDENTIFIER;
}

- (NSDictionary*) getSchemaDataToAdd
{
    NSMutableDictionary *_dictionaryArgs = [NSMutableDictionary dictionary];
    if (self.clientFullName != nil)
        [_dictionaryArgs setObject:self.clientFullName forKey:COLUMN_NAME_FULLNAME];
    
    if (self.clientPhone != nil)
        [_dictionaryArgs setObject:self.clientPhone forKey:COLUMN_NAME_PHONE];
    
    if (self.clientCellPhone != nil)
        [_dictionaryArgs setObject:self.clientCellPhone forKey:COLUMN_NAME_CELL_PHONE];
    
    if (self.clientEmail != nil)
        [_dictionaryArgs setObject:self.clientEmail forKey:COLUMN_NAME_EMAIL];
    
    if (self.clientIdentifierNumber != nil)
        [_dictionaryArgs setObject:self.clientIdentifierNumber forKey:DB_CLIENT_NUMBER_IDENTIFIER];
    
    if (self.clientNationality != nil)
        [_dictionaryArgs setObject:self.clientNationality forKey:DB_CLIENT_NATIONALITY];
    
    if (self.clientBornDate != nil)
        [_dictionaryArgs setObject:self.clientBornDate forKey:DB_CLIENT_DATE_BORN];
    
    if (self.clientDisciplineAttention != nil)
        [_dictionaryArgs setObject:self.clientDisciplineAttention forKey:DB_CLIENT_DISCIPLINE_ATTENTION];

    if (self.clientSpecialAttention != nil)
        [_dictionaryArgs setObject:self.clientSpecialAttention forKey:DB_CLIENT_SPECIAL_ATTENTION];
    
    return _dictionaryArgs;
}

- (NSDictionary*) getSchemaDataToUpdate
{
    return [self getSchemaDataToAdd];
}

+ (instancetype) createDataFromResultSet:(FMResultSet*) aResultSet
{
    FRClient *_client = [[FRClient alloc] init];
    
    [_client setClientDBId:[aResultSet intForColumn:DB_CLIENT_IDENTIFIER]];
    [_client setClientFullName:[aResultSet stringForColumn:COLUMN_NAME_FULLNAME]];
    [_client setClientPhone:[aResultSet stringForColumn:COLUMN_NAME_PHONE]];
    [_client setClientCellPhone:[aResultSet stringForColumn:COLUMN_NAME_CELL_PHONE]];
    [_client setClientEmail:[aResultSet stringForColumn:COLUMN_NAME_EMAIL]];
    [_client setClientIdentifierNumber:[aResultSet stringForColumn:DB_CLIENT_NUMBER_IDENTIFIER]];
    [_client setClientNationality:[aResultSet stringForColumn:DB_CLIENT_NATIONALITY]];
    [_client setClientBornDate:[aResultSet dateForColumn:DB_CLIENT_DATE_BORN]];
    [_client setClientDisciplineAttention:[aResultSet stringForColumn:DB_CLIENT_DISCIPLINE_ATTENTION]];
    [_client setClientSpecialAttention:[aResultSet stringForColumn:DB_CLIENT_SPECIAL_ATTENTION]];
    
    return _client;
}

+ (NSString*) getTableName
{
    return DB_CLIENT_TABLE_NAME;
}

- (NSInteger) getDBIdentifer
{
    return  self.clientDBId;
}

@end