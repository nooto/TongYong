//
//  DDBConfig.m
//
//
//  Created by  on 12-5-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
//本地数据配置库
#import "DDBConfig.h"
#include <sys/xattr.h>
#import "DDatabaseQueue.h"
#import "DDatabaseAdditions.h"

@interface DDBConfig() 

@end

@implementation DDBConfig
@synthesize dbPath;

static DDBConfig* dbconfigShareInstance;

+(DDBConfig*) shareInstace{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (dbconfigShareInstance == nil) {
            dbconfigShareInstance = [[ DDBConfig alloc] init];
        }
    });
	return dbconfigShareInstance;
}

-(id) init
{
	@synchronized(self) {
		if ((self = [super init])) {
            [self getDbWithCurAccount];
		}
		return self;
	}
}


#pragma mark - 数据库基本操作。
- (void)AddSkipBackupAttributeToFilePath: (NSString *)strFile
{
    u_int8_t b = 1;
    setxattr([strFile fileSystemRepresentation], "com.apple.MobileBackup", &b, 1, 0, 0);
}

-(void)initDBPath:(NSString *)path{
	if (path== nil && path.length  <= 0) {
		return;
	}
	else{
		self.dbPath = path;
	}
}
- (NSString *)getDbPath
{
    NSString *account = nil;
    NSInteger userID = [DAccountManagerInstance curAccountInfoUserID];
    if (userID <= 0) {
        account = @"EeventPlaza";
    }else{
        account = [NSString stringWithFormat:@"%@",@(userID)];
    }
	NSString *filePath=@"";
//	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
//	filePath=[paths objectAtIndex:0];
    
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (version == 5.0) {
        // iOS 5 code
        NSArray * paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        filePath = [paths objectAtIndex:0];
    }
    else {
        NSArray * paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
        filePath = [paths objectAtIndex:0];
    }
	[self AddSkipBackupAttributeToFilePath:filePath];
	
	NSMutableString * aTPath=[NSMutableString stringWithString:filePath];
	[aTPath appendString:@"/"];
	NSMutableString * tempPath =[NSMutableString stringWithString:aTPath];
	[tempPath appendString:[NSString stringWithFormat:@"%@/",account]];
	
	// 判断文件夹是否存在，不存在则创建对应文件夹
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = FALSE;
    BOOL isDirExist = [fileManager fileExistsAtPath:tempPath isDirectory:&isDir];
    if(!(isDirExist && isDir))
    {
        BOOL bCreateDir = [fileManager createDirectoryAtPath:tempPath withIntermediateDirectories:YES attributes:nil error:nil];
        if(!bCreateDir){
            NSLog(@"Create Audio Directory Failed.");
        }
    }

	//创建对应的帐号数据库文件。
	if (account) {
		[tempPath appendString:[NSString stringWithFormat:@"%@.db",account]];
	}
	else{
		[tempPath appendString:@"Daccount.db"];
	}
	filePath = tempPath;
    return filePath;
}

- (DDatabase *)getDbWithCurAccount{
    NSString *filePath = [self getDbPath];
	DDatabase *curDB =[DDatabase databaseWithPath:filePath];
    return curDB;
}

//根据表名往表中插入一条记录
-(BOOL) InsertIntoTableByName:(NSDictionary*)dic tableName:(NSString*)tableName :(DDatabase*)m_db
{
		if(dic==nil || [dic count]==0) return NO;
		
		NSArray * arrKeys=[dic allKeys];
		NSArray * arrValues=[dic allValues];
		NSInteger count=[arrKeys count];
		NSString *sql = [NSString stringWithFormat:@"insert into %@(",tableName];
		NSMutableString * tempsql=[NSMutableString stringWithString:sql];
		for (int i=0; i<count; i++)
		{
			[tempsql appendString:[arrKeys objectAtIndex:i]];
			if(i != count-1)
			{
				[tempsql appendString:@","];
			}
		}
		[tempsql appendString:@") values("];
		for(int k=0; k<count; k++)
		{
			[tempsql appendString:@"?"];
			if(k != count-1)
			{
				[tempsql appendString:@","];
			}
		}
		[tempsql appendString:@")"];
		[m_db executeUpdate:tempsql withArgumentsInArray:arrValues];
		if([m_db hadError])
		{
			NSLog(@"Insert into %@ table has Error, %@",tableName, [m_db lastError]);
			return NO;
		}
		return YES;
}

//更新满足所有条件的记录
-(BOOL)UpdateByTableName:(NSDictionary*)dic condition:(NSDictionary*)dicCondtion tableName:(NSString*)name :(DDatabase*)m_db
{

		if([dicCondtion count]==0) return NO;
		NSInteger count=[dic count];
		if(dic==nil || count==0) return NO;
		NSArray * keyArray=[dic allKeys];
		NSString *sql = [NSString stringWithFormat:@"update %@ set ",name];
		NSMutableString * tempsql=[NSMutableString stringWithString:sql];
		
		for (int i=0; i<count; i++) {
			[tempsql appendString:[keyArray objectAtIndex:i]];
			[tempsql appendString:@"=?"];
			if(i != count-1)
			{
				[tempsql appendString:@", "];
			}
		}
		count=[dicCondtion count];
		[tempsql appendString:@" where "];
		keyArray=[dicCondtion allKeys];
		for (int i=0; i<count; i++) {
			[tempsql appendString:[keyArray objectAtIndex:i]];
			[tempsql appendString:@"=?"];
			if(i != count-1)
			{
				[tempsql appendString:@" and "];
			}
		}
		
		NSMutableArray * valArray=[NSMutableArray arrayWithArray:[dic allValues]];
		NSArray *conditionValArray=[dicCondtion allValues];
		for(int i=0;i<[conditionValArray count];i++)
		{
			[valArray addObject:[conditionValArray objectAtIndex:i]];
		}
		
		[m_db executeUpdate:tempsql withArgumentsInArray:valArray];
		if([m_db hadError])
		{
			return NO;
		}
	    return YES;
}

- (BOOL)deleteTable:(NSString *)tableName :(DDatabase*)m_db
{
		[m_db executeUpdate: [NSString stringWithFormat:@"DELETE FROM %@", tableName]];
		if ([m_db hadError]) {
			return NO;
		}
		else{
			return YES;
		}
}

-(BOOL)createTable:(NSString*)sql :(DDatabase*)db{
	if (![db open]) {
		[db open];
	}
		[db executeUpdate:sql];
		if([db hadError])
		{
			return NO;
		
		}
		return YES;
}


-(BOOL) MakeAccountDBIsExistAndOpen:(DDatabase*)db
{
	if(![db open]){
		return NO;
	}
	else{
		@try {
            [self createAllTableWithDB:db];
		}
		@catch (NSException *exception) {
			return NO;
		}
		return YES;
	}
}

- (DDatabaseQueue *)dbQueue{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (_dbQueue == nil) {
            NSString *path = [self getDbPath];
            _dbQueue = [DDatabaseQueue databaseQueueWithPath:path];
            NSString *last = [path lastPathComponent];
            NSRange rang = [path rangeOfString:last];
            path = [path substringToIndex:rang.location];
            
            NSDictionary *attributes = [NSDictionary dictionaryWithObject:NSFileProtectionNone
                                                                   forKey:NSFileProtectionKey];
            [[NSFileManager defaultManager] setAttributes:attributes
                                                        ofItemAtPath:path
                                                               error:nil];
            if (_dbQueue) {
                __weak DDBConfig *tempSelf = self;
                [_dbQueue inTransaction:^(DDatabase *db, BOOL *rollback) {
                    [tempSelf createAllTableWithDB:db];
                }];
            }
        }
    });
    return _dbQueue;
}

-(void)resetDBQueue{

    if (_dbQueue) {
        NSString *path = [self getDbPath];
        _dbQueue = [DDatabaseQueue databaseQueueWithPath:path];
        if (_dbQueue) {
            __weak DDBConfig *tempSelf = self;
            [_dbQueue inTransaction:^(DDatabase *db, BOOL *rollback) {
                [tempSelf createAllTableWithDB:db];
            }];
        }
    }
}

- (void)createAllTableWithDB:(DDatabase *)db
{
    [self CreateEventTable:db];
    [self CreateDraftEventTable:db];
    [self CreateEventVersionTable:db];
    [self CreateEventAlarmTable:db];
    [self CreateEventInviteTable:db];
    [self CreateEventFeeTable:db];
    [self CreateEventMessageTable:db];
    [self CreateCommentDataTable:db];
    [self createAreaInfoDataTable:db];
    [self createChatMessageDataTable:db];
    [self createConversationDataTable:db];
    [self createBuddyDataTable:db];
    [self createConfigDataTable:db];
    [self createEeventImageUploadTable:db];
    
    //数据库表的版本适配，表创建完成之后做
    [self versionAdaptive:db];
}
#pragma mark -  表操作
-(BOOL)deleteTableWithAccount:(NSString *)account{
	DDatabase*  m_db = [self getDbWithCurAccount];
	BOOL success = YES;
	if (![self deleteTable:TABLE_EVENT :m_db]) {
		success = NO;
		NSLog(@"delete table_Message fail!");
	}
	
	NSString *filePath=@"";
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
	filePath=[paths objectAtIndex:0];
	[self AddSkipBackupAttributeToFilePath:filePath];
	
	NSMutableString * aTPath=[NSMutableString stringWithString:filePath];
	[aTPath appendString:@"/"];
	NSMutableString * tempPath =[NSMutableString stringWithString:aTPath];
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	[tempPath appendString:[NSString stringWithFormat:@"%@/",account]];
	NSError *error = nil;
	[fileManager removeItemAtPath:tempPath error:&error];

	if (error) {
		return NO;
	}
	return YES;
}

//根据满足所有and条件的删除记录
- (BOOL)DeleteByTableName:(NSDictionary*)dic tableName:(NSString*)name
{
    if(name.length <= 0) return NO;
    if(dic==nil || [dic count]==0) return NO;
	DDatabase*  m_db = [self getDbWithCurAccount];

    NSArray * arrKeys=[dic allKeys];
    NSArray * arrValues=[dic allValues];
    int count=[arrKeys count];
    NSString *sql = [NSString stringWithFormat:@"delete from %@ where ",name];
    NSMutableString * tempsql=[NSMutableString stringWithString:sql];
    for (int i=0; i<count; i++)
    {
        [tempsql appendString:[arrKeys objectAtIndex:i]];
        [tempsql appendString:@"=? "];
        if(i!=count-1)
        {
            [tempsql appendString:@"and "];
        }
    }
	[m_db open];
    [m_db executeUpdate:tempsql withArgumentsInArray:arrValues];
    if([m_db hadError])
    {
		[m_db close];
        return NO;
    }
	[m_db close];
    return YES;
}

-(DEventData*)eventInfoByResultSet:(DResultSet*)rs{
    DEventData *item = [[DEventData alloc] init];
    item.gid = [rs stringForColumn:@"gid"];
    item.timeZone = [rs stringForColumn:@"timeZone"];
    item.calendarType = [[rs stringForColumn:@"calendarType"] intValue];
    item.eventType = [[rs stringForColumn:@"eventType"] intValue];
    item.location=[rs stringForColumn:@"location"];
	
    item.geoPoint = [rs stringForColumn:@"geoPoint"];
    item.dtStart = [rs doubleForColumn:@"dtStart"];
    item.dtEnd = [rs doubleForColumn:@"dtEnd"];
    item.rule = [rs stringForColumn:@"rule"];
	
    item.ruleDesc = [rs stringForColumn:@"ruleDesc"];
    
    item.isAlarm = [[rs stringForColumn:@"isAlarm"] intValue];
    item.isAllDay = [[rs stringForColumn:@"isAllDay"] intValue];
    
    item.title=[rs stringForColumn:@"title"];
    item.senderNickname=[rs stringForColumn:@"senderNickname"];
    item.senderUserNumber=[rs stringForColumn:@"senderUserNumber"];
    item.senderUserID=[rs intForColumn:@"senderUserID"];
        item.senderUserPhotoURL=[rs stringForColumn:@"senderUserPhotoURL"];
        item.senderUserGender=[rs stringForColumn:@"senderUserGender"];
    item.source=[[rs stringForColumn:@"source"] intValue];
    item.isPublic=[[rs stringForColumn:@"isPublic"] intValue];
	item.eventSign=[rs stringForColumn:@"eventSign"];
	item.maxPersonNum=[rs intForColumn:@"maxPersonNum"];
	item.eventStatus = [rs intForColumn:@"eventStatus"];
	
	item.checkStatus=[rs intForColumn:@"checkStatus"];
    
	//审核信息。
	item.isCheckFlag=[rs intForColumn:@"isCheckFlag"];
	[item.checkInfo setName:[rs stringForColumn:@"name"]];
	[item.checkInfo setUserNumber:[rs stringForColumn:@"userNumber"]];
	[item.checkInfo setCertNo:[rs stringForColumn:@"certNo"]];
	[item.checkInfo setRemark:[rs stringForColumn:@"remark"]];
	
    //费用
    item.feeType = [rs intForColumn:@"feeType"];
	item.feeDesc=[rs stringForColumn:@"feeDesc"];
	item.fee=[rs doubleForColumn:@"fee"];
    item.prepay=[rs doubleForColumn:@"prepay"];

    //重复规则
    item.repeatRule = [rs intForColumn:@"repeatRule"];
    item.atStart = [rs doubleForColumn:@"atStart"];
    item.atEnd = [rs doubleForColumn:@"atEnd"];

	item.gatherAddress=[rs stringForColumn:@"gatherAddress"];
	item.gatherGeo=[rs stringForColumn:@"gatherGeo"];
	item.gatherTime=[rs longLongIntForColumn:@"gatherTime"];
    
	item.commentNum=[rs intForColumn:@"commentNum"];
    item.inviterCount=[rs intForColumn:@"inviterCount"];
    item.voteCount=[rs intForColumn:@"voteCount"];
	item.createTime=[rs longLongIntForColumn:@"createTime"];
	item.latitude=[rs doubleForColumn:@"latitude"];
	item.longitude=[rs doubleForColumn:@"longitude"];
	item.regionCode=[rs stringForColumn:@"regionCode"];
    item.discussGid=[rs longLongIntForColumn:@"discussGid"];
    
//	//邀请人
//	item.inviterInfo = [DDBConfigInstance queryEventInviteByGid:item.gid];
//	
//	//提醒
//	item.alarmInfo = [DDBConfigInstance queryAlarmByGid:item.gid];
    
    //活动介绍。
	NSError *error;
	NSString *contet = [rs stringForColumn:@"content"];
	id firstDict = [NSJSONSerialization JSONObjectWithData:[contet dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:&error];
	if ([firstDict isKindOfClass:[NSArray class]]) {
		for (id itemData  in firstDict) {
			if ([itemData isKindOfClass:[NSDictionary class]]) {
				NSDictionary *secondDict = (NSDictionary*)itemData;
				DEventContent *info = [[DEventContent alloc] init];
				//类型
				info.type = [[secondDict valueForKey:@"type"] intValue];
				//内容。
				NSArray *arr =[secondDict objectForKey:@"ctx"];
				if ([arr isKindOfClass:[NSArray class]]) {
					for (id thirdDict in arr) {
						if ([thirdDict isKindOfClass:[NSDictionary class]]) {
							NSString *val = [thirdDict objectForKey:@"val"];
							
							if (val && [val isKindOfClass:[NSString class]]) {
								
								Ctx *ctx1 = [[Ctx alloc] init];
								NSRange rang = [val rangeOfString:@".png"];
								if (rang.length >0 ) {
									info.type = 2;
								}
								rang = [val rangeOfString:@".jpeg"];
								if (rang.length > 0) {
									info.type = 2;
								}
								
								ctx1.val = val;
								[info.ctx addObject:ctx1];
							}
						}
					}
				}
				[item.content addObject:info];
			}
		}
	}
    return item;
}

- (void)addField:(NSString*)field fieldType:(NSString*)type toTable:(NSString*)tablename db:(DDatabase *)db
{
    BOOL isExist = [db columnExists:tablename columnName:field];
    if (!isExist) {
        NSString *sql = [NSString stringWithFormat:@"ALTER TABLE %@ ADD %@ %@;",tablename,field,type];
        [db executeUpdate:sql];
    }
}

- (void)versionAdaptive:(DDatabase *)db
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *lastVersion = [userDefaults objectForKey:AppVersion];
    NSString *curVersiom = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    if (NSOrderedDescending == [curVersiom compare:lastVersion]) {
        if (NSOrderedAscending == [lastVersion compare:@"2.2.0"]) {
            //从2.2.0开始添加下面字段 (即版本号小于2.2.0的需要添加)
            [self addField:@"senderUserID" fieldType:@"number" toTable:TABLE_EVENT db:db];
            [self addField:@"senderUserGender" fieldType:@"text" toTable:TABLE_EVENT db:db];
            [self addField:@"senderUserPhotoURL" fieldType:@"text" toTable:TABLE_EVENT db:db];
            [self addField:@"inviterCount" fieldType:@"number" toTable:TABLE_EVENT db:db];
            [self addField:@"voteCount" fieldType:@"number" toTable:TABLE_EVENT db:db];
            
            [self addField:@"senderUserID" fieldType:@"number" toTable:TABLE_EVENTDRAFT db:db];
            [self addField:@"senderUserGender" fieldType:@"text" toTable:TABLE_EVENTDRAFT db:db];
            [self addField:@"senderUserPhotoURL" fieldType:@"text" toTable:TABLE_EVENTDRAFT db:db];
            [self addField:@"inviterCount" fieldType:@"number" toTable:TABLE_EVENTDRAFT db:db];
            [self addField:@"voteCount" fieldType:@"number" toTable:TABLE_EVENTDRAFT db:db];
        }
        if (NSOrderedAscending == [lastVersion compare:@"2.3.0"]) {
            //从2.3.0开始添加下面字段 (即版本号小于2.3.0的需要添加)
            
            [self addField:@"liveId" fieldType:@"number" toTable:TABLE_EVENTMESSAGE db:db];
            [self addField:@"commentId" fieldType:@"number" toTable:TABLE_EVENTMESSAGE db:db];
            [self addField:@"livePicUrl" fieldType:@"text" toTable:TABLE_EVENTMESSAGE db:db];
            [self addField:@"replyNickname" fieldType:@"text" toTable:TABLE_EVENTMESSAGE db:db];
            [self addField:@"avatorName" fieldType:@"text" toTable:TABLE_EVENTMESSAGE db:db];
        }
        
        [userDefaults setObject:curVersiom forKey:AppVersion];
    }
}

//创建活动表。
//@synthesize gid, timeZone, calendarType, eventType, location;
//@synthesize geoPoint, duration, dtEnd, dtStart, rule;
//@synthesize ruleDesc, arrContent, isAlarm, isAllDay,title;
//@synthesize arrAlarmInfo, arrInviterInfo, senderNickname;
//@synthesize source, isPublic;
//@synthesize maxPersonNum,fee, feeDesc, eventSign;
//@synthesize isCheckFlag, checkInfo,gatherAddress, gatherGeo, gatherTime,eventStatus;
//@synthesize userNumber, remark, name, certNo;
//@synthesize checkStatus, prepay;
//@synthesize distance, isExpired, commentNum, createTime, senderUserNumber;
//@synthesize latitude, longitude, regionCode;

-(NSString*)getEventTableStructStr{
    return @"CREATE TABLE IF NOT EXISTS %@ (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, gid text,\
    title text,\
    senderNickname text, \
    senderUserID number, \
    senderUserNumber text,\
    senderUserGender text,\
    senderUserPhotoURL text,\
    timeZone text,\
    calendarType text,\
    eventType text,\
    content text,\
    location text,\
    geoPoint text,\
    duration text,\
    dtEnd datetime,\
    repeatRule number,\
    dtStart datetime,\
    atStart datetime,\
    atEnd datetime,\
    rule text,\
    ruleDesc text,\
    fee number,\
    feeType number,\
    prepay number,\
    feeDesc text,\
    eventSign text,\
    maxPersonNum number,\
    isAlarm text,\
    isAllDay text,\
    source text,\
    isPublic text,\
    isCheckFlag number, \
    userNumber text,\
    checkInfo text,\
    gatherAddress text,\
    gatherGeo text,\
    gatherTime number,\
    checkStatus number,\
    eventStatus number,\
    distance number,\
    inNum number,\
    isExpired number,\
    commentNum number,\
    inviterCount number,\
    voteCount number,\
    createTime number,\
    remark text,\
    name text,\
    certNo text,\
    discussGid number,\
    latitude number,\
    longitude number,\
    regionCode text,\
    draftStatus number,\
    remark1 varchar(255), remark2 varchar(255) ,remark3 varchar(255)) ";
}
-(BOOL)CreateEventTable:(DDatabase*)db
{
    NSString *sql = [NSString stringWithFormat:[self getEventTableStructStr],TABLE_EVENT];
	return [self createTable:sql :db];
}

-(BOOL)CreateDraftEventTable:(DDatabase*)db
{
    NSString *sql = [NSString stringWithFormat:[self getEventTableStructStr],TABLE_EVENTDRAFT];
	return [self createTable:sql :db];
}


-(BOOL)CreateEventVersionTable:(DDatabase*)db
{
    NSString *sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,lastupdatetime datetime NOT NULL)",TABLE_EVENTVSERSION];
	return [self createTable:sql :db];
}


-(BOOL)CreateEventAlarmTable:(DDatabase*)db
{
    NSString *sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, gid text,alarmTrigger text, alarmType number, remark1 varchar(255),remark2 varchar(255) ,remark3 varchar(255)) ",TABLE_EVENTALARM];
	
	return [self createTable:sql :db];
}

//@synthesize hasCheckInfo,number,photoUrl;
//@synthesize payment,paymentTime, isHasPay;

-(BOOL)CreateEventInviteTable:(DDatabase*)db
{
    NSString *sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, gid text,userNumber text, nickname text, inviteStatus number, isOwn number, hasCheckInfo number, peoplenumber number, photoUrl text, applyTime number, userId number, showCheckInfo number, remark1 varchar(255),remark2 varchar(255) ,remark3 varchar(255)) ",TABLE_EVENTINVITE];
	
	return [self createTable:sql :db];
	
}

-(BOOL)CreateEventFeeTable:(DDatabase*)db
{
    NSString *sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, gid text,userID number, nickName text, payment number, paymentTime number, isHasPay number, remark1 varchar(255),remark2 varchar(255) ,remark3 varchar(255)) ",TABLE_EVENTFEE];
	
	return [self createTable:sql :db];
	
}

-(BOOL)CreateEventMessageTable:(DDatabase*)db
{
//    insert into DCalendar_EventMessage(account,msgId,secondId,time,type,badge,isFull,numOfCount,gid,numOfFail,isRead,numOfFinished,voteId,alert) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?)
    NSString *sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, msgId number, accountID number, alert text,sound text, badge number, gid text, secondId number, type number,time number,voteId number,updateField text,isFull number,userNumber text,userId number,nickname text,reason text,isRead number, isOperation number,isCheckFlag number, numOfFinished number,numOfFail number,numOfCount number, replyNickname text, liveId number, commentId number,  livePicUrl text, avatorName text, remark1 varchar(255),remark2 varchar(255) ,remark3 varchar(255)) ",TABLE_EVENTMESSAGE];
	 
	return [self createTable:sql :db];
	
}

-(BOOL)CreateCommentDataTable:(DDatabase*)db
{
	NSString *sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, commentId text, gid text, content text,nickName text, userNumber text, commentTime number,remark1 varchar(255),remark2 varchar(255) ,remark3 varchar(255)) ",TABLE_COMMENT];
	
	return [self createTable:sql :db];
	
}

-(BOOL)createAreaInfoDataTable:(DDatabase*)db{
    NSString *sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (regionCode text PRIMARY KEY NOT NULL, regionName text, level INTEGER, fatherCode text, sort text, dr text, commentTime number,remark1 varchar(255),remark2 varchar(255))",TABLE_AREAINFOS];
	
	return [self createTable:sql :db];
}

-(BOOL)createChatMessageDataTable:(DDatabase*)db{
    NSString *sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (\
                     Z_PK INTEGER PRIMARY KEY,\
                     Z_ENT INTEGER,\
                     Z_OPT INTEGER,\
                     ZDELIVERYSTATE INTEGER,\
                     ZHASSETCONVERSATION INTEGER,\
                     ZISACKED INTEGER,\
                     ZISENCRYPTEDONSERVER INTEGER,\
                     ZISGROUP INTEGER,\
                     ZISREAD INTEGER,\
                     ZREQUIREENCRYPTION INTEGER,\
                     ZTIMESTAMP number,\
                     ZCHATTER VARCHAR,\
                     ZACCOUNT VARCHAR,\
                     ZBODIES VARCHAR,\
                     ZEXT VARCHAR,\
                     ZFROM VARCHAR,\
                     ZGROUPSENDERNAME VARCHAR,\
                     ZMESSAGEID VARCHAR,\
                     ZTO VARCHAR)",TABLE_CHATMESSAGE];
	return [self createTable:sql :db];
}

-(BOOL)createConversationDataTable:(DDatabase*)db{
    NSString *sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (\
                     Z_PK INTEGER PRIMARY KEY,\
                     Z_ENT INTEGER,\
                     Z_OPT INTEGER,\
                     ZENABLERECEIVEMESSAGE INTEGER,\
                     ZENABLESHOWINLIST INTEGER default 0,\
                     ZENABLEUNREADMESSAGESCOUNTEVENT INTEGER,\
                     ZISGROUP INTEGER,\
                     ZLATESTMESSAGE number,\
                     title text,\
                     ZACCOUNT VARCHAR,\
                     ZCHATTER VARCHAR)",TABLE_CONVERSATION];
	
	return [self createTable:sql :db];
}

-(BOOL)createBuddyDataTable:(DDatabase*)db{
    NSString *sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (\
                     Z_PK INTEGER PRIMARY KEY,\
                     userNumber text,\
                     nickname text,\
                     chatname text,\
                     sex text,\
                     photoURL text,\
                     regionCode text,\
                     signature text,\
                     userId INTEGER,\
                     followingCount INTEGER,\
                     followerCount INTEGER,\
                     updataTime number,\
                     birthDate number\
                     )",TABLE_BUDDY];

    return [self createTable:sql :db];
}
-(BOOL)createConfigDataTable:(DDatabase*)db{
    NSString *sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (\
                     configId text,\
                     configKey text,\
                     configValue text\
                     )",TABLE_CONFIGDATA];
    
    return [self createTable:sql :db];
}

-(BOOL)createEeventImageUploadTable:(DDatabase*)db{
    NSString *sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (\
                     msgId number,\
                     eventId text, \
                     imageName text,\
                     imageState  INTEGER,\
                     primary key(msgId,eventId,imageName)\
                     )",TABLE_EVENTIMAGES];
    
    return [self createTable:sql :db];
}


@end
