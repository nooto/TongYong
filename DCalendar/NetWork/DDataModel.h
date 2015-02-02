//
//  DDataModel.h
//  DCalendar
//
//  Created by GaoAng on 14-5-13.
//  Copyright (c) 2014年 richinfo.cn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "../NetWork/HHJSONKit.h"

#pragma mark - 使用到的数据类型。

@interface DAppInfo : NSObject
/**
 *	@brief	 = 开发者 ID;

 *
 *	Created by gao on 2014-07-16 17:38
 */
@property (nonatomic, copy)NSString*  artistId;
/**
 *	@brief	 = 开发者名称;

 *
 *	Created by gao on 2014-07-16 17:38
 */
@property (nonatomic, copy)  NSString* artistName;
/**
 *	@brief
 *
 *	Created by gao on 2014-07-16 17:38
 */
@property (nonatomic, assign) float price;
/**
 *	@brief	<#Description#>
 *
 *	Created by gao on 2014-07-16 17:39
 */
@property (nonatomic, assign)NSInteger isGameCenterEnabled;

/**
 *	@brief	<#Description#>
 *
 *	Created by gao on 2014-07-16 17:39
 */
@property (nonatomic, copy)NSString*  kind;
/**
 *	@brief	 = 审查名称;
 *
 *	Created by gao on 2014-07-16 17:39
 */
@property (nonatomic, copy)NSString*  trackCensoredName;

/**
 *	@brief	 = 评级;

 *
 *	Created by gao on 2014-07-16 17:39
 */
@property (nonatomic, copy)NSString*  trackContentRating;
/**
 *	@brief	 = 应用程序 ID;
 *
 *	Created by gao on 2014-07-16 17:39
 */
@property (nonatomic, copy)NSString*  trackId;
/**
 *	@brief	= 应用程序名称";
 *
 *	Created by gao on 2014-07-16 17:39
 */
@property (nonatomic, copy)NSString*  trackName;
/**
 *	@brief	 = 应用程序介绍网址;
 *
 *	Created by gao on 2014-07-16 17:39
 */
@property (nonatomic, copy)NSString*  trackViewUrl;

/**
 *	@brief	 = 用户评级;
 *
 *	Created by gao on 2014-07-16 17:40
 */
@property (nonatomic, assign)NSInteger userRatingCount;
/**
 *	@brief	 = 1;
 *
 *	Created by gao on 2014-07-16 17:40
 */
@property (nonatomic, assign)NSInteger  userRatingCountForCurrentVersion;

/**
 *	@brief	 = 版本号;

 *
 *	Created by gao on 2014-07-16 17:40
 */
@property (nonatomic, copy)NSString*  version;
/**
 *	@brief	= software;
 *
 *	Created by gao on 2014-07-16 17:40
 */
@property (nonatomic, copy)NSString*  wrapperType;;

@end

@interface Ctx : NSObject <NSCoding>
@property (nonatomic,copy)NSString*val;  //name、image
@end

/***************************************************************************************************************
 *	@brief	活动内容。
 *
 *	Created by gao on 2014-05-24 17:32
 */
@interface DEventContent : NSObject<NSCopying, NSCoding>
/**
 *	@brief		是	Int	1-3	内容类型：1：文本；2：图片
 *
 *	Created by gao on 2014-06-04 15:06
 */
@property (nonatomic, assign) NSInteger type;

/**
 *	@brief		是	array	1-1024	内容
 *
 *	Created by gao on 2014-06-04 15:07
 */
@property (nonatomic, copy) NSMutableArray *ctx;

@end

 
/***************************************************************************************************************
 *	@brief	活动提醒信息。
 *
 *	Created by gao on 2014-05-24 17:32
 */
@interface DAlarmInfoBase : NSObject
@property (nonatomic, copy) NSString* gid;
@end

@interface DAlarmInfo : DAlarmInfoBase<NSCopying>

/**
 *	@brief	是	Int	1-32	提醒方式：0：默认本地 1：短信 2：邮件 3：短信和邮件
 *
 *	Created by gao on 2014-05-24 17:34
 */
@property (nonatomic, assign) NSInteger alarmType;

/**
 *	@brief		否	String	1-32	提前时间 –P表示提前 事例：
								 -P0DT0H30M0S(提前30分钟)
								 不填写表示不提前
 *
 *	Created by gao on 2014-05-24 17:34
 */
@property (nonatomic, copy)NSString*  alarmTrigger;

-(NSMutableDictionary*)dicionaryWithAlarmInfo;
@end


#pragma mark - 关注、粉丝信息机构
@interface DFansPersonInfo:NSObject<NSCopying>

/**
 *	@brief		是	Int	1-20	记录Id
 *
 *	Created by gao on 2014-08-20 16:58
 */
@property (nonatomic, assign) NSInteger  followId;
/**
 *	@brief		是	Int		用户Id
 *
 *	Created by gao on 2014-08-20 16:58
 */
@property (nonatomic, assign) NSInteger userId;
/**
 *	@brief		否	String		用户头像地址
 *
 *	Created by gao on 2014-08-20 16:58
 */
@property (nonatomic, copy) NSString* photoUrl;
/**
 *	@brief		否	String		描述
 *
 *	Created by gao on 2014-08-20 16:58
 */
@property (nonatomic, copy) NSString* introduction;

/**
 *	@brief		否	String		用户昵称
 *
 *	Created by gao on 2014-08-20 16:58
 */
@property (nonatomic, copy) NSString* nickname;

/**
 *	@brief	关注列表。 粉丝列表解析过程。
 *
 *	Created by gao on 2014-08-20 17:03
 */
-(void)parseDict:(NSDictionary*)dict;
@end

#pragma mark - 收费信息
/***************************************************************************************************************
 *	@brief	收费信息
 *
 *	Created by gao on 2014-05-24 17:33
 */
@interface DInviterFee:NSObject<NSCopying>


/**
 *	@brief		是	String	1-32	外部活动ID，如果存在外部ID需要带上
 *
 *	Created by gao on 2014-05-24 17:39
 */
@property (nonatomic, copy) NSString* gid;

/**
 *	@brief		是	String	1-32	用户手机号码
 *
 *	Created by gao on 2014-05-24 17:36
 */
//@property (nonatomic, copy)NSString*  userNumber;
@property (nonatomic, assign)NSInteger  userID;
/**
 *	@brief		否	String	1-128	用户昵称
 *
 *	Created by gao on 2014-05-24 17:36
 */
@property (nonatomic, copy)NSString*  nickname;

/**
 *	@brief	个人活动缴费金额。
 *
 *	Created by gao on 2014-07-29 14:35
 */
@property (nonatomic, assign)double payment;

/**
 *	@brief	活动缴费时间
 *
 *	Created by gao on 2014-07-29 14:50
 */
@property (nonatomic, assign)long long paymentTime;

/**
 *	@brief	缴费标记： 0：未交费  1：已缴费
 *
 *	Created by gao on 2014-07-29 14:51
 */
@property (nonatomic, assign) NSInteger isHasPay;

-(NSMutableDictionary*)dicionaryWithInviteFee;

@end

#pragma mark - 审核规则
@interface DCheckInfo:NSObject<NSCopying>
/**
 *	@brief		否	String	1-32	用户手机号码
 *
 *	Created by gao on 2014-08-07 16:39
 */
@property (nonatomic, copy) NSString* userNumber;

/**
 *	@brief		否	String	1-128	用户名称
 *
 *	Created by gao on 2014-08-07 16:40
 */
@property (nonatomic, copy) NSString* name;

/**
 *	@brief		否	String	1-21	身份证号码
 *
 *	Created by gao on 2014-08-07 16:41
 */
@property (nonatomic, copy) NSString* certNo;

/**
 *	@brief		否	String	1-1024	备注
 *
 *	Created by gao on 2014-08-07 16:41
 */
@property (nonatomic, copy) NSString* remark;

-(void)parseDict:(NSDictionary*)dict;
@end

#pragma mark - 查询审核信息资料
@interface DQueryCheckInfo : NSObject<NSCopying>
/**
 *	@brief		int	1-32	审核ID
 *
 *	Created by gao on 2014-08-13 16:53
 */
@property (nonatomic, assign) NSInteger checkId;

/**
 *  用户id
 */
@property (nonatomic, assign) NSInteger  userId;

/**
 *	@brief		String	1-128	报名人昵称
 *
 *	Created by gao on 2014-08-13 16:53
 */
@property (nonatomic, copy) NSString* nickname;

/**
 *	@brief		Long	1-32	报名时间，日期的毫秒数
 *
 *	Created by gao on 2014-08-13 16:53
 */
@property (nonatomic, assign) long long applyTime;
/**
 *	@brief		int	1-32	报名人数
 *
 *	Created by gao on 2014-08-13 16:53
 */
@property (nonatomic, assign) NSInteger number;
/**
 *	@brief		int	1-3	参与状态：0:初始;1:发起人；2:已同意；3：已拒绝；4：报名待审核;5:已取消
 *
 *	Created by gao on 2014-08-13 16:54
 */
@property (nonatomic, assign) NSInteger checkStatus;
/**
 *	@brief		String	1-11	报名人电话号码
 *
 *	Created by gao on 2014-08-13 16:54
 */
@property (nonatomic, copy) NSString* userNumber;


/**
 *	@brief		int	1-3	是否显示报名资料:0：不显示；1：显示。
 当（活动结束时间 + 配置的有效期）小于 当前时间，值为0;否则为1。
 *
 *	Created by gao on 2014-09-04 19:39
 */
@property (nonatomic, assign)NSInteger showCheckInfo;

/**
 *	@brief		array		邀请人列表
 *
 *	Created by gao on 2014-08-13 16:54
 */
@property (nonatomic, strong) NSMutableArray* arrCheckInfo;

-(void)parseDict:(NSDictionary*)dict;
@end

#pragma mark - 接受/拒绝审核资料数据
@interface DRefuseOrAcceptCheckInfo:NSObject<NSCopying>
/**
 *	@brief		是	String	1-32	用户手机号码
 *
 *	Created by gao on 2014-08-13 17:16
 */
@property (nonatomic, copy) NSString* userNumber;

/**
 *  userId
 */
@property (nonatomic, assign) NSInteger userId;

/**
 *	@brief		否	String	1-128	用户昵称
 *
 *	Created by gao on 2014-08-13 17:16
 */
@property (nonatomic, copy) NSString* nickname;
/**
 *	@brief		否	String	1-1028	拒绝原因
 *
 *	Created by gao on 2014-08-13 17:16
 */
@property (nonatomic, copy) NSString* reason;
@end

#pragma mark - 邀请人信息
/***************************************************************************************************************
 *	@brief	邀请人信息
 *
 *	Created by gao on 2014-05-24 17:33
 */
@interface DInviterInfo:NSObject<NSCopying>


/**
 *	@brief		是	String	1-32	外部活动ID，如果存在外部ID需要带上
 *
 *	Created by gao on 2014-05-24 17:39
 */
@property (nonatomic, copy) NSString* gid;

/**
 *	@brief		是	String	1-32	用户手机号码
 *
 *	Created by gao on 2014-05-24 17:36
 */
@property (nonatomic, copy)NSString*  userNumber;

/**
 *	@brief		否	String	1-128	用户昵称
 *
 *	Created by gao on 2014-05-24 17:36
 */
@property (nonatomic, copy)NSString*  nickname;

/**
 *	@brief	邀请状态： 参与状态： 0:邀请人  1：发起人  2：参与人  4：待审核 --- 2014-08-13 14:14:53 更新。
 *	Created by gao on 2014-06-12 14:53
 */
@property (nonatomic, assign)NSInteger inviteStatus;

/**
 *	@brief	是否小D用户 0：非小D用户 1：小D用户
 *
 *	Created by gao on 2014-06-12 14:53
 */
@property (nonatomic, assign)NSInteger isOwn;

/**
 *	@brief		否	Int	1-3	报名人数  // 数据库中存储字段对应 peoplenumber  防止关键字重复。
 *
 *	Created by gao on 2014-07-29 14:34
 */
@property (nonatomic, assign)NSInteger number;

/**
 *	@brief		否	String	1-128	头像URL
 *
 *	Created by gao on 2014-07-29 14:34
 */
@property (nonatomic, copy)NSString* photoUrl;

/**
 *	@brief		否	Int	1-3	是否有审核资料：0：没有；1：有
 *
 *	Created by gao on 2014-07-29 14:35
 */
@property (nonatomic, assign)NSInteger hasCheckInfo;

/**
 *	@brief		否	Long	1-32	报名时间，日期的毫秒数
 *
 *	Created by gao on 2014-08-25 10:56
 */
@property (nonatomic, assign)long long applyTime;

/**
 *	@brief		否	array		报名信息列表
 *
 *	Created by gao on 2014-09-04 19:33
 */
@property(nonatomic, strong) NSMutableArray* checkInfo;
/**
 *	@brief		否	Int	1-32	用户ID
 *
 *	Created by gao on 2014-09-04 19:33
 */
@property (nonatomic, assign) NSInteger userId;
/**
 *	@brief		否	int	1-3	是否显示报名资料:0：不显示；1：显示。 当（活动结束时间 + 配置的有效期）小于 当前时间，值为0;否则为1。
 *
 *	Created by gao on 2014-09-04 19:33
 */
@property (nonatomic, assign) NSInteger  showCheckInfo;

-(NSMutableDictionary*)dicionaryWithInvite;
-(void)parseDict:(NSDictionary*)dict;

@end

#pragma mark - 活动信息结构。
/***************************************************************************************************************
 *	@brief   活动信息结构。
 *
 *	Created by gao on 2014-05-24 17:30
 */
@interface  DEventData: NSObject<NSCopying>

/**
 *	@brief		是	String	1-32	外部活动ID，如果存在外部ID需要带上
 *
 *	Created by gao on 2014-05-24 17:39
 */
@property (nonatomic, copy) NSString* gid;

/**
 *	@brief		是	String	1-10	活动标题
 *
 *	Created by gao on 2014-05-24 17:39
 */
@property (nonatomic, copy) NSString* title;

/**
 *	@brief		是	NSMutableArray	7	活动内容
 *
 *	Created by gao on 2014-05-24 17:39
 */
@property (nonatomic, copy) NSMutableArray* content;
/**
 *	@brief 否	int	1-3	活动类型： TYPE_OTHER = 0,    其他
									 TYPE_HIKING = 1,    徒步
									 TYPE_MOUNTAIN = 2,   登山
									 TYPE_RIDING = 3,     骑行
									 TYPE_RUNNING = 4,    跑步
									 
									 TYPE_MEETING= 5,     会议
									 TYPE_BALL= 6,         球类
                                        TYPE_TRAVEL= 7,       旅行	
                TYPE_DRIVERING= 8,       //自驾
                TYPE_GONGYI= 9,       //公益
 *
 *	Created by gao on 2014-05-24 17:39
 */
@property (nonatomic, assign) NSInteger eventType;


/**
 *	@brief	活动所属 讨论组id
 *
 *	Created by gao on 2014-09-10 14:03
 */
@property (nonatomic, assign) long long discussGid;


/**
 *	@brief		否	String	1-255	活动地点
 *
 *	Created by gao on 2014-05-24 17:39
 */
@property (nonatomic, copy) NSString* location;

/**
 *	@brief		否	String	1-255	地点经纬度          "geoPoint": "116.41667,39.91667", 
 *
 *	Created by gao on 2014-05-24 17:39
 */
@property (nonatomic, copy) NSString* geoPoint;

/**
 *	@brief		是	long	15	事件开始时间
 *
 *	Created by gao on 2014-05-24 17:39
 */
@property (nonatomic, assign) double dtStart;
/**
 *	@brief		是	long	15	事件结束时间
 *
 *	Created by gao on 2014-05-24 17:40
 */
@property (nonatomic, assign) double dtEnd;

/**
 *  是	long	15	活动持续时间的开始时间	12
 */
@property (nonatomic, assign) double atStart;

/**
 *  是	long	15	活动持续时间的结束时间	12
 */
@property (nonatomic, assign) double atEnd;

///**
// *	@brief		是	String	32	持续时间
// *
// *	Created by gao on 2014-05-24 17:40
// */
//@property (nonatomic, copy) NSString*  duration;

/**
 *  是	int	1	重复活动规则（默认1）： 1:单次；2：每天； 3：每周；4：每月；
 */
@property (nonatomic, assign) NSInteger repeatRule;

/**
 *	@brief		是	int	32	活动来源：0：创建者；1：被邀请
 *
 *	Created by gao on 2014-05-27 18:39
 */
@property (nonatomic, assign) NSInteger  source;

/**
 *	@brief		否	String	1024	事件循环规则，单次时间不用填（参照标准的Caldav协议）
 *
 *	Created by gao on 2014-05-24 17:40
 */
@property (nonatomic, copy) NSString* rule;//可以去掉
/**
 *	@brief		否	String	1024	事件循环规则描述
 *
 *	Created by gao on 2014-05-24 17:40
 */
@property (nonatomic, copy) NSString* ruleDesc;
/**
 *	@brief		是	Int	2	公历/农历    1：公历    2：农历
 *
 *	Created by gao on 2014-05-24 17:40
 */
@property (nonatomic, assign) NSInteger calendarType;

/**
 *	@brief		是	Int	2	是否有提醒：0：无；1：有 
 自定义判断，初始字段的含义已经无含义，现根据 alarmInfo 自定义判断  中如果有设定的有提醒则：1，如果无提醒则：0
 *
 *	Created by gao on 2014-05-24 17:40
 */
@property (nonatomic, assign) NSInteger isAlarm;

/**
 *	@brief		是	Int	2	是否全天：0：否；1：是
 *
 *	Created by gao on 2014-05-24 17:41
 */
@property (nonatomic, assign) NSInteger isAllDay;

/**
 *	@brief		是	Int	2	是否公开：0：否；1：是

 *
 *	Created by gao on 2014-05-28 11:40
 */
@property (nonatomic, assign) NSInteger isPublic;

/**
 *	@brief		是	String	32	时区
 *
 *	Created by gao on 2014-05-24 17:41
 */
@property (nonatomic, copy) NSString* timeZone;
/**
 *	@brief		否	array		提醒方式。提前提醒时间。 在请求头中apiversion为4时，去掉该参数。
 *
 *	Created by gao on 2014-05-24 17:41
 */
@property (nonatomic, strong) NSMutableArray *alarmInfo;
/**
 *	@brief		否	array		邀请人信息。 在请求头中apiversion为2时，增加参数。 在请求头中apiversion为4时，去掉该参数。
 *
 *	Created by gao on 2014-05-24 17:41
 */
@property (nonatomic, strong) NSMutableArray *inviterInfo;

/**
 *	@brief	是	String	1-128	发起人昵称

 *
 *	Created by gao on 2014-05-26 19:39
 */
@property (nonatomic, assign)NSInteger senderUserID;
@property (nonatomic, strong) NSString* senderNickname;
@property (nonatomic, strong)NSString*  senderUserNumber;//发起人手机号码 2014-08-23 14:10
@property (nonatomic, strong)NSString* senderUserPhotoURL;
@property (nonatomic, strong)NSString*  senderUserGender;

/**
 *  是	int	1	费用类型：1：AA制；0:其它
 */
@property (nonatomic, assign) NSInteger feeType;

/**
 *	@brief	double	1-32	活动费用
 *
 *	Created by gao on 2014-06-20 13:51
 */
@property (nonatomic, assign)double fee;

/**
 *	@brief		否	String	1-512	活动费用描述
 *
 *	Created by gao on 2014-06-20 13:52
 */
@property (nonatomic, copy) NSString* feeDesc;

/**
 *	@brief		是	int	1-10	最大参与人数
 *
 *	Created by gao on 2014-06-20 13:53
 */
@property (nonatomic, assign) NSInteger maxPersonNum;

/**
 *	@brief		是	String	1-10	活动的唯一标识，用于分享活动
 *
 *	Created by gao on 2014-06-20 13:53
 */
@property (nonatomic, copy) NSString* eventSign;

/**
 *	@brief		否	String	1-255	集合地点
 *
 *	Created by gao on 2014-07-29 14:14
 */
@property (nonatomic, copy) NSString* gatherAddress;

/**
 *	@brief		否	String	1-255	集合地点经纬度
 *
 *	Created by gao on 2014-07-29 14:14
 */
@property (nonatomic, copy) NSString* gatherGeo;

/**
 *	@brief		是	long	15	集合时间
 *
 *	Created by gao on 2014-07-29 14:14
 */
@property (nonatomic, assign) long long gatherTime;

/**
 *	@brief		是	int	1-3	是否报名审核状态：0：不需要审核；1：需要审核
 *
 *	Created by gao on 2014-07-29 14:14
 */
@property (nonatomic, assign) NSInteger isCheckFlag;

/**
 *	@brief		否	JSON		审核规则
 *
 *	Created by gao on 2014-07-29 14:14
 */
@property (nonatomic, strong) DCheckInfo* checkInfo;

/**
 *	@brief		是	int	1-3	活动状态：0：正常；1：取消； 2：活动已开始；3：活动已结束
 *
 *	Created by gao on 2014-07-29 14:14
 */
@property (nonatomic, assign) NSInteger eventStatus;


/**
 *	@brief		否	Int	1-3	审核状态：
							 0：初始状态
							 1:发起人
							 2:加入；
							 3:拒绝；
							 4：待审核
							 5:取消活动
 *
 *	Created by gao on 2014-08-08 14:52
 */
@property (nonatomic, assign) NSInteger checkStatus;
/**
 *	@brief	否	double	1-32	预付款

 *
 *	Created by gao on 2014-08-08 14:52
 */
@property (nonatomic, assign) double prepay;

/**
 *	@brief		是	double	1-128	用户当前坐标与该活动创建时坐标的距离，以米为单位
 *
 *	Created by gao on 2014-08-23 14:10
 */
@property(nonatomic, assign) double distance;

/**
 *	@brief		是	int	1-3	是否已经过期的标识：0：未过期；1：已过期
 *
 *	Created by gao on 2014-08-23 14:11
 */
@property (nonatomic, assign)NSInteger  isExpired;

/**
 *	@brief	是	int	1-10	已经参与人数-- 活动广场查询显示。
 *
 *	Created by gao on 2014-08-27 15:32
 */
@property (nonatomic, assign) NSInteger inNum;

/**
 *	@brief		是	int	1-9	讨论数量
 *
 *	Created by gao on 2014-08-23 14:11
 */
@property (nonatomic, assign)NSInteger commentNum;
@property (nonatomic, assign)NSInteger inviterCount;
@property (nonatomic, assign)NSInteger voteCount;

/**
 *	@brief		是	Long	32	活动创建时间
 *
 *	Created by gao on 2014-08-23 14:11
 */
@property(nonatomic, assign)long long createTime;


/**
 *	@brief		是	double	1-32	活动创建地点经度
 *
 *	Created by gao on 2014-08-29 10:44
 */
@property (nonatomic, assign) double longitude;

/**
 *	@brief		是	double	1-32	活动创建地点纬度
 *
 *	Created by gao on 2014-08-29 10:44
 */
@property (nonatomic, assign) double latitude;
/**
 *	@brief		是	String	1-6	活动创建地点城市编码
 *
 *	Created by gao on 2014-08-29 10:44
 */
@property (nonatomic, copy) NSString* regionCode;


/**
 *	@brief	对初始话的DEventData  进行初始数据赋值。
 *
 *	Created by gao on 2014-08-08 16:53
 */
-(void)initEventData;
/**
 *	@brief	更新数据库中 已经存在的活动
 *
 *	@return
 *
 *	Created by gao on 2014-09-10 17:39
 */
-(void)upDataEventToDateBase;

/**
 *	@brief	插入活动到数据库中。
 *
 *	@return	
 *
 *	Created by gao on 2014-09-10 17:39
 */
-(void)insertEventToDateBase;

-(NSString*)feeDescString;
-(NSString*)maxPersonNumDescription;
-(NSString*)userNumberDescription;
-(NSString*)isCheckFlagDescrption;
-(NSString*)isPublicDescrption;
-(NSString*)contentDescription;
-(NSString*)GatherInfoDescription;
-(NSString*)checkInfoDescrption;
-(NSString*)repeatRuleDescrpition;

/**
 *	@brief	从活动表结构中删除活动苏句
 *
 *	@return	yes or no
 *
 *	Created by gao on 2014-09-13 16:35
 */
-(void)deleteEventFromDateBase;



/**
 *	@brief	活动插入到草稿表中
 *
 *	@return
 *
 *	Created by gao on 2014-09-13 16:37
 */
-(void)insertDraftEventToDateBase;

/**
 *	@brief	更新草稿表中的 活动数据
 *
 *	@return	yes or no
 *
 *	Created by gao on 2014-09-13 16:38
 */
-(void)upDateDraftEventToDateBase;

/**
 *	@brief	删除草稿表中的数据。
 *
 *	@return	
 *
 *	Created by gao on 2014-09-13 16:39
 */
-(void)deleteDraftEventFromDateBase;



-(void)parseDict:(NSDictionary*)dict;
-(NSMutableDictionary*)dicionaryWithEvent;

@end

#pragma mark -	简化的活动数据，用于 个人资料中 我发起的活动，我参与的活动展示。
@interface DSimpleEventData: NSObject
/**
 *  活动特殊id  用来进行翻页处理。
 */
@property (nonatomic, assign) NSInteger eventId;

/**
 *  活动对应的用户id
 */
@property (nonatomic, assign) NSInteger userId;

/**
 *  活动的gid
 */
@property (nonatomic, copy) NSString* gid;

/**
 *  活动的vent
 */
@property (nonatomic, copy) NSString* eventSign;

/**
 *  活动标题
 */
@property (nonatomic, copy) NSString* title;

/**
 *  活动开始时间
 */
@property (nonatomic, assign) double  dtStart;

/**
 *  活动结束时间
 */
@property (nonatomic, assign) double dtEnd;
/**
 *  加入活动时间。
 */
@property (nonatomic, assign) double joinTime;

/**
 *  活动类型
 */
@property (nonatomic, assign) NSInteger eventType;

/**
 *   *	@brief		是	int	1-3	活动状态：0：正常；1：取消； 2：活动已开始；3：活动已结束
 */
@property (nonatomic, assign) NSInteger eventStatus;
-(void)parseDict:(NSDictionary*)dict;
@end


#pragma mark - 配置项数据。
@interface DConfigData : NSObject
/**
 *  配置项id
 */
@property (nonatomic, assign) NSInteger configId;

/**
 *  配置项key
 */
@property (nonatomic, copy) NSString* configKey;

/**
 *  配置项value
 */
@property (nonatomic, copy) NSString* configValue;

-(NSMutableDictionary*)dicionaryWithConfigData;
-(void)parseDict:(NSDictionary*)dict;
@end

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - 投票。
@interface DVoteItem : NSObject<NSCopying>
/**
 *	@brief	是	int	1-32	选项ID
 *
 *	Created by gao on 2014-06-15 21:20
 */
@property (nonatomic, assign) NSInteger voteItemId;

/**
 *	@brief	是	String	1-125	投票选项描述
 *
 *	Created by gao on 2014-06-15 21:20
 */
@property (nonatomic, copy) NSString* itemDesc;
/**
 *	@brief	是	int	1-32	投票数量
 *
 *	Created by gao on 2014-06-15 21:20
 */
@property (nonatomic, assign) NSInteger num;

/**
 *	@brief	选项的item
 *
 *	Created by gao on 2014-07-15 16:54
 */
@property (nonatomic, assign) NSInteger itemId;
/**
 *	@brief	选项所在的投票vote 的唯一di
 *
 *	Created by gao on 2014-07-15 16:54
 */
@property (nonatomic, assign) NSInteger voteId;

@end


@interface DVote : NSObject<NSCopying>
/**
 *	@brief		int	1-32	投票ID
 *
 *	Created by gao on 2014-06-15 21:43
 */
@property (nonatomic, assign) NSInteger voteId;

/**
 *	@brief		long		创建投票时间
 *
 *	Created by gao on 2014-06-15 21:43
 */
@property (nonatomic, assign) long long createVoteTime;

/**
 *	@brief		String	1-128	投票主题
 *
 *	Created by gao on 2014-06-15 21:43
 */
@property (nonatomic, copy) NSString* title;

/**
 *	@brief		int	1-3	投票模式：0：单选；1：多选
 *
 *	Created by gao on 2014-06-15 21:43
 */
@property (nonatomic, assign) NSInteger mode;

/**
 *	@brief		int	1-3	是否已经投票：0：否；1：是
 *
 *	Created by gao on 2014-06-15 21:43
 */
@property (nonatomic, assign) NSInteger hasVote;


/**
 *	@brief		int	4	抽票是否结束，0未结束，1结束
 *
 *	Created by gao on 2014-07-14 01:37
 */
@property (nonatomic, assign) NSInteger isFinish;

/**
 *	@brief		int	1-6	参与投票总人数
 *
 *	Created by gao on 2014-06-15 21:43
 */
@property (nonatomic, assign) NSInteger totalNum;

/**
 *	@brief		array		投票选项
 *
 *	Created by gao on 2014-06-15 21:43
 */
@property (nonatomic, copy) NSMutableArray* voteItem;
-(void)parseDict:(NSDictionary*)dict;

@end

@interface DUploadImageRecordData : NSObject<NSCopying>
@property ( nonatomic, copy) NSString* gid;               //图片所属活动id
@property (nonatomic, assign) NSInteger numOfFinished;    //已经上传的图片数量
@property (nonatomic, assign) NSInteger numOfFail;    //上传失败的图片数量
@property (nonatomic, assign) NSInteger numOfCount;       //图片总数
@end


#pragma mark -	评论
@interface DCommentData : NSObject<NSCopying>

@property (nonatomic, copy) NSString *gid;
@property (nonatomic, copy) NSString *commentId;           //评论标示
@property (nonatomic, copy) NSString *content;             //评论内容
@property (nonatomic, copy) NSString *nickName;            //评论用户昵称
@property (nonatomic, copy) NSString *userNumber;          //评论用户
@property (nonatomic, assign) long long commentTime;       //评论时间

-(NSMutableDictionary*)dicionaryWithComment;

@end

#pragma mark -- 消息图片上传
@interface DEventImagesUpload : NSObject
/**
 *  账号
 */
@property (nonatomic, strong) NSString *eventId;
/**
 *  对应消息ID
 */
@property (nonatomic, assign) NSInteger msgId;
/**
 *  图片名
 */
@property (nonatomic, strong) NSString *imageName;
/**
 *  是否已经上传:0没有，1已经上传，2上传失败
 */
@property (nonatomic, assign) NSInteger imageState;

@end

#pragma mark -	消息
#define DMessageImageUploadChange           @"DMessageImageUploadChange"
//#define DMessageImageUploadDelete           @"DMessageImageUploadDelete"
@interface DMessageData : NSObject<NSCopying>

/**
*	@brief	//一个帐号绑定多个设备。防止 当前设备收到曾经登录过的帐号的push消息。
*
*	Created by gao on 2014-08-08 10:31
*/
@property (nonatomic, assign) NSInteger accountID;

/**
 *	@brief	消息id 消息自增量 唯一识别id
 *
 *	Created by gao on 2014-07-11 11:00
 */
@property (nonatomic, assign) NSInteger msgId;

/**
 *	@brief	推送消息提示信息。
 *
 *	Created by gao on 2014-07-11 11:02
 */
@property (nonatomic, copy) NSString *alert;

/**
 *	@brief	消息数目
 *
 *	Created by gao on 2014-07-11 11:03
 */
//@property (nonatomic,assign) NSInteger badge;

/**
 *	@brief	消息提示指定声音
 *
 *	Created by gao on 2014-07-11 11:03
 */
//@property (nonatomic, copy) NSString* sound;

/**
 *	@brief	消息关联的活动id
 *
 *	Created by gao on 2014-07-11 11:01
 */
@property (nonatomic, copy) NSString *gid;

/**
 *	@brief	        //消息对应的二级ID，存在一个活动对应多个投票
 *
 *	Created by gao on 2014-07-11 11:07
 */
@property (nonatomic, assign) NSInteger secondId;



/**
 *	@brief	消息类型: 0：创建活动；
					 1：活动更新；
					 2：删除活动；
                     3：评论；
                     4：加入活动；
                     5：退出活动；
                     6：发起人创建投票；
                     7：参与人投票;
                     8：报名申请；
                     9：同意报名；
                     10：拒绝报名
 			         100:上传消息 
 100 //当消息为本地创建活动(type=100)，已经上传的图片数量，失败的数量和需要上传的图片数量 一个活动可以有多条消息(例如多次上传图片)
 *
 *	Created by gao on 2014-07-11 11:04
 */

typedef enum {
    EMessage_Create = 0,//0：创建活动；
    EMessage_Update,//1：活动更新；
    EMessage_Delete,//2：取消活动；
    EMessage_Discuss,//3：评论；
    EMessage_Join,//4：加入活动；
    EMessage_Exit,//5：退出活动；
    EMessage_CreateVote,//6：发起人创建投票；
    EMessage_Vote,//7：参与人投票;
    EMessage_Apply,//8：报名申请；
    EMessage_Agree,//9：同意报名；
    EMessage_Reject,//10：拒绝报名
    EMessage_ApplySUC,//11：报名人显示报名成功消息
    
    EMessage_Upload = 20,//:上传消息

    EMessage_live_Create= 21,// 21：新发布的直播消息（所有参与人都可以接收）；
    EMessage_live_comment,// 22：活动直播评论（仅直播发起人可以接收）；
    EMessage_live_reply,// 23：对直播评论进行回复的消息（仅发表评论的人接收到回复消息）
    EMessage_live_Praise,// 24:赞。
    EMessage_live_OTHER = 50,//Z直播消息类型 截至区间。

    
//    EMessage_Upload = 100,//:上传消息

    EMessage_Draft,//：草稿
    EMessage_Chat = 200,//：聊天
    EMessage_Note, //活动通知
    EMessage_Live = 300, //活动直播
    
} EMessageType;

@property (nonatomic, assign) EMessageType type;              //消息类型

/**
 *	@brief	//消息发送时间
 *
 *	Created by gao on 2014-07-11 11:07
 */
@property (nonatomic, assign) long long time;

/**
 *	@brief	否	int	1-32	投票ID。当type为6：发起人创建投票；7：参与人投票时有值。
 *
 *	Created by gao on 2014-08-08 11:14
 */
@property (nonatomic, assign) NSInteger voteId;

/**
 *	@brief	否	String	1-32	当type为1时有值。当消息类型为更新字段描述： 第1位:title, 第2位:content, 第3位:dtStart, 第4位:dtEnd, 第5位:location，第6位:geoPoint，第7位: fee，第8位: feeDesc，第9位: gatherAddress，第10位: gatherGeo，第11位: gatherTime
 示例：01000000000 表示：content有更新
 *
 *	Created by gao on 2014-08-08 11:14
 */
@property (nonatomic, strong) NSString* updateField;

/**
 *	@brief 否	int	1-3	当type为4时有值。报名是否已满：0：可以报名；1：报名已满;
 *
 *	Created by gao on 2014-08-08 11:14
 */
@property (nonatomic, assign) NSInteger isFull;

/**
 *	@brief		否	String	11	当type为5时有值。手机号码。
 *
 *	Created by gao on 2014-08-08 11:14
 */
@property (nonatomic, copy) NSString* userNumber;
@property (nonatomic, assign) NSInteger userID;
/**
 *	@brief		否	String	100	当type为5时有值。昵称。
 *
 *	Created by gao on 2014-08-08 11:15
 */
@property (nonatomic, copy) NSString* nickname;
@property (nonatomic, copy) NSString* avatorName;//临时增加，不用保存数据库 --  //保存到数据库2014-12-11 14:53:36
@property (nonatomic, copy) NSString* defaultAvatorName;//临时增加，不用保存数据库
@property (nonatomic, copy) NSString* reason;//理由，如拒绝报名

@property (nonatomic, copy) NSString* replyNickname;

/**
 *	@brief	 //消息是否读 0未读 1已读
 *
 *	Created by gao on 2014-07-11 11:06
 */
@property (nonatomic, assign) NSInteger isRead;


//直播消息  迭代十八新加字段。
/**
 *  否	Int	1-32	活动直播ID
 */
@property (nonatomic, assign) NSInteger liveId;

/**
 *  否	Int	1-32	活动直播评论ID
 */
@property (nonatomic, assign) NSInteger commentId;

/**
 *  否	String	1-64	活动直播第一张图片
 */
@property (nonatomic, copy) NSString* livePicUrl;

/**
 *	@brief	//判断消息内容是否操作过。
 *
 *	Created by gao on 2014-09-22 17:23
 */
@property (nonatomic, assign)NSInteger isOperation;

/**
 *	@brief	否	int	1-3	是否报名审核状态：0：不需要审核；1：需要审核
 *
 *	Created by gao on 2014-09-23 19:06
 */
@property(nonatomic, assign) NSInteger isCheckFlag;

//成功个数
@property (nonatomic, assign) NSInteger  numOfFinished;
//失败个数
@property (nonatomic, assign) NSInteger numOfFail;
//总数
@property (nonatomic, assign) NSInteger numOfCount;

-(NSMutableDictionary*)dicionaryWithMessage;
-(void)parsePushDict:(NSDictionary*)dict;

@end
