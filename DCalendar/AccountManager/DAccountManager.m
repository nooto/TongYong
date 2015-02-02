//
//  DAccountManager.m
//  DCalendar
//
//  Created by GaoAng on 14-5-6.
//  Copyright (c) 2014年 richinfo.cn. All rights reserved.
//

#import "DAccountManager.h"

#define KEYAccountSave @"accountMangser"
#define KEYAccount @"account"
#define KEYPassword @"password"
#define KEYSID @"sid"
#define KEYTOKEN @"token"
#define KEYUID @"uid"
#define KEYNickName @"nickName"
#define KEYPhotoUrl @"photoUrl"
#define KEYDeviceBind @"deviceBind"
#define KEYUserId @"userId"
#define KEYChatName @"chatName"
#define KEYChatPwd @"chatPwd"

@implementation DAccountInfo
@synthesize  isLogin, account, psw;
@synthesize sid, token,uid,nickName,photoUrl,isDeviceBind;
-(DAccountInfo*)init{
	self = [super init];
	if (self) {
		isLogin=NO;
		account = @"";
		psw = @"";
        _chatName = nil;
        _chatPsw = nil;
		token =@"";
		sid =@"";
        uid = @"";
		photoUrl = @"";
		nickName = @"";
		isDeviceBind = NO;
        _isHaveNewMsg = YES;
        self.userId = 0;
	}
	return self;
}
-(void)initAccountInfo{
    isLogin=NO;
    account = @"";
    psw = @"";
    _chatName = nil;
    _chatPsw = nil;
    token =@"";
    sid =@"";
    uid = @"";
    photoUrl = @"";
    nickName = @"";
    isDeviceBind = NO;
    _isHaveNewMsg = YES;
    self.userId = 0;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.account = [aDecoder decodeObjectForKey:KEYAccount];
		self.psw = [aDecoder decodeObjectForKey:KEYPassword];
		self.nickName = [aDecoder decodeObjectForKey:KEYNickName];
        self.uid = [aDecoder decodeObjectForKey:KEYUID];
		self.photoUrl = [aDecoder decodeObjectForKey:KEYPhotoUrl];
		self.sid = [aDecoder decodeObjectForKey:KEYSID];
		self.token = [aDecoder decodeObjectForKey:KEYTOKEN];
        self.isDeviceBind = [[aDecoder decodeObjectForKey:KEYDeviceBind] boolValue];
        self.userId = [[aDecoder decodeObjectForKey:KEYUserId] integerValue];
        self.chatName = [aDecoder decodeObjectForKey:KEYChatName];
        self.chatPsw = [aDecoder decodeObjectForKey:KEYChatPwd];

        self.isHaveNewMsg = YES;
    }
    return  self;
}


-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:account forKey:KEYAccount];
	[aCoder encodeObject:psw forKey:KEYPassword];
	[aCoder encodeObject:sid forKey:KEYSID];
	[aCoder encodeObject:token forKey:KEYTOKEN];
    [aCoder encodeObject:uid forKey:KEYUID];
	[aCoder encodeObject:nickName forKey:KEYNickName];
	[aCoder encodeObject:photoUrl forKey:KEYPhotoUrl];
    [aCoder encodeObject:[NSString stringWithFormat:@"%d",isDeviceBind] forKey:KEYDeviceBind];
    [aCoder encodeObject:[NSString stringWithFormat:@"%d",self.userId] forKey:KEYUserId];
    [aCoder encodeObject:_chatName forKey:KEYChatName];
    [aCoder encodeObject:_chatPsw forKey:KEYChatPwd];
	
	isLogin = YES;
}

@end


/*******************************************************************************
 *  帐号管理
 */

@interface DAccountManager()
@property (nonatomic, strong) DAccountInfo *curAccountInfo;
@property (nonatomic, strong) NSMutableArray *arrAccountInfo;

@end

@implementation DAccountManager
@synthesize curAccountInfo, arrAccountInfo;

static DAccountManager* shartinstance;

+(DAccountManager*)shareInstance{
	@synchronized(self){
		if (shartinstance == nil) {
			shartinstance = [[DAccountManager alloc] init];
		}
		return shartinstance;
	}
}

-(id)init{
	self = [super init];
	if (self) {
		
		//
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
		NSData *saveAccount = [defaults objectForKey:KEYAccountSave];
		if (saveAccount) {
			arrAccountInfo = (NSMutableArray *)[NSKeyedUnarchiver unarchiveObjectWithData:saveAccount];
			if ([self.arrAccountInfo count] > 0) {
				self.curAccountInfo = [self.arrAccountInfo objectAtIndex:0];
			}
		}
	}
	return self;
}

-(NSMutableArray*)arrAccountInfo{
	
	if (arrAccountInfo == nil) {
		arrAccountInfo = [[NSMutableArray alloc] initWithCapacity:1];
	}
	
	return arrAccountInfo;
}

-(DAccountInfo*)curAccountInfo{
	if (curAccountInfo == nil) {
		if ([self.arrAccountInfo count] > 0) {
			curAccountInfo = [self.arrAccountInfo objectAtIndex:0];
		}
		else{
			curAccountInfo = [[DAccountInfo alloc] init];
			[self.arrAccountInfo addObject:curAccountInfo];
		}
	}
	return curAccountInfo;
}

-(NSString*)curAccountInfoSid{
	if (curAccountInfo ) {
		return curAccountInfo.sid;
	}
	else{
		return @"";
	}
}

-(void)setcurAccountInfoSid:(NSString *)sid{
	if (!curAccountInfo || sid.length <= 0) {
		return;
	}
	else{
		[curAccountInfo setSid:sid];
        [self saveAccountInfo];
	}
}


-(NSString*)curAccountInfoToken{
	if (curAccountInfo.token ) {
		return curAccountInfo.token;
	}
	else{
		return @"";
	}
}

-(void)setCurAccountInfoToken:(NSString *)token{
	if (!curAccountInfo || token.length <= 0) {
		return;
	}
	else{
		[curAccountInfo setToken:token];
        [self saveAccountInfo];
	}
}
-(BOOL)curAccountInfoIsDeviceBind{
	if (curAccountInfo ) {
		return curAccountInfo.isDeviceBind;
	}
	else{
		return NO;
	}
}

-(void)setcurAccountInfoDeviceBind:(BOOL)bind{
	if (curAccountInfo) {
		[curAccountInfo setIsDeviceBind:bind];
	}
	
	[self saveAccountInfo];
	
}

//获取和保存 当前账户是否有新的push消息
-(BOOL)curAccountInfoHaveNewMsg{
	if (curAccountInfo ) {
		return curAccountInfo.isHaveNewMsg;
	}
	else{
		return YES;
	}
}

-(void)setcurAccountInfoHaveNewMsg:(BOOL)haveNew{
	if (curAccountInfo) {
		[curAccountInfo setIsHaveNewMsg:haveNew];
        [self saveAccountInfo];
	}
}


-(NSString*)curAccountInfoUid{
    if (curAccountInfo) {
		return curAccountInfo.uid;
	}
	else{
		return @"";
	}
}

-(void)setCurAccountInfoUid:(NSString*)uid{
    if (!curAccountInfo || uid.length <= 0) {
		return;
	}
	else{
		[curAccountInfo setUid:uid];
        [self saveAccountInfo];
	}
}



-(BOOL)saveCurAccountInfo:(DResponsedLogin*)res withName:(NSString*)name passwrod:(NSString*)passwrod{
	if (res == nil) {
		return NO;
	}
    [self.curAccountInfo initAccountInfo];
    
	if (name.length >0) {
		[self.curAccountInfo setAccount:name];
	}
	if (passwrod.length >0) {
		[self.curAccountInfo setPsw:passwrod];
	}
	[self saveAccountInfo];
	return YES;
}

-(BOOL)saveCurAccountInfoWithUserInfo:(DResponsedUserInfo*)res{
    if (res == nil) {
        return  NO;
    }
    [self saveAccountInfo];
    return YES;
    
}

-(BOOL)curAccountIsLogin{
    if (arrAccountInfo == nil) {
        return NO;
    }else{
        return curAccountInfo.isLogin;
    }
}
-(void)SetCurAccountlogin:(BOOL)login{
	if (curAccountInfo == nil) {
		return;
	}
	else{
		curAccountInfo.isLogin = login;
	}
}

-(NSString*)curAccountInfoUserNumber{
//	if (self.curAccountInfo && self.curAccountInfo.account.length > 0) {
		return curAccountInfo.account;
//	}
//	return nil;
}
//获取昵称
-(NSString*)curAccountInfoNickName{
//	if (curAccountInfo && curAccountInfo.nickName.length > 0) {
		return curAccountInfo.nickName;
//	}
//	return nil;
}
-(void)setCurAccountInfoNickName:(NSString*)name{
	if (!curAccountInfo || name.length <= 0) {
		return;
	}
	else{
		[curAccountInfo setNickName:name];
        [self saveAccountInfo];
	}
}

//获取userid
-(NSInteger)curAccountInfoUserID{
//    if (curAccountInfo ) {
        return curAccountInfo.userId;
//    }
//    return -1;
}

//获取头像名称
-(void)setCurAccountInfoPhoneUrl:(NSString *)photo{
    [curAccountInfo setPhotoUrl:photo];
    [self saveAccountInfo];
}

-(NSString*)curAccountInfoPhoteUrl{
//	if (curAccountInfo && curAccountInfo.photoUrl.length > 0) {
		return curAccountInfo.photoUrl;
//	}
//	return nil;
}

-(NSString*)curAccountInfoPassword{
	if (curAccountInfo && curAccountInfo.psw.length > 0) {
		return curAccountInfo.psw;
	}
	return nil;
}

-(NSString*)curChatName{return curAccountInfo.chatName;}
-(NSString*)curChatPsw{return curAccountInfo.chatPsw;}

-(void)saveAccount:(NSString*)account pswd:(NSString*)pswd save:(BOOL)save{
	DAccountInfo* info = [[DAccountInfo alloc] init];
	info.account= account;
	info.psw = pswd;
    info.isLogin = YES;
    
    if (arrAccountInfo != nil) {
        NSMutableArray *allAccount = [arrAccountInfo copy];
        for (DAccountInfo *accountInfo in allAccount) {
            if ([accountInfo.account isEqualToString:account]) {
                [arrAccountInfo removeObject:accountInfo];
            }
        }
    }
	
	[self.arrAccountInfo insertObject:info atIndex:0];
    
	if (save) {
		NSUserDefaults *usertDeftault = [NSUserDefaults standardUserDefaults];
		NSData *accountlist = [NSKeyedArchiver archivedDataWithRootObject:arrAccountInfo];
		[usertDeftault setValue:accountlist forKey:KEYAccountSave];
		[usertDeftault synchronize];
	}
	curAccountInfo = [self.arrAccountInfo objectAtIndex:0];
}


-(void)saveAccountInfo{
	NSUserDefaults *usertDeftault = [NSUserDefaults standardUserDefaults];
	NSData *accountlist = [NSKeyedArchiver archivedDataWithRootObject:arrAccountInfo];
	[usertDeftault setValue:accountlist forKey:KEYAccountSave];
	[usertDeftault synchronize];
}

-(BOOL)appIsFirstUse{
    NSUserDefaults *userDeftault = [NSUserDefaults standardUserDefaults];
    NSString *isUseApp = [userDeftault objectForKey:@"isUseApp"];
    if (isUseApp== nil) {
		return YES;
	}
	else{
		return NO;
	}
}

-(void)setAppIsFirstUse{
    NSUserDefaults *userDeftault = [NSUserDefaults standardUserDefaults];
    [userDeftault setValue:@"use" forKey:@"isUseApp"];
    [userDeftault synchronize];
}


-(BOOL)deleteCurAccount{
    [self.curAccountInfo initAccountInfo];
	if (curAccountInfo == nil) {
		return NO;
	}
	
	if ([self.arrAccountInfo containsObject:curAccountInfo]) {
		[self.arrAccountInfo removeObject:curAccountInfo];
		NSUserDefaults *usertDeftault = [NSUserDefaults standardUserDefaults];
		NSData *accountlist = [NSKeyedArchiver archivedDataWithRootObject:self.arrAccountInfo];
		[usertDeftault setValue:accountlist forKey:KEYAccountSave];
		[usertDeftault synchronize];
		return YES;
	}
	return NO;
}


-(DAccountInfo*)queryAccountDetial:(NSString*)account{
	if (account == nil) {
		return nil;
	}
	
	for (NSInteger i = 0; i< [arrAccountInfo count]; i++) {
		DAccountInfo *info = [arrAccountInfo objectAtIndex:i];
		if ([info.account isEqualToString:account]) {
			return info;
		}
	}
	return nil;
}



-(BOOL)addAccountTomanager:(DAccountInfo*)info{
	if (nil == info) {
		return NO;
	}
	
	NSInteger i = 0;
	do {
		if (i == [arrAccountInfo count]) {
			[self.arrAccountInfo addObject:info];
			break;
		}
		
		//替换成新的数据，
		DAccountInfo *tempAccout = (DAccountInfo*)[arrAccountInfo objectAtIndex:i];
		if ([tempAccout.account isEqualToString:info.account]) {
			[self.arrAccountInfo replaceObjectAtIndex:i withObject:info];
			return YES;
		}
		i++;
	} while ( i <= [arrAccountInfo count]);
	
	NSUserDefaults *usertDeftault = [NSUserDefaults standardUserDefaults];
	NSData *accountlist = [NSKeyedArchiver archivedDataWithRootObject:arrAccountInfo];
	[usertDeftault setValue:accountlist forKey:KEYAccountSave];
	[usertDeftault synchronize];
	return YES;
}


-(BOOL)deleteAllAccount{
	if ([self.arrAccountInfo count] <= 0) {
		return YES;
	}
	else{
		[self.arrAccountInfo removeAllObjects];
		arrAccountInfo = nil;
		return YES;
	}
	return NO;
}


-(BOOL)deleteAccountFromManager:(DAccountInfo*)info{
	if (nil == info) {
		return NO;
	}
	
	//遍历超找 如果找到则删除
	for (id data in arrAccountInfo) {
		DAccountInfo *tempAccout = (DAccountInfo*)data;
		if ([tempAccout.account isEqualToString:info.account]) {
			[self.arrAccountInfo removeObject:data];
			return YES;
		}
	}
	
	return NO;
}

-(BOOL)deleteAccountFromManagerByaccount:(NSString*)account{
	if (nil == account) {
		return NO;
	}
	
	//遍历超找 如果找到则删除
	for (id data in arrAccountInfo) {
		DAccountInfo *tempAccout = (DAccountInfo*)data;
		if ([tempAccout.account isEqualToString:account]) {
			[self.arrAccountInfo removeObject:data];
			return YES;
		}
	}
	
	return NO;
}

@end
