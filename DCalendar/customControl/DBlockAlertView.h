//
//  DBlockAlertView.h
//  DCalendar
//
//  Created by hunanldc on 14-10-23.
//  Copyright (c) 2014年 richinfo.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DBlockAlertView;

typedef void(^DBlockAlertViewComplete)(DBlockAlertView *alertView, NSInteger buttonIndex);

@interface DBlockAlertView : UIAlertView

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message complete:(DBlockAlertViewComplete)complete cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... ;

@end
