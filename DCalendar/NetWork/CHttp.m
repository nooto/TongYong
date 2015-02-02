
#import "CHttp.h"

#import "ASIFormDataRequest.h"
#import "ASIHTTPRequest.h"
#import "ASINetworkQueue.h"
#import "DDBConfig.h"

#define HTTP_POST  @"POST"
#define HTTP_GET     @"GET"
#define KRequestOjb @"requestOjbect"

//extern NSOperationQueue *sharedQueue;

@interface  CHttp()

@property (nonatomic, readonly) NSMutableArray *mArrUploardImageOper;
@property (nonatomic, strong) ASINetworkQueue *mHighPriorityQueue;//高优先级队列：需要在UI上展示的请求，后请求先执行。
@property (nonatomic, strong) ASINetworkQueue *mLowPriorityQueue;//低优先级：像离线下载，杂志下载

@end

@implementation CHttp

//@synthesize m_url;
//@synthesize m_port;
//@synthesize m_userInfo;
//@synthesize m_request;
//@synthesize netCallBackSelector;
static CHttp* gCHttpInstance;
static NSInteger gCurrentIndex;

+ (CHttp *)shareNetInstance{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (gCHttpInstance == nil) {
            gCHttpInstance = [[ CHttp alloc] init];
            gCurrentIndex  = 1;
            
//            [[NSNotificationCenter defaultCenter] addObserver:self
//                                                     selector:@selector(reachabilityChanged:)
//                                                         name:kReachabilityChangedNotification
//                                                       object:nil];
        }
    });
    return gCHttpInstance;
}

//- (void)dealloc{
//  [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
//}

- (void)setUrl:(NSString *)url port:(int)port callback:(void *)call userInfo:(NSDictionary *)dic
{
 //   if (self = [super init]) {
//        m_url   = url;
//        m_port  = port;
//        m_userInfo = nil;
//        m_userInfo   = dic;
//        [self setNetCallBackSelector:@selector(netCallBack:type:)];
//        m_callback = call;
    if (nil == _mHighPriorityQueue) {
        _mHighPriorityQueue = [[ASINetworkQueue alloc] init];//高优先级队列：需要在UI上展示的请求，后请求先执行。
        [_mHighPriorityQueue setShouldCancelAllRequestsOnFailure:NO];
        [_mHighPriorityQueue go];
    
        _mLowPriorityQueue = [[ASINetworkQueue alloc] init];//低优先级：像离线下载，杂志下载
        [_mLowPriorityQueue setShouldCancelAllRequestsOnFailure:NO];
        [_mLowPriorityQueue go];
    }
    
    _mArrUploardImageOper = [NSMutableArray arrayWithCapacity:5];
//    }
//    return self;
}


- (bool)open{
    return true;
}

- (bool)close{
    return true;
}

- (NSString *)GetNetName{
    return @"http";
}

- (bool)connet{
    return true;
}

- (bool)disConnect{
    return true;
}

- (void)resumeLowPriorityQueue{
    if(_mHighPriorityQueue.operations.count <= 1){
        [_mLowPriorityQueue setSuspended:NO];
    }
}

- (NSInteger)startRequest:(DBaseRequest *)baseReq callback:(void (^)(DBaseResponsed *receData))callback {
//- (bool)sendData:(NSData *)data extHead:(NSDictionary *)head {

    NSString *baseUrl = [baseReq GetrequestURL];

    __weak CHttp *weakSelf = self;
#if DEBUG
    NSLog(@"--开始网络请求：%@",baseUrl);
//    UtilityLOG;
#endif
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:baseUrl]];
    if (nil == request) return 0;
    
    [request setQueuePriority:NSOperationQueuePriorityNormal];
    [request setRequestMethod:HTTP_POST];
    [request addRequestHeader:@"apiversion" value:[NSString stringWithFormat:@"%d",baseReq.apiversion]];
    [request addRequestHeader:@"comeFrom" value:baseReq.comeFrom];
    if (baseReq.requestType == ERequest_UploadImg || baseReq.requestType == ERequest_UploadImg_User) {
        //downloadCache;
        //cachePolicy
        request.cachePolicy = NSURLRequestReloadIgnoringCacheData;
        NSString *content=[[NSString alloc]initWithFormat:@"multipart/form-data; boundary=%@",TWITTERFON_FORM_BOUNDARY];
        [request addRequestHeader:@"Content-Type" value:content];
        [request addRequestHeader:@"Content-Length" value:[NSString stringWithFormat:@"%d", [[baseReq getRequestData] length]]];
        [request setQueuePriority:NSOperationQueuePriorityLow];
    }
    else if (baseReq.requestType == ERequest_DeviceToken || baseReq.requestType == ERequest_DeviceBind || baseReq.requestType == ERequest_DeviceUnbind) {
        [request addRequestHeader:@"Content-Type" value:@"text/xml"];
    }
    else{
        [request addRequestHeader:@"Content-Type" value:@"text/x-json"];
    }
    
    NSData *reqData = [baseReq getRequestData];
    [request appendPostData:reqData];
    
    request.threadPriority = 1.0f;
	request.allowCompressedResponse = FALSE;
    request.numberOfTimesToRetryOnTimeout = 2;
//	request.delegate = self;
//    request.timeOutSeconds = 2;
//    request.tag = [[m_userInfo objectForKey:TYPE] integerValue];
//    request.userInfo = [NSDictionary dictionaryWithObject:baseReq forKey:KRequestOjb];
    request.didRequestFinishedBlock = ^(NSData *receData, NSError *error){
#if DEBUG
//        UtilityLOG;
        NSLog(@"--结束网络请求");
#endif
        if (!error)
        {
            if (receData)
            {
                NSError *error = nil;
                NSString* responseString = [[NSString alloc] initWithData:receData encoding:NSUTF8StringEncoding];
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
                [weakSelf handleOper:baseReq respondData:baseRes];
                
                if (callback) {
                    callback(baseRes);
                }
            }
        }
        else {
            if (callback){
                // delegate 通知失败。
                NSLog(@"%@", error);
                DBaseResponsed *baseRes = [[DBaseResponsed alloc] init];
                switch (error.code) {
                    case 1:
                        baseRes.summary = @"网络不可用";
                        baseRes.errorCode = KErrorCode_NONETWORK;
                        baseRes.code = KErrorCode_NONETWORK;
                        break;
                    case 2:
                        baseRes.summary = @"网络超时";
                        baseRes.errorCode = KErrorCode_TimeOut;
                        baseRes.code = KErrorCode_TimeOut;
                        break;
                        
                    default:
                        baseRes.summary = [NSString stringWithFormat:@"%@",error];
                        baseRes.errorCode = error.code;
                        baseRes.code = baseRes.errorCode;
                        break;
                }
                callback(baseRes);
            }
        }
    };
    
//    NSString *str = [[NSString alloc] initWithData:data encoding: NSUTF8StringEncoding];
//    DDLogInfo(@"send data: %@", str);
//    DDLogInfo(@"url:%@",m_url);
//    [str release];
    //request.timeIntervalBegin = [NSDate timeIntervalSinceReferenceDate];
//    int priority = [[m_userInfo objectForKey:PRIORITY] integerValue];
    /*
    if (NSOperationQueuePriorityVeryHigh == priority) {
        [request setQueuePriority:NSOperationQueuePriorityVeryHigh];
        NSArray *array = [NSArray arrayWithArray:[sharedQueue operations]];
        for (ASIHTTPRequest *pre in array)
        {
            if (NSOperationQueuePriorityVeryHigh==pre.queuePriority&&![pre isExecuting]) {
                [pre setQueuePriority:NSOperationQueuePriorityHigh];
//                DDLogInfo(@"-----------priority:%i last:4",priority);
            };
        }
    }
     */
    [request startAsynchronous];
    
    [self handleOper:baseReq respondData:nil];//执行前进行一个处理，把业务绑定到这里，不懂
/*
    //网络优化，优先级。
    if (NSOperationQueuePriorityVeryHigh == priority) {
        [_mLowPriorityQueue setSuspended:YES];
        [_mHighPriorityQueue addOperation:request];
    }
    else{
        [self resumeLowPriorityQueue];
        [_mLowPriorityQueue addOperation:request];
    }
 */
    request.tag = gCurrentIndex++;
    return request.tag;
}

/*
- (void)uploadFileWithPath:(NSString*)filePath key:(NSString*)key extHead:(NSDictionary *)head
{
    ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:[NSURL URLWithString:m_url]];
   
    NSString *value = nil;
    NSArray *keys = [head allKeys];
    for (NSString *key in keys)
    {
        value = [head valueForKey:key];
        [request addRequestHeader:key value:value];
    }

    [request setFile:filePath  forKey:key];
    request.threadPriority = 1.0f;
	request.allowCompressedResponse = FALSE;
//	request.delegate = self;
    request.timeOutSeconds = 20;
    request.tag = [[m_userInfo objectForKey:TYPE] integerValue];
    request.userInfo = m_userInfo;
    request.m_pReceiveFinishCallback = m_callback;
    [request setRequestMethod:HTTP_POST];
    
    [_mLowPriorityQueue setSuspended:YES];
    [_mHighPriorityQueue addOperation:request];
    / *
    int priority = [[m_userInfo objectForKey:PRIORITY] integerValue];
    //网络优化，优先级。
    if (NSOperationQueuePriorityVeryHigh == priority) {
        [m_lowPriorityQueue setSuspended:YES];
        [m_highPriorityQueue addOperation:request];
        //    NSLog(@"VeryHigh: ");
    }
    else{
        [m_lowPriorityQueue addOperation:request];
        //    NSLog(@"Low: ");
    }
     * /
}

- (void)uploadFileWithData:(NSData*)data key:(NSString*)key extHead:(NSDictionary *)head{
    ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:[NSURL URLWithString:m_url]];
    
    NSString *value = nil;
    NSArray *keys = [head allKeys];
    for (NSString *key in keys)
    {
        value = [head valueForKey:key];
        [request addRequestHeader:key value:value];
    }
    
    [request setData:data  forKey:key];
    request.threadPriority = 1.0f;
	request.allowCompressedResponse = FALSE;
    //	request.delegate = self;
    request.timeOutSeconds = 20;
    request.tag = [[m_userInfo objectForKey:TYPE] integerValue];
    request.userInfo = m_userInfo;
    request.m_pReceiveFinishCallback = m_callback;
    [request setRequestMethod:HTTP_POST];
    
    [_mLowPriorityQueue setSuspended:YES];
    [_mHighPriorityQueue addOperation:request];
    / *
     int priority = [[m_userInfo objectForKey:PRIORITY] integerValue];
     //网络优化，优先级。
     if (NSOperationQueuePriorityVeryHigh == priority) {
     [m_lowPriorityQueue setSuspended:YES];
     [m_highPriorityQueue addOperation:request];
     //    NSLog(@"VeryHigh: ");
     }
     else{
         [m_lowPriorityQueue addOperation:request];
         //    NSLog(@"Low: ");
     }
     * /
}
*/
/*
- (bool)receiveData:(NSData *)data type:(int)type
{
    if (m_delegate && [m_delegate respondsToSelector:netCallBackSelector]) {
		[m_delegate performSelector:netCallBackSelector withObject:data withObject:
         [NSString stringWithFormat:@"%i",type]];
	}
    return true;
}
*/
- (bool)cancelAllRequst
{
//    NSLog(@"cancelAllRequst");
    [ASIHTTPRequest.sharedQueue cancelAllOperations];
    gCurrentIndex = 1;
    return true;
}

- (bool)cancelRequstOperatioWithTag:(NSInteger)tag
{
    if (tag <= 0)
    {
        return false;
    }

    
//    NSLog(@"---------------------begin cancel Requst");
    NSArray *array = [NSArray arrayWithArray:[ASIHTTPRequest.sharedQueue operations]];
    for (ASIHTTPRequest *request in array)
    {
        if (tag == request.tag)
        {
            //NSLog(@"---------------------begin cancel Requstrequest=%@",request);
            if (![request isExecuting]) {
                [request cancel];
                return true;
            }
            //request.timeIntervalBegin = 0.0f;
            // NSLog(@"---------------------end Requst:request");
            break;
        }
    }
    
//    NSLog(@"---------------------end cancel Requst");
    return false;
}

//- (bool)cancelRequstByUrlArray:(NSArray *)array
//{
//    if (nil == array || [array count] == 0)
//    {
//        return false;
//    }
//
//    for (id strUrl in array)
//    {
//        if ([strUrl isKindOfClass: [NSString class]])
//        {
//            [self cancelRequstByUrl:strUrl andData:nil];
//        }
//    }
//    
//    return true;
//}

#pragma mark --
#pragma mark ASIHTTPRequest callbak
/*
- (void)request:(ASIHTTPRequest *)request didReceiveData:(NSData *)data;
{
	if(data)
	{
        [self receiveData:data type:request.tag];
	}
}
*/
- (void)requestFinished:(ASIHTTPRequest *)request
{
//    NSData *data = request.postBody;
//    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    NSLog(@"%@,%@",request.url,string);
//    NSLog(@"%@",request.responseString);
//    NSString *str = [request responseString];
//    DDLogInfo(@"receive data: %@",str);
/*
    NSData *data = [request responseData];
    //每次用完就释放
    [self receiveData:data type:request.tag];*/
//    NSDictionary *dicHead = [request responseHeaders];
    switch(request.tag)
    {
            break;
            default:
                break;
    }
    
    if (request)
    {
        [request clearDelegatesAndCancel];
//        [request release];
    }
    [self resumeLowPriorityQueue];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    if (request)
    {
        [request clearDelegatesAndCancel];
//        [request release];
    }

//    NSError *error = [request error];
//    DDLogError(@"error is <%@>",error);
    [self resumeLowPriorityQueue];
}

-(void)handleOper:(DBaseRequest *)baseRequest respondData:(DBaseResponsed *)receivedata{
    
    BOOL beforRequtest= receivedata == nil ? YES:NO;
//    DBaseRequest* baseRequest = (DBaseRequest*)(oper.requestData);
    //请求前or后进行数据处理
    switch (baseRequest.requestType) {
            
            //登录完成。
        case ERequest_Login:{
        }
            break;
            
            //刷新活动。
        case ERequest_SyncEvetn:{
            if (beforRequtest) {
                
            }
            else{
                dispatch_async(dispatch_get_main_queue(), ^{
                });
            }
        }
            break;
 
        default:
            break;
    }
}

@end