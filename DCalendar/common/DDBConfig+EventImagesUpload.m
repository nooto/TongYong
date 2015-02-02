//
//  DDBConfig+EventImagesUpload.m
//  DCalendar
//
//  Created by hunanldc on 14-11-7.
//  Copyright (c) 2014年 richinfo.cn. All rights reserved.
//

#import "DDBConfig+EventImagesUpload.h"

@implementation DDBConfig (EventImagesUpload)

#pragma mark -- 增
- (BOOL)insertItemToDB:(DEventImagesUpload *)imageInfo
{
    if (!imageInfo.eventId || !imageInfo.imageName) {
        return NO;
    }
    __weak DDBConfig *tempSelf = self;
    __block BOOL ret = NO;
    [self.dbQueue inDatabase:^(DDatabase *db) {
        NSString *sql  = [NSString stringWithFormat:@"select * from %@ where eventId = ? and msgId = ? and imageName = ?",TABLE_EVENTMESSAGE];
        DResultSet *rs = [db executeQuery:sql,imageInfo.eventId,@(imageInfo.msgId),imageInfo.imageName];
        if ([rs next]) {
            //存在则修改
            NSDictionary *dict = @{@"eventId":imageInfo.eventId,@"msgId":@(imageInfo.msgId),@"imageName":imageInfo.imageName};
            NSDictionary *updateProperties = @{@"imageState":@(imageInfo.imageState)};
            ret = [tempSelf UpdateByTableName:updateProperties condition:dict tableName:TABLE_EVENTIMAGES :db];
        }else {
            //插入
            NSDictionary *dict = @{@"eventId":imageInfo.eventId,@"msgId":@(imageInfo.msgId),@"imageName":imageInfo.imageName,@"imageState":@(imageInfo.imageState)};
            [self InsertIntoTableByName:dict tableName:TABLE_EVENTIMAGES :db];
        }
        [rs close];
    }];
    return ret;
}

#pragma mark -- 删
- (BOOL)deleteItemsWithEventID:(NSString *)gid// msgId:(NSInteger)msgId
{
    if (!gid || ![gid isKindOfClass:[NSString class]] || [gid length] == 0) {
        return YES;
    }
    NSDictionary *dict = @{@"eventId":gid};//,@"msgId":@(msgId)
    return [self DeleteByTableName:dict tableName:TABLE_EVENTIMAGES];
}

- (BOOL)deleteItem:(DEventImagesUpload *)imageInfo
{
    if (!imageInfo.eventId || !imageInfo.imageName) {
        return NO;
    }
    NSDictionary *dict = @{@"eventId":imageInfo.eventId,@"msgId":@(imageInfo.msgId),@"imageName":imageInfo.imageName};
    return [self DeleteByTableName:dict tableName:TABLE_EVENTIMAGES];
}

#pragma mark -- 改

- (BOOL)updateItemToDB:(DEventImagesUpload *)imageInfo
{
    if (!imageInfo.eventId || !imageInfo.imageName) {
        return NO;
    }
    __weak DDBConfig *tempSelf = self;
    __block BOOL ret = NO;
    [self.dbQueue inDatabase:^(DDatabase *db) {
        //存在则修改
        NSDictionary *dict = @{@"eventId":imageInfo.eventId,@"msgId":@(imageInfo.msgId),@"imageName":imageInfo.imageName};
        NSDictionary *updateProperties = @{@"imageState":@(imageInfo.imageState)};
        ret = [tempSelf UpdateByTableName:updateProperties condition:dict tableName:TABLE_EVENTIMAGES :db];
    }];
    return ret;
}

#pragma mark -- 查
- (BOOL)isNotNull:(NSString *)str
{
    if (!str || ![str isKindOfClass:[NSString class]] || [str length] == 0) {
        return NO;
    }
    return YES;
}

- (BOOL)imageExistWithEventId:(NSString *)eventId msgId:(NSInteger)msgId imageName:(NSString *)imageName
{
    if (![self isNotNull:eventId] || ![self isNotNull:imageName]) {
        return NO;
    }
    __block BOOL isExist = NO;
    [self.dbQueue inDatabase:^(DDatabase *db) {
        if (db) {
            NSString *sql  = [NSString stringWithFormat:@"select * from %@ where eventId = ? and msgId = ? and imageName = ?",TABLE_EVENTIMAGES];
            DResultSet * rs = [db executeQuery:sql,eventId,@(msgId),imageName];
            while ([rs next]) {
                isExist = YES;
            }
            [rs close];
        }
    }];
    return isExist;
}

- (NSArray *)queryUploadImageByEventId:(NSString *)eventId msgId:(NSInteger)msgId
{
    __block NSMutableArray *array = [NSMutableArray array];
    
    [self.dbQueue inDatabase:^(DDatabase *db) {
        if (!eventId || !db) {
            
        }else {
            NSString *sql  = [NSString stringWithFormat:@"select * from %@ where eventId = ? and msgId = ?",TABLE_EVENTIMAGES];
            
            DResultSet * rs = [db executeQuery:sql,eventId,@(msgId)];
            while ([rs next]) {
                DEventImagesUpload *imageInfo = [[DEventImagesUpload alloc] init];
                imageInfo.eventId = eventId;
                imageInfo.msgId = msgId;
                imageInfo.imageName = [rs stringForColumn:@"imageName"];
                [array addObject:imageInfo];
            }
            [rs close];
        }
    }];
    return array;
}

- (void)queryUploadImageByEventId:(NSString *)eventId msgId:(NSInteger)msgId complete:(void (^)(NSArray *array))complete
{
    [self.dbQueue inDatabase:^(DDatabase *db) {
        NSMutableArray *array = [NSMutableArray array];
        if (!eventId || !db) {
            if (complete) {
                complete(array);
            }
            return ;
        }
        NSString *sql  = [NSString stringWithFormat:@"select * from %@ where eventId = ? and msgId = ? and imageState = ?",TABLE_EVENTIMAGES];
        
        DResultSet * rs = [db executeQuery:sql,eventId,@(msgId),@(0)];
        while ([rs next]) {
            DEventImagesUpload *imageInfo = [[DEventImagesUpload alloc] init];
            imageInfo.eventId = eventId;
            imageInfo.msgId = msgId;
            imageInfo.imageName = [rs stringForColumn:@"imageName"];
            imageInfo.imageState = [rs intForColumn:@"imageState"];
            [array addObject:imageInfo];
        }
        [rs close];
        if (complete) {
            complete(array);
        }

    }];
}

- (NSArray *)queryUploadImageByEventId:(NSString *)eventId msgId:(NSInteger)msgId imageState:(NSInteger)state
{
    __block NSMutableArray *array = [NSMutableArray array];

    [self.dbQueue inDatabase:^(DDatabase *db) {
        if (!eventId || !db) {

        }else {
            NSString *sql  = [NSString stringWithFormat:@"select * from %@ where eventId = ? and msgId = ? and imageState = ?",TABLE_EVENTIMAGES];
            
            DResultSet * rs = [db executeQuery:sql,eventId,@(msgId),@(state)];
            while ([rs next]) {
                DEventImagesUpload *imageInfo = [[DEventImagesUpload alloc] init];
                imageInfo.eventId = eventId;
                imageInfo.msgId = msgId;
                imageInfo.imageName = [rs stringForColumn:@"imageName"];
                imageInfo.imageState = [rs intForColumn:@"imageState"];
                [array addObject:imageInfo];
            }
            [rs close];
        }
    }];
    return array;
}

@end
