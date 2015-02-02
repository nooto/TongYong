//
//  DRequestOperatorManager.h
//  DCalendar
//
//  Created by GaoAng on 14-5-13.
//  Copyright (c) 2014年 richinfo.cn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DRequestOperator.h"
//#import "AFNetworking/AFNetworking.h"
#import "../DataBase/DDB_EventInviteTable.h"
#import "../DataBase/DDB_EventMessage.h"
#import "../DataBase/DDB_EventAlarmTable.h"
#import "../DataBase/DDB_CommentTable.h"
#import "../DataBase/DDB_ConfigData.h"
#import "Reachability.h"

@protocol DRequestOperatorManagerDelegate <NSObject>
- (void)URLDataReceiverDidFinish:(DBaseResponsed *)receiverData;
@end

@interface DRequestOperatorManager : NSObject <DRequestOperatorDelegate>

+ (id)connection;

//- (void)cancelConnectionWithDelegate:(id)delegate;

// 设置列表最大长度
//- (void)resetListSize:(NSInteger)iSize;
//- (void)startRequest:(DBaseRequest *)baseReq delegate:(id)delegate;
- (void)startRequest:(DBaseRequest *)baseReq callback:(void (^)(DBaseResponsed *receData))callback;

// 移除正在使用的进度条delegate
//- (void)removeProgressDelegate:(id)progress;

//更具活动gid 查询 该活动下 图片的总数。
//- (DUploadImageRecordData*)queryUooardRecordWith:(NSString*)gid;

@end
