//
//  DRequestOperator.h
//  DCalendar
//
//  Created by GaoAng on 14-5-13.
//  Copyright (c) 2014年 richinfo.cn. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "AFNetworking/AFNetworking.h"
#import "DDBConfig.h"
#import "../DataBase/DDBConfig.h"
#import "../DataBase/DDB_EventTable.h"
//#import "DProtocol.h"

//网络请求处理过程。
@protocol DRequestOperatorDelegate;

@interface DRequestOperator : NSObject

@property (unsafe_unretained) id<DRequestOperatorDelegate>delegate;
@property (nonatomic, strong) DBaseRequest *requestData;

// 从发送请求。
//- (BOOL)requestWithBaseRequest:(DBaseRequest *)baseReq;
//- (BOOL)requestWithBaseRequest:(DBaseRequest *)baseReq progressDelegate:(id)progress;
- (BOOL)requestWithBaseRequest:(DBaseRequest *)baseReq callback:(void (^)(DBaseResponsed *receData))callback;

// 取消下载
- (void)cancelRequest;
- (void)setProgressDelegate:(id)progress;
- (id)getProgressDelegate;

@end

@protocol DRequestOperatorDelegate <NSObject>
- (void)requestFinishedOper:(DRequestOperator *)oper respondData:(DBaseResponsed *)receivedata;

//添加callback后 在 opserator 中  通知operatorManager 管理请求的数据处理。 2014-10-20 15:47:28。added  by gaoang
//- (void)requestFinishedOperForCallback:(DRequestOperator *)oper respondData:(DBaseResponsed *)receivedata;
@end
