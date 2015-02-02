//
//  CAppDelegate.m
//  DCalendar
//
//  Created by GaoAng on 14-5-5.
//  Copyright (c) 2014年 richinfo.cn. All rights reserved.
//

#import "CAppDelegate.h"
//#import "MainViewController.h"
//#import "MainTabBarController.h"
#import "UMFeedback.h"
#import "RFStatusBar.h"
#import "MainViewController.h"
//友盟统计渠道
#define CHANNEL @"AppStore"
//#define CHANNEL @"hiapk" //91
//#define CHANNEL @"tongbu" //同步推
//#define CHANNEL @"kuaiyong" //快用

@implementation CAppDelegate
__weak MainViewController           *mMainViewVC;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge categories:nil];
    //    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];

    /*//为友盟sdk获取测试设备信息
    Class cls = NSClassFromString(@"UMANUtil");
    SEL deviceIDSelector = @selector(openUDIDString);
    NSString *deviceID = nil;
    if(cls && [cls respondsToSelector:deviceIDSelector]){
        deviceID = [cls performSelector:deviceIDSelector];
    }
    NSLog(@"{\"oid\": \"%@\"}", deviceID);*/
    [MobClick startWithAppkey:@"545c6330fd98c58f45002078" reportPolicy:BATCH channelId:CHANNEL];//友盟
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
    
	// Register for push notifications
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    //保存 device token 令牌
    NSString *token = [userDefaults objectForKey:DDeviceToken];
    if (token.length <= 0)    {
        
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
            UIUserNotificationType type = UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert;
            UIUserNotificationSettings *notificationSetting = [UIUserNotificationSettings settingsForTypes:type categories:nil];
            [application registerForRemoteNotifications];
            [application registerUserNotificationSettings:notificationSetting];
        }
        else {
            UIRemoteNotificationType notificationTypes = UIRemoteNotificationTypeBadge |
            UIRemoteNotificationTypeSound |
            UIRemoteNotificationTypeAlert;
            [application registerForRemoteNotificationTypes:notificationTypes];
        }
    }

	[UMFeedback setLogEnabled:YES];
	[UMFeedback checkWithAppkey:UMENG_APPKEY];
        
	//	设置的时间到了以后，会自动在桌面弹出一个提示框，点显示后，就可以启动软件。对lanchOptions进行处理，找到它里面的信息,就可以拿到设置时的需要处理的东西，就可以继续操作了
	UILocalNotification *localNotif = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
	if (localNotif)
	{
		NSLog(@"Recieved Notification %@",localNotif);
		NSDictionary* infoDic = localNotif.userInfo;
		NSLog(@"userInfo description=%@",[infoDic description]);
	}
	
	//
	if ([Utility isSystemVersionSeven]) {
		[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
	}
	
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
//	MainViewController *viewCtrl = [[MainViewController alloc]init];
//    AKTabBarController *tabBarController = [[AKTabBarController alloc] initWithTabBarHeight:KBOTTOMHIGHT];
//    mTabBarController = tabBarController;
    
    MainViewController *mainViewVC = [[MainViewController alloc] init];
    self.mainViewController = mMainViewVC = mainViewVC;
	self.navCtrl = [[MLNavigationController alloc] initWithRootViewController:mainViewVC];
	self.window.rootViewController = self.navCtrl;
    [self.window makeKeyAndVisible];
	if ([Utility isSystemVersionSeven]) {
        [[UINavigationBar appearance] setBarTintColor:MainTitleBgColor];
	}
    
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    // Or for those who prefer dot syntax: [UIApplication sharedApplication].idleTimerDisabled = YES;
    
    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
	//将device token转换为字符串
    NSString *deviceTokenStr = [NSString stringWithFormat:@"%@",deviceToken];
    deviceTokenStr = [[deviceTokenStr substringWithRange:NSMakeRange(0, 72)] substringWithRange:NSMakeRange(1, 71)];
    //将deviceToken保存在NSUserDefaults
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    //保存 device token 令牌
    [userDefaults setObject:deviceTokenStr forKey:DDeviceToken];
	NSLog(@"设备注册到APNs服务器成功，%@", deviceToken);
}

-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
	NSLog(@"设备注册到APNs服务器失败，%@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [self application:application didReceiveRemoteNotification:userInfo fetchCompletionHandler:nil];
}

//本地闹钟提醒。
- (void)application:(UIApplication *)app didReceiveLocalNotification:(UILocalNotification *)notif{
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))handler{

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0),^{
    });
}

- (void)applicationWillResignActive:(UIApplication *)application
{
	// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
	// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
	// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
	// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
	// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
}


@end
