//
//  DRequestOperator.m
//  DCalendar
//
//  Created by GaoAng on 14-5-13.
//  Copyright (c) 2014年 richinfo.cn. All rights reserved.
//

#import "DRequestOperator.h"


@protocol DownloadProgressDelegate <NSObject>

- (void)setProgress:(float)newProgress;

@end

@interface DRequestOperator ()

//@property (nonatomic, readonly) AFHTTPRequestOperation *m_objAFOper;
@property (nonatomic, readonly) id <DownloadProgressDelegate> downloadProgressDelegate;

@end

@implementation DRequestOperator
@synthesize delegate;
//@synthesize m_objAFOper = _objAFOper;
@synthesize downloadProgressDelegate;
@synthesize requestData;
- (id)init
{
    self = [super init];
    if (self)
    {
    }else{}
    return self;
}
- (void)dealloc
{
//    if (_objAFOper)
//    {
//        [_objAFOper cancel];
//        _objAFOper = nil;
//    }else{}
    
    delegate = nil;
    downloadProgressDelegate = nil;
}

/*
-(BOOL)requestWithBaseRequest:(DBaseRequest *)baseReq progressDelegate:(id)progress{
    BOOL bRet = NO;
    
    [self cancelRequest];
    if (baseReq )
    {
        bRet = YES;
        [self cancelRequest];
        downloadProgressDelegate = progress;
        self.requestData = baseReq;
		
        __block NSString *blockStrURL = [baseReq GetrequestURL];
        __weak typeof(self) blockSelf = self;
		
		if (blockStrURL.length <= 0) {
			NSLog(@"URL  IS NULL...");
			return NO;
		}
		else{
			NSLog(@"%@", blockStrURL);
		}
		NSURL *requestURL = [NSURL URLWithString:[blockStrURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
		NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:requestURL];
		[urlRequest setTimeoutInterval:20.0f];
		[urlRequest setHTTPMethod:@"POST"];
		[urlRequest addValue:[NSString stringWithFormat:@"%d",baseReq.apiversion] forHTTPHeaderField:@"apiversion"];
        [urlRequest addValue:baseReq.comeFrom forHTTPHeaderField:@"comeFrom"];
		[urlRequest setValue:@"text/x-json" forHTTPHeaderField:@"Content-Type"];

		//根据不同的请求的类型 特殊处理HTTPHeaderField
		//上传图片的接口特殊处理。
		if (baseReq.requestType == ERequest_UploadImg || baseReq.requestType == ERequest_UploadImg_User) {
			urlRequest.cachePolicy = NSURLRequestReloadIgnoringCacheData;
			
			NSString *content=[[NSString alloc]initWithFormat:@"multipart/form-data; boundary=%@",TWITTERFON_FORM_BOUNDARY];
			[urlRequest setValue:content forHTTPHeaderField:@"Content-Type"];
			[urlRequest setValue:[NSString stringWithFormat:@"%d", [[baseReq getRequestData] length]] forHTTPHeaderField:@"Content-Length"];
			
		}else if (baseReq.requestType == ERequest_DeviceToken || baseReq.requestType == ERequest_DeviceBind || baseReq.requestType == ERequest_DeviceUnbind) {
			
			[urlRequest setValue:@"text/xml" forHTTPHeaderField:@"Content-Type"];
        }else{
			[urlRequest setValue:@"text/x-json" forHTTPHeaderField:@"Content-Type"];
		}
		//请求的数据。
		[urlRequest setHTTPBody:[baseReq getRequestData]];
        
        UtilityLOG;
		_objAFOper = [[AFHTTPRequestOperation alloc] initWithRequest:urlRequest];
        _objAFOper.responseSerializer = [AFHTTPResponseSerializer serializer];
        [_objAFOper setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             @try {
                 NSData *responseData = (NSData *)responseObject;
                 if (responseData)
                 {
					 NSError *error = nil;
					 NSString* responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
					 NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:[responseString dataUsingEncoding:NSUTF8StringEncoding]
                                                                          options:kNilOptions error:&error];
//					 NSLog(@"debug: %@", responseString);
					 DBaseResponsed *baseRes = (DBaseResponsed*)[baseReq getRespondParseClass];
					 if (baseReq == nil) {
						 NSLog(@"没有提供解析类:%@", baseReq.requestURL);
					 }
					 else{
						 if (baseReq.requestType == ERequest_DeviceUnbind || baseReq.requestType == ERequest_DeviceBind) {
							 [baseRes parseResponseStrData:responseString];
						 }
						 else{
							 [baseRes parseResponseData:dict];
						 }
    				 }
	                 if (blockSelf.delegate && [blockSelf.delegate respondsToSelector:@selector(requestFinishedOper:respondData:)])
                     {
                         // delegate 通知获取成功
						 [blockSelf.delegate requestFinishedOper:blockSelf respondData:baseRes];
                     }
					 else{
						 NSLog(@"UI ：requestFinishedOper failded");
					 }
                     UtilityLOG;

				 }
             }
             @catch (NSException *exception) {
				 NSLog(@"exception:没有解析");
             }
             @finally {}
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
         {
			 if (blockSelf.delegate && [blockSelf.delegate respondsToSelector:@selector(requestFinishedOper:respondData:)])
			 {
				 // delegate 通知失败。
				 NSLog(@"%@", error);
				 DBaseResponsed *baseRes = [[DBaseResponsed alloc] init];
				 baseRes.summary = [NSString stringWithFormat:@"%@",error];
                 baseRes.errorCode = error.code;
				 [blockSelf.delegate requestFinishedOper:blockSelf respondData:baseRes];
			 }
         }];
        
        [_objAFOper setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead)
         {
             if (blockSelf.downloadProgressDelegate && [blockSelf.downloadProgressDelegate respondsToSelector:@selector(setProgress:)])
             {
                 CGFloat f = (CGFloat)totalBytesRead / totalBytesExpectedToRead;
                 [blockSelf.downloadProgressDelegate setProgress:f];
             }else{}
         }];
        
        [_objAFOper start];
    }
    else
    {
        bRet = NO;
    }
    
    return bRet;
}*/

- (BOOL)requestWithBaseRequest:(DBaseRequest *)baseReq callback:(void (^)(DBaseResponsed *receData))callback{
    BOOL bRet = NO;
    /*
    [self cancelRequest];
    if (baseReq )
    {
        bRet = YES;
        [self cancelRequest];
//        downloadProgressDelegate = progress;
        self.requestData = baseReq;
        
        __block NSString *blockStrURL = [baseReq GetrequestURL];
        __weak typeof(self) blockSelf = self;
        
        if (blockStrURL.length <= 0) {
            NSLog(@"URL  IS NULL...");
            return NO;
        }
//        else{
//            NSLog(@"%@", blockStrURL);
//        }
        NSURL *requestURL = [NSURL URLWithString:[blockStrURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:requestURL];
        [urlRequest setTimeoutInterval:20.0f];
        [urlRequest setHTTPMethod:@"POST"];
        [urlRequest addValue:[NSString stringWithFormat:@"%d",baseReq.apiversion] forHTTPHeaderField:@"apiversion"];
        [urlRequest addValue:baseReq.comeFrom forHTTPHeaderField:@"comeFrom"];
        [urlRequest setValue:@"text/x-json" forHTTPHeaderField:@"Content-Type"];
        
        //根据不同的请求的类型 特殊处理HTTPHeaderField
        //上传图片的接口特殊处理。
        if (baseReq.requestType == ERequest_UploadImg || baseReq.requestType == ERequest_UploadImg_User) {
            urlRequest.cachePolicy = NSURLRequestReloadIgnoringCacheData;
            NSString *content=[[NSString alloc]initWithFormat:@"multipart/form-data; boundary=%@",TWITTERFON_FORM_BOUNDARY];
            [urlRequest setValue:content forHTTPHeaderField:@"Content-Type"];
            [urlRequest setValue:[NSString stringWithFormat:@"%d", [[baseReq getRequestData] length]] forHTTPHeaderField:@"Content-Length"];
        }
        else if (baseReq.requestType == ERequest_DeviceToken || baseReq.requestType == ERequest_DeviceBind || baseReq.requestType == ERequest_DeviceUnbind) {
            [urlRequest setValue:@"text/xml" forHTTPHeaderField:@"Content-Type"];
        }
        else{
            [urlRequest setValue:@"text/x-json" forHTTPHeaderField:@"Content-Type"];
        }
        //请求的数据。
        [urlRequest setHTTPBody:[baseReq getRequestData]];

        NSLog(@"--开始网络请求：%@",blockStrURL);
        UtilityLOG;
//        __weak DRequestOperator *_self = self;
        _objAFOper = [[AFHTTPRequestOperation alloc] initWithRequest:urlRequest];
        _objAFOper.responseSerializer = [AFHTTPResponseSerializer serializer];
        [_objAFOper setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             @try {
                 NSData *responseData = (NSData *)responseObject;
                 UtilityLOG;
                 NSLog(@"--结束网络请求");
                 if (responseData)
                 {
                     NSError *error = nil;
                     NSString* responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
                     NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:[responseString dataUsingEncoding:NSUTF8StringEncoding]
                                                                          options:kNilOptions error:&error];
//                     NSLog(@"debug: %@", responseString);
                     DBaseResponsed *baseRes = (DBaseResponsed*)[baseReq getRespondParseClass];
                     if (baseReq == nil) {
                         NSLog(@"没有提供解析类:%@", baseReq.requestURL);
                     }
                     else{
                         if (baseReq.requestType == ERequest_DeviceUnbind || baseReq.requestType == ERequest_DeviceBind) {
                             [baseRes parseResponseStrData:responseString];
                         }
                         else{
                             [baseRes parseResponseData:dict];
                         }
                     }
                     
                     //统一处理数据库中数据。
                     if (blockSelf.delegate && [blockSelf.delegate respondsToSelector:@selector(requestFinishedOper:respondData:)])
                     {
                         // delegate 通知获取成功
                         [blockSelf.delegate requestFinishedOper:blockSelf respondData:baseRes];
                     }
                     
                     if (callback) {
                         callback(baseRes);
                     }
                 }
             }
             @catch (NSException *exception) {
                 NSLog(@"exception:没有解析");
             }
             @finally {}
         }
        failure:^(AFHTTPRequestOperation *operation, NSError *error){
             if (callback){
                 // delegate 通知失败。
                 NSLog(@"%@", error);
                 DBaseResponsed *baseRes = [[DBaseResponsed alloc] init];
                 baseRes.summary = [NSString stringWithFormat:@"%@",error];
                 baseRes.errorCode = error.code;
                 baseRes.code = baseRes.errorCode;
                 callback(baseRes);
             }
         }];
        
        [_objAFOper start];
    }
    else{
        bRet = NO;
    }
    */
    return bRet;
}


- (void)cancelRequest{
//    if (_objAFOper){
//        [_objAFOper cancel];
//        _objAFOper = nil;
//    }else{}
}

- (void)setProgressDelegate:(id)progress{
    downloadProgressDelegate = progress;
}

- (id)getProgressDelegate{
    return downloadProgressDelegate;
}

@end
