//
//  DAccountManager.h
//  DCalendar
//
//  Created by GaoAng on 14-5-6.
//  Copyright (c) 2014年 richinfo.cn. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "../NetWork/DDataModel.h"
//#import "../NetWork/DProtocol.h"
/**
 *  帐号信息 数据集
 */
@interface DAccountInfo : NSObject

@property (nonatomic, assign) BOOL  isLogin;  //当前帐号是否登录。
@property (nonatomic, strong) NSString *account;   //用户名
@property (nonatomic, strong) NSString *psw;       //用户密码
@property (nonatomic, assign) BOOL  isDeviceBind;  //当前帐号是否绑定过设备。
@property (nonatomic, strong) NSString *chatName;   //环信帐号
@property (nonatomic, strong) NSString *chatPsw;    //环信密码

@property (nonatomic, copy) NSString *sid;
@property (nonatomic, copy) NSString *token;
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSString *photoUrl;
@property (nonatomic, assign) NSInteger  userId;

@property (nonatomic, assign) BOOL isHaveNewMsg;  //判断是否有新的通知消息。

@end



/*******************************************************************************
 *
 */
@class DResponsedLogin, DResponsedUserInfo,DAccountInfo;
#define DAccountManagerInstance [DAccountManager shareInstance]

@interface DAccountManager : NSObject
+(DAccountManager*)shareInstance;


//保存登录返回数据到 帐号信息中
-(BOOL)saveCurAccountInfo:(DResponsedLogin*)res withName:(NSString*)name passwrod:(NSString*)passwrod;

//个人资料擦 修改后保存到本地。
-(BOOL)saveCurAccountInfoWithUserInfo:(DResponsedUserInfo*)res;

//获取和保存 sid
-(NSString*)curAccountInfoSid;
-(void)setcurAccountInfoSid:(NSString*)sid;

//获取和设置 token
-(NSString*)curAccountInfoToken;
-(void)setCurAccountInfoToken:(NSString*)token;

//获取和设置 uid
-(NSString*)curAccountInfoUid;
-(void)setCurAccountInfoUid:(NSString*)uid;

//获取和保存 sid
-(BOOL)curAccountInfoIsDeviceBind;
-(void)setcurAccountInfoDeviceBind:(BOOL)bind;

//获取和保存 当前账户是否有新的push消息
-(BOOL)curAccountInfoHaveNewMsg;
//-(void)setcurAccountInfoHaveNewMsg:(BOOL)bind;


//获取昵称
-(NSString*)curAccountInfoNickName;
-(void)setCurAccountInfoNickName:(NSString*)name;

/**
 *  获取userid
 *
 *  @return uisID
 */
-(NSInteger)curAccountInfoUserID;

//获取头像名称
-(void)setCurAccountInfoPhoneUrl:(NSString*)photo;
-(NSString*)curAccountInfoPhoteUrl;

//获取当前帐号 和密码(加密后)
-(NSString*)curAccountInfoUserNumber;
-(NSString*)curAccountInfoPassword;

-(NSString*)curChatName;
-(NSString*)curChatPsw;

//保存用户名+密码(加密后) 到userdefault
-(void)saveAccount:(NSString*)account pswd:(NSString*)pswd save:(BOOL)save;

//获取当前帐号是否登录 和 设置登录。
-(BOOL)curAccountIsLogin;
-(void)SetCurAccountlogin:(BOOL)login;

//获取和设置 app 是否第一次使用。
-(BOOL)appIsFirstUse;
-(void)setAppIsFirstUse;

//删除当前帐号。
-(BOOL)deleteCurAccount;
-(DAccountInfo*)curAccountInfo;
@end

