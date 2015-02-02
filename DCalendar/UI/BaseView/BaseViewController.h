//
//  BaseViewController.h
//  DCalendar
//
//  Created by GaoAng on 14-5-6.
//  Copyright (c) 2014年 richinfo.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <math.h>
#import "MLNavigationController.h"
#import "DTextField.h"
#import "../../customControl/DCountButton.h"
//#import "../../NetWork/DRequestOperatorManager.h"
#import "../../AccountManager/DAccountManager.h"
#import "../../customControl/DPopoverView.h"
#import "../../customControl/MBProgressHUD.h"
#import "../../customControl/MJRefresh/MJRefresh.h"
#import "MobClick.h"

@interface BaseViewController : UIViewController//<DRequestOperatorManagerDelegate>
@property (nonatomic, assign) BOOL showNetWorkingAnimated;
@property (nonatomic, assign)BOOL bAnimating;

-(void)addGestureRecognizerToView;
-(void)removeGestureRecognizerFromView;
-(void)setPanDragType:(EDragType)dragType;

//标题设置。
-(void)setTitle:(NSString *)title;
-(void)setTitle:(NSString *)title font:(UIFont*)font;
-(void)setTitle:(NSString *)title font:(UIFont*)font color:(UIColor*)color;

//自定义左键 返回。
-(void)setCustomerLeftButton;
-(void)setLeftBtnWithNoImageName:(NSString *)normal selectImageName:(NSString *)select;

//可重载退出页面操作。
-(void)backAction:(UIButton*)sender;
//-(void)SaveButtonAction:(UIButton*)sender;

//网络请求与取消。
//-(void)requestWithBaseReq:(DBaseRequest *)baseReq;
-(void)requestWithBaseReq:(DBaseRequest *)baseReq callback:(void (^)(DBaseResponsed *receData))callback;
-(void)requestWithBaseReq:(DBaseRequest *)baseReq showAnimat:(BOOL)show callback:(void (^)(DBaseResponsed *receData))callback;

//-(void)uploadImageWithBaseReq:(DBaseRequest *)baseReq;
//-(void)cancelRequest;

//push OR pop 简单写法。
- (void)pushToViewControllerCustom:(UIViewController *)viewController animated:(BOOL)animated;
-(void)popViewControllerAnimatedYes;
-(void)popViewControllerAnimatedNo;

//联网标志显示的状态语
-(void)setAnimateText:(NSString*)text;
-(void)hideAnimateHUD;
-(void)adjustAnimate;//子页面调用。

//ui功能函数。
//-(BOOL)isCeaterForEventData:(DEventData *)eventData;
-(void)URLDataReceiverDidFinish:(DBaseResponsed *)receiverData;
-(void)bringHUDToFront;

@end
