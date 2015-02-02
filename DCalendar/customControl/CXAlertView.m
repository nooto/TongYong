//
//
//  JKCustomAlert.m
//  AlertTest
//
//  Created by  on 12-5-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CXAlertView.h"

@interface CXAlertView ()

@property (nonatomic, strong) NSMutableArray *arrButtonTitles;
@property (nonatomic, copy) void (^selectBlock)(NSInteger index);

@end

@implementation CXAlertView

- (id) initWithMessage:(NSString *)message delegate:(id)delegate buttonTitles:(NSString *)firstObject, ... NS_REQUIRES_NIL_TERMINATION{
    
    CGRect frame = [UIApplication sharedApplication].delegate.window.rootViewController.view.frame;
    self = [super initWithFrame:frame];
    if (self) {
        _delegate = delegate;
        
        _arrButtonTitles = [NSMutableArray arrayWithCapacity:2];
        id eachObject;
        va_list argumentList;
        if (firstObject) // The first argument isn't part of the varargs list,
        {                                   // so we'll handle it separately.
            [_arrButtonTitles addObject: firstObject];
            va_start(argumentList, firstObject); // Start scanning for arguments after firstObject.
            while ((eachObject = va_arg(argumentList, id))) // As many times as we can get an argument of type "id"
                [_arrButtonTitles addObject: eachObject]; // that isn't nil, add it to self's contents.
            va_end(argumentList);
        }
        
        [self initSubView:message];
    }
    return self;
}

- (id) initWithMessage:(NSString *)message selectBlock:(void (^)(NSInteger index))selectindex buttonTitles:(NSString *)firstObject, ... NS_REQUIRES_NIL_TERMINATION{
    CGRect frame = [UIApplication sharedApplication].delegate.window.rootViewController.view.frame;
    self = [super initWithFrame:frame];
    if (self) {
        _selectBlock = selectindex;
        
        _arrButtonTitles = [NSMutableArray arrayWithCapacity:2];
        id eachObject;
        va_list argumentList;
        if (firstObject) // The first argument isn't part of the varargs list,
        {                                   // so we'll handle it separately.
            [_arrButtonTitles addObject: firstObject];
            va_start(argumentList, firstObject); // Start scanning for arguments after firstObject.
            while ((eachObject = va_arg(argumentList, id))) // As many times as we can get an argument of type "id"
                [_arrButtonTitles addObject: eachObject]; // that isn't nil, add it to self's contents.
            va_end(argumentList);
        }
        [self initSubView:message];
    }
    return self;
}

- (void)initSubView:(NSString *)message{
    
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    UIImage *image = [UIImage imageNamed:@"fee_alter.png"];
    CGFloat height = [[self class] heightForBubbleWithObject:message withwidth:300];
    height = height>40 ? height:40;
    
    UIView *bkview = [[UIView alloc] initWithFrame:CGRectMake(10, 205, 300, 164)];
    [self addSubview:bkview];
    bkview.backgroundColor = [UIColor whiteColor];
    bkview.layer.cornerRadius = 6;
    bkview.layer.masksToBounds = YES;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(130, 30, 60, 60)];
    [self addSubview:imageView];
    imageView.image = image;
    imageView.frame = CGRectMake(130, 175, 60, 60);
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(24, 40, bkview.frame.size.width-48, height)];
    [bkview addSubview:label];
    label.font = [UIFont systemFontOfSize:17];
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByCharWrapping;
    label.textAlignment = NSTextAlignmentCenter;
    label.text = message;
 
    UIButton *cancel = [UIButton buttonWithType:UIButtonTypeCustom];
    [bkview addSubview:cancel];
    cancel.frame = CGRectMake(9, 108, 136, 47);
    cancel.backgroundColor = [Utility colorFromColorString:@"#CECECE"];
    [cancel setTitle:[_arrButtonTitles firstObject] forState:UIControlStateNormal];
    [cancel addTarget:self action:@selector(cancelButtonPressedDown:) forControlEvents:UIControlEventTouchDown];
    [cancel addTarget:self action:@selector(cancelButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    cancel.layer.cornerRadius = 3;
    cancel.layer.masksToBounds = YES;
    cancel.tag = 0;
    
    UIButton *ok = [UIButton buttonWithType:UIButtonTypeCustom];
    [bkview addSubview:ok];
    ok.frame = CGRectMake(155, 108, 136, 47);
    //        ok.backgroundColor = [UIColor colorWithRed:22/255.0f green:203/255.0f blue:150/255.0f alpha:1.0f];
    ok.backgroundColor = [Utility colorFromColorString:@"#16CC95"];
    [ok addTarget:self action:@selector(okButtonPressedDown:) forControlEvents:UIControlEventTouchDown];
    [ok setTitle:[_arrButtonTitles lastObject] forState:UIControlStateNormal];
    [ok addTarget:self action:@selector(okButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    ok.layer.cornerRadius = 3;
    ok.layer.masksToBounds = YES;
    ok.tag = 1;
}

- (void)show{
    self.alpha = 0;
    [[UIApplication sharedApplication].delegate.window.rootViewController.view addSubview:self];
    [UIView animateWithDuration:ANIMATIONDURATION animations:^{
        self.alpha = 1;
    }completion:nil];
}

- (void)cancelButtonPressedDown:(UIButton *)btn{
    btn.backgroundColor = [Utility colorFromColorString:@"#AFAFAF"];
}

- (void)cancelButtonPressed:(UIButton *)btn{
    btn.backgroundColor = [Utility colorFromColorString:@"#CECECE"];
    if ([_delegate respondsToSelector:@selector(alertView:clickedButtonAtIndex:)]) {
        [_delegate alertView:self clickedButtonAtIndex:btn.tag];
    }
    
    if (_selectBlock) {
        _selectBlock(btn.tag);
    }
    
    [UIView animateWithDuration:ANIMATIONDURATION animations:^{
        self.alpha = 0;
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)okButtonPressedDown:(UIButton *)btn{
    btn.backgroundColor = [Utility colorFromColorString:@"#13AD80"];
}

- (void)okButtonPressed:(UIButton *)btn{
    btn.backgroundColor = [Utility colorFromColorString:@"#16CC95"];
    if ([_delegate respondsToSelector:@selector(alertView:clickedButtonAtIndex:)]) {
        [_delegate alertView:self clickedButtonAtIndex:btn.tag];
    }
    if (_selectBlock) {
        _selectBlock(btn.tag);
    }
    
    [UIView animateWithDuration:ANIMATIONDURATION animations:^{
        self.alpha = 0;
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    UIButton *cancel = [UIButton buttonWithType:UIButtonTypeCustom];
    cancel.tag = -1000;
    [self cancelButtonPressed:cancel];
    
    [UIView animateWithDuration:ANIMATIONDURATION animations:^{
        self.alpha = 0;
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

/*
- (CGSize)sizeThatFits:(CGSize)size
{

    CGSize textBlockMinSize = {TEXTLABEL_MAX_WIDTH-iconHeigh, CGFLOAT_MAX};
    CGSize retSize;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        retSize = [self.model.content boundingRectWithSize:textBlockMinSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[[self class] textLabelFont]} context:nil].size;
    }else{
        retSize = [self.model.content sizeWithFont:[[self class] textLabelFont] constrainedToSize:textBlockMinSize lineBreakMode:[[self class] textLabelLineBreakModel]];
    }

    
    CGFloat height = 40;
    if (2*BUBBLE_VIEW_PADDING + retSize.height > height) {
        height = 2*BUBBLE_VIEW_PADDING + retSize.height+10;
    }
    
    return CGSizeMake(retSize.width + BUBBLE_VIEW_PADDING*2 + BUBBLE_VIEW_PADDING+iconHeigh, height);
}*/


+ (CGFloat)heightForBubbleWithObject:(NSString *)object withwidth:(CGFloat)w
{
    CGSize textBlockMinSize = {w, CGFLOAT_MAX};
    CGSize size;
    static float systemVersion;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        systemVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    });
    
    if (systemVersion >= 7.0) {
        size = [object boundingRectWithSize:textBlockMinSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil].size;
    }else{
        size = [object sizeWithFont:[UIFont systemFontOfSize:17] constrainedToSize:textBlockMinSize lineBreakMode:NSLineBreakByCharWrapping];
    }

    return size.height+20;
}

@end
