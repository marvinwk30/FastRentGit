//
//  FRState.m
//  FastRent
//
//  Created by Joysonic on 3/1/16.
//  Copyright © 2016 Marvin Avila Kotliarov. All rights reserved.
//

#define DB_STATE_TABLE_NAME @"fr_state"
#define DB_STATE_IDENTIFIER @"state_id"
#define DB_STATE_ROOMS @"rooms"
#define DB_STATE_NIGHT_PRICE @"night_price"
#define DB_STATE_OWN @"own"
#define DB_STATE_ADDRESS @"address"
#define DB_STATE_ACCOUNT_ID @"account_id"
#define DB_STATE_PHOTOS @"photos"
#define DB_STATE_ACCOUNT_DESCRIPTION @"account_description"

#import "FRState.h"

@implementation FRState

- (instancetype) init
{
    if (!(self = [super init]))
        return nil;
    
    return self;
}

#pragma mark - FRSchemaProtocol
+ (NSString*) getColumnIdentifierName
{
    return DB_STATE_IDENTIFIER;
}

- (NSDictionary*) getSchemaDataToAdd
{
    NSMutableDictionary *_dictionaryArgs = [NSMutableDictionary dictionary];
    if (self.stateName != nil)
        [_dictionaryArgs setObject:self.stateName forKey:COLUMN_NAME_NAME];
    
    if (self.stateRooms > 0)
        [_dictionaryArgs setObject:[NSNumber numberWithInteger:self.stateRooms] forKey:DB_STATE_ROOMS];
    
    if (self.stateNightPrice != nil)
        [_dictionaryArgs setObject:self.stateNightPrice forKey:DB_STATE_NIGHT_PRICE];
    
    if (self.statePhotos != nil)
        [_dictionaryArgs setObject:self.statePhotos forKey:DB_STATE_PHOTOS];
    
    [_dictionaryArgs setObject:[NSNumber numberWithBool:self.stateOwn] forKey:DB_STATE_OWN];
    
    if (self.stateAddress != nil)
        [_dictionaryArgs setObject:self.stateAddress forKey:DB_STATE_ADDRESS];
    
    if (self.stateOwnerId > 0)
        [_dictionaryArgs setObject:[NSNumber numberWithInteger:self.stateOwnerId] forKey:DB_STATE_ACCOUNT_ID];
    
    if (self.stateAccountDescription != nil)
        [_dictionaryArgs setObject:self.stateAccountDescription forKey:DB_STATE_ACCOUNT_DESCRIPTION];

    if (self.statePhone != nil)
        [_dictionaryArgs setObject:self.statePhone forKey:COLUMN_NAME_PHONE];

    if (self.stateCellPhone != nil)
        [_dictionaryArgs setObject:self.stateCellPhone forKey:COLUMN_NAME_CELL_PHONE];
    
    return _dictionaryArgs;
}

- (NSDictionary*) getSchemaDataToUpdate
{
    return [self getSchemaDataToAdd];
}

+ (instancetype) createDataFromResultSet:(FMResultSet*) aResultSet
{
    FRState *_state = [[FRState alloc] init];

    [_state setStateDBId:[aResultSet intForColumn:DB_STATE_IDENTIFIER]];
    [_state setStateName:[aResultSet stringForColumn:COLUMN_NAME_NAME]];
    [_state setStateRooms:[aResultSet intForColumn:DB_STATE_ROOMS]];
    [_state setStateNightPrice:[NSNumber numberWithFloat:[aResultSet doubleForColumn:DB_STATE_NIGHT_PRICE]]];
    [_state setStatePhotos:[aResultSet stringForColumn:DB_STATE_PHOTOS]];
    [_state setStateOwn:[aResultSet boolForColumn:DB_STATE_OWN]];
    [_state setStateAddress:[aResultSet stringForColumn:DB_STATE_ADDRESS]];
    [_state setStateOwnerId:[aResultSet intForColumn:DB_STATE_ACCOUNT_ID]];
    [_state setStateAccountDescription:[aResultSet stringForColumn:DB_STATE_ACCOUNT_DESCRIPTION]];
    [_state setStatePhone:[aResultSet stringForColumn:COLUMN_NAME_PHONE]];
    [_state setStateCellPhone:[aResultSet stringForColumn:COLUMN_NAME_CELL_PHONE]];
    return _state;
}

+ (NSString*) getTableName
{
    return DB_STATE_TABLE_NAME;
}

- (NSInteger) getDBIdentifer
{
    return  self.stateDBId;
}

@end