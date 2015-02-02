


//@class ASIHTTPRequest;
//@class ASINetworkQueue;

@interface  CHttp: NSObject {

//    NSString *m_url;
//    int       m_port;
//    NSDictionary *m_userInfo;
//    ASIHTTPRequest *mRequest;
    
//    IMP m_call;
//    SEL netCallBackSelector;//oc形势回调
//    CallBackFunc m_callback;//C++形势回调
}

//@property (nonatomic, retain)NSString *m_url;
//@property (nonatomic, assign)int       m_port;
//@property (nonatomic, assign)NSDictionary       *m_userInfo;
//@property(nonatomic, assign) ASIHTTPRequest *m_request;

+ (CHttp *)shareNetInstance;

//发送请求，返回值为请求对象的tag，取消时需要传这个tag值
- (NSInteger)startRequest:(DBaseRequest *)baseReq callback:(void (^)(DBaseResponsed *receData))callback;

- (bool)cancelAllRequst;
- (bool)cancelRequstOperatioWithTag:(NSInteger)tag;

//- (void)uploadFileWithPath:(NSString*)filePath key:(NSString*)key extHead:(NSDictionary *)head;
//- (void)uploadFileWithData:(NSData*)data key:(NSString*)key extHead:(NSDictionary *)head;

@end