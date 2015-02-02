//
//  DBlockAlertView.m
//  DCalendar
//
//  Created by hunanldc on 14-10-23.
//  Copyright (c) 2014年 richinfo.cn. All rights reserved.
//

#import "DBlockAlertView.h"


@interface DBlockAlertView ()

@property (strong , nonatomic)DBlockAlertViewComplete complete;

@end

@implementation DBlockAlertView


- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message complete:(DBlockAlertViewComplete)complete cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...
{
    self = [super initWithTitle:title message:message delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles, nil];
    if (self) {
        self.complete = complete;
        self.delegate = self;
    }
    return self;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (self.complete) {
        self.complete((id)alertView,buttonIndex);
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
