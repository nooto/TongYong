//
//  DDetailEventViewController.m
//  DCalendar
//
//  Created by GaoAng on 14-5-26.
//  Copyright (c) 2014年 richinfo.cn. All rights reserved.
//

#import "ViewButton.h"

@interface ViewButton ()

@property (nonatomic, strong) void (^mButtonPressed)(UIButton *sender);

@end

@implementation ViewButton

- (id)initWithFrame:(CGRect)frame buttonPress:(void (^)(UIButton *sender))block
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _mButtonPressed = block;
        
        UILabel *uptitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 5.5, frame.size.width, 16)];
        [self addSubview:uptitle];
        _mUpTitle = uptitle;
        uptitle.font = [UIFont systemFontOfSize:14.0f];
        uptitle.textColor = [Utility colorFromColorString:@"#333333"];
        uptitle.textAlignment = NSTextAlignmentCenter;
        uptitle.layer.cornerRadius = 2;
        uptitle.clipsToBounds = YES;
         
        UILabel *downTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 24, uptitle.frame.size.width, uptitle.frame.size.height)];
        [self addSubview:downTitle];
        _mDownTitle = downTitle;
        downTitle.font = [UIFont systemFontOfSize:12.0f];;
        downTitle.textColor = [Utility colorFromColorString:@"#7e7e7e"];
        downTitle.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}

- (void)setUpTitleStyleToNormal{
    _mUpTitle.font = [UIFont systemFontOfSize:14.0f];
    _mUpTitle.textColor = [Utility colorFromColorString:@"#333333"];
    _mUpTitle.backgroundColor = [UIColor clearColor];
    
    CGSize size = [Utility sizeOfString:_mUpTitle.text font:_mUpTitle.font maxWidth:self.frame.size.width];
    float x = (self.frame.size.width-size.width)/2;
    _mUpTitle.frame = CGRectMake(x, _mUpTitle.frame.origin.y, size.width, _mUpTitle.frame.size.height);
}
- (void)setUpTitleStyleToAA{
    _mUpTitle.text = @"AA";
    _mUpTitle.font = [UIFont systemFontOfSize:13.0f];
    _mUpTitle.textColor = [UIColor whiteColor];
    _mUpTitle.backgroundColor = [Utility colorFromColorString:@"#56cc56"];
    
    float x = (self.frame.size.width-26)/2;
    _mUpTitle.frame = CGRectMake(x, _mUpTitle.frame.origin.y, 26, _mUpTitle.frame.size.height);
}
- (void)setUpTitleStyleToFree{
    _mUpTitle.text = @"免费";
    _mUpTitle.font = [UIFont systemFontOfSize:10.0f];
    _mUpTitle.textColor = [UIColor whiteColor];
    _mUpTitle.backgroundColor = [Utility colorFromColorString:@"#ffa51c"];
    
    float x = (self.frame.size.width-26)/2;
    _mUpTitle.frame = CGRectMake(x, _mUpTitle.frame.origin.y, 26, _mUpTitle.frame.size.height);
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    NSUInteger tapCount = touch.tapCount;
    switch (tapCount) {
        case 1:
            [self handleSingleTap:touch];
            break;/*
        case 2:
            [self handleDoubleTap:touch];
            break;
        case 3:
            [self handleTripleTap:touch];
            break;*/
        default:
            break;
    }
    [[self nextResponder] touchesEnded:touches withEvent:event];
}

- (void)handleSingleTap:(UITouch *)touch {
    if (_mButtonPressed) {
        _mButtonPressed(nil);
    }
}

@end
