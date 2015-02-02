//
//  DPopInputView.h
//  DCalendar
//
//  Created by GaoAng on 14/10/24.
//  Copyright (c) 2014年 richinfo.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DPopInputView : UIView
- (id)initWithTitle:(NSString *)title  complete:(void(^)(NSString *text))complete;
- (void)showInView:(UIView *)view;

@end
