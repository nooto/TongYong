//
//  DPopoverView.h
//  DPopoverViewDemo
//
//  Created by zzl on 14-4-10.
//  Copyright (c) 2014年 zzl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DPopoverView : UIView

@property (nonatomic, assign) BOOL isShow;
+ (void)showPopoverAtPoint:(CGPoint)point inView:(UIView *)view withContentView:(UIView *)cView;
- (void)showPopoverAtPoint:(CGPoint)point inView:(UIView *)view withContentView:(UIView *)cView;
- (void)dismiss;
@end
