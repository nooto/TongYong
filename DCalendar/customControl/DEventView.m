//
//  DEventView.m
//  DCalendar
//
//  Created by hunanldc on 14-11-11.
//  Copyright (c) 2014年 richinfo.cn. All rights reserved.
//

#import "DEventView.h"

@implementation DEventView
@synthesize responseView = _responseView;
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    for (UIView *i in self.subviews) {
        if (CGRectContainsPoint(i.frame, point)) {
            return YES;
        }
    }
    return NO;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
+ (UIView *)hiddenKeyBoardView
{
    DEventView *view                  = [[DEventView alloc] initWithFrame:CGRectMake(0, 0, 49, 31)];
    view.backgroundColor                = [UIColor clearColor];
    UIButton *doneButton                = [UIButton buttonWithType:UIButtonTypeCustom];
    doneButton.frame = CGRectMake(0, 0, 50, 31);
    doneButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    [doneButton setImage:[UIImage imageNamed:@"TabImageDefault"] forState:UIControlStateNormal];
    [doneButton setImage:[UIImage imageNamed:@"TabImageHighlighted"] forState:UIControlStateHighlighted];
    [doneButton addTarget:self action:@selector(textViewShouldEnd) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:doneButton];
    return view;
}

+ (void)textViewShouldEnd
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

@end
