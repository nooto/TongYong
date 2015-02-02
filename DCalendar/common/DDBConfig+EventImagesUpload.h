//
//  DDBConfig+EventImagesUpload.h
//  DCalendar
//
//  Created by hunanldc on 14-11-7.
//  Copyright (c) 2014年 richinfo.cn. All rights reserved.
//

#import "DDBConfig.h"

@interface DDBConfig (EventImagesUpload)

- (BOOL)insertItemToDB:(DEventImagesUpload *)imageInfo;
- (BOOL)deleteItemsWithEventID:(NSString *)gid;// msgId:(NSInteger)msgId;
- (BOOL)deleteItem:(DEventImagesUpload *)imageInfo;
- (BOOL)updateItemToDB:(DEventImagesUpload *)imageInfo;

- (void)queryUploadImageByEventId:(NSString *)eventId msgId:(NSInteger)msgId complete:(void (^)(NSArray *array))complete;
- (NSArray *)queryUploadImageByEventId:(NSString *)eventId msgId:(NSInteger)msgId imageState:(NSInteger)state;
- (NSArray *)queryUploadImageByEventId:(NSString *)eventId msgId:(NSInteger)msgId;
- (BOOL)imageExistWithEventId:(NSString *)eventId msgId:(NSInteger)msgId imageName:(NSString *)imageName;

@end
