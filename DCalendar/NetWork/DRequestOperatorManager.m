//
//  DRequestOperatorManager.m
//  DCalendar
//
//  Created by GaoAng on 14-5-13.
//  Copyright (c) 2014年 richinfo.cn. All rights reserved.
//

#import "DRequestOperatorManager.h"

#define INT_DefaultListSize                 50

@interface DRequestOperatorManager (){
//	 AFHTTPRequestOperation    *_httpClient;
}

@property (nonatomic, readonly) dispatch_queue_t m_queueOperatro;
@property (nonatomic, readonly) NSMutableArray *m_arrOperator;
@property (nonatomic, readonly) NSMutableArray *m_arrUploardImageOper;
@property (nonatomic, readonly) NSInteger m_iListSize;

@end


@implementation DRequestOperatorManager
@synthesize m_queueOperatro = _queueOperatro;
@synthesize m_arrOperator = _arrOperator;
@synthesize m_iListSize = _iListSize;
@synthesize m_arrUploardImageOper = _arrUploardImageOper;

static DRequestOperatorManager* shareInstance;

+ (id)connection{
    @synchronized(self) {
        if (shareInstance == nil) {
            shareInstance = [[self alloc] init];
        }
    }
    return shareInstance;
}
/*
- (void)cancelConnectionWithDelegate:(id)delegate{
    for (NSInteger i = 0; i< [_arrOperator count]; i++) {
        DRequestOperator* tempOper = [_arrOperator objectAtIndex:i];
        if ([tempOper.requestData.requestDelegate isEqual:delegate]) {
            [tempOper cancelRequest];
            break;
        }
    }
}*/

-(DRequestOperatorManager*)init{
	if (self = [super init]) {
		_queueOperatro = dispatch_queue_create("com.richinfo.DClander.app", NULL);
		_arrOperator = [[NSMutableArray alloc] init];
		_arrUploardImageOper = [[NSMutableArray alloc] init];
        _iListSize = INT_DefaultListSize;
	}
	return self;
}

- (void)dealloc
{
    dispatch_async(_queueOperatro, ^{
        for (DRequestOperator *objOper in _arrOperator)
        {
            if (objOper)
            {
                [objOper setProgressDelegate:nil];
                [objOper cancelRequest];
            }else{}
        }
        [_arrOperator removeAllObjects];
		[_arrUploardImageOper removeAllObjects];
    });
    
    _queueOperatro = nil;
}
/*
// 设置列表最大长度
- (void)resetListSize:(NSInteger)iSize
{
    dispatch_sync(_queueOperatro, ^{
        _iListSize = (iSize > 0) ? iSize : INT_DefaultListSize;
    });
}
*/
/*
- (void)startRequest:(DBaseRequest *)baseReq delegate:(id)delegate
{
	//	下面是一个判断网络是否可以连接的例子
	Reachability *r = [Reachability reachabilityWithHostName:@"www.baidu.com"];
	if ([r currentReachabilityStatus] == NotReachable) {
		if (delegate && [delegate respondsToSelector:@selector(URLDataReceiverDidFinish:)]) {
            DBaseResponsed *baseRes = (DBaseResponsed*)[baseReq getRespondParseClass];
            baseRes.errorCode = KErrorCode_NONETWORK;
            baseRes.summary= @"网络不可用,请检查连接";
			[delegate URLDataReceiverDidFinish:baseRes];
		}
		return;
	}
	
    if (baseReq)
    {
        __weak id progressBlock = delegate;
		baseReq.requestDelegate = delegate;
        dispatch_async(_queueOperatro, ^{
			
			NSInteger i = 0;
			do {
				
				//到队列尾端。放入队列。
				if (i == [_arrOperator count]) {
					DRequestOperator *objImgOper = [[DRequestOperator alloc] init];
					[objImgOper setDelegate:self];
					
					[objImgOper requestWithBaseRequest:baseReq progressDelegate:progressBlock];
					[_arrOperator addObject:objImgOper];
					
					//在进行网络请求之前保存数据
					[self handleOper:objImgOper respondData:nil];
					
					
					// 列表满，取消第一个的下载并推出。
					if (_arrOperator && _arrOperator.count > _iListSize)
					{
						DRequestOperator  *objOper = [_arrOperator objectAtIndex:0];
						if (objOper)
						{
                            [objOper cancelRequest];
                            objOper = nil;
						}
						[_arrOperator removeObjectAtIndex:0];
					}
					break;
					
				}
				//前面的数据进行检测
				else{
//					DRequestOperator *item = (DRequestOperator*)[_arrOperator objectAtIndex:i];
//					
//					//
//                    if (item.requestData.requestType == baseReq.requestType) {
//                        break;
//                    }
//					if ([item.requestData.requestType isEqualToString:baseReq.requestURL] &&
//						item.requestData.requestType != ERequest_UploadImg) {
//						if (progressBlock)
//						{
//							[item setProgressDelegate:progressBlock];
//						}
//						break;          // break loop
//					}
				}
				i++;
				
			} while (i <= [_arrOperator count]);
			
        });
    }
}*/

- (void)startRequest:(DBaseRequest *)baseReq callback:(void (^)(DBaseResponsed *receData))callback{
    //	下面是一个判断网络是否可以连接的例子
//    Reachability *r = [Reachability reachabilityWithHostName:@"www.baidu.com"];
//    if ([r currentReachabilityStatus] == NotReachable) {
    if(![self getNetStatus]){
        if (callback) {
            DBaseResponsed *baseRes = (DBaseResponsed*)[baseReq getRespondParseClass];
            baseRes.errorCode = KErrorCode_NONETWORK;
            baseRes.issuccess = NO;
            baseRes.summary= @"网络不可用,请检查连接";
            [Utility showMessage:baseRes.summary];
            callback(baseRes);
        }
        return;
    }
    
    if (baseReq)
    {
        dispatch_async(_queueOperatro, ^{
            
            //下面代码逻辑，先找到队尾index(无意义)，然后创建一个新的请求对象并加入到队列中，同时判断队列是否超限(是则移除头节点并取消其下载，不合理)
            NSInteger i = 0;
            do {
                //到队列尾端。放入队列。
                if (i == [_arrOperator count]) {
                    DRequestOperator *objImgOper = [[DRequestOperator alloc] init];
                    [objImgOper setDelegate:self];
                    
                    [objImgOper requestWithBaseRequest:baseReq callback:callback];
                    [_arrOperator addObject:objImgOper];
                    
                    //在进行网络请求之前保存数据
                    [self handleOper:objImgOper respondData:nil];
                    
                    //列表满，取消第一个的下载并推出。
                    if (_arrOperator && _arrOperator.count > _iListSize)
                    {
                        DRequestOperator  *objOper = [_arrOperator objectAtIndex:0];
                        if (objOper)
                        {
                            [objOper cancelRequest];
                            objOper = nil;
                        }
                        [_arrOperator removeObjectAtIndex:0];
                    }
                    break;
                }
                i++;
                
            } while (i <= [_arrOperator count]);
        });
    }
}

//删除operator
- (void)removeOperFromManager:(DRequestOperator *)oper
{
    dispatch_sync(_queueOperatro, ^{
        for (DRequestOperator *objImgOper in _arrOperator)
        {
            if ([objImgOper isEqual:oper]) {
                [objImgOper setProgressDelegate:nil];
                [objImgOper cancelRequest];
                [_arrOperator removeObject:objImgOper];
                break;
            }
        }
    });
}

- (void)removeAllProgressDelegate
{
    dispatch_async(_queueOperatro, ^{
		for (DRequestOperator *objOper in _arrOperator)
        {
            if (objOper)
            {
                [objOper setProgressDelegate:nil];
            }else{}
        }
    });
}
/*
// 移除正在使用的进度条delegate
- (void)removeProgressDelegate:(id)progress
{
    if (progress)
    {
        dispatch_async(_queueOperatro, ^{
            for (DRequestOperator *objOper in _arrOperator)
            {
                if (objOper && (progress == [objOper getProgressDelegate]))
                {
                    [objOper setProgressDelegate:nil];
                }
            }
        });
    }
}*/

#pragma mark - DRequestOperatorDelegate delegate
-(void)requestFinishedOper:(DRequestOperator *)oper respondData:(DBaseResponsed *)receivedata{
    @try
    {
        if ( oper)
        {
			//成功返回后重新更新或者保存到数据库中。
			[self handleOper:oper respondData:receivedata];
/*			if (oper.requestData.requestDelegate && [oper.requestData.requestDelegate respondsToSelector:@selector(URLDataReceiverDidFinish:)]) {
				[oper.requestData.requestDelegate URLDataReceiverDidFinish:receivedata];
			}*/
        }
		
        [self removeOperFromManager:oper];
    }
    @catch (NSException *exception)
    {
		NSLog(@"error: requestFinishedOper");
    }
    @finally
    {
    }
}

/*
-(void)requestFinishedOperForCallback:(DRequestOperator *)oper respondData:(DBaseResponsed *)receivedata{
    @try
    {
        if ( oper)
        {
            //成功返回后重新更新或者保存到数据库中。
            [self handleOper:oper respondData:receivedata];
        }
        
        [self removeOperFromManager:oper];
    }
    @catch (NSException *exception)
    {
        NSLog(@"error: requestFinishedOper");
    }
    @finally
    {
    }
}*/


-(void)handleOper:(DRequestOperator *)oper respondData:(DBaseResponsed *)receivedata{
	
	BOOL beforRequtest= receivedata == nil ? YES:NO;
	DBaseRequest* baseRequest = (DBaseRequest*)(oper.requestData);
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
                    if ([receivedata isKindOfClass:[DResponsedSyncEvent class]]) {
                        DResponsedSyncEvent *res = (DResponsedSyncEvent*)receivedata;
                        //更新的活动。
                        for (NSInteger i = 0; i< [res.arrUpdateEvents count]; i++) {
                            DEventData * data = [res.arrUpdateEvents objectAtIndex:i];
                            [data insertEventToDateBase];
                        }
                    }
                });
            }
		}
			break;
        case ERequest_UpdateInviter:{
		//邀请人更新 客户端本地不保存数据库。  2014-07-25 10:06:00。by gaoang
//            DRequestUpdateInviter *joinInviter = (DRequestUpdateInviter *)oper.requestData;
//            NSString *gid = joinInviter.gid;
//            NSMutableArray *addInviter = joinInviter.addInviter;
//            NSMutableArray *delInviterList = joinInviter.delInviterList;
//            if (beforRequtest) {
//                if (addInviter) {//添加邀请人
//                    NSMutableArray *inviteList = [NSMutableArray array];
//                    for (NSDictionary *dic in addInviter) {
//                        DInviterInfo *invite = [[DInviterInfo alloc] init];
//                        [invite setGid:gid];
//                        [invite setUserNumber:[dic objectForKey:@"userNumber"]];
//                        [invite setNickname:[dic objectForKey:@"nickname"]];
//                        [invite setInviteStatus:0];
//                        [inviteList addObject:invite];
//                    }
//                    
//                    [DDBConfigInstance insertDBArrInvite:inviteList byGid:gid];
//                }else{//删除邀请人
//                    
//                }
//            }else{
//                if (addInviter) {
//                    NSMutableArray *inviteList = [NSMutableArray array];
//                    for (NSDictionary *dic in addInviter) {
//                        DInviterInfo *invite = [[DInviterInfo alloc] init];
//                        [invite setGid:gid];
//                        [invite setUserNumber:[dic objectForKey:@"userNumber"]];
//                        [invite setNickname:[dic objectForKey:@"nickname"]];
//                        [invite setInviteStatus:0];
//                        [inviteList addObject:invite];
//						[DDBConfigInstance  insertDBInvite:invite byGid:gid];
//                    }
//                }
//				else{
//                    for (NSString *userNumber in delInviterList) {
//                        [DDBConfigInstance deleteInvite:gid withUserNumber:userNumber];
//                    }
//                }
//            }
        }
            break;
        case ERequest_UpDateInviteStatus:{
            DRequestUpdateInviteStatus *updateInviteStatus = (DRequestUpdateInviteStatus*)oper.requestData;
            NSString *gid = updateInviteStatus.gid;
            int inviteStatus = updateInviteStatus.inviteStatus;
//            if (beforRequtest) {
                DInviterInfo *invite = [[DInviterInfo alloc] init];
                [invite setGid:gid];
                [invite setInviteStatus:inviteStatus];
                [invite setUserNumber:[DAccountManagerInstance curAccountInfoUserNumber]];
                invite.userId = [DAccountManagerInstance curAccountInfoUserID];
            
                [DDBConfigInstance insertDBInvite:invite byGid:gid];
//            }else{
//                
//            }
        }
            break;
        //删除活动
		case ERequest_DelEvent:{
			
			DRequestDelEvent *requset = (DRequestDelEvent*)oper.requestData;
			if (beforRequtest) {
			}
			else{
				if (receivedata.issuccess) {
					[DDBConfigInstance deleteEventWithGidFromDB:requset.gid];
					
					DRequestDelEvent* req = (DRequestDelEvent*)(oper.requestData);
					[DFileManager deleteFolderByGid:req.gid];
				}
			}
		}
			break;
		//新建 或者编辑活动
        case ERequest_PutEvent:{
			if (beforRequtest) {
            }
			else{
                DResponsedPutEvent *putEventRes = (DResponsedPutEvent *)receivedata;
                if (putEventRes.issuccess) {
				
					//
					DRequestPutEvent *putEventRequest = (DRequestPutEvent *)oper.requestData;
                    DEventData *event = putEventRequest.event;
                    //记录新的eventsign
					[event setEventSign:putEventRes.eventSign];
                    
                    //保存到数据库
                    [event insertEventToDateBase];
                    
					//创建活动或者更新活动时，需要判断这个活动中是否有图片，有图片上传的话创建一条本地的消息
                    int numOfPicture = 0;
                    for (NSInteger i = 0; i < [event.content count]; i++) {
                        DEventContent* content = [event.content objectAtIndex:i];
                        if (content.type == 2) {
                            numOfPicture +=content.ctx.count;
                        }
                    }
                }
            }
        }
            break;
		//图片上传。
		case ERequest_UploadImg:{
			DRequestUploadImg* req =  (DRequestUploadImg*)oper.requestData;
			
			//上传图片活动前保存记录。
			if (beforRequtest) {
				
				//
				if (![oper.requestData isKindOfClass:[DRequestUploadImg class]]) {
					return;
				}
				
				NSInteger i = 0;
				do {
					//检测前面是否有记录。
					if (i != [_arrUploardImageOper count]) {
						
						DUploadImageRecordData *tempData = (DUploadImageRecordData*)[_arrUploardImageOper objectAtIndex:i];
						//有活动记录 记录图片
						if ([tempData.gid isEqualToString:req.gid]) {
							tempData.numOfCount +=1;
							break;
						}
					}
					//到达队尾 无记录。
					else{
						//保存记录。
						DUploadImageRecordData *imageData = [[DUploadImageRecordData alloc] init];
						imageData.gid = req.gid;
						imageData.numOfCount = 1;
						[_arrUploardImageOper addObject:imageData];
						break;
					}

					i ++;
				} while ([_arrUploardImageOper count]+ 1);
				
			}
			//图片上传后。
			else{
                //不管成功失败都push消息过去。。。
                for (NSInteger i = 0 ; i< [_arrUploardImageOper count]; i ++) {
                    DUploadImageRecordData *tempData = (DUploadImageRecordData*)[_arrUploardImageOper objectAtIndex:i];
                    
                    //知道记录的上传的活动
                    if ([tempData.gid isEqualToString:req.gid]) {

                        DResponsedUploadImg *responseUpload = (DResponsedUploadImg*)receivedata;
                        if (responseUpload.issuccess) {
                            tempData.numOfFinished += 1;
                            [DDBConfigInstance updateMessageByGid:tempData.gid andType:100 isSuccess:YES];
                        }
                        else{
                            tempData.numOfFail += 1;
                            [DDBConfigInstance updateMessageByGid:req.gid andType:100 isSuccess:NO];
                        }

                        DUploadImageRecordData *copyData = nil;
                        if (tempData.numOfCount == tempData.numOfFinished + tempData.numOfFail) {
                            copyData = [tempData copy];
                            [self.m_arrUploardImageOper removeObject:tempData];
                        }
                        else{
                            copyData = tempData;
                        }

                        //上传图片通知
//                        dispatch_async(dispatch_get_main_queue(), ^{
//                            [[NSNotificationCenter defaultCenter] postNotificationName:UPLOADIMGNOTIFY object:copyData userInfo:nil];
//                        });
                        break;
                    }
                }
			}
		}
			break;
        case ERequest_QueryEventDetails:{
            if (beforRequtest) {
                
            }else{
                DResponsedQueryEventDetails *querEvent = (DResponsedQueryEventDetails *)receivedata;
                if (querEvent.issuccess) {
                    [querEvent.varEventData upDataEventToDateBase];
              }
            }
        }
            break;
		//批量查询活动详情
        case ERequest_QueryEventBatch:{
            if (beforRequtest) {
                
            }else{
                DResponsedQueryEventBatch *querEvent = (DResponsedQueryEventBatch *)receivedata;
                if (querEvent.issuccess) {
                    for (DEventData *event in querEvent.arrEvents) {
						[event upDataEventToDateBase];
                    }
                }
            }
        }
            break;
			
		//3.3.3	查询活动所有参与人
		case ERequest_QueryAllInviter:
        case ERequest_JoinDisGrpUpdateAvator:{
			DRequestQueryAllInviter* req =  (DRequestQueryAllInviter*)oper.requestData;
			if (beforRequtest) {
    
			}
			else{
				DResponsedQueryAllInviter *res = (DResponsedQueryAllInviter *)receivedata;
				if (res.issuccess) {
					
					//更新所该活动所有邀请人信息。
                    for (DInviterInfo *info in res.arrInviter) {
                        [DDBConfigInstance insertDBInvite:info byGid:req.gid];
                    }
				}
			}
		}
			break;
            
		//发表评论
		case ERequest_CommentEvent:{
		}
			break;
		//查询评论数据。
		case ERequest_QueryCommentEvent:{
			if (beforRequtest) {
    
			}
			else{
				DRequestCommentQueryEvent* req =  (DRequestCommentQueryEvent*)oper.requestData;
				DResponsedCommentQueryEvent *res = (DResponsedCommentQueryEvent *)receivedata;
				if (res.issuccess) {
					for (id itemData in res.commentList) {
						if (itemData && [itemData isKindOfClass:[DCommentData class]]) {
							DCommentData *tempData = (DCommentData*)itemData;
							[tempData setGid:req.gid];
							[DDBConfigInstance insertCommentToDB:tempData];
						}
					}
				}
			}
		}
			break;
            
        case ERequest_QueryConfig:{
            if (beforRequtest) {
                
            }
            else{
                DResponsedQueryConfig *res = (DResponsedQueryConfig *)receivedata;
                if (res.issuccess) {
                    
                    //更新所该活动所有邀请人信息。
                    for (DConfigData *info in res.arrConfigData) {
                        [DDBConfigInstance insertConfigData:info];
                    }
                }
            }
        }
            break;
			
			//批量查询投票详情。
		case ERequest_QueryVoteDetailBatch:{
		}
			break;
			
		//查询消息列表。
		case ERequest_QueryMsgBatch:{
			if (beforRequtest) {
    
			}
			else{
				DResponsedQueryMsgBatch *res = (DResponsedQueryMsgBatch *)receivedata;
				if (res.issuccess) {
				
					for (id itemData in res.arrMessage) {
						if (itemData && [itemData isKindOfClass:[DMessageData class]]) {
							DMessageData *tempData = (DMessageData*)itemData;
							[DDBConfigInstance insertMessageToDB:tempData];
						}
					}
				}
			}
		}
			break;
			
		case ERequest_UpdateStatus:{
			if (beforRequtest) {
				
			}
			else{
				DRequestUpdateStatus* req =  (DRequestUpdateStatus*)oper.requestData;
				DResponsedUpdateStatus* res = (DResponsedUpdateStatus*)receivedata;
				if (res.issuccess) {
					[DDBConfigInstance updateEventStatusWithGId:req.gid statues:req.eventStatus];
				}
			}
		}
		default:
			break;
	}
}
/*
- (DUploadImageRecordData*)queryUooardRecordWith:(NSString*)gid{
	if (gid.length <= 0) {
		return nil;
	}
	for (NSInteger i = 0; i< [_arrUploardImageOper count]; i++) {
		DUploadImageRecordData *tempData = (DUploadImageRecordData*)[_arrUploardImageOper objectAtIndex:i];
		if ([tempData.gid isEqualToString:gid]) {
			return tempData;
		}
	}
	
	return nil;
}*/

- (BOOL)getNetStatus
{
    return  (NotReachable == [[Reachability reachabilityForInternetConnection] currentReachabilityStatus]) ? NO: YES;
}

@end
