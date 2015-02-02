//
//  ViewController.h
//  MultiLayerNavigation
//
//  Created by Feather Chan on 13-4-12.
//  Copyright (c) 2013年 Feather Chan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseView/BaseViewController.h"
#import "MLNavigationController.h"
#import "../AccountManager/DAccountManager.h"
#import "../customControl/ButtonSelectControl.h"
typedef enum{
	MV_Btn_time_Tag = 0,
	MV_Btn_today_Tag ,
	MV_Btn_More_tag ,
	MV_Btn_setting_tag ,
	MV_Btn_QRCode_tag ,
	MV_Btn_msgbox_tag ,
	MV_Btn_create_tag ,
    MV_Btn_unreadmsg_tag
}EMainViewBtn_tag;

@interface MainViewController : BaseViewController

@end
