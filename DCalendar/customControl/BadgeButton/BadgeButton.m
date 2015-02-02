
/*
 CTAssetsPickerController.m
 
 The MIT License (MIT)
 
 Copyright (c) 2013 Clement CN Tsang
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 
 */


#import "BadgeButton.h"
#import "CustomBadge.h"

@interface BadgeButton (){
//    __weak UIButton *btn_left;
//    __weak UIButton *btn_rigth;

    CustomBadge *customBadge;
}


@end


@implementation BadgeButton

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        
        self.titleLabel.font = [UIFont systemFontOfSize: 14.0];
        float value = 180.0/255;
        [self setTitleColor:[UIColor colorWithRed:value green:value blue:value alpha:1.0] forState:UIControlStateDisabled];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [self setBackgroundImage:[UIImage imageNamed:@"album_preview_pressed.png"] forState:UIControlStateNormal];
        [self setBackgroundImage:[UIImage imageNamed:@"album_ok_pressed.png"] forState:UIControlStateHighlighted];
        [self setBackgroundImage:[UIImage imageNamed:@"album_preview_disabled.png"] forState:UIControlStateDisabled];
        
       UIColor *color = [UIColor colorWithRed:51.0/255 green:136.0/255 blue:234.0/255 alpha:1.0];
       customBadge = [CustomBadge customBadgeWithString:nil
                                                       withStringColor:[UIColor whiteColor]
                                                        withInsetColor:color//[UIColor redColor]
                                                        withBadgeFrame:NO
                                                   withBadgeFrameColor:nil//[UIColor whiteColor]
                                                             withScale:1.0
                                                           withShining:NO];
        [self addSubview:customBadge];
    }

    return self;
}

- (void)setBadge:(NSUInteger)number{
    if (0 == number) {
        [customBadge autoBadgeSizeWithString:nil];
    }
    else{
        [customBadge autoBadgeSizeWithString:[NSString stringWithFormat:@"%lu",(unsigned long)number]];
    }
}

- (void)setBadgeStr:(NSString *)str{
    [customBadge autoBadgeSizeWithString:str];
}

- (void)dealloc{
    customBadge = nil;
}

@end
