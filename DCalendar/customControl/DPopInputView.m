//
//  DPopInputView.m
//  DCalendar
//
//  Created by GaoAng on 14/10/24.
//  Copyright (c) 2014年 richinfo.cn. All rights reserved.
//

#import "DPopInputView.h"

@interface DPopInputView ()
@property(nonatomic, copy)  void(^complete)(NSString*);
@property (nonatomic, strong) UITextView *textView;
@end
@implementation DPopInputView
@synthesize textView;

- (id)initWithTitle:(NSString *)title  complete:(void(^)(NSString *text))success
{
    self = [super init];
    if (self) {
        
        //初始化背景视图，添加手势
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedCancel)];
        [self addGestureRecognizer:tapGesture];

        if (success) {
            self.complete = success;
        }
        
        [self setupView:title];
        
    }
    return self;
}

- (void)showInView:(UIView *)view
{
    [[UIApplication sharedApplication].delegate.window.rootViewController.view addSubview:self];
}

-(void)setupView:(NSString*)title{
    UIView *bigBkView = [[UIView alloc] initWithFrame:self.bounds];
    [bigBkView setBackgroundColor:[UIColor grayColor]];
    bigBkView.alpha = 0.5f;
    [self addSubview:bigBkView];

    
    UIView *bkview = [[UIView alloc] initWithFrame:CGRectMake(10, 60, 300, 240)];
    if (ScreenHeight >  500) {
        [bkview setFrame:CGRectMake(10, 100, 300, 200)];
    }
    else{
        [bkview setFrame:CGRectMake(10, 60, 300, 200)];
    }
    [self addSubview:bkview];
    bkview.backgroundColor = [UIColor whiteColor];
    bkview.layer.cornerRadius = 4;
    bkview.layer.masksToBounds = YES;

    //
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(130, 30, 60, 60)];
    [self addSubview:imageView];
    imageView.image = [UIImage imageNamed:@"fee_edit.png"];
    [imageView setFrame:CGRectMake(ScreenWidth/2 - 30, CGRectGetMinY(bkview.frame) - 30, CGRectGetWidth(imageView.frame), CGRectGetHeight(imageView.frame))];

    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(24, 35, bkview.frame.size.width-48, 20)];
    [bkview addSubview:label];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setText:title];
    label.font = [UIFont systemFontOfSize:15];
    
    textView = [[UITextView alloc] initWithFrame:CGRectMake(CGRectGetMinX(label.frame), CGRectGetMaxY(label.frame), CGRectGetWidth(label.frame), 80)];
    [textView setBackgroundColor:[UIColor clearColor]];
    textView.layer.borderColor = [Utility cellDevideLineColor].CGColor;
    textView.layer.borderWidth = 0.5f;
    textView.layer.cornerRadius = 4.0f;
    [bkview addSubview:textView];
    
    UIButton *cancel = [UIButton buttonWithType:UIButtonTypeCustom];
    [bkview addSubview:cancel];
    cancel.frame = CGRectMake(9, 145, 136, 47);
    cancel.backgroundColor = [Utility colorFromColorString:@"#CECECE"];
    [cancel setTitle:@"取消" forState:UIControlStateNormal];
    [cancel addTarget:self action:@selector(cancelBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    cancel.layer.cornerRadius = 4;
    cancel.layer.masksToBounds = YES;
    
    UIButton *ok = [UIButton buttonWithType:UIButtonTypeCustom];
    [bkview addSubview:ok];
    ok.frame = CGRectMake(155, 145, 136, 47);
    ok.backgroundColor = [UIColor colorWithRed:22/255.0f green:203/255.0f blue:150/255.0f alpha:1.0f];
    [ok setTitle:@"确认" forState:UIControlStateNormal];
    [ok addTarget:self action:@selector(okBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    ok.layer.cornerRadius = 4;
    ok.layer.masksToBounds = YES;
}

- (void)tappedCancel{
    [self didmiss];
}

- (void)cancelBtnPressed:(UIButton*)sender{
    [self didmiss];
}

- (void)okBtnPressed:(UIButton*)sender{
    if (self.complete) {
        self.complete(textView.text);
    }
    [self didmiss];
}

-(void)didmiss{
    //    [UIView animateWithDuration:2 animations:^{
    //        [self setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, 0)];
    //        self.alpha = 0;
    //    } completion:^(BOOL finished) {
    //        if (finished) {
    [self removeFromSuperview];
    //        }
    //    }];

}
@end