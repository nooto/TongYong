//
//  BaseViewController.m
//  DCalendar
//
//  Created by GaoAng on 14-5-6.
//  Copyright (c) 2014年 richinfo.cn. All rights reserved.
//

#import "BaseViewController.h"
#import "MLNavigationController.h"
#import "CAppDelegate.h"
#import "CHttp.h"

@interface BaseViewController (){
	MBProgressHUD *HUD;
    BOOL isFromExtern;  //是不是从外部拉起数据。 web端口 进入。 或者通知栏木进入。
}

@end

@implementation BaseViewController

@synthesize showNetWorkingAnimated;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
		[self setPanDragType:EDrag_right];
        _bAnimating = NO;
    }
    return self;
}
//
//-(void)dealloc{
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self.view setBackgroundColor:MainViewBgColor];

	showNetWorkingAnimated = YES;
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [HUD hide:YES];
    HUD.labelText = @"正在处理...";
    [self.view addSubview:HUD];

	if ([Utility isSystemVersionSeven]) {
		[[UINavigationBar appearance] setBarTintColor:MainTitleBgColor];
		//背景栏
		UILabel *bgLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 44)];
		[bgLabel setBackgroundColor:MainTitleBgColor];
		[self.view addSubview:bgLabel];
	}
    
    [self setLeftBtnWithNoImageName:@"detail_back" selectImageName:@"detail_back"];
    
    UIButton  *returnBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 44)];
    [returnBtn setBackgroundColor:[UIColor clearColor]];
    [returnBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 10, 0, -10)];
    [returnBtn  setBackgroundImage:[UIImage imageNamed:@"save_nor"] forState:UIControlStateNormal];
    [returnBtn  setBackgroundImage:[UIImage imageNamed:@"save_sel"] forState:UIControlStateHighlighted];
    [returnBtn addTarget:self action:@selector(SaveButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:returnBtn];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
    [self.view setBackgroundColor:[Utility colorFromColorString:@"#f0efed"]];
	[self.navigationController.navigationBar setHidden:NO];
	[self addGestureRecognizerToView];
    [MobClick beginLogPageView:NSStringFromClass([self class])];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    _bAnimating = NO;
    [self removeGestureRecognizerFromView];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    _bAnimating = NO;
    
    [MobClick endLogPageView:NSStringFromClass([self class])];
}

-(void)addGestureRecognizerToView{
	MLNavigationController* nv = (MLNavigationController*)self.navigationController;
	[nv addGestureRecognizer];
}

-(void)removeGestureRecognizerFromView{
//	MLNavigationController *nv = (MLNavigationController*)self.navigationController;
//	[nv releaseGestureRecognizer];
}


#pragma mark -FSDF
-(void)setCustomerLeftButton{
    [self setLeftBtnWithNoImageName:@"ic_del_nor" selectImageName:@"ic_del_sel"];
}

-(void)setLeftBtnWithNoImageName:(NSString *)normal selectImageName:(NSString *)select{
    UIButton  *returnBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 44)];
    [returnBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 10)];
	[returnBtn setBackgroundColor:[UIColor clearColor]];
	[returnBtn setImage:[UIImage imageNamed:normal] forState:UIControlStateNormal];
	[returnBtn setImage:[UIImage imageNamed:select] forState:UIControlStateHighlighted];
	[returnBtn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:returnBtn];
//    returnBtn.imageEdgeInsets = UIEdgeInsetsMake(9, 11, 8, 11);
}

#pragma mark -
-(void)setPanDragType:(EDragType)dragType{
	if (dragType >= EDrag_No && dragType <= EDrag_All) {
		MLNavigationController* nav = (MLNavigationController*)self.navigationController;
		[nav setDragType:dragType];
	}
}
- (void )pushToViewControllerCustom:(UIViewController *)viewController animated:(BOOL)animated{
	if (viewController) {
        CAppDelegate *app = (CAppDelegate *)[[UIApplication sharedApplication] delegate];
        [app.navCtrl pushViewController:viewController animated:animated];
	}
}
-(void)popViewControllerAnimatedYes{
	[self.navigationController popViewControllerAnimated:YES];
}
-(void)popViewControllerAnimatedNo{
	[self.navigationController popViewControllerAnimated:NO];
}

#pragma mark -
-(void)setTitle:(NSString *)title{
	[self setTitle:title font:[UIFont systemFontOfSize:20.0f]];
}

-(void)setTitle:(NSString *)title font:(UIFont*)font{
	[self setTitle:title font:font color:[UIColor whiteColor]];
}

-(void)setTitle:(NSString *)title font:(UIFont*)font color:(UIColor*)color{
	if (font == nil) {
		font = [UIFont systemFontOfSize:20];
	}
	if (color == nil) {
		color = [UIColor whiteColor];
	}
	
	UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width/4, 44)];
    titleLabel.font = font;
    titleLabel.textColor = color;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = title;
    self.navigationItem.titleView = titleLabel;
}

-(void)backAction:(UIButton*)sender{
    [self popViewControllerAnimatedYes];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)SaveButtonAction:(UIButton*)sender{
    [self popViewControllerAnimatedYes];
}



-(void)setAnimateText:(NSString*)text{
	if (HUD) {
        HUD.labelText=text;
        HUD.alpha = 0.5f;
	}
}


-(void)hideAnimateHUD{
    dispatch_async(dispatch_get_main_queue(), ^{
        HUD.numOfCount = 0;
        [HUD hide:YES];
        
//        UIWindow* keyWindow = [UIApplication sharedApplication].keyWindow;
//        UIView *view = keyWindow.rootViewController.view;
//        [MBProgressHUD hideAllHUDsForView:view animated:YES];
    });
}

-(void)adjustAnimate{
    if (HUD) {
        if (HUD.numOfCount > 0) {
            HUD.numOfCount --;
        }
        if (HUD.numOfCount <= 0) {
            [self hideAnimateHUD];
        }
    }
}
/*
-(BOOL)isCeaterForEventData:(DEventData *)eventData{
	

	//判断是否活动的创建者的帐号和当前帐号进行匹配判断。
	BOOL isEventCreater = NO;
    
//    if (eventData.checkStatus == 1) {
//        isEventCreater = YES;
//        return YES;
//    }
//    else{
//        return NO;
//    }
	// source 字段不准确。当进行通过eventsign 搜索时候返回的 source 不准确。
	if (eventData && eventData.inviterInfo) {
        for (DInviterInfo *invite in eventData.inviterInfo) {
			if (invite.inviteStatus == 1 && invite.userId == [DAccountManagerInstance curAccountInfoUserID]) {
				isEventCreater = YES;
				break;
			}
		}
	}
	return isEventCreater;
}*/
#pragma mark - 
//- (void)requestWithBaseReq:(DBaseRequest *)baseReq {
//	
//	if (showNetWorkingAnimated && HUD.isHidden) {
//		[HUD show:YES];
//		[self.view bringSubviewToFront:HUD];
//	}
//
//	[[DRequestOperatorManager connection] startRequest:baseReq delegate:self];
//}

- (void)requestWithBaseReq:(DBaseRequest *)baseReq callback:(void (^)(DBaseResponsed *receData))callback{
    [self requestWithBaseReq:baseReq showAnimat:YES callback:callback];
}

-(void)requestWithBaseReq:(DBaseRequest *)baseReq showAnimat:(BOOL)show callback:(void (^)(DBaseResponsed *receData))callback{

//    __weak BaseViewController *tempSelf = self;
//    [[CHttp shareNetInstance] startRequest:baseReq callback:^(DBaseResponsed *receData) {
//        [tempSelf adjustAnimate];
//        if (callback) {
//            
//            //sid 过期。通知重新登录。
//            if (receData.code == 16) {
////                dispatch_async(dispatch_get_main_queue(), ^(){
////                    [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFY_SID_Vaild object:nil];
////                });
//                if (nil == _mLoginView) {
//                    DLoginViewController *vc = [[DLoginViewController alloc] init];
//                    _mLoginView = vc;
//                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.4 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
//                        
//                        CAppDelegate *app = (CAppDelegate *)[[UIApplication sharedApplication] delegate];
//                        [app.navCtrl pushViewControllerMust:vc animated:YES];
//                        //                    [self pushToViewControllerCustom:vc animated:YES];
//                    });
//                }                
//                [DAccountManagerInstance SetCurAccountlogin:NO];
//                
//                /*
//                //自动登录
//                NSInteger userid = [DAccountManagerInstance curAccountInfoUserID];
//                NSString *pwd = [DAccountManagerInstance curAccountInfoPassword];
//              
//                NSString *token = [Utility GetDeviceToken];
//                DRequestLogin *req = [[DRequestLogin alloc] init];
//                [req setDeviceToken:token];
//                [req setModel:[NSString stringWithFormat:@"%@ %@",[UIDevice currentDevice].model, [UIDevice currentDevice].systemVersion]];
////                req.userId = userid;
//                NSString* deskey = [DESKEY stringByAppendingString:token];
//                [req setPwd:[Utility EncryptTripleDES:pwd key:deskey]];
//                
//                [self requestWithBaseReq:req callback:^(DBaseResponsed *callback){
////                    [_self loginWithRes:(DResponsedLogin *)callback];
//                }];*/
//            }
//            else{
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    if (receData.code == KErrorCode_NONETWORK){
//                        [Utility showMessage:@"网络不可用,请稍后再试"];
//                    }
//                    else if (receData.code == KErrorCode_TimeOut){
//                        [Utility showMessage:@"请求超时，请稍后再试"];
//                    }
//                });
//                
//                callback(receData);
//            }
//        }
//    }];
//    
//    if (showNetWorkingAnimated && HUD.isHidden && show) {
//        HUD.numOfCount ++;
//        __weak typeof(BaseViewController*)_self=self;
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [HUD show:YES];
//            [_self.view bringSubviewToFront:HUD];
//        });
//    }
}
/*
 - (void)uploadImageWithBaseReq:(DBaseRequest *)baseReq{
 //	[[DRequestOperatorManager connection] startRequest:baseReq delegate:self];
    [[DRequestOperatorManager connection] startRequest:baseReq callback:nil];
}
*/
/*
-(void)cancelRequest{
    [[DRequestOperatorManager connection] cancelConnectionWithDelegate:self];
}*/

-(void)URLDataReceiverDidFinish:(DBaseResponsed *)receiverData{
    //增量刷新 由子vc 控制 联网标志显示。
    
	//code == 3 :待同步活动数量为0
	if (receiverData ==nil) {
		return;
	}
	
	//错误提示吗可以在这统一管理。
	if (receiverData.code!= 0) {
	}
	
	if (receiverData && (receiverData.code != 0  && receiverData.code != 3)) {
//		[Utility showMessage:receiverData.summary];
        return;
	}
	else if (receiverData && receiverData.errorCode == KErrorCode_TimeOut){
		[Utility showMessage:@"网络超时，请检查网络连接"];
        return;
	}  //网络不可用。
    else if (receiverData.errorCode == KErrorCode_NONETWORK) {
		[Utility showMessage:@"网络超时，请检查网络连接"];
        return;
    }
}
-(void)bringHUDToFront{
    [HUD show:YES];
    [self.view bringSubviewToFront:HUD];
}

@end
