//
//  DDataModel.m
//  DCalendar
//
//  Created by GaoAng on 14-5-13.
//  Copyright (c) 2014年 richinfo.cn. All rights reserved.
//

#import "DDataModel.h"
#import "../NetWork/HHJSONKit.h"
#import "../DataBase/DDBConfig.h"
#pragma mark - 使用到的数据类型。

@implementation DAppInfo
@synthesize artistId, artistName, price, isGameCenterEnabled, kind,trackCensoredName, trackContentRating, trackId, trackName, trackViewUrl, userRatingCount, userRatingCountForCurrentVersion, version, wrapperType;
-(DAppInfo*)init{
	if (self = [super init]) {
		
	}
	return self;
}
@end

@implementation Ctx
@synthesize val;

-(id)initWithCoder:(NSCoder *)aDecoder{
	self = [super init];
	if (self) {
		self.val = [aDecoder decodeObjectForKey:@"val"];
	}
	return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder{

	[aCoder encodeObject:self.val forKey:@"val"];
}

@end


@implementation DEventContent
@synthesize type, ctx;
-(NSMutableArray*)ctx{
	if (ctx == nil) {
		ctx = [[NSMutableArray alloc] initWithCapacity:1];
	}
	return ctx;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:[NSString stringWithFormat:@"%d",self.type] forKey:@"type"];
//	NSData *archiveCarPriceData = [NSKeyedArchiver archivedDataWithRootObject:self.ctx];
//	[aCoder encodeObject:archiveCarPriceData forKey:@"ctx"];
    [aCoder encodeObject:self.ctx forKey:@"ctx"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self)
    {
        self.type = [[aDecoder decodeObjectForKey:@"type"] intValue];//personName
//		self.ctx = [NSKeyedUnarchiver unarchiveObjectWithData:nil];
        self.ctx = [aDecoder decodeObjectForKey:@"ctx"];
		
    }
    return self;
}

-(id)copyWithZone:(NSZone *)zone{
	DEventContent *copyData = [[DEventContent alloc] init];
	copyData.type = self.type;
	copyData.ctx = self.ctx;
	return nil;
}

@end

@implementation DAlarmInfoBase : NSObject
@synthesize gid;
-(DAlarmInfoBase*)init{
	if (self = [super init]) {
		
	}
	return self;
}
@end

@implementation DAlarmInfo
@synthesize alarmTrigger, alarmType;
//@synthesize gid;

-(NSMutableDictionary*)dicionaryWithAlarmInfo{
	NSMutableDictionary *infoDic = [[NSMutableDictionary alloc] init];
	[infoDic setValue:self.gid forKey:@"gid"];
	[infoDic setValue:self.alarmTrigger forKey:@"alarmTrigger"];
	[infoDic setValue:[NSString stringWithFormat:@"%d", self.alarmType] forKey:@"alarmType"];
	return infoDic;
}


-(id)copyWithZone:(NSZone *)zone{
	DAlarmInfo *copy = [[DAlarmInfo alloc] init];
	copy.alarmTrigger= self.alarmTrigger;
	copy.alarmType = self.alarmType;
	copy.gid = self.gid;
	return copy;
}

@end
#pragma mark - 关注、粉丝信息机构
#pragma mark - 关注、粉丝信息机构
@implementation DFansPersonInfo
@synthesize followId, userId, photoUrl, introduction, nickname;

-(id)copyWithZone:(NSZone *)zone{
	DFansPersonInfo *copy = [[DFansPersonInfo alloc] init];
	[copy setFollowId:self.followId];
	[copy setUserId:self.userId];
	[copy setPhotoUrl:self.photoUrl];
	[copy setIntroduction:self.introduction];
	[copy setNickname:self.nickname];
	return copy;
}
-(void)parseDict:(NSDictionary*)dict{
	
	if (dict == nil) {
		return;
	}
	[self setFollowId:[[dict objectForKey:@"followId"] integerValue]];
	[self setUserId:[[dict objectForKey:@"userId"] integerValue]];
	[self setPhotoUrl:[dict objectForKey:@"photoUrl"]];
	[self setIntroduction:[dict objectForKey:@"introduction"]];
	[self setNickname:[dict objectForKey:@"nickname"]];
}
@end



#pragma mark - 收费信息。
@implementation DInviterFee
@synthesize gid, nickname, userID;// userNumber,
@synthesize payment,paymentTime, isHasPay;

-(NSMutableDictionary*)dicionaryWithInviteFee{
	NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
	[dict setValue:self.gid forKey:@"gid"];
	[dict setValue:self.nickname forKey:@"nickname"];
//	[dict setValue:self.userNumber forKey:@"userNumber"];
    [dict setValue:@(self.userID) forKey:@"userID"];
	
	[dict setValue:[NSString stringWithFormat:@"%f", self.payment] forKey:@"payment"];
	[dict setValue:[NSString stringWithFormat:@"%lld", self.paymentTime] forKey:@"paymentTime"];
	[dict setValue:[NSString stringWithFormat:@"%d", self.isHasPay] forKey:@"isHasPay"];

	return dict;
}

-(id)copyWithZone:(NSZone *)zone{
	DInviterFee *copy = [[DInviterFee alloc] init];
	copy.gid = self.gid;
	copy.nickname = self.nickname;
//	copy.userNumber = self.userNumber;
    copy.userID = self.userID;
    
	[copy setPayment:self.payment];
	[copy setPaymentTime:self.paymentTime];
	[copy setIsHasPay:self.isHasPay];
	
	return copy;
}
@end


@implementation DCheckInfo
@synthesize userNumber, remark, name, certNo;
-(id)copyWithZone:(NSZone *)zone{
	DCheckInfo *copy = [[DCheckInfo alloc] init];
	[copy setName:self.name];
	[copy setUserNumber:self.userNumber];
	[copy setCertNo:self.certNo];
	[copy setRemark:self.remark];
	return copy;
}

-(void)parseDict:(NSDictionary*)dict{
	if (dict == nil) {
		return;
	}
	[self setName: [dict objectForKey:@"name"]];
	[self setUserNumber: [dict objectForKey:@"userNumber"]];
	[self setCertNo: [dict objectForKey:@"certNo"]];
	[self setRemark: [dict objectForKey:@"remark"]];
}
@end

#pragma mark - 查询审核信息资料
@implementation DQueryCheckInfo
@synthesize checkId, nickname, applyTime, number, checkStatus,userNumber, arrCheckInfo;

-(NSMutableArray*)arrCheckInfo{
	if (arrCheckInfo == nil) {
		arrCheckInfo = [[NSMutableArray alloc] initWithCapacity:1];
	}
	return arrCheckInfo;
}
-(id)copyWithZone:(NSZone *)zone{
	DQueryCheckInfo *copy = [[DQueryCheckInfo alloc] init];
	[copy setCheckId:self.checkId];
	[copy setNickname:self.nickname];
	[copy setApplyTime:self.applyTime];
    [copy setUserId:self.userId];
    
	[copy setNumber:self.number];
	[copy setCheckStatus:self.checkStatus];
	[copy setUserNumber:self.userNumber];
	[copy setArrCheckInfo:[self.arrCheckInfo mutableCopy]];
    
    [copy setShowCheckInfo:self.showCheckInfo];
	return copy;
}
-(void)parseDict:(NSDictionary*)dict{
	
	if (dict == nil) {
		return;
	}
	[self setCheckId:[[dict objectForKey:@"checkId"] integerValue]];
	[self setNickname:[dict objectForKey:@"nickname"]];
	[self setApplyTime:[[dict objectForKey:@"applyTime"] longLongValue]/1000];

	[self setNumber:[[dict objectForKey:@"number"] integerValue]];
    [self setCheckStatus:[[dict objectForKey:@"checkStatus"] integerValue]];
    [self setUserId:[[dict objectForKey:@"userId"] integerValue]];
	[self setUserNumber:[dict objectForKey:@"userNumber"]];
	
    [self setShowCheckInfo:[[dict objectForKey:@"showCheckInfo"] integerValue]];

	NSArray* arr = [dict objectForKey:@"checkInfo"];
	for (id item in arr) {
		if ([item isKindOfClass:[NSDictionary class]]) {
			NSDictionary *tempDict = (NSDictionary*)item;
			DCheckInfo *info = [[DCheckInfo alloc] init];
			[info parseDict:tempDict];
			[self.arrCheckInfo addObject:info];
		}
	}
	
}
@end

#pragma mark - 接受/拒绝审核资料数据
@implementation DRefuseOrAcceptCheckInfo
@synthesize userNumber, nickname, reason;
-(id)copyWithZone:(NSZone *)zone{
	DRefuseOrAcceptCheckInfo *copy = [[DRefuseOrAcceptCheckInfo alloc] init];
	[copy setNickname:self.nickname];
	[copy setUserNumber:self.userNumber];
    [copy setUserId:self.userId];
	[copy setReason:self.reason];
	return copy;
}
@end

#pragma mark - 邀请人/参与人
@implementation DInviterInfo

@synthesize gid, inviteStatus, nickname, userNumber, isOwn;
@synthesize hasCheckInfo,number,photoUrl;

-(NSMutableArray*)checkInfo{
    if (_checkInfo == nil) {
        _checkInfo = [[NSMutableArray alloc] initWithCapacity:1];
    }
    return _checkInfo;
}

-(NSMutableDictionary*)dicionaryWithInvite{
	NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
	[dict setValue:self.gid forKey:@"gid"];
	[dict setValue:self.nickname forKey:@"nickname"];
	[dict setValue:self.userNumber forKey:@"userNumber"];
	[dict setValue:@(self.inviteStatus) forKey:@"inviteStatus"];
	[dict setValue:@( self.isOwn) forKey:@"isOwn"];
	[dict setValue:@( self.hasCheckInfo) forKey:@"hasCheckInfo"];
	[dict setValue:@(self.number) forKey:@"peoplenumber"];
	[dict setValue:self.photoUrl forKey:@"photoUrl"];
	[dict setValue:@(self.applyTime) forKey:@"applyTime"] ;
	[dict setValue:@(self.userId) forKey:@"userId"] ;
    [dict setValue:@(self.showCheckInfo) forKey:@"showCheckInfo"] ;
    
	return dict;
}

-(id)copyWithZone:(NSZone *)zone{
	DInviterInfo *copy = [[DInviterInfo alloc] init];
	copy.gid = self.gid;
	copy.inviteStatus = self.inviteStatus;
	copy.nickname = self.nickname;
	copy.userNumber = self.userNumber;
	copy.isOwn = self.isOwn;
	
	[copy setHasCheckInfo:self.hasCheckInfo];
	[copy setNumber: self.number];
	[copy setPhotoUrl:self.photoUrl];
	[copy setApplyTime:self.applyTime];
    
//    2014-09-04 19:34:35 补充
    [copy setCheckInfo:[self.checkInfo mutableCopy]];
    [copy setUserId:self.userId];
    [copy setShowCheckInfo:self.showCheckInfo];
    
    
	return copy;
}
-(void)parseDict:(NSDictionary*)dict{

	if (dict == nil) {
		return;
	}
	[self setUserNumber:[dict objectForKey:@"userNumber"]];
	[self setNickname:[dict objectForKey:@"nickname"]];
	[self setInviteStatus:[[dict objectForKey:@"inviteStatus"] integerValue]];
	[self setIsOwn:[[dict objectForKey:@"isOwn"] integerValue]];
	[self setNumber:[[dict objectForKey:@"number"] integerValue]];
	[self setPhotoUrl:[dict objectForKey:@"photoUrl"]];
	[self setHasCheckInfo:[[dict objectForKey:@"hasCheckInfo"] integerValue]];
	[self setApplyTime:[[dict objectForKey:@"applyTime"] longLongValue] / 1000];

    NSArray *arr = [dict objectForKey:@"checkInfo"];
    for (NSDictionary *item in arr) {
        DCheckInfo *Info = [[DCheckInfo alloc] init];
        [Info parseDict:item];
        [self.checkInfo addObject:Info];
    }
    [self setUserId:[[dict objectForKey:@"userId"] integerValue]];
	[self setShowCheckInfo:[[dict objectForKey:@"showCheckInfo"] integerValue]];
}

@end

#pragma mark - 活动数据
@implementation DEventData
@synthesize gid, timeZone, calendarType, eventType, location;
@synthesize geoPoint, dtEnd, dtStart, rule;
@synthesize ruleDesc, isAlarm, isAllDay,title;
@synthesize content ;
@synthesize alarmInfo ;
@synthesize inviterInfo, senderNickname;
@synthesize source, isPublic;
@synthesize maxPersonNum,fee, feeDesc, eventSign;
@synthesize isCheckFlag, checkInfo,gatherAddress, gatherGeo, gatherTime,eventStatus;
@synthesize checkStatus, prepay;
@synthesize distance, isExpired, commentNum, createTime, senderUserNumber,inNum;
@synthesize latitude, longitude, regionCode;
-(DEventData*)init{
	if (self = [super init]) {
		gid = @"";
		timeZone = @"";
		calendarType = 1;
		eventType = 0;  //默认活动类型 为：其他。
		location= @"";
		geoPoint = @"";
		rule = @"";
		ruleDesc = @"";
		isAlarm = 1;
		isAllDay = 0;
		title = @"";
		source = 0;
		isPublic = 1;
		maxPersonNum = 0;
		feeDesc = @"";
		fee =0;
		eventSign = @"";
		gatherAddress= @"";
		gatherGeo=@"";
		eventStatus=0;
		prepay = 0;
		checkStatus = 0; //默认创建活动的状态 为 发起人状态
		distance = 1;
		isExpired = 0;
        _repeatRule=1;
		createTime = [Utility getTimestamp];
//		senderUserNumber = [DAccountManagerInstance curAccountInfoUserNumber];
//        _senderUserID = [DAccountManagerInstance curAccountInfoUserID];
        
        self.discussGid = 0;
	}
	return self;
}

-(void)initEventData{
	[self setGid:KDRAFTEVETN];
    
	[self setTimeZone:[NSTimeZone defaultTimeZone].name];
	[self setCalendarType:1];
    
	//默认的活动
	[self setIsAlarm:1];
	DAlarmInfo *info = [[DAlarmInfo alloc] init];
	info.alarmType = 0;
	info.alarmTrigger = @"P0W0D1H0M0S";
	[self.alarmInfo addObject:info];
	[self setSource:0];
	[self setSenderNickname:[DAccountManagerInstance curAccountInfoNickName]];
     self.senderUserNumber = [DAccountManagerInstance curAccountInfoUserNumber];
    self.senderUserID = [DAccountManagerInstance curAccountInfoUserID];
    
    DInviterInfo *invInfo = [[DInviterInfo alloc] init];
	invInfo.isOwn = 1;
	invInfo.inviteStatus = 1;
	invInfo.userNumber = [DAccountManagerInstance curAccountInfoUserNumber];
	invInfo.nickname = [DAccountManagerInstance curAccountInfoNickName];
	invInfo.gid = self.gid;
	[self.inviterInfo addObject:invInfo];
    
    self.discussGid = 0;
    self.eventType = TYPE_OTHER;
	[self setInNum:1];
    [self setGatherTime:self.dtStart];
    
    self.repeatRule = 1;
    self.feeType = 1;
    self.isCheckFlag = 0;
    self.isPublic= 1;
    self.maxPersonNum = 0;
}


-(void)upDataEventToDateBase{
    //活动
}

-(void)insertEventToDateBase{
    
}


-(NSString*)isCheckFlagDescrption{
    if (self.isCheckFlag == 1) {
        return @"需要";
    }
    else{
        return @"无需";
    }
}
-(NSString*)isPublicDescrption{
    if (self.isPublic == 1) {
        return @"公开";
    }
    else{
        return @"私密";
    }
}

-(NSString*)contentDescription{
    if (self.content && [self.content count] > 0) {
        return @"有";
    }
    else{
        return @"无";
    }
}
-(NSString*)checkInfoDescrption{
    if (!self.checkInfo) {
        return @"无";
    }
    
    if (![Utility isEmptyString:self.checkInfo.name]||
        ![Utility isEmptyString:self.checkInfo.userNumber]||
        ![Utility isEmptyString:self.checkInfo.certNo]||
        ![Utility isEmptyString:self.checkInfo.remark]
        ) {
        return @"有";
    }
    return @"无";
}

-(NSString*)repeatRuleDescrpition{
    if (self.repeatRule ==1) {
        return @"单次";
    }
    else if (self.repeatRule ==2){
        return @"每天";
    }
    else if (self.repeatRule == 3){
        return @"每周";
        
    }
    else if (self.repeatRule == 4){
        return @"每月";
    }
    return @"单次";
}


-(NSString*)feeDescString{
    if (self.feeType == 1) {
        return @"AA";
    }
    
    if (self.fee > 0) {
        return [NSString stringWithFormat:@"%.2f元",self.fee];
    }
    else{
        return @"免费";
    }
}

-(NSString*)maxPersonNumDescription{
    if (self.maxPersonNum <= 0) {
        return @"不限";
    }
    else{
        return [NSString stringWithFormat:@"%d人",self.maxPersonNum];
    }
}
-(NSString*)userNumberDescription{
    if (self.senderUserNumber.length >0) {
        return self.senderUserNumber;
    }
    else{
        return @"无";
    }
}

-(NSString*)GatherInfoDescription{
    if (self.gatherTime > 1000) {
        return @"有";
    }
    if (self.gatherAddress.length > 0) {
        return @"有";
    }
    if (self.gatherGeo.length > 0) {
        return @"有";
    }
    return @"无";
}

-(void)deleteEventFromDateBase{
}


-(void)insertDraftEventToDateBase{
}

-(void)upDateDraftEventToDateBase{
}

-(void)deleteDraftEventFromDateBase{
}



-(NSMutableArray*)content{
	if (content == nil) {
		content = [[NSMutableArray alloc] initWithCapacity:1];
	}
	return content;
}

-(void)setContent:(NSMutableArray *)content1{
	content = [content1 mutableCopy];
}

-(NSMutableArray*)alarmInfo{
	if (alarmInfo == nil) {
		alarmInfo = [[NSMutableArray alloc] initWithCapacity:1];
	}
	return alarmInfo;
}
-(NSMutableArray*)inviterInfo{
	if (inviterInfo == nil) {
		inviterInfo = [[NSMutableArray alloc] initWithCapacity:1];
	}
	return inviterInfo;
}
-(DCheckInfo*)checkInfo{
	if (checkInfo == nil) {
		checkInfo = [[DCheckInfo alloc] init];
	}
	return checkInfo;
}
-(id)copyWithZone:(NSZone *)zone{
	DEventData *copyData = [[DEventData alloc] init];
	copyData.title = self.title;
	copyData.gid = self.gid;
	copyData.eventType = self.eventType;
	copyData.location = self.location;
	
	copyData.dtStart = self.dtStart;
	copyData.dtEnd = self.dtEnd;
	copyData.geoPoint = self.geoPoint;
	copyData.rule = self.rule;
    copyData.atEnd = self.atEnd;
    copyData.atStart = self.atStart;
    
	copyData.ruleDesc = self.ruleDesc;
	copyData.calendarType = self.calendarType;
	copyData.isAlarm = self.isAlarm;
	copyData.isAllDay = self.isAllDay;
	copyData.isPublic = self.isPublic;
	copyData.timeZone = self.timeZone;
	copyData.source = self.source;
	copyData.senderNickname = self.senderNickname;
    [copyData setSenderUserNumber:self.senderUserNumber];
    copyData.senderUserID = self.senderUserID;
    copyData.senderUserPhotoURL = self.senderUserPhotoURL;
    copyData.senderUserGender = self.senderUserGender;
	copyData.eventSign = self.eventSign;
	
	copyData.alarmInfo = [self.alarmInfo mutableCopy];
	copyData.content = [self.content mutableCopy];
	copyData.inviterInfo = [self.inviterInfo mutableCopy];
//	copyData.checkInfo = [self.checkInfo copy];
	copyData.checkInfo = self.checkInfo;
    copyData.maxPersonNum = self.maxPersonNum;
	
    
    //费用描述
    copyData.feeType = self.feeType;
	[copyData setFee:self.fee];
	[copyData setFeeDesc:self.feeDesc];
    [copyData setPrepay:self.prepay];
    
    //重复活动
    copyData.repeatRule = self.repeatRule;
    copyData.atStart = self.atStart;
    copyData.atEnd = self.atEnd;
    
    copyData.isPublic = self.isPublic;
    
	[copyData setGatherAddress:self.gatherAddress];
	[copyData setGatherGeo:self.gatherGeo];
	[copyData setGatherTime:self.gatherTime];
	[copyData setIsCheckFlag:self.isCheckFlag];
	[copyData setEventStatus:self.eventStatus];
	[copyData setCheckStatus:self.checkStatus];
	
	//2014-08-23 14:16:38 协议补充字段。

    copyData.senderUserID = self.senderUserID;
	[copyData setIsExpired:self.isExpired];
	[copyData setCreateTime:self.createTime];
	[copyData setDistance:self.distance];
	[copyData setCommentNum:self.commentNum];
	[copyData setInNum:self.inNum];
    copyData.inviterCount = self.inviterCount;
    copyData.voteCount = self.voteCount;
    
    [copyData setLatitude: self.latitude];
    [copyData setLongitude: self.longitude];
    [copyData setRegionCode:self.regionCode];
    
    [copyData setDiscussGid:self.discussGid];
    [copyData setCheckStatus:self.checkStatus];
    
	return copyData;
}

-(void)parseDict:(NSDictionary*)dict{
	if (dict == nil) {
		return;
	}
	
	self.gid = [dict objectForKey:@"gid"];
	self.title = [dict objectForKey:@"title"];
   
	self.eventType = [[dict objectForKey:@"eventType"] intValue];
	self.location = [dict objectForKey:@"location"];

	self.dtStart = [[dict objectForKey:@"dtStart"] longLongValue] /1000;
	self.dtEnd = [[dict objectForKey:@"dtEnd"] longLongValue] / 1000;
    
    self.atStart = [[dict objectForKey:@"atStart"] longLongValue] /1000;//shizejing 2014-11-21
    self.atEnd = [[dict objectForKey:@"atEnd"] longLongValue] /1000;//shizejing 2014-11-21
    
	self.geoPoint = [dict objectForKey:@"geoPoint"];
	self.repeatRule = [[dict objectForKey:@"repeatRule"] integerValue];
    if (0 == self.repeatRule) {
        //兼容历史数据
        self.repeatRule = 1;
    }
	
    //begin 在迭代18中去掉
//    self.rule = [dict objectForKey:@"rule"];
//	self.ruleDesc = [dict objectForKey:@"ruleDesc"];
//	self.calendarType = [[dict objectForKey:@"calendarType"] intValue];
//	self.isAlarm = [[dict objectForKey:@"isAlarm"] intValue];
//	self.isAllDay = [[dict objectForKey:@"isAllDay"] intValue];
    //end 在迭代18中去掉
    
	self.isPublic  = [[dict objectForKey:@"isPublic"] intValue];
	self.timeZone = [dict objectForKey:@"eventTimeZone"];//timeZone
	self.source = [[dict objectForKey:@"source"] intValue];
    
	self.eventSign = [dict objectForKey:@"eventSign"];
    self.senderUserID = [[dict objectForKey:@"senderUserId"] integerValue];
    self.senderNickname = [dict objectForKey:@"senderNickname"];
    self.senderUserNumber = [dict objectForKey:@"senderUserNumber"];
    
    //begin 在迭代18中增加
    self.senderUserPhotoURL  = [dict objectForKey:@"senderUserPhotoUrl"];
    self.senderUserGender  = [dict objectForKey:@"senderUserSex"];    
    self.inviterCount = [[dict objectForKey:@"inviterCount"] integerValue];
    self.voteCount = [[dict objectForKey:@"voteCount"] integerValue];
    self.feeType = [[dict objectForKey:@"feeType"] integerValue];
    //end 在迭代18中增加
    
	self.fee = [[dict objectForKey:@"fee"] doubleValue];
	self.feeDesc = [dict objectForKey:@"feeDesc"];
	self.maxPersonNum = [[dict objectForKey:@"maxPersonNum"] intValue];

	self.gatherAddress= [dict objectForKey:@"gatherAddress"];
	self.gatherGeo= [dict objectForKey:@"gatherGeo"];
	self.gatherTime= [[dict objectForKey:@"gatherTime"] longLongValue] / 1000;
	
    //默认的集合时间未 开始时间。
    if (self.gatherTime <= 100) {
        self.gatherTime = self.dtStart;
    }
    
	self.eventStatus = [[dict objectForKey:@"eventStatus"] integerValue];
	self.checkStatus = [[dict objectForKey:@"checkStatus"] integerValue];
	self.prepay = [[dict objectForKey:@"prepay"] doubleValue];
////begin 迭代18 新版活动详情接口里去掉了 shizejing
	self.distance = [[dict objectForKey:@"distance"] doubleValue];
	self.isExpired = [[dict objectForKey:@"isExpired"] integerValue];
	self.createTime = [[dict objectForKey:@"createTime"] longLongValue] / 1000;
	self.commentNum = [[dict objectForKey:@"commentNum"] integerValue];
	self.inNum = [[dict objectForKey:@"inNum"] integerValue];
    self.discussGid = [[dict objectForKey:@"discussGid"] longLongValue];
//end
	self.longitude = [[dict objectForKey:@"longitude"] doubleValue];
	self.latitude = [[dict objectForKey:@"latitude"] doubleValue];
	self.regionCode = [dict objectForKey:@"regionCode"];



	//内容
	NSError *error = nil;
	NSString *contet = [dict valueForKey:@"content"];
	id firstDict = nil;
	if (contet) {
		firstDict = [NSJSONSerialization JSONObjectWithData:[contet dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:&error];
	}

	if ([firstDict isKindOfClass:[NSArray class]]) {
		
		for (id item  in firstDict) {
			
			if ([item isKindOfClass:[NSDictionary class]]) {
				
				NSDictionary *secondDict = (NSDictionary*)item;
				DEventContent *info = [[DEventContent alloc] init];
				
				//类型
				info.type = [[secondDict valueForKey:@"type"] intValue];
				//内容。
				NSArray *arr =[secondDict objectForKey:@"ctx"];
				if ([arr isKindOfClass:[NSArray class]]) {
					for (id thirdDict in arr) {
						if ([thirdDict isKindOfClass:[NSDictionary class]]) {
							Ctx *ctx1 = [[Ctx alloc] init];
							NSString *val = [thirdDict objectForKey:@"val"];
							ctx1.val = val;
							[info.ctx addObject:ctx1];
						}
					}
				}
				
				[self.content addObject:info];
			}
		}
	}
	//审核信息。
	self.isCheckFlag = [[dict objectForKey:@"isCheckFlag"] integerValue];
	NSString *checkInfoStr = [dict valueForKey:@"checkInfo"];
	if (checkInfoStr) {
		id checkInfoDict = [NSJSONSerialization JSONObjectWithData:[checkInfoStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:&error];
		if ([checkInfoDict isKindOfClass:[NSDictionary class]]) {
			NSDictionary *tempDict = (NSDictionary*)checkInfoDict;
			DCheckInfo *info = [[DCheckInfo alloc] init];
			[info setName: [tempDict objectForKey:@"name"]];
			[info setUserNumber: [tempDict objectForKey:@"userNumber"]];
			[info setCertNo: [tempDict objectForKey:@"certNo"]];
			[info setRemark: [tempDict objectForKey:@"remark"]];
			[self setCheckInfo:info];
		}
	}
////begin 迭代18 新版活动详情接口里去掉了 shizejing
	//提醒 服务器无保存 默认提醒一个小时。
	NSArray *arrDict = [dict valueForKey:@"valarm"];
	if ([arrDict isKindOfClass:[NSArray class]]) {
		for (id item  in arrDict) {
			if ([item isKindOfClass:[NSDictionary class]]) {
				NSDictionary *alarm = (NSDictionary*)item;
				DAlarmInfo *info = [[DAlarmInfo alloc] init];
				info.alarmType = [[alarm objectForKey:@"alarmType"] intValue];
				info.alarmTrigger = [alarm objectForKey:@"alarmTrigger"];
				
				info.gid = self.gid;
				[self.alarmInfo addObject:info];
                if (![info.alarmTrigger isEqualToString:@"-P0W0D0H0M0S"]) {
                    self.isAlarm = 1;
                }
                else{
                    self.isAlarm = 0;
                }
			}
		}
	}
	else{
		DAlarmInfo *info = [[DAlarmInfo alloc] init];
		info.alarmType = 0;
		info.alarmTrigger = @"P0W0D1H0M0S";
		info.gid = self.gid;
		[self.alarmInfo addObject:info];
        self.isAlarm = 1;
	}

    
	//邀请人
	NSArray *arrInviterDict = [dict valueForKey:@"inviter"];
	if ([arrInviterDict isKindOfClass:[NSArray class]]) {
		for (id item  in arrInviterDict) {
			if ([item isKindOfClass:[NSDictionary class]]) {
				NSDictionary *invite = (NSDictionary*)item;
				DInviterInfo *info = [[DInviterInfo alloc] init];
                [info parseDict:invite];
				info.gid = self.gid;
				[self.inviterInfo addObject:info];
			}
		}
	}
    //end 在迭代18中去掉
    
    
    //迭代18 不支持隐私活动 ，默认设置成公开活动。
    self.isPublic = 1;
}

-(NSMutableDictionary*)dicionaryWithEvent{
	NSMutableDictionary *eventDic = [[NSMutableDictionary alloc] init];
	
	[eventDic setValue:self.gid forKey:@"gid"];
	[eventDic setValue:self.title forKey:@"title"];
	
	//
	NSDictionary * dictSelf = [PrintObject getObjectData:self];
	NSDictionary* contentDic = [dictSelf objectForKey:@"content"];
	NSString* text = [contentDic HHJSONString];
	[eventDic setValue:text forKey:@"content"];

	[eventDic setValue:[NSString stringWithFormat:@"%d",self.eventType] forKey:@"eventType"];
	[eventDic setValue:self.location forKey:@"location"];
	
	[eventDic setValue:self.geoPoint forKey:@"geoPoint"];
	[eventDic setValue:[NSString stringWithFormat:@"%f",self.dtStart] forKey:@"dtStart"];
	[eventDic setValue:[NSString stringWithFormat:@"%f",self.dtEnd] forKey:@"dtEnd"];
	[eventDic setValue:self.rule forKey:@"rule"];
	
	[eventDic setValue:self.ruleDesc forKey:@"ruleDesc"];
	[eventDic setValue:[NSString stringWithFormat:@"%d",self.calendarType] forKey:@"calendarType"];
	[eventDic setValue:[NSString stringWithFormat:@"%d",self.isAlarm] forKey:@"isAlarm"];
	[eventDic setValue:[NSString stringWithFormat:@"%d",self.isAllDay] forKey:@"isAllDay"];
	[eventDic setValue:self.timeZone forKey:@"timeZone"];
	[eventDic setValue:[NSString stringWithFormat:@"%d",self.source] forKey:@"source"];

	//费用描述
    [eventDic setValue:[NSString stringWithFormat:@"%d",self.feeType] forKey:@"feeType"];
    [eventDic setValue:[NSString stringWithFormat:@"%f",self.prepay] forKey:@"prepay"];
    [eventDic setValue:[NSString stringWithFormat:@"%f",self.fee] forKey:@"fee"];
	[eventDic setValue:self.feeDesc forKey:@"feeDesc"];
    
	[eventDic setValue:[NSString stringWithFormat:@"%d",self.maxPersonNum] forKey:@"maxPersonNum"];
    
	[eventDic setValue:self.eventSign forKey:@"eventSign"];
	[eventDic setValue:self.senderNickname forKey:@"senderNickname"];
    [eventDic setValue:self.senderUserNumber forKey:@"senderUserNumber"];
    [eventDic setValue:@(self.senderUserID) forKey:@"senderUserID"];
    
    [eventDic setValue:self.senderUserPhotoURL forKey:@"senderUserPhotoURL"];
    [eventDic setValue:self.senderUserGender forKey:@"senderUserGender"];

	//报名审核。
	[eventDic setValue:[NSString stringWithFormat:@"%d",self.isCheckFlag] forKey:@"isCheckFlag"];
	[eventDic setValue:self.checkInfo.name forKey:@"name"];
	[eventDic setValue:self.checkInfo.userNumber forKey:@"userNumber"];
	[eventDic setValue:self.checkInfo.certNo forKey:@"certNo"];
	[eventDic setValue:self.checkInfo.remark forKey:@"remark"];

	[eventDic setValue:[NSString stringWithFormat:@"%d",self.checkStatus] forKey:@"checkStatus"];
	[eventDic setValue:[NSString stringWithFormat:@"%f",self.prepay] forKey:@"prepay"];

    //重复活动。
    [eventDic setValue:[NSString stringWithFormat:@"%d",self.repeatRule] forKey:@"repeatRule"];
    [eventDic setValue:[NSString stringWithFormat:@"%f",self.atStart] forKey:@"atStart"];
    [eventDic setValue:[NSString stringWithFormat:@"%f",self.atEnd] forKey:@"atEnd"];

    
	//集合时间
	[eventDic setValue:[NSString stringWithFormat:@"%lld",self.gatherTime] forKey:@"gatherTime"];
	[eventDic setValue:self.gatherGeo forKey:@"gatherGeo"];
	[eventDic setValue:self.gatherAddress forKey:@"gatherAddress"];

	//
	[eventDic setValue:[NSString stringWithFormat:@"%d",self.eventStatus] forKey:@"eventStatus"];
	[eventDic setValue:[NSString stringWithFormat:@"%d",self.isExpired] forKey:@"isExpired"];
	[eventDic setValue:[NSString stringWithFormat:@"%f",self.distance] forKey:@"distance"];
	[eventDic setValue:[NSString stringWithFormat:@"%ld",(long)self.commentNum] forKey:@"commentNum"];
	[eventDic setValue:@(self.inviterCount) forKey:@"inviterCount"];
    [eventDic setValue:@(self.voteCount) forKey:@"voteCount"];
    [eventDic setValue:[NSString stringWithFormat:@"%lld",self.createTime] forKey:@"createTime"];
	[eventDic setValue:[NSString stringWithFormat:@"%d",self.inNum] forKey:@"inNum"];

    
    [eventDic setValue:[NSString stringWithFormat:@"%f",self.longitude] forKey:@"longitude"];
	[eventDic setValue:[NSString stringWithFormat:@"%f",self.latitude] forKey:@"inNum"];
	[eventDic setValue:self.regionCode forKey:@"regionCode"];

    
    [eventDic setValue:[NSString stringWithFormat:@"%lld",self.discussGid] forKey:@"discussGid"];

	return eventDic;
}
@end


#pragma mark -	简化的活动数据，用于 个人资料中 我发起的活动，我参与的活动展示。
@implementation DSimpleEventData
-(void)parseDict:(NSDictionary*)dict{
    if (dict == nil || ![dict isKindOfClass:[NSDictionary class]]) {
        return;
    }
    self.eventId = [[dict objectForKey:@"eventId"] integerValue];
    self.userId = [[dict objectForKey:@"userId"] integerValue];
    self.gid = [dict objectForKey:@"gid"];
    self.eventSign = [dict objectForKey:@"eventSign"];
    self.title = [dict objectForKey:@"title"];
    self.dtStart = [[dict objectForKey:@"dtStart"] longLongValue] / 1000;
    self.dtEnd = [[dict objectForKey:@"dtEnd"] longLongValue] / 1000;
    self.joinTime = [[dict objectForKey:@"joinTime"] longLongValue] / 1000;
    self.eventType = [[dict objectForKey:@"eventType"] integerValue];
    self.eventStatus = [[dict objectForKey:@"eventStatus"] integerValue];
}

@end

#pragma mark - 配置项数据。
@implementation DConfigData
-(NSMutableDictionary*)dicionaryWithConfigData{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:self.configKey forKey:@"configKey"];
    [dict setValue:self.configValue forKey:@"configValue"];
    [dict setValue:[NSString stringWithFormat:@"%d", self.configId] forKey:@"configId"];
    return dict;
}

-(void)parseDict:(NSDictionary *)dict{
    if (dict == nil || ![dict isKindOfClass:[NSDictionary class]]) {
        return;
    }
    self.configKey = [dict objectForKey:@"configKey"];
    self.configValue = [dict objectForKey:@"configValue"];
    self.configId = [[dict objectForKey:@"configId"] integerValue];
}

@end

#pragma mark - 投票数据。
@implementation DVoteItem
@synthesize voteItemId, num, itemDesc,voteId,itemId;
-(void)parseDict:(NSDictionary*)dict{
	if (dict == nil || ![dict isKindOfClass:[NSDictionary class]]) {
		return;
	}
	self.voteItemId = [[dict objectForKey:@"voteItemId"] intValue];
	self.num = [[dict objectForKey:@"num"] intValue];
	self.itemDesc = [dict objectForKey:@"itemDesc"];
	self.voteId = [[dict objectForKey:@"voteId"] intValue];
	self.itemId = [[dict objectForKey:@"itemId"] intValue];
	
}

-(id)copyWithZone:(NSZone *)zone{
	DVoteItem *copy = [[DVoteItem alloc] init];
	copy.voteItemId = self.voteItemId;
	copy.num = self.num;
	copy.itemDesc = self.itemDesc;
	copy.itemId = self.itemId;
	copy.voteId = self.itemId;
	
	return copy;
}
@end

@implementation DVote
@synthesize voteItem, createVoteTime, title, mode, voteId, hasVote, totalNum,isFinish;
-(NSMutableArray*)voteItem{
	if (voteItem == nil) {
		voteItem = [[NSMutableArray alloc] initWithCapacity:1];
	}
	return voteItem;
}

-(id)copyWithZone:(NSZone *)zone{
	DVote *copy = [[DVote alloc] init];
	
	copy.voteItem = [self.voteItem mutableCopy];
	copy.createVoteTime = self.createVoteTime;
	copy.title = self.title;
	copy.mode = self.mode;
	copy.voteId = self.voteId;
	copy.hasVote = self.hasVote;
	copy.totalNum = self.totalNum;
	copy.isFinish = self.isFinish;
	
	return copy;
}
-(void)parseDict:(NSDictionary*)dict{
	if (dict == nil || ![dict isKindOfClass:[NSDictionary class]]) {
		return;
	}
	
	self.voteId = [[dict objectForKey:@"voteId"] intValue];
	self.createVoteTime = [[dict objectForKey:@"createVoteTime"] longLongValue]/1000;
	self.title = [dict objectForKey:@"title"];
	self.mode = [[dict objectForKey:@"mode"] intValue];
	self.hasVote = [[dict objectForKey:@"hasVote"] intValue];
	self.isFinish = [[dict objectForKey:@"isFinish"] intValue];
	self.totalNum = [[dict objectForKey:@"totalNum"] intValue];
	
	NSArray *arrItem  = [dict objectForKey:@"voteItem"];
	for (id data in arrItem) {
		if ([data isKindOfClass:[NSDictionary class]]) {
			NSDictionary *dic  = (NSDictionary*)data;
			DVoteItem *item = [[DVoteItem alloc] init];
			[item parseDict:dic];
			[self.voteItem addObject:item];
		}
	}
}
@end

//记录图片上传时 的信息。
@implementation DUploadImageRecordData
@synthesize gid, numOfCount,numOfFinished,numOfFail;
-(DUploadImageRecordData*)init{
	if (self = [super init]) {
		gid = @"";
		numOfFinished = 0;
		numOfCount = 0;
        numOfFail = 0;
	}
	return self;
}
-(id)copyWithZone:(NSZone *)zone{
	DUploadImageRecordData *copy = [[DUploadImageRecordData alloc] init];
    [copy setGid:self.gid];
    [copy setNumOfCount:self.numOfCount];
    [copy setNumOfFinished:self.numOfFinished];
    [copy setNumOfFail:self.numOfFail];
	return copy;
}

@end

@implementation DCommentData
@synthesize gid, commentId, content, nickName, userNumber, commentTime;

-(NSMutableDictionary*)dicionaryWithComment{
    NSMutableDictionary *commentDic = [[NSMutableDictionary alloc] init];
	
	[commentDic setValue:self.gid forKey:@"gid"];
	[commentDic setValue:self.commentId forKey:@"commentId"];
	[commentDic setValue:self.content forKey:@"content"];
	[commentDic setValue:self.nickName forKey:@"nickName"];
	[commentDic setValue:self.userNumber forKey:@"userNumber"];
	[commentDic setValue:[NSString stringWithFormat:@"%lld",self.commentTime] forKey:@"commentTime"];
	
	return commentDic;
}

-(id)copyWithZone:(NSZone *)zone{
	DCommentData *copy = [[DCommentData alloc] init];
	copy.gid = self.gid;
	copy.commentId = self.commentId;
	copy.content = self.content;
	copy.nickName = self.nickName;
	copy.userNumber = self.userNumber;
	copy.commentTime = self.commentTime;

	return copy;
}

@end

#pragma mark -- 消息图片上传
@implementation DEventImagesUpload


@end

@implementation DMessageData
@synthesize alert;//, sound, badge;
@synthesize msgId;
@synthesize gid, secondId, type, time;
@synthesize isRead, numOfCount,numOfFail,numOfFinished;
@synthesize accountID, isOperation, isCheckFlag;
@synthesize voteId, updateField, isFull, userNumber,userID, nickname;
-(DMessageData*)init{
	if (self = [super init]) {
//		self.account = [DAccountManagerInstance curAccountInfoUserNumber];
        self.accountID = [DAccountManagerInstance curAccountInfoUserID];
        self.isRead = 0;
        self.isOperation = 0;
	}
	
	return self;
}

-(NSMutableDictionary*)dicionaryWithMessage{
    NSMutableDictionary *messageDic = [[NSMutableDictionary alloc] init];
	
	[messageDic setValue:@(self.accountID) forKey:@"accountID"];
	//
	[messageDic setValue:[NSString stringWithFormat:@"%d",self.msgId] forKey:@"msgId"];
	
	//推送自带信息
	[messageDic setValue:self.alert forKey:@"alert"];
	
	[messageDic setValue:self.gid forKey:@"gid"];
	[messageDic setValue:[NSString stringWithFormat:@"%d",self.secondId] forKey:@"secondId"];
	[messageDic setValue:[NSString stringWithFormat:@"%lld",self.time] forKey:@"time"];
	[messageDic setValue:[NSString stringWithFormat:@"%d",self.type] forKey:@"type"];
    [messageDic setValue:[NSString stringWithFormat:@"%d",self.isOperation] forKey:@"isOperation"];

	[messageDic setValue:[NSString stringWithFormat:@"%d",self.isRead] forKey:@"isRead"];
    [messageDic setValue:[NSString stringWithFormat:@"%d",self.numOfFinished] forKey:@"numOfFinished"];
    [messageDic setValue:[NSString stringWithFormat:@"%d",self.numOfFail] forKey:@"numOfFail"];
    [messageDic setValue:[NSString stringWithFormat:@"%d",self.numOfCount] forKey:@"numOfCount"];

	[messageDic setValue:[NSString stringWithFormat:@"%d",self.voteId] forKey:@"voteId"];
    [messageDic setValue:[NSString stringWithFormat:@"%d",self.isFull] forKey:@"isFull"];
    [messageDic setValue:self.updateField forKey:@"updateField"];
    [messageDic setValue:self.userNumber forKey:@"userNumber"];
        [messageDic setValue:[NSString stringWithFormat:@"%d",self.userID] forKey:@"userId"];
    [messageDic setValue:self.nickname forKey:@"nickname"];
    [messageDic setValue:self.avatorName forKey:@"avatorName"];
    [messageDic setValue:self.reason?self.reason:@"" forKey:@"reason"];
    [messageDic setValue:[NSString stringWithFormat:@"%d",self.isCheckFlag] forKey:@"isCheckFlag"];
    
    [messageDic setValue:[NSString stringWithFormat:@"%d",self.userID] forKey:@"userId"];

    [messageDic setValue:[NSString stringWithFormat:@"%d",self.liveId] forKey:@"liveId"];
    [messageDic setValue:self.livePicUrl forKey:@"livePicUrl"];
    [messageDic setValue:self.replyNickname forKey:@"replyNickname"];
    [messageDic setValue:[NSString stringWithFormat:@"%d",self.commentId] forKey:@"commentId"];
    
 	return messageDic;
}

-(void)parsePushDict:(NSDictionary*)dict{
    /*
     
     dict = @{@"aps":@{
     @"alert":@"cghhjw",
     @"badge":@(0),
     @"sound":@"default"},@"id":@"{\"msgId\":1080,\"type\":8,\"gid\":\"0D22552E-FA78-4BCF-A160-D069C15BC482\",\"sendTime\":1410415889323,\"title\":\"cghhjw\",\"userNumber\":\"15818734850\",\"nickname\":\"james2\",\"isFull\":1}"};
     
     dict = @{@"aps":@{
     @"alert":@"cghhjw",
     @"badge":@(0),
     @"sound":@"default"},@"id":@"{\"msgId\":1081,\"type\":8,\"gid\":\"0D22552E-FA78-4BCF-A160-D069C15BC482\",\"sendTime\":1410415889323,\"title\":\"cghhjw\",\"userNumber\":\"15818734850\",\"nickname\":\"james2\",\"isFull\":0}"};
     
     dict = @{@"aps":@{
     @"alert":@"cghhjw",
     @"badge":@(0),
     @"sound":@"default"},@"id":@"{\"msgId\":1083,\"type\":5,\"gid\":\"0D22552E-FA78-4BCF-A160-D069C15BC482\",\"sendTime\":1410415889323,\"title\":\"cghhjw\",\"userNumber\":\"15818734850\",\"nickname\":\"james2\"}"};
     */
    
    self.alert = [dict objectForKey:@"content"];
	self.msgId = [[dict objectForKey:@"msgId"]intValue];
    
	//自定义信息。 服务器拉取的数据。
	NSString *dataString = [dict objectForKey:@"topic"];
	if (!dataString) {
        self.gid = [dict objectForKey:@"gid"];
        self.isFull = [[dict objectForKey:@"isFull"] integerValue];
        self.time = [[dict objectForKey:@"sendTime"] longLongValue] / 1000;
        self.type = [[dict objectForKey:@"type"] intValue];
        self.alert = [dict objectForKey:@"title"];
        self.userNumber = [dict objectForKey:@"userNumber"];
                self.userID = [[dict objectForKey:@"userId"] integerValue];
        self.nickname = [dict objectForKey:@"nickname"];
        self.msgId = [[dict objectForKey:@"msgId"]intValue];
        self.reason = [dict objectForKey:@"refuseReason"];
        self.isCheckFlag = [[dict objectForKey:@"isCheckFlag"] intValue];
        self.updateField = [dict objectForKey:@"updateField"];
        self.avatorName = [dict objectForKey:@"photoUrl"];
        self.replyNickname = [dict objectForKey:@"replyNickname"];
    
        //直播消息
        self.liveId = [[dict objectForKey:@"liveId"] integerValue];
        self.commentId = [[dict objectForKey:@"commentId"] integerValue];
        self.livePicUrl = [dict objectForKey:@"livePicUrl"];

		return ;
    }
    else {
        //push获取的消息。
        NSDictionary *parameterDic = [NSJSONSerialization JSONObjectWithData: [dataString dataUsingEncoding:NSUTF8StringEncoding]
                                                                     options: NSJSONReadingMutableContainers
                                                                       error: nil];
        
        self.msgId = [[parameterDic objectForKey:@"msgId"]intValue];
        self.type = [[parameterDic objectForKey:@"type"] intValue];
        self.gid = [parameterDic objectForKey:@"gid"];
        self.alert = [parameterDic objectForKey:@"title"];
        self.secondId = [[parameterDic objectForKey:@"secondId"] intValue];
        self.time = [[parameterDic objectForKey:@"sendTime"] longLongValue] / 1000;
        
        self.voteId = [[parameterDic objectForKey:@"voteId"] intValue];
        self.updateField = [parameterDic objectForKey:@"updateField"];
        self.isFull = [[parameterDic objectForKey:@"isFull"] intValue];
        self.userNumber = [parameterDic objectForKey:@"userNumber"];
                self.userID = [[dict objectForKey:@"userId"] integerValue];
        self.nickname = [parameterDic objectForKey:@"nickname"];
        self.reason = [parameterDic objectForKey:@"refuseReason"];
        
        self.isCheckFlag = [[parameterDic objectForKey:@"isCheckFlag"] intValue];
        
        //直播消息
        self.liveId = [[parameterDic objectForKey:@"liveId"] integerValue];
        self.commentId = [[parameterDic objectForKey:@"commentId"] integerValue];
        self.livePicUrl = [parameterDic objectForKey:@"livePicUrl"];
    }
}

-(id)copyWithZone:(NSZone *)zone{
	DMessageData *copy = [[DMessageData alloc] init];
	copy.accountID = self.accountID;
	copy.msgId = self.msgId;
	
	copy.alert = self.alert;
//	copy.badge = self.badge;
//	copy.sound = self.sound;
	
	copy.gid = self.gid;
	copy.secondId = self.secondId;
	copy.time = self.time;
	copy.type = self.type;
	
	copy.isRead = self.isRead;
    copy.numOfCount = self.numOfCount;
    copy.numOfFinished = self.numOfFinished;
    copy.numOfFail = self.numOfFail;
	
	copy.isFull = self.isFull;
	copy.voteId = self.voteId;
	copy.userNumber= self.userNumber;
    	copy.userID= self.userID;
	copy.nickname = self.nickname;
	copy.updateField = self.updateField;
    copy.reason = self.reason;
    copy.isOperation = self.isOperation;
    
    copy.isCheckFlag = self.isCheckFlag;
    
    copy.liveId = self.liveId;
    copy.commentId = self.commentId;
    copy.livePicUrl = self.livePicUrl;
    
	return copy;
}

@end




