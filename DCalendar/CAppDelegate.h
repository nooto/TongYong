//
//  CAppDelegate.h
//  DCalendar
//
//  Created by GaoAng on 14-5-5.
//  Copyright (c) 2014年 richinfo.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UI/BaseView/MLNavigationController.h"


@class MainViewController;

@interface CAppDelegate : UIResponder <UIApplicationDelegate>{
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) MLNavigationController *navCtrl;
@property (strong, nonatomic) MainViewController *mainViewController;

@end
