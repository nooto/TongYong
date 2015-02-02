//
//  DTextView.h
//  DCalendar
//
//  Created by GaoAng on 14-5-20.
//  Copyright (c) 2014年 richinfo.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CXTextView.h"

@interface DTextView : UIView<UITextViewDelegate>
{
    UIColor *defaultTextColor;
}

@property (strong, nonatomic) CXTextView *textView;
@property (assign, nonatomic) NSInteger maxInputLength;
@property (strong, nonatomic) NSString *placeHolder;

@property (strong, nonatomic) UIColor *placeHolderColor;

@property (weak, nonatomic) id<UITextViewDelegate> aDelegate;

-(void)setText:(NSString*)text;

@end
