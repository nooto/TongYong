//
//  DActionSheet.h
//  DActionSheetDemo
//
//  Created by lixiang on 14-3-10.
//  Copyright (c) 2014年 lcolco. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DActionSheetDelegate <NSObject>
- (void)didClickOnButtonIndex:(NSInteger)buttonIndex;
@optional
- (void)didClickOnDestructiveButton;
- (void)didClickOnCancelButton;
- (void)didClickHidden;
@end

@interface DActionSheet : UIView

- (id)initWithTitle:(NSString *)title delegate:(id<DActionSheetDelegate>)delegate cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSArray *)otherButtonTitlesArray;

- (id)initWithTitle:(NSString *)title selectBlock:(void (^)(NSInteger index))selectindex cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSArray *)otherButtonTitlesArray;

- (void)showInView:(UIView *)view;

@end
