//
//  CXTextView.m
//  DCalendar
//
//  Created by hunanldc on 14-7-7.
//  Copyright (c) 2014年 richinfo.cn. All rights reserved.
//

#import "CXTextView.h"

@interface CXTextView ()

@property (nonatomic, assign)BOOL isEdit;

@end

@implementation CXTextView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setPlaceHolder:(NSString *)placeHolder
{
    _placeHolder = placeHolder;
    [self setNeedsDisplay];
}

- (void)setPlaceHolderColor:(UIColor *)placeHolderColor
{
    _placeHolderColor = placeHolderColor;
    [self setNeedsDisplay];
}

- (BOOL)becomeFirstResponder
{
    BOOL fist = [super becomeFirstResponder];
    if (fist) {
        self.isEdit = YES;
        [self setNeedsDisplay];
    }
    return fist;
}

- (BOOL)resignFirstResponder
{
    BOOL resign = [super resignFirstResponder];
    if (resign) {
        self.isEdit = NO;
        [self setNeedsDisplay];
    }
    return resign;
}

- (void)drawRect:(CGRect)rect
{
    if (_placeHolder && [self.text length] == 0 && !self.isEdit) {
        if (!_placeHolderColor) {
            [_placeHolderColor set];
        }else {
            [[UIColor grayColor] set];
        }
        UIFont *font = self.font;
        if (!font) font = [UIFont systemFontOfSize:14.f];
        [_placeHolder drawAtPoint:CGPointMake(5, 10) forWidth:rect.size.width withFont:font lineBreakMode:NSLineBreakByTruncatingTail];
    }
    [self.textColor set];
    [super drawRect:rect];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
