//
//  ButtonSelectControl.h
//  KDSPad
//
//  Created by zhong xl on 11-9-22.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * Button 选择按钮
 */

@protocol ButtonSelectControlDelegate
@optional
- (void)clickButtonAt:(UIButton*)button index:(NSInteger)index;
- (void)buttonSelectNoChoose;
@end

@interface ButtonSelectControl : UIView {
    NSMutableArray *buttonArray_;
    //Button 排列的方向
    BOOL vertical_; 
    
    CGFloat x_;
    CGFloat y_;
}

@property (nonatomic, assign) float fSelFontSize;
@property (nonatomic, assign) float normalFontSize;
@property (nonatomic, assign) id<ButtonSelectControlDelegate> delegate;
@property (nonatomic, retain) UIColor *selectColor;
@property (nonatomic, retain) UIColor *normalColor;
@property (nonatomic, assign) BOOL shade;

- (id)initWithFrame:(CGRect)frame direction:(BOOL)vertical;
- (void)addButton:(UIButton *)button; 
- (void)selectAtIndex:(NSInteger)index;
- (void)layoutVer:(BOOL)her rect:(CGRect)rect;
-(void)removeAllObjects;
- (UIButton *)buttonWithIndex:(NSInteger)index;
- (void)noChoose;
@end
