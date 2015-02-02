//
//  DLocalNotificationManage.h
//  DCalendar
//
//  Created by GaoAng on 14-6-16.
//  Copyright (c) 2014年 richinfo.cn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DLocalNotificationManage : NSObject

+ (DLocalNotificationManage *)sharedInstance;
- (BOOL)addOneLocalNotificationWithEvent:(DEventData*)event;
- (void)cancelAllNotification;
- (BOOL)cancelLocalNotificationWithEvent:(DEventData*)event;
- (BOOL)cancelLocalNotificationWithEventGid:(NSString *)gid;

@end
