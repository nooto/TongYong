//
//  DLocalNotificationManage.m
//  DCalendar
//
//  Created by GaoAng on 14-6-16.
//  Copyright (c) 2014年 richinfo.cn. All rights reserved.
//

#import "DLocalNotificationManage.h"

@implementation DLocalNotificationManage
+(DLocalNotificationManage*)sharedInstance{
	static DLocalNotificationManage*myInstance = nil;
	
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		myInstance = [[[self class] alloc] init];
	});
	
	return myInstance;
}

- (BOOL)addOneLocalNotificationWithEvent:(DEventData *)event
{
    BOOL isSuccess=NO;
    return isSuccess;
    
    NSArray *arrNotification = [[UIApplication sharedApplication] scheduledLocalNotifications];//获取所有本地通知
    int count = [arrNotification count];//获取所有通知数
    for(int indx=0;indx<count;indx++)
    {
        UILocalNotification *item = [arrNotification objectAtIndex:indx];
        NSString *gid=[item.userInfo objectForKey:@"gid"];
        if([gid isEqualToString:event.gid])//如果找到相同的活动，则取消
        {
            [[UIApplication sharedApplication] cancelLocalNotification:item];
            break;
        }
    }

	//活动开始时间。
	NSDate *start = [Utility getLocaleDataWithTimerInterval:event.dtStart];
	//活动提醒时间。
	NSDate *remind=[NSDate dateWithTimeInterval:- 10 * 60 sinceDate:start];
	if (event.alarmInfo.count > 0) {
		DAlarmInfo *info = [event.alarmInfo objectAtIndex:0];
		//			不提醒。
		if ([info.alarmTrigger isEqualToString:@"-P0W0D0H0M0S"]) {
			remind = nil;
		}
		//立即提醒
		else if ([info.alarmTrigger isEqualToString:@"P0W0D0H0M0S"]){
			remind = [NSDate dateWithTimeIntervalSince1970:event.dtStart];
		}
		//活动前五分钟提醒
		else if ([info.alarmTrigger isEqualToString:@"P0W0D0H5M0S"]){
			remind = [NSDate dateWithTimeInterval: -5 * 60 sinceDate:start];
		}
		//活动前十分钟提醒
		else if ([info.alarmTrigger isEqualToString:@"P0W0D0H10M0S"]){
			remind = [NSDate dateWithTimeInterval: -10 * 60 sinceDate:start];
		}
		//活动前15分钟提醒
		else if ([info.alarmTrigger isEqualToString:@"P0W0D0H15M0S"]){
			remind = [NSDate dateWithTimeInterval: -15 * 60 sinceDate:start];
		}
		//活动前30 分钟
		else if ([info.alarmTrigger isEqualToString:@"P0W0D0H30M0S"]){
			remind = [NSDate dateWithTimeInterval: -30 * 60 sinceDate:start];
		}
		//活动前 1 小时
		else if ([info.alarmTrigger isEqualToString:@"P0W0D1H0M0S"]){
			remind = [NSDate dateWithTimeInterval: -60 * 60 sinceDate:start];
		}
		//活动前3小时
		else if ([info.alarmTrigger isEqualToString:@"P0W0D3H0M0S"]){
			remind = [NSDate dateWithTimeInterval: -3 * 60 * 60 sinceDate:start];
		}
		//活动前 1 天
		else if ([info.alarmTrigger isEqualToString:@"P0W1D0H0M0S"]){
			remind = [NSDate dateWithTimeInterval: -24* 60 * 60 sinceDate:start];
		}
		//活动前 3 天
		else if ([info.alarmTrigger isEqualToString:@"P0W3D0H0M0S"]){
			remind = [NSDate dateWithTimeInterval: -3* 24 * 60 * 60 sinceDate:start];
		}
	}
    
//    remind= [NSDate date];
	
	//提醒时间已过，不在提醒。
	NSTimeInterval val = [remind timeIntervalSinceDate:[NSDate date]];
	if ( val <= 0) {
		return NO;
	}
	
    UILocalNotification *notififcation=[[UILocalNotification alloc] init];
    if(notififcation)
    {
        notififcation.fireDate=remind;
        notififcation.timeZone=[NSTimeZone defaultTimeZone];
        notififcation.repeatInterval = 0;
        notififcation.soundName = UILocalNotificationDefaultSoundName;
        notififcation.alertBody = event.title;
        NSDictionary *userInfo=[NSDictionary dictionaryWithObjectsAndKeys:event.gid,@"gid",start,@"starttime",event.title,@"eventtitle",nil];
        notififcation.userInfo = userInfo;
        UIApplication *app = [UIApplication sharedApplication];
        [app scheduleLocalNotification:notififcation];
        isSuccess=YES;
    }

    return isSuccess;
}



-(void)cancelAllNotification
{
    NSArray *arrNotification = [[UIApplication sharedApplication] scheduledLocalNotifications];//获取所有本地通知
    int count = [arrNotification count];//获取所有通知数
    for(int indx=0;indx<count;indx++)
    {
        UILocalNotification *item = [arrNotification objectAtIndex:indx];
        [[UIApplication sharedApplication] cancelLocalNotification:item];
    }
}

- (BOOL)cancelLocalNotificationWithEvent:(DEventData *)event
{
	if (event ==nil) {
		return NO;
	}
	return [self cancelLocalNotificationWithEventGid:event.gid];
}

- (BOOL)cancelLocalNotificationWithEventGid:(NSString *)gid
{
	if (gid.length <= 0) {
		return NO;
	}
	
    BOOL isSuccess=NO;
    NSArray *arrNotification = [[UIApplication sharedApplication] scheduledLocalNotifications];//获取所有本地通知
    int count = [arrNotification count];//获取所有通知数
    for(int indx=0;indx<count;indx++)
    {
        UILocalNotification *item = [arrNotification objectAtIndex:indx];
        NSString *gid=[item.userInfo objectForKey:@"gid"];
        if([gid isEqualToString:gid])//如果找到相同的活动，则取消
        {
            [[UIApplication sharedApplication] cancelLocalNotification:item];
            isSuccess=YES;
            break;
        }
    }
    return isSuccess;
}

@end
