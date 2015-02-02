//
//  DDBConfig.h
//
//
//  Created by  on 12-5-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "DDatabase.h"
#import "DResultSet.h"
#import "DDatabaseQueue.h"

#define TABLE_EVENT                         @"DCalendar_Event"            //活动表
#define TABLE_EVENTDRAFT                    @"DCalendar_EventDraft"       //活动草稿表 草稿数据单独存储
#define TABLE_COMMENT                       @"DCalendar_Comment"          //评论表
#define TABLE_EVENTVSERSION                 @"DCalendar_EventVersion"     //活动版本号
#define TABLE_EVENTALARM                    @"DCalendar_EventAlarm"       //提醒表格。
#define TABLE_EVENTINVITE                   @"DCalendar_EventInvite"      //邀请人/参与人表格。
#define TABLE_EVENTFEE                      @"DCalendar_EventFee"        //活动费用
#define TABLE_EVENTMESSAGE                  @"DCalendar_EventMessage" //活动消息
#define TABLE_AREAINFOS                     @"DCalendar_areainfo"
#define TABLE_CHATMESSAGE                   @"DCalendar_ChatMessage"
#define TABLE_CONVERSATION                  @"DCalendar_Conversation"
#define TABLE_BUDDY                         @"DCalendar_Buddy" //聊天好友
#define TABLE_CONFIGDATA                    @"DCalendar_ConfigData" //职业信息。
#define TABLE_EVENTIMAGES                   @"DCalendar_Event_Images_Upload" //活动图片上传服务器表


#define DDBConfigInstance [DDBConfig shareInstace]

@interface DDBConfig : NSObject
@property (nonatomic, strong) NSString *dbPath;
@property(nonatomic,strong) DDatabaseQueue *dbQueue;

//数据库静态接口
+(DDBConfig*) shareInstace;
-(DDatabase *)getDbWithCurAccount;
-(BOOL) MakeAccountDBIsExistAndOpen:(DDatabase*)db;
-(void)resetDBQueue;

//数据库基本操作。
//-(BOOL)createTable:(NSString*)sql :(DDatabase*)db;
//-(BOOL)deleteTableWithAccount:(NSString *)account;
-(BOOL)DeleteByTableName:(NSDictionary*)dic tableName:(NSString*)name;
-(BOOL)InsertIntoTableByName:(NSDictionary*)dic tableName:(NSString*)tableName :(DDatabase*)m_db;
-(BOOL)UpdateByTableName:(NSDictionary*)dic condition:(NSDictionary*)dicCondtion tableName:(NSString*)name :(DDatabase*)db;

@end
