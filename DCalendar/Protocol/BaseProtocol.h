//
//  DProtocol.h
//  DCalendar
//
//  Created by GaoAng on 14-5-24.
//  Copyright (c) 2014年 richinfo.cn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "../AccountManager/DAccountManager.h"
#import "PrintObject.h"
#import "DDataModel.h"
#import "HHJSONKit.h"
#import "../common/DLocalFileManager.h"

//************************************************************************************

typedef enum{
	ERequest_SENDSMSAUTHCODE = 0,   //下发短信验证码
	ERequest_Login,       //
	ERequest_Logout,
	ERequest_Register,
	ERequest_Resetpwd,
	ERequest_CodeLogin,
	ERequest_Update,

	ERequest_FollowingList, //3.1.13	关注人列表
	ERequest_FollowerList, //3.1.14	粉丝列表
	ERequest_FollowSave, //3.1.9 关注好友
	ERequest_FollowCancel, //	取消关注
    ERequest_SendUserGeo, //3.1.14	粉丝列表
    ERequest_QueryUserEventCount,
    
	ERequest_PutEvent,
	ERequest_DelEvent,
	ERequest_SyncEvetn,
	ERequest_QueryEventBatch,
	ERequest_ShareEvent,
	ERequest_QueryEventDetails,
	ERequest_UpdateStatus,     //  3.2.7	更新活动状态
    ERequest_QueryEventSquare,     //  3.2.8 活动广场数据查询
    
    ERequest_QueryJoinList,     //  3.2.10	查询用户参与活动列表接口
    ERequest_QueryCreateList,     //  3.2.11	查询用户发起活动列表接口
	
	ERequest_UpDateInviteStatus,
	ERequest_UpdateInviter,
	ERequest_QueryAllInviter,
	ERequest_JoinInviter,
    ERequest_FetchUserInfo,//查询用户详情

	ERequest_QueryCheckInfo,         //3.3.5	查询报名审核信息
	ERequest_UpdateCheckStatusAccept,  //3.3.6	发起人同意报名人
	ERequest_UpdateCheckStatusRefuse,  //3.3.7	发起人拒绝报名人
	
	ERequest_UpdateInviteAlarm,

	ERequest_CommentEvent,
	ERequest_QueryCommentEvent,
	ERequest_QueryCommentEventNum,
	
	ERequest_QueryMsgBatch,  //批量查询消息
    ERequest_JoinDisGrp, //加入讨论组
    ERequest_ExitDisGrp, //退出讨论组
    ERequest_JoinDisGrpUpdateAvator, //加入讨论组

	ERequest_UploadImg,   //新建活动上传时候
	ERequest_UploadImg_User,//用户头像上传。
	ERequest_AppIsUpdate,
	ERequest_GenerateQrCode,
	
	//投票功能。
	ERequest_CreateVote,
	ERequest_QueryVoteDetailBatch,   //查询活动的所有投票详情
	ERequest_Vote,
	ERequest_DeleteVote,
	ERequest_FinishVote,
	
    ERequest_DeviceToken,
    ERequest_DeviceBind,
    ERequest_DeviceUnbind,
	//
    
	//直播功能。
    ERequest_LiveCommentCreate,
    ERequest_MessageLiveDelete,  //清空直播消息。
    
    //
    ERequest_QueryConfig,   //配置信息查询。
    
    ERequest_QueryHotCity, //查询热门城市
    ERequest_PastInviter, //往期报名列表
	ERequest_Other,

}ERequestType;
#pragma mark - 请求 & 返回的数据
/**
 *	@brief	所有请求的基类
 *
 *	Created by gao on 2014-05-13 13:59
 */
@interface DBaseRequest: NSObject

@property (nonatomic, copy) NSString* requestURL;
@property (nonatomic, assign) NSInteger apiversion;
@property (nonatomic, copy) NSString* comeFrom;
@property (nonatomic, assign) ERequestType requestType;
//@property (nonatomic, weak) id      requestDelegate;

@property (nonatomic, strong) NSDictionary *userInfo;

@property (nonatomic, strong) NSData *requestData;

-(NSString*)GetrequestURL;
-(NSData*)getRequestData;
-(id)getRespondParseClass;

-(NSData*)dataWithDictionary:(NSDictionary*)dict;

@end


/**
 *	@brief	返回数据的的基类
 *
 *	Created by gao on 2014-05-13 14:00
 */
@interface DBaseResponsed: NSObject
@property (nonatomic, copy) NSString* requestURL;
@property (nonatomic, assign) NSInteger apiversion;
@property (nonatomic, assign) BOOL       issuccess;
@property (nonatomic, assign) NSInteger       code;
@property (nonatomic, assign) NSInteger       errorCode;
@property (nonatomic, copy) NSString*       summary;
@property (nonatomic, assign) ERequestType requestType;
@property (nonatomic, strong) NSDictionary *userInfo;

- (void)parseResponseData:(NSDictionary*)dict;
- (void)parseResponseStrData:(NSString*)respond;
@end


//#pragma mark - 3.1.1	下发短信验证码
////************************************************************************************
///**
// *`	@brief	3.1.1	下发短信验证码
// 3.1.1.1	功能说明
// 用户请求下发短信验证码，用于验证用户有效性。短信验证码为不连续的6位数字串。
// 频率和IP做限制：
// 1．	每个手机号码每天下发短信验证码次数20次；
// 2．	每个IP码每天下发短信验证码次数20次；
// 增加业务处理：
// 随着业务发展，用户收到短信验证码的种类增加。当请求头中apiversion为2时，需要判断短信验证码的类型。
// 
// 3.1.1.2	输入
// http://IP:PORT/CalendarApp/user/sendSmsAuthCode.do
// *
// *	Created by gao on 2014-05-13 14:10
// */
//@interface DRequestSendSmsAuthCode: DBaseRequest
//
///**
// *	@brief
// *
// *	Created by gao on 2014-05-27 11:08
// */
//@property (nonatomic, copy) NSString* sid;
//
///**
// *	@brief		是	Int	1-32	时间戳	1
// *
// *	Created by gao on 2014-05-27 11:08
// */
//@property (nonatomic, assign) long long  timestamp;
//
///**
// *	@brief   是	String	1-3	用户手机号码
// *
// *	Created by gao on 2014-05-13 14:08
// */
//@property (nonatomic, copy) NSString*        userNumber;
//
///**
// *	@brief  否	Int	1-3	请求下发短信验证码类型：1：登录；2：注册；3：重置密码
// *
// *	Created by gao on 2014-05-13 14:08
// */
//@property (nonatomic, assign) NSInteger       type;
//
//
//@end
//
//@interface DResponsedSendSmsAuthCode : DBaseResponsed
//
//@end
//
//
////************************************************************************************
//#pragma mark - 3.1.2	用户登录
////************************************************************************************
///**
// *	@brief	3.1.2	用户登录
// 3.1.2.1	功能说明
// 用户登录，校验短信验证码有效性。
// 增加业务处理：
// 当请求头中apiversion为2时, 绑定用户设备和登录帐号关联关系。
// 当请求头中apiversion为3时,支持用户帐号登录。
// 3.1.2.2	输入
// http://IP:PORT/CalendarApp/user/login.do
// *
// *	Created by gao on 2014-05-13 14:23
// */
//@interface DRequestLogin: DBaseRequest
///**
// *	@brief
// *
// *	Created by gao on 2014-05-27 11:08
// */
//@property (nonatomic, copy) NSString* sid;
//
///**
// *	@brief		是	Int	1-32	时间戳	1
// *
// *	Created by gao on 2014-05-27 11:08
// */
//@property (nonatomic, assign) long long  timestamp;
//
//
///**
// *	@brief	是	String	1-11	用户手机号码
// *
// *	Created by gao on 2014-05-13 14:24
// */
//@property (nonatomic, copy) NSString* userName;
//
///**
// *	@brief	否	String	1-32	终端设备唯一标识。只有在请求头中apiversion为2时，为必选参数。
// *
// *	Created by gao on 2014-05-13 14:24
// */
//@property (nonatomic, copy) NSString* deviceToken;
//
///**
// *	@brief	否	String	1-32	终端设备唯一标识。只有在请求头中apiversion为2时，为必选参数。
// *
// *	Created by gao on 2014-05-13 14:24
// */
//@property (nonatomic, copy) NSString* APNSToken;
//
///**
// *	@brief	否	String	1-6	短信验证码。只有在请求头中apiversion为1，2时，为必选参数。
// *
// *	Created by gao on 2014-05-13 14:24
// */
//@property (nonatomic, copy) NSString* authCode;
//
///**
// *	@brief	否	String	6-16	用户密码。只有在请求头中apiversion为3时，为必选参数。
// *
// *	Created by gao on 2014-05-13 14:24
// */
//@property (nonatomic, copy) NSString* pwd;
//
///**
// *	@brief	客户端类型。
// *
// *	Created by gao on 2014-05-14 11:56
// */
//@property (nonatomic, copy) NSString* model;
//
///**
// *	@brief	imei 号。
// *
// *	Created by gao on 2014-05-14 11:56
// */
//@property (nonatomic, copy) NSString* imei;
//
//@end
//
//@interface DResponsedLogin : DBaseResponsed
///**
// *	@brief	String	1-32	会话ID
// *
// *	Created by gao on 2014-05-13 14:27
// */
//@property (nonatomic, copy) NSString* sid;
//
///**
// *	@brief	String	1-32	动态密钥
// *
// *	Created by gao on 2014-05-13 14:27
// */
//@property (nonatomic, copy) NSString* token;
//
///**
// *	@brief	String	1-32	用户登录设备生成的绑定关系ID，生成规则：MD5(userName + deviceToken)
// *
// *	Created by gao on 2014-05-13 14:27
// */
//@property (nonatomic, copy) NSString* bindUid;
//
///**
// *	@brief		String	1-128	用户昵称
// *
// *	Created by gao on 2014-06-27 13:52
// */
//@property (nonatomic, copy) NSString* nickname;
//
///**
// *	@brief		String	1-128	用户头像
// *
// *	Created by gao on 2014-06-27 13:52
// */
//@property (nonatomic,copy) NSString* photoUrl;
//
///**
// *  用户id
// */
//@property (nonatomic, assign) NSInteger userId;
//
////环信
//@property (nonatomic,copy) NSString* emUserName;
//@property (nonatomic,copy) NSString* emPwd;
//
//@end
//
////************************************************************************************
//#pragma mark - 3.1.3    139邮箱用户登录
///**
// *	@brief   3.1.3	139邮箱用户登录
// 3.1.3.1	功能说明
// 提供139邮箱帐号登录小D活动，登录分为俩个步骤。需要调用俩个接口，首先调用这个接口，完成后再调用3.1.4节描述的接口。
// 
// 3.1.3.2	输入
// http://IP:PORT/user/mail139/login.do?mac=xxx
// ************************************************************************************
// */
//
//@interface DRequest139Login : DBaseRequest
///**
// *  用户手机号码 必选 (未标注为非必选项)
// */
//@property (nonatomic, copy) NSString *userName;
///**
// *  设备唯一识别码 必选
// */
//@property (nonatomic, copy) NSString *imei;
///**
// *  手机型号 必选
// */
//@property (nonatomic, copy) NSString *model;
///**
// *  终端设备唯一标识。只有在请求头中apiversion为2时，为必选参数。
// */
//@property (nonatomic, copy) NSString *deviceToken;
///**
// *  短信验证码。只有在请求头中apiversion为1，2时，为必选参数。
// */
//@property (nonatomic, copy) NSString *authCode;
///**
// *  用户密码。只有在请求头中apiversion为3时，为必选参数。
// */
//@property (nonatomic, copy) NSString *pwd;
///**
// *  第一次为false ，第二次则为true，是否为完善资料确认。
// */
//@property (nonatomic, copy) NSString *isConfirm;
//
//@end
//
//@interface DResponse139Login : DBaseResponsed
//
///**
// *  
// //未注册
// {
// "code": "29",
// "summary": "未注册",
// "var": {
// "loginType": 1,
// "account": "xxxx",
// "accessToken": "xxxxx",
// "nickname": "xxxx",
// "photoUrl": " xxx",
// "sex": " F",
// "birthDate": " xxx",
// "regionCode": " xxx",
// "introduction": " xxx"
// }
// }
// 
// //已注册，则登录成功或失败
// {
// "code": "0",
// "summary": "Success",
// "var": {
// "sid": "2ee4fbf37db04c17ab875b33214a58a8"，
// "token": "1ee4fbf37db04c17ab875b33214a5xxx"，
// "bindUid": "xxx4fbf37db04c17ab87xxxxxxxxxxx",
// "userId":1,
// "nickname": "张三",
// "photoUrl": " f539011ed25133a57040b5729675c5ed.png"，
// chatUser: {
// "userName": "xxxx"
// "password": "xxxx"
// }
// }
// }
// */
///**
//*  所有返回数据，字典 如果code为0则为DRequestLogin类型数据
//*/
//@property (nonatomic, copy) NSDictionary *dict;
//
//@end
//
//#pragma mark - 3.1.2	第三方登录确认
///**
// *  @brief 3.1.2.1	功能说明
// *  用户通过第三方帐号登录后，需要在客户端完善个人资料，然后确认。确认成功后才算登录成功！
// *
// 3.1.2.2	输入
// http://IP:PORT/user/ext/reglogin.do?mac=xxx
// 请求报文：
// {
// "iemi": "xxxxx",
// "model": "Nexus 4",
// "deviceToken": "xxxxx",
// "loginType": 1,
// "account": "xxxx",
// "accessToken": "xxxxx",
// "nickname": "xxxx",
// "photoUrl": " xxx",
// "sex": " F",
// "birthDate": " xxx",
// "regionCode": " xxx",
// "introduction": " xxx",
// "timestamp": 100707000541
// }
// *
// */
//@interface DRequestThirdPartLogin : DBaseRequest
//
///**
// *  自动补全
// */
//@property (nonatomic, copy) NSString *imei;
///**
// *  自动补全
// */
//@property (nonatomic, copy) NSString *model;
///**
// *  自动补全
// */
//@property (nonatomic, copy) NSString *deviceToken;
///**
// *  loginType,登录类型，1：139,2：qq,3:微信，4：微博
// */
//@property (nonatomic, copy) NSString *loginType;
//@property (nonatomic, copy) NSString *account;
///**
// *  动态秘钥
// */
//@property (nonatomic, copy) NSString *accessToken;
//
//@property (nonatomic, copy) NSString *nickname;
///**
// *  头像地址
// */
//@property (nonatomic, copy) NSString *photoUrl;
//@property (nonatomic, copy) NSString *sex;
//@property (nonatomic, copy) NSString *birthDate;
///**
// *  城市
// */
//@property (nonatomic, copy) NSString *regionCode;
///**
// *  个人简介
// */
//@property (nonatomic, copy) NSString *introduction;
//@property (nonatomic, copy) NSString *timestamp;
///**
// *  第一次为false ，第二次则为true，是否为完善资料确认。
// */
//@property (nonatomic, copy) NSString *isConfirm;
//
//@end
//
//#pragma mark - 3.1.2	第三方登录确认 输出
//
//@interface DResponseThirdPartLogin: DBaseResponsed
//
///**
// *  所有返回数据，字典 如果code为0则为DRequestLogin类型数据
// */
//@property (nonatomic, copy) NSDictionary *dict;
//
//@end
//
//#pragma mark - 3.1.3	用户退出
///**
// *	@brief   3.1.3	用户退出
// 3.1.3.1	功能说明
// 用户退出
// 增加业务处理：
// 当请求头中apiversion为2时, 解除用户设备和登录帐号关联关系。
// 
// 3.1.3.2	输入
// http://IP:PORT/CalendarApp/user/logout.do
// *
// *	Created by gao on 2014-05-13 14:39
// */
//@interface  DRequestlogout: DBaseRequest
///**
// *	@brief
// *
// *	Created by gao on 2014-05-27 11:08
// */
//@property (nonatomic, copy) NSString* sid;
//
///**
// *	@brief		是	Int	1-32	时间戳	1
// *
// *	Created by gao on 2014-05-27 11:08
// */
//@property (nonatomic, assign) long long  timestamp;
//
//
//
//
///**
// *	@brief	否	String	1-32	终端设备唯一标识。只有在请求头中apiversion为2时，为必选参数。
// *
// *	Created by gao on 2014-05-13 14:46
// */
//@property (nonatomic, copy) NSString* deviceToken;
//
///**
// *	@brief	是	String	1-32	MD5(sid + timestamp + 动态密钥)
// *
// *	Created by gao on 2014-05-13 14:47
// */
//@property (nonatomic, copy) NSString* mac;
//
//@end
//
//@interface DReqsponsedLogout : DBaseResponsed
//
//@end
//
//
////************************************************************************************
//#pragma mark - 3.1.4	用户注册
///**
// *	@brief	3.1.4	用户注册
// 3.1.4.1	功能说明
// 用户注册，校验注册短信验证码有效性，保存用户帐号信息。
// 3.1.4.2	输入
// http://IP:PORT/CalendarApp/user/register.do
// *
// *	Created by gao on 2014-05-13 14:57
// */
//@interface DRequestRegister:DBaseRequest
//
///**
// *	@brief
// *
// *	Created by gao on 2014-05-27 11:08
// */
//@property (nonatomic, copy) NSString* sid;
//
///**
// *	@brief		是	Int	1-32	时间戳	1
// *
// *	Created by gao on 2014-05-27 11:08
// */
//@property (nonatomic, assign) long long  timestamp;
//
//
//
///**
// *	@brief	是	String	1-11	用户手机号码
// *
// *	Created by gao on 2014-05-13 14:59
// */
//@property (nonatomic, copy) NSString* userNumber;
//
//
///**
// *	@brief	是	String	6-16	用户密码
// *
// *	Created by gao on 2014-05-13 14:59
// */
//@property (nonatomic, copy) NSString* pwd;
//
///**
// *  否	String	1-11	用户昵称
// */
//@property (nonatomic, copy) NSString* nickname;
//
///**
// *	@brief	是	String	1-6	注册短信验证码
// *
// *	Created by gao on 2014-05-13 15:00
// */
//@property (nonatomic, copy) NSString* authCode;
//
///**
// *	@brief	否	String	1-32	终端设备唯一标识。只有在请求头中apiversion为2时，为必选参数。
// *
// *	Created by gao on 2014-05-13 15:00
// */
//@property (nonatomic, copy) NSString* deviceToken;
//
//@end
//
//@interface DResponsedRegister : DBaseResponsed
///**
// *	@brief	String	1-32	会话ID
// *
// *	Created by gao on 2014-05-13 15:01
// */
//@property (nonatomic, copy) NSString* sid;
//
///**
// *	@brief	String	1-32	动态密钥
// *
// *	Created by gao on 2014-05-13 15:01
// */
//@property (nonatomic, copy) NSString* token;
//
///**
// *	@brief	String	1-32	用户登录设备生成的绑定关系ID，生成规则：MD5(userName + deviceToken)
// *
// *	Created by gao on 2014-05-13 15:01
// */
//@property (nonatomic, copy) NSString* bindUid;
//
//@end
//
//
////************************************************************************************
//#pragma mark  3.1.5	用户重置密码
///**
// *	@brief	3.1.5	用户重置密码
// 3.1.5.1	功能说明
// 用户忘记密码后，需要通过该功能设置新密码。
// 3.1.5.2	输入
// http://IP:PORT/CalendarApp/user/resetPwd.do
// *
// *	Created by gao on 2014-05-13 15:06
// */
//@interface  DRequestResetPwd :DBaseRequest
//
///**
// *	@brief
// *
// *	Created by gao on 2014-05-27 11:08
// */
//@property (nonatomic, copy) NSString* sid;
//
///**
// *	@brief		是	Int	1-32	时间戳	1
// *
// *	Created by gao on 2014-05-27 11:08
// */
//@property (nonatomic, assign) long long   timestamp;
//
//
//
///**
// *	@brief	是	String	1-11	用户手机号码
// *
// *	Created by gao on 2014-05-13 15:06
// */
//@property (nonatomic ,copy) NSString* userNumber;
//
///**
// *	@brief	是	String	6-16	用户密码
// *
// *	Created by gao on 2014-05-13 15:06
// */
//@property (nonatomic, copy) NSString* pwd;
//
///**
// *	@brief	是	String	1-6	短信验证码
// *
// *	Created by gao on 2014-05-13 15:07
// */
//@property (nonatomic, copy) NSString* authCode;
//
//@end
//
//@interface DResponsedResetPwd : DBaseResponsed
//
//@end
//
//
////************************************************************************************
//#pragma mark - 3.1.6	二维码登录
///**
// *	@brief	3.1.6	二维码登录
// 3.1.6.1	功能说明
// 用户登录手机小D日历客户端，通过客户端扫描PC网页中的二维码，实现登录PC网页版小D日历的功能。
// 手机客户端在扫描二维码后调用该接口来登录PC网页版小D日历。
// 3.1.6.2	输入
// http://IP:PORT/CalendarApp/user/codeLogin.do
// *
// *	Created by gao on 2014-05-13 15:27
// */
//@interface  DRequestQRCodeLogin : DBaseRequest
//
///**
// *	@brief
// *
// *	Created by gao on 2014-05-27 11:08
// */
//@property (nonatomic, copy) NSString* sid;
//
///**
// *	@brief		是	Int	1-32	时间戳	1
// *
// *	Created by gao on 2014-05-27 11:08
// */
//@property (nonatomic, assign) long long   timestamp;
//
//
//
///**
// *	@brief	是	String	1-32	PC网页二维码标识，uuid在二维码中获取	1
// *
// *	Created by gao on 2014-05-13 15:28
// */
//@property (nonatomic, copy) NSString* uuid;
//
///**
// *	@brief	是	String	1-32	MD5(sid + timestamp + 密钥)	1
// *
// *	Created by gao on 2014-05-13 15:28
// */
//@property (nonatomic, copy) NSString*  mac;
//
//
//@end
//
//@interface DResponsedQRCodeLogin : DBaseResponsed
///**
// *	@brief	String	1-32	网页登录后产生的会话Id，用于退出网页版操作
// *
// *	Created by gao on 2014-05-13 15:30
// */
//@property (nonatomic, copy) NSString* sid;
//
//@end
//
//
////************************************************************************************
//#pragma mark - 3.1.7	更新用户信息
///**
// *	@brief	3.1.7.1	功能说明
//				 更新用户信息。
//				 3.1.7.2	输入
//				 http://IP:PORT/CalendarApp/user/update.do
//			 3.1.6.2	输入
// *
// *	Created by gao on 2014-06-27 17:17
// */
//@interface DRequestUpdate:DBaseRequest
//
///**
// *	@brief		是	String	1-32	会话ID	6
// *
// *	Created by gao on 2014-06-27 17:18
// */
//@property (nonatomic, copy) NSString* sid;
//
///**
// *	@brief		是	String	1-32	外部活动ID 	6
// *
// *	Created by gao on 2014-06-27 17:19
// */
//@property (nonatomic, copy)NSString* gid;
//
///**
// *	@brief		否	String	1-128	用户昵称	6
// *
// *	Created by gao on 2014-06-27 17:19
// */
//@property (nonatomic, copy)NSString*  nickname;
//
//
///**
// *	@brief		否	String	1-128	用户头像	6
// *
// *	Created by gao on 2014-06-27 17:20
// */
//@property (nonatomic, copy) NSString*  photoUrl;
//
//@property (nonatomic, copy) NSString*  sex;
//@property (nonatomic, assign) double  birthDate;
//@property (nonatomic, copy) NSString*  regionCode;
//@property (nonatomic, copy) NSString*  introduction;
//
///**
// *  	否	String	1-11	行业，这里填写一个配置key就可以了
// *
// */
//@property (nonatomic, copy) NSString*  industry;
//
///**
// *  	否	String	1-30	职业
// *
// */
//@property (nonatomic, copy) NSString*  occupation;
//
///**
// *  	否	Strign	1-30	兴趣
// *
// */
//@property (nonatomic, copy) NSString*  interest;
//
///**
// *	@brief		是	long	1-32	时间戳	6
// *
// *	Created by gao on 2014-06-27 17:20
// */
//@property(nonatomic, assign) long long  timestamp;
//
//@end
//
//@interface DResponsedUpdate : DBaseResponsed
//@end
//
//
////************************************************************************************
//#pragma mark - 3.1.9	关注好友
///**
// *	@brief 3.1.9	关注好友
// 3.1.9.1	功能说明
// 关注用户
// 3.1.9.2	输入
// http://IP:PORT/user/follow/save.do
// 
// *
// *	Created by gao on 2014-08-27 17:27:40
// */
//@interface DRequestFollowSave:DBaseRequest
//
///**
// *	@brief		是	String	1-32	会话ID	6
// *
// *	Created by gao on 2014-08-27 17:27:40
// */
//@property (nonatomic, copy) NSString* sid;
//
///**
// *	@brief	是	String	1-11	被关注人用户Id。
// *
// *	Created by gao on 2014-08-27 17:27:40
// */
//@property (nonatomic, assign) NSInteger toUserId;
//
//
///**
// *	@brief		是	long	1-32	时间戳	6
// *
// *	Created by gao on 2014-08-27 17:27:40
// */
//@property(nonatomic, assign) long long  timestamp;
//
//@end
//
//@interface DResponsedFollowSave : DBaseResponsed
//@end
//
//
////************************************************************************************
//#pragma mark - 3.1.10	取消关注
///**
// *	@brief 3.1.10	取消关注
//		 3.1.10.1	功能说明
//		 取消已关注用户
//		 3.1.10.2	输入
//		 http://IP:PORT/user/follow/cancel.do
//
// *
// *	Created by gao on 2014-08-27 17:27:40
// */
//@interface DRequestFollowCancel: DBaseRequest
//
///**
// *	@brief		是	String	1-32	会话ID	6
// *
// *	Created by gao on 2014-08-27 17:27:40
// */
//@property (nonatomic, copy) NSString* sid;
//
///**
// *	@brief	是	String	1-11	被关注人用户Id。
// *
// *	Created by gao on 2014-08-27 17:27:40
// */
//@property (nonatomic, assign) NSInteger toUserId;
//
//
///**
// *	@brief		是	long	1-32	时间戳	6
// *
// *	Created by gao on 2014-08-27 17:27:40
// */
//@property(nonatomic, assign) long long  timestamp;
//
//@end
//
//@interface DResponsedFollowCancel : DBaseResponsed
//@end
//
//
////************************************************************************************
//#pragma mark - 3.1.11	关注总数
// /**
// *	@brief  3.1.11.1	功能说明
// 我关注的用户总数
// 3.1.11.2	输入
// http://IP:PORT/user/following/count.do
// *
// *	Created by gao on 2014-06-27 17:17
// */
//@interface DRequestFollowingCount:DBaseRequest
//
///**
// *	@brief		是	String	1-32	会话ID	6
// *
// *	Created by gao on 2014-08-20 17:07
// */
//@property (nonatomic, copy) NSString* sid;
//
///**
// *	@brief		是	long	1-32	时间戳	6
// *
// *	Created by gao on 2014-08-20 17:07
// */
//@property(nonatomic, assign) long long  timestamp;
//
//@end
//
///**
// *	@brief	关注人列表返回数据。
// *
// *	Created by gao on 2014-08-20 17:08
// */
//@interface DResponsedFollowingCount : DBaseResponsed
///**
// *	@brief	关注雷列表数据。
// *
// *	Created by gao on 2014-08-20 17:08
// */
//@property(nonatomic, assign) NSInteger count;
//
//@end
//
////************************************************************************************
//#pragma mark - 3.1.12	粉丝总数
///**
// *	@brief  3.1.12	粉丝总数
//         3.1.12.1	功能说明
//         我的粉丝总数
//         3.1.12.2	输入
//         http://IP:PORT/user/follower/count.do *
// *	Created by gao on 2014-06-27 17:17
// */
//@interface DRequestFollowerCount:DBaseRequest
//
///**
// *	@brief		是	String	1-32	会话ID	6
// *
// *	Created by gao on 2014-08-20 17:07
// */
//@property (nonatomic, copy) NSString* sid;
//
///**
// *	@brief		是	long	1-32	时间戳	6
// *
// *	Created by gao on 2014-08-20 17:07
// */
//@property(nonatomic, assign) long long  timestamp;
//
//@end
//
///**
// *	@brief	关注人列表返回数据。
// *
// *	Created by gao on 2014-08-20 17:08
// */
//@interface DResponsedFollowerCount : DBaseResponsed
///**
// *	@brief	关注雷列表数据。
// *
// *	Created by gao on 2014-08-20 17:08
// */
//@property(nonatomic, assign) NSInteger count;
//
//@end
//
//
//
//
//
//
//
////************************************************************************************
//#pragma mark -3.1.13	关注人列表
///**
// *	@brief  3.1.13.1	功能说明
//	 我的关注人列表
//	 3.1.13.2	输入
//	 http://IP:PORT/user/following/queryList.do
// *
// *	Created by gao on 2014-06-27 17:17
// */
//@interface DRequestFollowingList:DBaseRequest
//
///**
// *	@brief		是	String	1-32	会话ID	6
// *
// *	Created by gao on 2014-08-20 17:07
// */
//@property (nonatomic, copy) NSString* sid;
//
///**
// *	@brief		记录ID。当followId为0时，默认获取最新pageSize条数据。
// *
// *	Created by gao on 2014-08-20 17:07
// */
//@property (nonatomic, assign) NSInteger followId;
///**
// *	@brief		否	Int	1-32	每次查询数量，默认值为10	1
// *
// *	Created by gao on 2014-08-20 17:07
// */
//@property (nonatomic, assign) NSInteger pageSize;
//
//
///**
// *	@brief		否	Int	1-3	0：向下翻页，查询最新的数据；1：向上翻页
// *
// *	Created by gao on 2014-08-20 17:07
// */
//@property (nonatomic, assign)NSInteger pageFlag;
//
///**
// *	@brief		是	long	1-32	时间戳	6
// *
// *	Created by gao on 2014-08-20 17:07
// */
//@property(nonatomic, assign) long long  timestamp;
//
//@end
//
///**
// *	@brief	关注人列表返回数据。
// *
// *	Created by gao on 2014-08-20 17:08
// */
//@interface DResponsedFollowingList : DBaseResponsed
///**
// *	@brief	关注雷列表数据。
// *
// *	Created by gao on 2014-08-20 17:08
// */
//@property(nonatomic, strong) NSMutableArray* arrFollowers;
//@end
//
//
//
//
////************************************************************************************
//#pragma mark - 3.1.14	粉丝列表
///**
// *	@brief3.1.14	粉丝列表
// 3.1.14.1	功能说明
// 我的粉丝列表
// 3.1.14.2	输入
// http://IP:PORT/user/follower/queryList.do
// 3.1.6.2	输入
// *
// *	Created by gao on 2014-06-27 17:17
// */
//@interface DRequestFollowerList:DBaseRequest
//
///**
// *	@brief		是	String	1-32	会话ID	6
// *
// *	Created by gao on 2014-08-20 17:07
// */
//@property (nonatomic, copy) NSString* sid;
//
///**
// *	@brief		记录ID。当followId为0时，默认获取最新pageSize条数据。
// *
// *	Created by gao on 2014-08-20 17:07
// */
//@property (nonatomic, assign) NSInteger followId;
///**
// *	@brief		否	Int	1-32	每次查询数量，默认值为10	1
// *
// *	Created by gao on 2014-08-20 17:07
// */
//@property (nonatomic, assign) NSInteger pageSize;
//
//
///**
// *	@brief		否	Int	1-3	0：向下翻页，查询最新的数据；1：向上翻页
// *
// *	Created by gao on 2014-08-20 17:07
// */
//@property (nonatomic, assign)NSInteger pageFlag;
//
///**
// *	@brief		是	long	1-32	时间戳	6
// *
// *	Created by gao on 2014-08-20 17:07
// */
//@property(nonatomic, assign) long long  timestamp;
//
//@end
//
//
//@interface DResponsedFollowerList : DBaseResponsed
///**
// *	@brief	粉丝数据。
// *
// *	Created by gao on 2014-08-20 17:08
// */
//@property(nonatomic, strong) NSMutableArray* arrFollowers;
//@end
//
//
//////************************************************************************************
//#pragma mark - 3.1.15	上报用户坐标信息
///**
// *	@brief  3.1.15.1	功能说明
// 用户在启动小D活动时，若已经登录，则上传用户地理坐标，作为用户近期坐标。
// 3.1.15.2	输入
// http://IP:PORT/user/sendUserGeo.do
// *
// *	Created by gao on 2014-06-27 17:17
// */
//@interface DRequestSendUserGeo:DBaseRequest
//
///**
// *	@brief		是	String	1-32	会话ID	6
// *
// *	Created by gao on 2014-08-20 17:07
// */
//@property (nonatomic, copy) NSString* sid;
//
//
///**
// *  double	1-32	用户近期坐标经度
// */
//@property (nonatomic, assign) double  userLongitude;
//
///**
// *  是	double	1-32	用户近期坐标纬度
// */
//@property (nonatomic, assign) double  userLatitude;
//
///**
// *	@brief		是	long	1-32	时间戳	6
// *
// *	Created by gao on 2014-08-20 17:07
// */
//@property(nonatomic, assign) long long  timestamp;
//
//@end
//
///**
// *	@brief
// *
// *	Created by gao on 2014-08-20 17:08
// */
//@interface DResponsedSendUserGeo : DBaseResponsed
//
//@end
//
//
//////************************************************************************************
//#pragma mark - 3.1.16	查询指定用户活动数量
///**
// *	@brief  3.1.16.1	功能说明
// 查询指定用户活动数量。
// 3.1.16.2	输入
// http://IP:PORT/user/queryUserEventCount.do
// *
// *	Created by gao on 2014-06-27 17:17
// */
//@interface DRequestQueryUserEventCount:DBaseRequest
//
///**
// *	@brief		是	String	1-32	会话ID	6
// *
// *	Created by gao on 2014-08-20 17:07
// */
//@property (nonatomic, copy) NSString* sid;
//
//
///**
// *  		用户Id
// */
//@property (nonatomic, assign) NSInteger  userId;
//
//
///**
// *	@brief		是	long	1-32	时间戳	6
// *
// *	Created by gao on 2014-08-20 17:07
// */
//@property(nonatomic, assign) long long  timestamp;
//
//@end
//
///**
// *	@brief
// *
// *	Created by gao on 2014-08-20 17:08
// */
//@interface DResponsedQueryUserEventCount : DBaseResponsed
//
///**
// *  参与的活动
// *
// */
//@property (nonatomic, assign)NSInteger  joinEventCount;
//
///**
// *  自己发起的活动数量。
// *
// */
//@property (nonatomic, assign)NSInteger createEventCount;
//
//@end




//
////************************************************************************************
//#pragma mark - 3.2	活动管理
////************************************************************************************
//#pragma mark - 3.2.1	创建/更新活动
///**
// *	@brief	3.2.1.1	功能说明
//			 用户创建/更新自定义活动
//			 当请求头中apiversion为2时,增加业务处理：
//			 创建/更新活动时，添加活动类型和被邀请人信息，并向被邀请人发出Push通知。
//			 迭代五：当请求头中apiversion为3时,增加业务操作：活动管理模块，增加地点经纬度，抽出版本号和删除标识，增加操作记录。
//			 迭代七：当请求头中apiversion为4时,增加业务操作：拆分活动创建和邀请接口。去掉valarm，inviter字段。
//			 迭代八：当请求头中apiversion为5时,活动介绍字段为数组结构。
//			 3.2.1.2	输入
//			 http://IP:PORT/CalendarApp/event/putEvent.do?mac=XXXX
// *
// *	Created by gao on 2014-05-27 11:04
// */
//@interface DRequestPutEvent:DBaseRequest
///**
// *	@brief
// *
// *	Created by gao on 2014-05-27 11:08
// */
//@property (nonatomic, copy) NSString* sid;
//
//
///**
// *	@brief	活动信息
// *
// *	Created by gao on 2014-05-27 11:10
// */
//@property (nonatomic, strong) DEventData* event;
//
///**
// *	@brief		是	Int	1-32	时间戳	1
// *
// *	Created by gao on 2014-05-27 11:08
// */
//@property (nonatomic, assign) long long   timestamp;
//
///**
// *	@brief		是	String	1-32	MD5(sid + timestamp + 密钥)	1
// *
// *	Created by gao on 2014-05-27 11:08
// */
//@property (nonatomic, copy) NSString* mac;
//
//@end
//
///**
// *	@brief
// *
// *	Created by gao on 2014-05-27 11:06
// */
//@interface DResponsedPutEvent: DBaseResponsed
//
///**
// *	@brief		String	1-32	新创建活动的外部ID
//
// *
// *	Created by gao on 2014-05-27 11:44
// */
//@property (nonatomic, copy) NSString *gid;
//@property (nonatomic, copy) NSString *eventSign;
//
//
//@end
//
////************************************************************************************
//#pragma mark - 3.2.2	删除活动
////************************************************************************************
///**
// *	@brief	3.2.2.1	功能说明
// 删除自定义活动
// 当请求头中apiversion为2时,增加业务处理：
// 删除活动时，向被邀请人发出Push通知。
// 迭代五：增加业务操作：活动管理模块，抽出版本号和删除标识，增加操作记录。
// 3.2.2.2	输入
// http://IP:PORT/CalendarApp/event/delEvent.do?mac=XXXX
// *
// *	Created by gao on 2014-06-03 10:01
// */
//@interface DRequestDelEvent: DBaseRequest
///**
// *	@brief
// *
// *	Created by gao on 2014-05-27 11:08
// */
//@property (nonatomic, copy) NSString* sid;
//
///**
// *	@brief		是	Int	1-32	时间戳	1
// *
// *	Created by gao on 2014-05-27 11:08
// */
//@property (nonatomic, assign) long long   timestamp;
//
//
//
///**
// *	@brief	gid	是	String	1-32	外部活动ID，删除时需要带上
// *
// *	Created by gao on 2014-06-03 10:03
// */
//@property (nonatomic, copy) NSString * gid;
//
//
//@end
//
//@interface DResponsedDelEvent : DBaseResponsed
//
//@end
//
//
////************************************************************************************
//#pragma mark - 3.2.3	增量同步活动接口
///**
// *	@brief	3.2.3	增量同步活动接口
//	 3.2.3.1	功能说明
//	 增量同步接口，获取返回的增加/更新、删除的gid。
//	 当请求头中apiversion为2时,增加业务处理：
//	 增量同步活动时，添加活动类型和被邀请人信息。
//	 迭代五：增量同步时，从活动表、活动参与表和操作表中筛选数据。
//	 同步的活动包括：
//	 1．	自己创建的活动：
//	 （1）	更新的活动；
//	 （2）	删除的活动；
//	 2．	受邀请的活动
//	 迭代八：当请求头中apiversion为5时,活动介绍字段为数组结构。
//	 增加pageFlag标识增量查询的方向： 0：向下翻页，查询最新的数据；1：向上翻页，查询历史数据。
// *
// *	Created by gao on 2014-05-28 10:43
// */
//@interface DRequestSyncEvent : DBaseRequest
//
///**
// *	@brief
// *
// *	Created by gao on 2014-05-27 11:08
// */
//@property (nonatomic, copy) NSString* sid;
//
///**
// *	@brief		是	Int	1-32	时间戳	1
// *
// *	Created by gao on 2014-05-27 11:08
// */
//@property (nonatomic, assign) long long  timestamp;
//
//
//
///**
// *	@brief		否	long	1-32	活动版本号,默认从版本当前时间戳开始，即查询所有活动	1
// *
// *	Created by gao on 2014-05-28 10:44
// */
//@property (nonatomic, assign) double version;
///**
// *	@brief		否	Int	1-32	每次查询数量，默认值为10	1
// *
// *	Created by gao on 2014-05-28 10:45
// */
//@property (nonatomic, assign) NSInteger pageSize;
//
//
///**
// *	@brief		否	Int	1-3	0：向下翻页，查询最新的数据；1：向上翻页，查询历史数据	5
// *
// *	Created by gao on 2014-05-28 10:45
// */
//@property (nonatomic, assign)NSInteger pageFlag;
//
//@end
//
//@interface DResponsedSyncEvent : DBaseResponsed
///**
// *	@brief  array	1-1024	创建/更新的活动详情列表
// *
// *	Created by gao on 2014-05-28 11:06
// */
//@property(nonatomic, strong) NSMutableArray* arrUpdateEvents;
//
///**
// *	@brief  array	1-1024	删除的活动gid列表
// *
// *	Created by gao on 2014-05-28 11:07
// */
//@property(nonatomic, strong) NSMutableArray* arrDelEvents;
///**
// *	@brief		Int	1	是否有下一页   0：否    1：是
// *
// *	Created by gao on 2014-05-28 11:07
// */
//@property(nonatomic, assign) NSInteger isHasNextPage;
//
///**
// *	@brief	long	1-32	下一次同步需要带的version;
// *
// *	Created by gao on 2014-05-28 11:07
// */
//@property(nonatomic, assign) double version;
//@end
//
//
//
//
//#pragma mark - 3.2.4	批量查询活动详情
////************************************************************************************
///**
// *	@brief	3.2.4.1	功能说明
//			 批量查询活动详情
//			 迭代五：从活动表、活动参与表和操作表中筛选数据。
//			 迭代八：当请求头中apiversion为5时,活动介绍字段为数组结构。
//			 迭代九：增加费用和费用描述字段。
// 
//			 3.2.4.2	输入
//			 http://IP:PORT/CalendarApp/ event/queryEventBatch.do?mac=XXXX
// *
// *	Created by gao on 2014-06-13 15:55
// */
//@interface DRequestQueryEventBatch:DBaseRequest
//
///**
// *	@brief		是	String	1-32	会话ID	1
// *
// *	Created by gao on 2014-06-13 15:56
// */
//@property (nonatomic, copy) NSString* sid;
//
///**
// *	@brief		是	String	1-32	外部活动ID 列表，以英文逗号分隔	1
// *
// *	Created by gao on 2014-06-13 15:56
// */
//@property (nonatomic,copy) NSString *gidList;
//
//
///**
// *	@brief		否	String	1-6	活动唯一短标识；
// *
// *	Created by gao on 2014-08-08 15:22
// */
//@property (nonatomic,copy) NSString *eventSign;
//
///**
// *	@brief		是	long	1-32	时间戳	1
// *
// *	Created by gao on 2014-06-13 15:56
// */
//@property (nonatomic, assign) long long timestamp;
//
///**
// *	@brief		是	String	1-32	MD5(sid + timestamp + 密钥)	1
// *
// *	Created by gao on 2014-06-13 15:57
// */
//@property (nonatomic, copy) NSString* mac;
//
//@end
//
//
//@interface DResponsedQueryEventBatch : DBaseResponsed
//
//@property (nonatomic, strong) NSMutableArray* arrEvents;
//
//@end
//
//
////************************************************************************************
//#pragma mark - 3.2.5	分享活动
///**
// *	@brief	3.2.5.1	功能说明
//			 分享自定义活动
//			 迭代五：更新返回参数字段。
//			 迭代八：当请求头中apiversion为5时,活动介绍字段为数组结构。
//			 
//			 3.2.5.2	输入
//			 http://IP:PORT/CalendarApp/ event/shareEvent.do?mac=XXXX
// *
// *	Created by gao on 2014-06-13 16:06
// */
//
//@interface DRequestShareEvent: DBaseRequest
//
///**
// *	@brief
// *
// *	Created by gao on 2014-06-13 16:06
// */
//@property (nonatomic, copy) NSString* sid;
//
//
//
///**
// *	@brief	gid	是	String	1-32	外部活动ID
// *
// *	Created by gao on 2014-06-13 16:06
// */
//@property (nonatomic, copy) NSString * gid;
//
//
//
//
///**
// *	@brief		是	Int	1-32	时间戳	1
// *
// *	Created by gao on 2014-06-13 16:06
// */
//@property (nonatomic, assign) long long  timestamp;
//@end
//
//
//
//@interface DResponsedShareEvent: DBaseResponsed
///**
// *	@brief url
// *
// *	Created by gao on 2014-06-13 16:06
// */
//@property (nonatomic, copy) NSString * shareUrl;
//
//@end
////************************************************************************************
//
//#pragma mark - 3.2.6	查询活动详情
//@interface DRequestQueryEventDetails: DBaseRequest
///**
// *	@brief		是	String	1-32	活动ID	5
// *
// *	Created by gao on 2014-07-18 12:36
// */
//@property (nonatomic, copy) NSString* eventSign;
///**
// *	@brief		是	long	1-32	时间戳	5
// *
// *	Created by gao on 2014-07-18 12:36
// */
//@property (nonatomic, assign) long long timestamp;
//@end
//
//@interface DResponsedQueryEventDetails: DBaseResponsed
///**
// *	@brief	<#Description#>
// *
// *	Created by gao on 2014-07-18 12:37
// */
//@property (nonatomic, strong) DEventData *varEventData;
//
//@end
////************************************************************************************
//
//
//#pragma mark - 3.2.7	更新活动状态
///**
// *	@brief	3.2.7.1	功能说明
//		 活动可以取消，但不支持取消后恢复。
//		 取消活动，需要处理的业务：
//		 1．	更新该活动的version版本；
//		 2．	将所有该项活动的投票信息置为已结束；
//		 3．	活动为取消状态后，不能更新活动信息；
//		 4．	活动为取消状态后，不能创建投票；
//		 5．	用户讨论、分享模块可正常操作；
//		 6．	向所有参与人发送取消活动PUSH消息；
//		 3.2.7.2	输入
//		 http://IP:PORT/CalendarApp/event/updateStatus.do?mac=XXXX
// *
// *	Created by gao on 2014-08-08 17:34
// */
//@interface  DRequestUpdateStatus: DBaseRequest
///**
// *	@brief		是	String	1-32	会话ID
// *
// *	Created by gao on 2014-08-08 17:35
// */
//@property (nonatomic, copy) NSString* sid;
//
///**
// *	@brief		是	String	1-32	外部活动ID，删除时需要带上
// *
// *	Created by gao on 2014-08-08 17:35
// */
//@property (nonatomic, copy) NSString* gid;
///**
// *	@brief		是	int	1-3	活动状态：0：正常；1：取消；
// *
// *	Created by gao on 2014-08-08 17:36
// */
//@property (nonatomic, assign) NSInteger eventStatus;
///**
// *	@brief		是	Int	1-32	时间戳
// *
// *	Created by gao on 2014-08-08 17:36
// */
//@property (nonatomic, assign) long long timestamp;
//
//@end
//
//@interface DResponsedUpdateStatus: DBaseResponsed
//@end
////************************************************************************************
//
//
//
//
//#pragma mark - 3.2.8	活动广场查询活动列表
///**
// *	@brief	3.2.8.1	功能说明
//		 活动广场查询活动列表，筛选条件：当前用户所在城市、活动是否过期的状态。
//		 最新的的活动列表：按活动创建时间倒序排列；
//		 附近的活动列表：按用户当前坐标与该活动创建时坐标的距离升序排列；
//		 3.2.8.2	输入
//		 http://IP:PORT/CalendarApp/event/queryEventSquare.do?mac=XXXX
// *
// *	Created by gao on 2014-08-22 16:55
// */
//@interface DRequestQueryEventSquare: DBaseRequest
//
///**
// *	@brief		是	String	1-32	当前用户所在的城市编码
// *
// *	Created by gao on 2014-08-22 16:56
// */
//@property (nonatomic, copy) NSString* regionCode;
//
//
///**
// *	@brief		是	String	1-32	会话ID
// *
// *	Created by gao on 2014-06-15 20:29
// */
//@property (nonatomic, copy) NSString* sid;
//
///**
// *	@brief		是	double	1-32	当前用户所在的经度
// *
// *	Created by gao on 2014-08-22 16:56
// */
//@property (nonatomic, assign) double longitude;
//
///**
// *	@brief		是	Double	1-32	当前用户所在的纬度
// *
// *	Created by gao on 2014-08-22 16:57
// */
//@property (nonatomic, assign) double latitude;
//
///**
// *	@brief		是	int	1-3	活动状态筛选：1.全部；2.未过期；3.已过期；
// 注：以“今天”来判断是否过期，活动开始日期为“今天”及将来的表示未过期，活动开始日期为“今天”以前的表示已过期。
// *
// *	Created by gao on 2014-08-22 16:57
// */
//@property (nonatomic, assign) NSInteger expireStatus;
//
///**
// *	@brief		是	int	1-3	排序类型：1：按活动创建时间降序排列；2：按用户当前坐标与该活动创建时坐标的距离升序排列
// *
// *	Created by gao on 2014-08-22 16:57
// */
//@property (nonatomic, assign) NSInteger sortType;
//
///**
// *	@brief		否	long	1-32	创建时间，当sortType为1时有值。
// *
// *	Created by gao on 2014-08-22 16:57
// */
//@property (nonatomic, assign) long long createTime;
//
///**
// *	@brief		否	double	1-128	用户当前坐标与该活动创建时坐标的距离，以米为单位，当sortType为2时有值
// *
// *	Created by gao on 2014-08-22 16:57
// */
//@property (nonatomic, assign) double distance;
//
///**
// *	@brief		是	Int	1-32	每次查询数量，默认值为10
// *
// *	Created by gao on 2014-08-22 16:57
// */
//@property (nonatomic, assign) NSInteger pageSize;
//
///**
// *	@brief		已查询到的活动的数量
// *
// *	Created by gao on 2014-08-22 16:58
// */
//@property (nonatomic, assign) NSInteger index;
///**
// *	@brief		是	long	1-32	时间戳	5
// *
// *	Created by gao on 2014-08-22 16:55
// */
//@property (nonatomic, assign) long long timestamp;
//
//@end
//
//@interface DResponsedQueryEventSquare: DBaseResponsed
// /**
// *	@brief	活动广场查询中获取到的最大的距离。
// *
// *	Created by gao on 2014-08-26 17:19
// */
//@property (nonatomic, assign) double maxDistance;
//
///**
// *	@brief	活动广场查询中分页查询需要 使用到上次查询获取的最大的 cretamatme
// *
// *	Created by gao on 2014-08-26 17:19
// */
//@property (nonatomic, assign) long long minCreateTime;
//
//@property (nonatomic, strong) NSMutableArray *varArrEventData;
//
//@end
//
//
//#pragma mark - 3.2.9	查询我的活动列表接口
////************************************************************************************
///**
// *	@brief
//     3.2.9.1	功能说明
// 查询自己的活动列表。
// 3.2.9.2	输入
// http://IP:PORT/event/queryEventList.do?mac=XXXX
// *
// *	Created by gao on 2014-06-15 20:28
// */
//@interface DRequestQueryEventList: DBaseRequest
//
///**
// *	@brief		是	String	1-32	会话ID
// *
// */
//@property (nonatomic, copy) NSString* sid;
//
///**
// *	@brief		是	Int	1-32	时间戳	1
// *
// */
//@property (nonatomic, assign) long long  timestamp;
//
//
///**
// *	@brief	gid	是	String	1-32	外部活动ID
// *
// *	Created by gao on 2014-06-15 20:29
// */
//@property (nonatomic, assign) NSInteger  pageSize;
//
///**
// *	@brief		是	String	1-32	MD5(sid + timestamp + 密钥)	1
// *
// *	Created by gao on 2014-06-15 20:29
// */
//@property (nonatomic, assign) NSInteger pageIndex;
//
//@end
//
//
//@interface DResponsedQueryEventList: DBaseResponsed
//
//@end
//
//
//
//#pragma mark -3.2.10	查询用户参与活动列表接口
////************************************************************************************
///**
// *	@brief  3.2.10.1	功能说明
//         查询自己的参与活动列表。
//         3.2.10.2	输入
//         http://IP:PORT/event/join/list.do?mac=XXXX
// *
// */
//@interface DRequestJoinList: DBaseRequest
//
///**
// *  是	String	1-32	会话ID	9
// *
// */
//@property (nonatomic, copy) NSString * sid;
//
///**
// *  	是	Int	1-32	每次查询数量，默认值为20	9
// *
// */
//@property (nonatomic, assign) NSInteger pageSize;
//
///**
// *  	加入活动的时间
// *
// */
//@property (nonatomic, assign) long long joinTime;
//
///**
// *  	否	Int	1-11
// *
// */
//@property (nonatomic, assign) NSInteger userId;
//
///**
// *  是	Int	1-32	时间戳	9
// *
// */
//@property (nonatomic, assign) long long timestamp;
//
//@end
//
//@interface DResponsedJoinList: DBaseResponsed
//@property (nonatomic, strong) NSMutableArray *arrVarEvetns;
//@end
//
//
//#pragma mark - 3.2.11	查询用户发起活动列表接口
////************************************************************************************
///**
// *	@brief	
//         3.2.11.1	功能说明
//         查询自己的发起活动列表。
//         3.2.11.2	输入
//         http://IP:PORT/event/create/list.do?mac=XXXX
// */
//@interface DRequestCreateList: DBaseRequest
//
///**
// *  是	String	1-32	会话ID	9
// *
// */
//@property (nonatomic, copy) NSString * sid;
//
///**
// *  	是	Int	1-32	每次查询数量，默认值为20	9
// *
// */
//@property (nonatomic, assign) NSInteger pageSize;
//
///**
// *  	是	Int	1-3	活动ID	9
// *
// */
//@property (nonatomic, assign) NSInteger eventId;
//
///**
// *  	否	Int	1-11
// *
// */
//@property (nonatomic, assign) NSInteger userId;
//
///**
// *  是	Int	1-32	时间戳	9
// *
// */
//@property (nonatomic, assign) long long timestamp;
//
//@end
//
//
//@interface DResponsedCreateList: DBaseResponsed
//@property (nonatomic, strong) NSMutableArray *arrVarEvetns;
//@end

//
//#pragma mark - 3.3	活动邀请管理
////************************************************************************************
//
//#pragma mark - 3.3.1	更新邀请状态
////************************************************************************************
///**
// *	@brief	3.3.1	参与人加入/退出活动
//	 3.3.1.1	功能说明
//	 更新邀请状态
//	 迭代九：凡是有参与人加入或退出，都PUSH消息给发起人。
//	 增加业务逻辑：若当前邀请状态为5（报名参加），则删除该参与人记录。
//	 参与者变更邀请状态，主要有以下场景：
//	 （1）	主动加入活动；（增加参与人记录，2加入）
//	 （2）	主动退出活动；（删除参与人记录,3退出）
//	 （3）	迭代十二：增加业务操作，
//	 主动加入活动：判断活动是否需要审核，若需要审核(inviteStatus:4)，则须填写报名审核资料，写入报名审核表；若不需要审核(inviteStatus:2)，则写入参与人表；
//	 主动退出活动：删除参与人记录、更新报名人状态,5已取消；
//	 取消报名：更新报名审核表状态为
//	 向活动发起人发出PUSH消息；
// *
// *	Created by gao on 2014-06-15 20:28
// */
//@interface DRequestUpdateInviteStatus: DBaseRequest
//
///**
// *	@brief		是	String	1-32	会话ID
// *
// *	Created by gao on 2014-06-15 20:29
// */
//@property (nonatomic, copy) NSString* sid;
//
///**
// *	@brief		是	Int	1-32	时间戳	1
// *
// *	Created by gao on 2014-06-15 20:29
// */
//@property (nonatomic, assign) long long  timestamp;
//
//
///**
// *	@brief	gid	是	String	1-32	外部活动ID
// *
// *	Created by gao on 2014-06-15 20:29
// */
//@property (nonatomic, copy) NSString * gid;
//
///**
// *	@brief		是	String	1-32	MD5(sid + timestamp + 密钥)	1
// *
// *	Created by gao on 2014-06-15 20:29
// */
//@property (nonatomic, copy) NSString* mac;
//
///**
// *	@brief   是 int	1-3	参与状态：
//								 0:未报名;
//								 1:发起人
//								 2:已同意；
//								 3：退出活动或拒绝；
//								 4：报名待审核；
//								 5：已取消
// *
// *  是	String	1-128	发起人昵称
// */
//@property (nonatomic, assign) NSInteger inviteStatus;
//
///**
// *	@brief		否	int	1-3	报名人数，当活动不需要审核时为必传参数
// *
// *	Created by gao on 2014-08-07 20:36
// */
//@property (nonatomic, assign) NSInteger number;
//
///**
// *	@brief		否	JSON		审核信息人列表
// *
// *	Created by gao on 2014-08-07 20:37
// */
//@property (nonatomic, strong) NSMutableArray* checkInfo;
//
//@end
//
//
//@interface DResponsedUpdateInviteStatus: DBaseResponsed
//
//@end
//
//#pragma mark - 3.3.2	更新邀请人
////************************************************************************************
///**
// *	@brief	3.3.2.1	更新邀请人
//             3.3.2.2	输入
//             http://IP:PORT/CalendarApp/event/updateInviter.do?mac=XXXX
// *
// *	Created by chengenlin on 2014-06-06 14:08
// */
//@interface DRequestUpdateInviter: DBaseRequest
//
///**
// *	@brief
// *
// *	Created by gao on 2014-05-27 11:08
// */
//@property (nonatomic, copy) NSString* sid;
//
///**
// *	@brief		是	Int	1-32	时间戳	1
// *
// *	Created by gao on 2014-05-27 11:08
// */
//@property (nonatomic, assign) long long  timestamp;
//
//
///**
// *	@brief	gid	是	String	1-32	外部活动ID
// *
// *	Created by chengenlin on 2014-06-06 14:08
// */
//@property (nonatomic, copy) NSString * gid;
//
///**
// *	@brief		是	String	1-32	MD5(sid + timestamp + 密钥)	1
// *
// *	Created by chengenlin on 2014-06-06 14:08
// */
//@property (nonatomic, copy) NSString* mac;
///**
// *  是	String	1-128	发起人昵称
// */
//@property (nonatomic, copy) NSString *senderUserName;
///**
// *  是	array	1-3	新增邀请人
// */
//@property (nonatomic, copy) NSMutableArray *addInviter;
///**
// *  是	String	1-1024	删除邀请人手机号码列表，以英文逗号分隔
// */
//@property (nonatomic, copy) NSMutableArray *delInviterList;
//
///**
// *  否	Array	1-1024	删除邀请人用户ID列表，以英文逗号分隔
// */
//@property (nonatomic, copy) NSMutableArray *  delUserIdList;
//
//
//@end
//
//@interface DResponsedUpdateInviter : DBaseResponsed
//
//@property (nonatomic, copy) NSArray *noIncludeList;
//
//@end
//
//#pragma mark - 3.3.3	查询活动所有参与人
////************************************************************************************
///**
// *	@brief	3.3.3.1	查询活动所有参与人
//            3.3.3.2	输入
//             http://IP:PORT/CalendarApp/event/queryAllInviter.do?mac=XXXX
// *
// *	Created by gao on 2014-06-03 10:01
// */
//@interface DRequestQueryAllInviter: DBaseRequest
///**
// *	@brief
// *
// *	Created by gao on 2014-05-27 11:08
// */
//@property (nonatomic, copy) NSString* sid;
//
///**
// *	@brief		是	Int	1-32	时间戳	1
// *
// *	Created by gao on 2014-05-27 11:08
// */
//@property (nonatomic, assign) long long  timestamp;
//
//
///**
// *	@brief	gid	是	String	1-32	外部活动ID
// *
// *	Created by chengenlin on 2014-06-06 14:08
// */
//@property (nonatomic, copy) NSString * gid;
//@end
//
//@interface DResponsedQueryAllInviter : DBaseResponsed
//
///**
// *	@brief	参与人列表，默认第一个参与人为发起人。
// *
// *	Created by gao on 2014-08-13 11:03
// */
//@property (nonatomic, strong) NSMutableArray *arrInviter;
//
//@end
//
//
//#pragma mark -3.3.4	邀请人报名参加活动
////************************************************************************************
///**
// *	@brief	3.3.4.1	功能说明
//			 迭代九：增加报名参加的人。
//			 1.	校验短信验证码；
//			 2.	校验是否达到活动最大参与人数限制
//			 3.	判断是否已经注册（未注册时，系统默认注册）
//			 4.	添加到活动报名邀请人列表
//			 5.	向发起人PUSH消息
//			 3.3.4.2	输入
//			 http://IP:PORT/CalendarApp/ event/joinInviter.do
// *
// *	Created by gao on 2014-06-15 20:38
// */
//@interface DRequestJoinInviter: DBaseRequest
//
///**
// *	@brief		是	String	1-11	用户手机号码
// *
// *	Created by gao on 2014-06-15 20:39
// */
//@property (nonatomic, copy) NSString* userName;
//
///**
// *	@brief	否	String	1-6	短信验证码。只有在请求头中apiversion为1，2时，为必选参数。
// *
// *	Created by gao on 2014-06-15 20:39
// */
//@property (nonatomic, copy) NSString* authCode;
//
///**
// *	@brief		是	String	1-32	外部活动ID
// *
// *	Created by gao on 2014-06-15 20:39
// */
//@property (nonatomic, copy) NSString* gid;
//
//@end
//
//@interface DResponsedJoinInviter: DBaseResponsed
//
//@end
//
//#pragma mark - 3.3.5	查询报名审核信息
///**
// *	@brief 3.3.5.1	功能说明
//		 活动发起人可以查询所有报名人列表的详细信息；
//		 3.3.5.2	输入
//		 http://IP:PORT/CalendarApp/ event/queryCheckInfo.do?mac=XXXX
// *
// *	Created by gao on 2014-06-15 20:38
// */
//@interface DRequestQueryCheckInfo: DBaseRequest
///**
// *	@brief		是	String	1-32	会话ID	7
// *
// *	Created by gao on 2014-08-13 16:43
// */
//@property (nonatomic, copy) NSString*  sid;
///**
// *	@brief		是	String	1-32	外部活动ID 	7
// *
// *	Created by gao on 2014-08-13 16:43
// */
//@property (nonatomic, copy) NSString* gid;
///**
// *	@brief		否	String	1-13	指定报名人的手机号码	7
// *
// *	Created by gao on 2014-08-13 16:43
// */
//@property (nonatomic, copy) NSString* userNumber;
///**
// *	@brief		否	int	1-32	审核ID，若第一次查询，可以传0	7
// *
// *	Created by gao on 2014-08-13 16:43
// */
//@property (nonatomic, assign) NSInteger checkId;
//
///**
// *	@brief		否	int	1-32	当前页查询数据条数,默认值20	7
// *
// *	Created by gao on 2014-08-13 16:44
// */
//@property (nonatomic, assign) NSInteger pageSize;
//
///**
// *	@brief		否	int	1-3	分页标识（0：查询大于checkId的数据，1：查询小于checkId的数据）	7
// *
// *	Created by gao on 2014-08-13 16:44
// */
//@property (nonatomic, assign) NSInteger pageflag;
//
//
///**
// *	@brief		是	long	1-32	时间戳	1
// *
// *	Created by gao on 2014-08-13 17:20
// */
//@property (nonatomic, assign) long long timestamp;
//
//
//@end
//
//@interface DResponsedQueryCheckInfo : DBaseResponsed
//
//@property (nonatomic, strong) NSMutableArray *arrQueryCheckinfo;
//
//@end
////************************************************************************************
//
//
//
//#pragma mark - 3.3.6	发起人同意报名人
///**
// *	@brief3.3.6.1	功能说明
//					 迭代十二增加业务操作：
//					 1．同意报名时，增加参与人表记录，更新报名审核信息表记录状态为2：同意加入活动；
//					 2．拒绝报名人时，更新报名审核信息表中报名人记录为3：拒绝；
//					 3．删除参与人时，删除参与人表记录，更新报名审核信息表中报名人记录为3：退出活动或拒绝；
//					 4．向报名人发出PUSH消息；
//					 3.3.6.2	输入
//					 http://IP:PORT/CalendarApp/ event/updateCheckStatusAccept.do?mac=XXXX
// *
// *	Created by gao on 2014-06-15 20:38
// */
//@interface DRequestUpdateCheckStatusAccept: DBaseRequest
//
///**
// *	@brief		是	String	1-32	会话ID	1
// *
// *	Created by gao on 2014-08-13 17:20
// */
//@property (nonatomic, copy) NSString*  sid;
///**
// *	@brief		是	String	1-32	外部活动ID 	1
// *
// *	Created by gao on 2014-08-13 17:20
// */
//@property (nonatomic, copy) NSString* gid;
//
///**
// *	@brief		是	String	1-128	发起人昵称	1
// *
// *	Created by gao on 2014-08-13 17:20
// */
//@property (nonatomic, copy) NSString* senderUserName;
///**
// *	@brief		否	array		同意报名人列表	7
// *
// *	Created by gao on 2014-08-13 17:20
// */
//@property (nonatomic, strong) NSMutableArray* acceptList;
//
///**
// *	@brief		是	long	1-32	时间戳	1
// *
// *	Created by gao on 2014-08-13 17:20
// */
//@property (nonatomic, assign) long long timestamp;
//
//@end
//
//@interface DResponsedUpdateCheckStatusAccept: DBaseResponsed
//
//@end
////************************************************************************************
//
//#pragma mark - 3.3.7	发起人拒绝报名人
///**
// *	@brief	3.3.7.1	功能说明
//			 迭代十二增加业务操作：
//			 1．同意报名时，增加参与人表记录，更新报名审核信息表记录状态为2：同意加入活动；
//			 2．拒绝报名人时，更新报名审核信息表中报名人记录为3：拒绝；
//			 3．删除参与人时，删除参与人表记录，更新报名审核信息表中报名人记录为3：退出活动或拒绝；
//			 4．向报名人发出PUSH消息；
//			 3.3.7.2	输入
//			 http://IP:PORT/CalendarApp/ event/updateCheckStatusRefuse.do?mac=XXXX
// *
// *	Created by gao on 2014-08-13 16:41
// */
//@interface  DRequestUpdateCheckStatusRefuse: DBaseRequest
//
///**
// *	@brief		是	String	1-32	会话ID	1
// *
// *	Created by gao on 2014-08-13 17:20
// */
//@property (nonatomic, copy) NSString*  sid;
///**
// *	@brief		是	String	1-32	外部活动ID 	1
// *
// *	Created by gao on 2014-08-13 17:20
// */
//@property (nonatomic, copy) NSString* gid;
//
///**
// *	@brief		是	String	1-128	发起人昵称	1
// *
// *	Created by gao on 2014-08-13 17:20
// */
//@property (nonatomic, copy) NSString* senderUserName;
///**
// *	@brief		否	array		同意报名人列表	7
// *
// *	Created by gao on 2014-08-13 17:20
// */
//@property (nonatomic, strong) NSMutableArray* refuseList;
//
///**
// *	@brief		是	long	1-32	时间戳	1
// *
// *	Created by gao on 2014-08-13 17:20
// */
//@property (nonatomic, assign) long long timestamp;
//
//@end
//
//@interface DResponsedUpdateCheckStatusRefuse: DBaseResponsed
//
//@end
////************************************************************************************




//************************************************************************************
//#pragma mark - 3.4	活动提醒管理
//
//
//#pragma mark - 3.4.1	更新参与者提醒信息
////************************************************************************************
///**
// *	@brief	3.4.1	更新参与者提醒信息
//			 3.4.1.1	功能说明
//			 增加、删除、更新参与者提醒信息。该接口用于活动被邀请者更新活动的提醒信息。
//			 3.4.1.2	输入
//			 http://IP:PORT/CalendarApp/ event/updateInviteAlarm.do?mac=XXXX
// *
// *	Created by gao on 2014-06-11 19:58
// */
//@interface  DRequestUpdateInviteAlarm  :DBaseRequest
///**
// *	@brief
// *
// *	Created by gao on 2014-05-27 11:08
// */
//@property (nonatomic, copy) NSString* sid;
//
///**
// *	@brief		是	Int	1-32	时间戳	1
// *
// *	Created by gao on 2014-05-27 11:08
// */
//@property (nonatomic, assign) long long  timestamp;
//
//
// /**
// *	@brief	外部活动ID 
// *
// *	Created by gao on 2014-06-11 20:03
// */
//@property (nonatomic, copy) NSString* gid;
//
///**
// *	@brief	提醒方式。提前提醒时间
// *
// *	Created by gao on 2014-06-11 20:04
// */
//@property(nonatomic, strong) NSMutableArray* valarm;
//@end
//
//
//@interface DResponsedUpdateInviteAlarm : DBaseResponsed
//@end
////************************************************************************************

//#pragma mark - 3.5	活动评论管理
////************************************************************************************
//#pragma mark - 3.5.1	活动评论
// /**
//  *	@brief    3.5.1.1	功能说明
//			  活动创建者、参与者、受邀者可以对活动进行评论，对活动进行评论后，向所有参与人Push消息。
//			  3.5.1.2	输入
//			  http://IP:PORT/CalendarApp/comment/commentEvent.do?mac=XXXX
// *
// *	Created by gao on 2014-06-10 17:04
// */
//@interface  DRequestCommentEvent  :DBaseRequest
//
///**
// *	@brief
// *
// *	Created by gao on 2014-05-27 11:08
// */
//@property (nonatomic, copy) NSString* sid;
//
///**
// *	@brief		是	Int	1-32	时间戳	1
// *
// *	Created by gao on 2014-05-27 11:08
// */
//@property (nonatomic, assign) long long  timestamp;
//
//
///**
// *	@brief		是	String	1-32	外部活动ID 	1
// *
// *	Created by gao on 2014-06-10 17:06
// */
//@property (nonatomic, copy) NSString* gid;
//
///**
// *	@brief		是	String	1-128	评论内容	1
// *
// *	Created by gao on 2014-06-10 17:06
// */
//@property (nonatomic,copy) NSString* content;
//@property (nonatomic,copy) NSString* type;
///**
// *	@brief		是	String	1-32	MD5(sid + timestamp + 密钥)	1
//
// *
// *	Created by gao on 2014-06-10 17:07
// */
//@property (nonatomic, copy) NSString* mac;
//
//@end
//
//@interface DResponsedCommentEvent : DBaseResponsed
///**
// *	@brief	活动评论时间
// *
// *	Created by gao on 2014-07-13 12:19
// */
//@property (nonatomic, assign) long long commentTime
//;
//@property (nonatomic, assign) long messageID;
//@end
//
//#pragma mark - 3.5.2	查询活动评论
///**
// *	@brief    3.5.2.1	功能说明
//                 查询活动评论
//              3.5.2.2	输入
//                 http://IP:PORT/comment/queryComment.do?mac=XXXX
// *
// *	Created by chengenlin on 2014-06-11 15:04
// */
//@interface  DRequestCommentQueryEvent  :DBaseRequest
//
///**
// *	@brief
// *
// *	Created by gao on 2014-05-27 11:08
// */
//@property (nonatomic, copy) NSString* sid;
//
//
///**
// *	@brief		是	Int	1-32	时间戳	1
// *
// *	Created by gao on 2014-05-27 11:08
// */
//@property (nonatomic, assign) long long  timestamp;
//
//
///**
// *	@brief		是	String	1-32	外部活动ID 	1
// *
// *	Created by chengenlin on 2014-06-11 15:04
// */
//@property (nonatomic, copy) NSString* gid;
//
///**
// *	@brief		是	Int	1-32	活动评论ID。当commentId为0时，默认获取最新pageSize条数据。
// *
// *	Created by chengenlin on 2014-06-11 15:04
// */
//@property (nonatomic, assign) NSInteger commentId;
//
///**
// *	@brief		是	int	1-32	当前页查询数据条数,默认值20
// *
// *	Created by chengenlin on 2014-06-11 15:04
// */
//@property (nonatomic,assign) NSInteger pageSize;
//
///**
// *	@brief		是	int	1-3	分页标识（0：向下翻页，1：向上翻页）
// *
// *	Created by chengenlin on 2014-06-11 15:04
// */
//@property (nonatomic,assign) NSInteger pageFlag;
//
///**
// *	@brief		是	String	1-32	MD5(sid + timestamp + 密钥)	1
// 
// *
// *	Created by chengenlin on 2014-06-11 15:04
// */
//@property (nonatomic, copy) NSString* mac;
//
//@end
//
//@interface DResponsedCommentQueryEvent : DBaseResponsed
//
//@property (nonatomic, strong) NSMutableArray *commentList;
//
//@end
//
//
////************************************************************************************
//#pragma mark - 3.5.3	查询活动评论的总数量
///**
// *	@brief	3.5.3.1	功能说明
//				 查询某一个活动评论的总数量。
//				 3.5.3.2	输入
//				 http://IP:PORT/CalendarApp/comment/queryCommentNumByGid.do?mac=XXXX
// *
// *	Created by gao on 2014-06-15 20:44
// */
//@interface DRequestQueryCommentNum : DBaseRequest
//
///**
// *	@brief
// *
// *	Created by gao on 2014-06-15 20:44
// */
//@property (nonatomic, copy) NSString* sid;
//
///**
// *	@brief	gid	是	String	1-32	外部活动ID
// *
// *	Created by gao on 2014-06-15 20:44
// */
//@property (nonatomic, copy) NSString * gid;
//
//
///**
// *	@brief	gid	是	String	1-32	活动唯一短标识
// *
// *	Created by gao on 2014-06-15 20:44
// */
//@property (nonatomic, copy) NSString * eventSign;
//
//
///**
// *	@brief		是	Int	1-32	时间戳	1
// *
// *	Created by gao on 2014-06-15 20:44
// */
//@property (nonatomic, assign) long long  timestamp;
//
//@end
//
//@interface DResponsedQueryCommentNum : DBaseResponsed
//
///**
// *	@brief		是	int	1-32	活动评论总数量
// *
// *	Created by gao on 2014-06-15 20:46
// */
//@property (nonatomic, assign) NSInteger commentNum;
//
//@end

////************************************************************************************
//#pragma mark - 3.6	基础数据接口
//
//
//#pragma mark -3.6.1	发送消息通知到PNS
////************************************************************************************
//
//#pragma mark - 3.6.2	上传图片
////************************************************************************************
///**
// *	@brief	3.6.2.1	功能说明
//			 上传图片,接口支持批量上传。
//			 3.6.2.2	输入
//			 http://IP:PORT/CalendarApp/img/uploadImg.do?mac=XXXX
//			 图片需要指定唯一的文件名称，文件类型。
// *
// *	Created by gao on 2014-06-15 20:55
// */
//@interface DRequestUploadImg: DBaseRequest
///**
// *	@brief
// *
// *	Created by gao on 2014-06-15 20:55
// */
//@property (nonatomic, copy) NSString* sid;
//
///**
// *	@brief		是	Int	1-32	时间戳	1
// *
// *	Created by gao on 2014-06-15 20:55
// */
//@property (nonatomic, assign) long long  timestamp;
//
//
//@property (nonatomic, copy) NSString *file;
//@property (nonatomic, copy) NSString *gid;
//
//@property (nonatomic, strong) UIImage *image;
//
//@property (nonatomic, strong) NSDictionary *userInfo;
//
//
//@end
//
//@interface DResponsedUploadImg : DBaseResponsed
//
//@property (nonatomic, strong) NSDictionary *userInfo;
//@end
//
//
//#pragma mark - 3.6.3	应用更新查询接口
////************************************************************************************
// /**
// *	@brief	3.6.3.1	功能说明
// 查询应用版本是否有更新
// 
// 3.6.3.2	输入
// http://mpost.mail.10086.cn/WebService/jpdyMobile/appIsUpdate.do
// *
// *	Created by gao on 2014-06-15 20:55
// */
//@interface DRequestAppIsUpdate: DBaseRequest
//
//
///**
// *	@brief		是	string	1-32	应用包名：App Package Name。如：“cn.richinfo.subscribe”
// *
// *	Created by gao on 2014-07-16 16:05
// */
//@property (nonatomic, copy) NSString *apn;
//
///**
// *	@brief		是	int	1-16	应用版本号：App Version Code。如3
// *
// *	Created by gao on 2014-07-16 16:05
// */
//@property (nonatomic, assign) NSInteger avc;
//
///**
// *	@brief		否	string	1-32	App channel number,应用渠道。若acn为空或者请求数据包中无改字段，则返回默认升级包信息
// *
// *	Created by gao on 2014-07-16 16:05
// */
//@property (nonatomic, copy) NSString * acn;
//
//@end
//
//@interface DResponsedAppIsUpdate : DBaseResponsed
//
//@property (nonatomic, strong) DAppInfo *lastAppInfo;
//
//@property (nonatomic, assign)BOOL isNeedUpdate;
//@property (nonatomic, copy) NSString *updateUrl;
//@end
//
//
//#pragma mark - 3.6.4	生成二维码
///**
// *	@brief	3.6.4.1	功能说明
//	 生成二维码。
//	 
//	 3.6.4.2	输入
//	 http://IP:PORT/CalendarApp//event/generateQrCode.do?mac=XXXX
// *
// *	Created by gao on 2014-07-17 14:05
// */
//@interface DRequestGenerateQRCode : DBaseRequest
///**
// *	@brief		是	String	1-32	会话ID	6
// *
// *	Created by gao on 2014-07-17 14:07
// */
//@property (nonatomic, copy) NSString* sid;
///**
// *	@brief		是	String	1-32	活动唯一标识	6
// *
// *	Created by gao on 2014-07-17 14:07
// */
//@property (nonatomic, copy) NSString* eventSign;
//
///**
// *	@brief		是	Int	1-32	时间戳	6
// *
// *	Created by gao on 2014-07-17 14:07
// */
//@property (nonatomic, assign) long long timestamp;
//
//@end
//
//@interface DResponsedGenerateQRCode : DBaseResponsed
//
///**
// *	@brief		是	String	不定长	二维码图片名称
// *
// *	Created by gao on 2014-07-17 14:07
// */
//@property (nonatomic, copy) NSString * imgName;
//
//@end
////************************************************************************************
//
//
//
//
//#pragma mark - 3.7.5	批量查询消息列表
///**
// *	@brief	3.6.5.1	功能说明
//			 1.PUSH消息后保存于服务器，提供该接口供IOS查询消息列表；
//			 2.消息在查询并成功返回后，删除消息；
//			 3.6.5.2	输入
//			 http://IP:PORT/CalendarApp/message/queryMsgBatch.do?mac=XXXX
// *
// *	Created by gao on 2014-07-09 14:46
// */
//@interface DRequestQueryMsgBatch : DBaseRequest
///**
// *	@brief		是	String	1-32	会话ID	6
// *
// *	Created by gao on 2014-07-09 14:48
// */
//@property (nonatomic, copy) NSString* sid;
//
///**
// *	@brief		是	Int	1-32	消息ID。当msgId为0时，默认获取最新pageSize条数据。	6
// *
// *	Created by gao on 2014-07-09 14:48
// */
//@property (nonatomic, assign)NSInteger msgId;
//
//
///**
// *	@brief		是	int	1-32	当前页查询数据条数,默认值20	6
// *
// *	Created by gao on 2014-07-09 14:48
// */
//@property (nonatomic, assign) NSInteger pageSize;
//
///**
// *	@brief		是	int	1-3	分页标识（0：查询大于msgId数据，1：查询小于msgId数据）	6
// *
// *	Created by gao on 2014-07-09 14:48
// */
//@property(nonatomic, assign) NSInteger pageFlag;
//
///**
// *	@brief		是	Int	1-32	时间戳	6
// *
// *	Created by gao on 2014-07-09 14:48
// */
//@property (nonatomic,assign) long long timestamp;
//@end
//
//
//@interface DResponsedQueryMsgBatch : DBaseResponsed
//
//@property (nonatomic, strong) NSMutableArray* arrMessage;
//
//@end
////************************************************************************************

//
//#pragma mark - 3.7	投票模块
//#pragma mark - 3.7.1	创建投票
///**
// *	@brief	3.7.1.1	功能说明
//			 1.发起投票
//			 （1）投票隶属于活动，且一个活动中可以有多个投票；
//			 （2）只有活动的发起人才能创建投票；
//			 （3）创建投票时需要确定 投票主题（必填）；
//			 （4）创建投票时需要确定 选项描述（必填），至少填写2个选项才能创建投票，不足2项时要给用户提示，用户可以自行增加选项；
//			 （5）创建投票时需要确定 投票规则，单选或多选，默认单选；
//			 3.消息
//			 （1）投票创建后，所有的活动参与人会收到一条消息，消息内容为——“活动标题”活动中发起了一个新的投票“投票主题”，点击该消息，进入投票详情页面；
//			 （2）有人参与投票后，所有的活动参与人会收到一条消息，消息内容为——“投票人的名字”参与了投票“投票主题”，其中投票人的名字遵循本地通讯录匹配规则；点击该消息，进入投票详情页面；
//			 3.7.1.2	输入
//			 http://IP:PORT/CalendarApp/vote/createVote.do?mac=XXXX
//			 请求报文：
// *
// *	Created by gao on 2014-06-15 21:16
// */
//@interface DRequestCreateVote : DBaseRequest
//
//
///**
// *	@brief		是	String	1-32	会话ID	6
// *
// *	Created by gao on 2014-06-15 21:16
// */
//@property (nonatomic, copy) NSString* sid;
///**
// *	@brief		是	String	1-32	外部活动ID，如果存在外部ID需要带上	6
// *
// *	Created by gao on 2014-06-15 21:16
// */
//@property (nonatomic, copy) NSString* gid;
//
///**
// *	@brief		是	String	1-128	投票主题	6
// *
// *	Created by gao on 2014-06-15 21:16
// */
//@property (nonatomic, copy) NSString* title;
//
///**
// *	@brief		是	int	1-3	投票模式：0：单选；1：多选	6
// *
// *	Created by gao on 2014-06-15 21:16
// */
//@property (nonatomic, assign) NSInteger mode;
//
///**
// *	@brief		是	array		投票选项	6
// *
// *	Created by gao on 2014-06-15 21:16
// */
//@property (nonatomic, strong) NSMutableArray* voteItem;
//
///**
// *	@brief		是	Int	1-32	时间戳	6
// *
// *	Created by gao on 2014-06-15 21:17
// */
//@property (nonatomic, assign) long long timestamp;
//
///**
// *	@brief		是	String	1-32	MD5(sid + timestamp + 密钥)	6
// *
// *	Created by gao on 2014-06-15 21:17
// */
//@property (nonatomic, copy) NSString* mac;
//
//@end
//
//@interface DResponsedCreateVote : DBaseResponsed
//@property (nonatomic, strong) DVote *vote;
//@end
////************************************************************************************
//
//
//#pragma mark - 3.7.2	3.7.2	批量查询投票详情
///**
// *	@brief	3.7.2.1	功能说明
//          用户可以手动刷新投票结果；支持同时查询多个投票ID列表
//           3.7.2.2	输入
// http://IP:PORT/CalendarApp/vote/queryVoteDetailBatch.do?mac=XXXX
// *
// *	Created by gao on 2014-06-15 21:06
// */
//@interface DRequestQueryVoteDetailBatch : DBaseRequest
///**
// *	@brief
// *
// *	Created by gao on 2014-06-15 21:06
// */
//@property (nonatomic, copy) NSString* sid;
//
///**
// *	@brief	gid	是	String	1-32	外部活动ID，删除时需要带上
// *
// *	Created by gao on 2014-06-15 21:06
// */
//@property (nonatomic, copy) NSString * gid;
//
//
///**
// *	@brief	"voteIdList":[1,2],
// *
// *	Created by gao on 2014-07-14 01:33
// */
//@property (nonatomic, copy) NSString *voteIdList;
//
///**
// *	@brief	活动识别码。
// *
// *	Created by gao on 2014-07-14 01:33
// */
//@property (nonatomic, copy) NSString * eventSign;
//
///**
// *	@brief		是	Int	1-32	时间戳	1
// *
// *	Created by gao on 2014-06-15 21:06
// */
//@property (nonatomic, assign) long long  timestamp;
//
//
//@end
//
//
//@interface DResponsedQueryVoteDetailBatch : DBaseResponsed
///**
// *	@brief	
// *
// *	Created by gao on 2014-06-15 22:01
// */
//@property (nonatomic, strong) NSMutableArray* arrVote;
//
//@end
////************************************************************************************
//
//
//
//
//#pragma mark -  3.7.3	参与投票
///**
// *	@brief	3.7.3	参与投票
//			 3.7.3.1	功能说明
//			 2.查看和参与投票
//			 （1）任何人都可以看到投票的各个选项，但只有参与人能进行投票；
//			 （2）只有在进行投票后才能看到投票结果；
//			 （3）每个人只有一次投票机会，投票后不能修改此前的选择；
//			 （4）投票结果中展示每个选项的描述，以及对应的票数，不能看到投票人的信息；
//			 （5）用户可以手动刷新投票结果；
//			 3.7.3.2	输入
//			 http://IP:PORT/CalendarApp/vote/vote.do?mac=XXXX
// *
// *	Created by gao on 2014-06-15 21:06
// */
//@interface DRequestVote : DBaseRequest
///**
// *	@brief		是	String	1-32	会话ID	6
// *
// *	Created by gao on 2014-06-15 22:17
// */
//@property (nonatomic, copy) NSString* sid;
//
///**
// *	@brief		是	String	1-32	外部活动ID，如果存在外部ID需要带上	6
// *
// *	Created by gao on 2014-06-15 22:17
// */
//@property (nonatomic, copy)NSString* gid;
///**
// *	@brief		是	int	1-32	投票ID	6
// *
// *	Created by gao on 2014-06-15 22:17
// */
//@property (nonatomic, assign) NSInteger voteId;
//
///**
// *	@brief		是	String	1-128	投票主题	6
// *
// *	Created by gao on 2014-06-15 22:18
// */
//@property (nonatomic, copy) NSString* title;
//
//
///**
// *	@brief		是	int	1-3	投票模式：0：单选；1：多选	6
// *
// *	Created by gao on 2014-06-15 22:18
// */
//@property (nonatomic, assign) NSInteger mode;
//
///**
// *	@brief		是	int	1-6	参与投票总人数	6
// *
// *	Created by gao on 2014-06-15 22:18
// */
//@property (nonatomic, assign) NSInteger totalNum;
//
//
///**
// *	@brief		是	array		投票选项	6
// *
// *	Created by gao on 2014-06-15 22:18
// */
//@property (nonatomic, strong) NSMutableArray*  voteItem;
//
///**
// *	@brief		是	Int	1-32	时间戳	6
// *
// *	Created by gao on 2014-06-15 22:19
// */
//@property (nonatomic,assign)long long timestamp;
//
///**
// *	@brief		是	String	1-32	MD5(sid + timestamp + 密钥)	6
// *
// *	Created by gao on 2014-06-15 22:19
// */
//@property (nonatomic, copy) NSString* mac;
//
//
//@end
//
//@interface DResponsedVote : DBaseResponsed
///**
// *	@brief
// *
// *	Created by gao on 2014-06-15 22:19
// */
//@property(nonatomic, strong) DVote *vote;
//
//@end
//
//
//
////************************************************************************************
//#pragma mark - 3.7.4	删除投票主题
///**
// *	@brief	3.7.4	删除投票主题
//			 3.7.4.1	功能说明
//			 删除投票主题及选项
//			 3.7.4.2	输入
//			 http://IP:PORT/CalendarApp/vote/deleteVote.do?mac=XXXX
// *
// *	Created by gao on 2014-06-15 21:06
// */
//@interface DRequestDeleteVote : DBaseRequest
///**
// *	@brief
// *
// *	Created by gao on 2014-06-15 21:06
// */
//@property (nonatomic, copy) NSString* sid;
//
///**
// *	@brief		是	Int	1-32	时间戳	1
// *
// *	Created by gao on 2014-06-15 21:06
// */
//@property (nonatomic, assign) long long  timestamp;
//
///**
// *	@brief	gid	是	String	1-32	外部活动ID
// *
// *	Created by gao on 2014-06-15 21:06
// */
//@property (nonatomic, copy) NSString * gid;
//
///**
// *	@brief	是	int	1-32	投票ID
// *
// *	Created by gao on 2014-06-15 21:06
// */
//@property (nonatomic, assign) NSInteger voteId;
//@end
//
//
//@interface DResponsedDeleteVote : DBaseResponsed
//
//@end
//
//
//
////************************************************************************************
//#pragma mark - 3.7.5	结束投票
///**
// *	@brief	3.7.5.1	功能说明
// 
//     删除投票主题及选项
// 
// 3.7.4.2	输入
// http://IP:PORT/CalendarApp/vote/finishVote.do?mac=XXXX
// *
// *	Created by gao on 2014-06-15 21:06
// */
//@interface DRequestFinishVote : DBaseRequest
///**
// *	@brief
// *
// *	Created by gao on 2014-06-15 21:06
// */
//@property (nonatomic, copy) NSString* sid;
//
///**
// *	@brief		是	Int	1-32	时间戳	1
// *
// *	Created by gao on 2014-06-15 21:06
// */
//@property (nonatomic, assign) long long  timestamp;
//
///**
// *	@brief	gid	是	String	1-32	外部活动ID
// *
// *	Created by gao on 2014-06-15 21:06
// */
//@property (nonatomic, copy) NSString * gid;
//
///**
// *	@brief	是	int	1-32	投票ID
// *
// *	Created by gao on 2014-06-15 21:06
// */
//@property (nonatomic, strong) NSMutableArray *voteIds;
//-(void)addVoteIds:(NSInteger)voteid;
//@end
//
//
//@interface DResponsedFinishVote : DBaseResponsed
//
//@end

#pragma mark - 消息推送相关
/**
 *	@brief	deviceToken绑定接口
 *
 *	Created by chengenlin on 2014-23-15 11:06
 */
@interface DRequestDeviceBind : DBaseRequest

@property (nonatomic,copy) NSString *deviceToken;
@property (nonatomic,copy) NSString *appId;
@property (nonatomic,copy) NSString *uid;
@property (nonatomic,copy) NSString *sign;

@end

@interface DResponsedDeviceBind : DBaseResponsed
@end

/**
 *	@brief	deviceToken解绑接口
 *
 *	Created by chengenlin on 2014-23-15 11:06
 */
@interface DRequestDeviceUnbind : DBaseRequest

@property (nonatomic,copy) NSString *deviceToken;
@property (nonatomic,copy) NSString *appId;
@property (nonatomic,copy) NSString *uid;
@property (nonatomic,copy) NSString *sign;

@end

@interface DResponsedDeviceUnbind : DBaseResponsed
@end
//************************************************************************************
