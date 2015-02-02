//
//  DProtocol.m
//  DCalendar
//
//  Created by GaoAng on 14-5-24.
//  Copyright (c) 2014年 richinfo.cn. All rights reserved.
//

#import "BaseProtocol.h"
//#import "DRequestOperatorManager.h"

//********************************************************************************************
#pragma mark -  请求的数据类型。
@implementation DBaseRequest

@synthesize apiversion, requestURL,comeFrom, requestType;//, requestDelegate;

-(DBaseRequest*)init{
	if (self = [super init]) {
		apiversion = 11;
		requestURL = @"";
		comeFrom= @"2";
		requestType = ERequest_Other;
	}
	return self;
}
-(NSData*)getRequestData{
    if (self.requestData) {
        return self.requestData;
    }
	return nil;
}

-(NSString*)GetrequestURL{
	NSString *result = [[NSString alloc] initWithData:[self getRequestData]  encoding:NSUTF8StringEncoding];
	result = [result stringByReplacingOccurrencesOfString:@"\n" withString:@""];
	result = [result stringByAppendingString:[DAccountManagerInstance curAccountInfoToken]];
	result = [result stringByAppendingString:[Utility GetDeviceToken]];
	result = [Utility md5:result].lowercaseString;
	return [self.requestURL stringByAppendingString:result];
}


-(NSData*)dataWithDictionary:(NSDictionary*)dict{
	NSError *error = nil;
    //NSJSONWritingPrettyPrinted:指定生成的JSON数据应使用空格旨在使输出更加可读。如果这个选项是没有设置,最紧凑的可能生成JSON表示。
    NSData *jsonData = [NSJSONSerialization
                        dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    if ([jsonData length] > 0 && error == nil){
    }
    else if ([jsonData length] == 0 && error == nil){
        NSLog(@"No data was returned after serialization.");
    }
    else if (error != nil){
        NSLog(@"An error happened = %@", error);
    }
	return jsonData;
}

-(id)getRespondParseClass{
	return nil;
}

@end

//返回的数据类型。
@implementation DBaseResponsed
@synthesize requestURL, apiversion;
@synthesize code, summary, errorCode;
@synthesize issuccess;
-(DBaseResponsed*)init{
	if (self = [super init]) {
        code = -1;
	}
	return self;
}

-(void)parseResponseData:(NSDictionary *)dict{
	if (dict == nil) {
		return;
	}
    if ([dict objectForKey:@"code"]) {
        self.code = [[dict objectForKey:@"code"] intValue];
    }
	issuccess = code == 0 ? YES: NO;
	self.summary = [dict objectForKey:@"summary" ];
    if ([dict objectForKey:@"errorCode"]) {
        self.errorCode = [[dict objectForKey:@"errorCode"] intValue];
    }
}
- (void)parseResponseStrData:(NSString*)respond{
//	2014-07-29 10:37:49.760 DCalendar[33585:60b] debug: <?xml version="1.0" encoding="UTF-8"?><responseData><resultCode>S_FAIL</resultCode><resultMsg>invalid auth client.</resultMsg></responseData>
	
	NSRange rang = [respond rangeOfString:@"<resultCode>"];
	NSRange rang1 = [respond rangeOfString:@"</resultCode>"];
	
	if (respond.length > rang.location+ rang.length + rang1.location) {
		NSString *resultCode = [respond substringWithRange:NSMakeRange(rang.location+ rang.length, rang1.location)];
		if ([resultCode isEqualToString:@"S_OK"]) {
			self.issuccess = YES;
            NSLog(@"绑定devicetoken 成功");
		}
		else{
			self.issuccess = NO;
            NSLog(@"绑定devicetoken 失败");
		}
		
		rang = [respond rangeOfString:@"<resultMsg>"];
		rang1 = [respond rangeOfString:@"<resultMsg>"];
		[self setSummary:[respond substringWithRange:NSMakeRange(rang.location+ rang.length, rang1.location)]];
	}
}

@end

//************************************************************************************
#pragma mark - 消息推送相关
@implementation DRequestDeviceBind
@synthesize deviceToken,appId,uid,sign;

-(DRequestDeviceBind*)init{
	if (self = [super init]) {
		self.requestURL = [NSString stringWithFormat:@"%@",DEVICEUSER_BIND_URL];
		self.requestType = ERequest_DeviceBind;
	}
	return self;
}

-(NSData*)getRequestData{
    if (self.requestData == nil) {
        NSString *signMD5 = [Utility md5:[NSString stringWithFormat:@"%@%@%@%@",self.deviceToken,self.appId,self.uid,APPKEY]];
        NSString *postString = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><deviceBind><deviceToken>%@</deviceToken><appId>%@</appId><uid>%@</uid><sign>%@</sign></deviceBind>",self.deviceToken, self.appId, self.uid, [signMD5 lowercaseString]];
        self.requestData = [postString dataUsingEncoding:NSUTF8StringEncoding];
    }
    return self.requestData;
    
//    NSString *signMD5 = [Utility md5:[NSString stringWithFormat:@"%@%@%@%@",self.deviceToken,self.appId,self.uid,APPKEY]];
//    NSString *postString = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><deviceBind><deviceToken>%@</deviceToken><appId>%@</appId><uid>%@</uid><sign>%@</sign></deviceBind>",self.deviceToken, self.appId, self.uid, [signMD5 lowercaseString]];
//    return [postString dataUsingEncoding:NSUTF8StringEncoding];
}

-(NSString*)GetrequestURL{
	return self.requestURL;
}
-(id)getRespondParseClass{
	DResponsedDeviceBind *res = [[DResponsedDeviceBind alloc] init];
	return res;
}

@end

@implementation DResponsedDeviceBind
-(DResponsedDeviceBind*)init{
	if (self = [super init]) {
		
	}
	return self;
}
@end


@implementation DRequestDeviceUnbind
@synthesize deviceToken,appId,uid,sign;

-(DRequestDeviceUnbind*)init{
	if (self = [super init]) {
		self.requestURL = [NSString stringWithFormat:@"%@",DEVICEUSER_UNBIND_URL];
		self.requestType = ERequest_DeviceUnbind;
	}
	return self;
}

-(NSData*)getRequestData{
    if (self.requestData == nil) {
        NSString *signMD5 = [Utility md5:[NSString stringWithFormat:@"%@%@%@%@",self.deviceToken,self.appId,self.uid,APPKEY]];
        NSString *postString = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><deviceBind><deviceToken>%@</deviceToken><appId>%@</appId><uid>%@</uid><sign>%@</sign></deviceBind>",self.deviceToken, self.appId, self.uid, [signMD5 lowercaseString]];

        self.requestData =  [postString dataUsingEncoding:NSUTF8StringEncoding];
    }
    return self.requestData;
}
-(NSString*)GetrequestURL{
	return self.requestURL;
}

-(id)getRespondParseClass{
	DResponsedDeviceUnbind *res = [[DResponsedDeviceUnbind alloc] init];
	return res;
}


@end

@implementation DResponsedDeviceUnbind
-(DResponsedDeviceUnbind*)init{
	if (self = [super init]) {
		
	}
	return self;
}
@end

//********************************************************************************************


