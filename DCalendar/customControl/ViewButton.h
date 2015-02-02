//
//  DDetailEventViewController.h
//  DCalendar
//
//  Created by GaoAng on 14-5-26.
//  Copyright (c) 2014年 richinfo.cn. All rights reserved.
//

@interface ViewButton :UIView

@property (nonatomic, weak) UILabel *mUpTitle;
@property (nonatomic, weak) UILabel *mDownTitle;

- (id)initWithFrame:(CGRect)frame buttonPress:(void (^)(UIButton *sender))block;

- (void)setUpTitleStyleToNormal;
- (void)setUpTitleStyleToAA;
- (void)setUpTitleStyleToFree;

@end
