//
//  CircularProgressView.h
//  CircularProgressView
//
//  Created by nijino saki on 13-3-2.
//  Copyright (c) 2013年 nijino. All rights reserved.
//  QQ:20118368
//  http://nijino.cn

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

typedef enum{
    PopView_Input,
    PopView_Modify,
    PopView_Zero
}PopView_TYPE;

@protocol PopInputViewDelegate;

@interface PopInputView : UIView

@property (nonatomic,assign) NSInteger maxCount;
@property (nonatomic, weak)id<PopInputViewDelegate> delegate;

- (id) initWithFrame:(CGRect)frame withFee:(double)fee name:(NSString *)name type:(PopView_TYPE)t;

@end

@protocol PopInputViewDelegate <NSObject>

- (void)cancelBtnPressed:(NSInteger)tag charge:(double)c type:(PopView_TYPE)t;
- (void)okBtnPressed:(NSInteger)tag charge:(double)c type:(PopView_TYPE)t;

@end