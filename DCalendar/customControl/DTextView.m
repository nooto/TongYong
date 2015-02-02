//
//  DTextView.m
//  DCalendar
//
//  Created by GaoAng on 14-5-20.
//  Copyright (c) 2014年 richinfo.cn. All rights reserved.
//

#import "DTextView.h"

#define SHOW_DEBUG_VIEW     0

#define RGBAlphaColor(r, g, b, a) \
[UIColor colorWithRed:(r/255.0)\
green:(g/255.0)\
blue:(b/255.0)\
alpha:(a)]

#define OpaqueRGBColor(r, g, b) RGBAlphaColor((r), (g), (b), 1.0)

@interface DTextView ()
@end

@implementation DTextView
@synthesize maxInputLength;
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    [self addSubview:self.textView];
    
//    self.placeHolderColor = OpaqueRGBColor(199, 200, 201);
    self.textView.delegate = self;
    self.maxInputLength = 300;
#if SHOW_DEBUG_VIEW
    self.textView.backgroundColor = DEBUG_VIEW_ITEM_COLOR;
    self.backgroundColor = DEBUG_VIEW_CONTAINER_COLOR;
#endif
}

#pragma mark - Layout
- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    CGRect aFrame = CGRectZero;
    aFrame.origin = self.bounds.origin;
    aFrame.size = frame.size;
    self.textView.frame = aFrame;
}

#pragma mark - Accessor
- (void)setPlaceHolder:(NSString *)placeHolder
{
    if (self.textView.text.length) {
        return;
    }
    _placeHolder = placeHolder;
    self.textView.placeHolder = placeHolder;
}

- (void)setPlaceHolderColor:(UIColor *)placeHolderColor
{
    _placeHolderColor = placeHolderColor;
    self.textView.placeHolderColor = placeHolderColor;
//    self.textView.textColor = placeHolderColor;
}

- (void)setTextColor:(UIColor *)textColor
{
//    defaultTextColor = self.textView.textColor;
    self.textView.textColor = textColor;
}

- (void)setADelegate:(id)aDelegate
{
    _aDelegate = aDelegate;
}

- (CXTextView *)textView
{
    if (_textView == nil) {
        _textView = [[CXTextView alloc] init];
        _textView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _textView.textColor = [UIColor blackColor];
    }
    return _textView;
}

-(void)setText:(NSString*)text{
    [self.textView setText:text];
}
#pragma mark - UITextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if ([self.aDelegate respondsToSelector:@selector(textViewShouldBeginEditing:)]) {
        return [self.aDelegate textViewShouldBeginEditing:textView];
    }
    
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    if ([self.aDelegate respondsToSelector:@selector(textViewShouldEndEditing:)]) {
        return [self.aDelegate textViewShouldEndEditing:textView];
    }
    
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([self.aDelegate respondsToSelector:@selector(textViewDidBeginEditing:)]) {
        [self.aDelegate textViewDidBeginEditing:textView];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([self.aDelegate respondsToSelector:@selector(textViewDidEndEditing:)]) {
        [self.aDelegate textViewDidEndEditing:textView];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([self.aDelegate respondsToSelector:@selector(textView:shouldChangeTextInRange:replacementText:)]) {
        return [self.aDelegate textView:textView shouldChangeTextInRange:range replacementText:text];
    }
    
    return YES;
}
- (void)textViewDidChange:(UITextView *)textView
{
	NSString *toBeString = textView.text;
	NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage]; // 键盘输入模式
	
	if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
		UITextRange *selectedRange = [textView markedTextRange];
		//获取高亮部分
		UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
		// 没有高亮选择的字，则对已输入的文字进行字数统计和限制
		if (!position) {
			if (toBeString.length > self.maxInputLength) {
				textView.text = [toBeString substringToIndex:maxInputLength];
			}
		}
		// 有高亮选择的字符串，则暂不对文字进行统计和限制
		else{
			
		}
	}
	// 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
	else{
		if (toBeString.length > maxInputLength) {
			textView.text = [toBeString substringToIndex:maxInputLength];
		}
	}

    if ([self.aDelegate respondsToSelector:@selector(textViewDidChange:)]) {
        [self.aDelegate textViewDidChange:textView];
    }
}

- (void)textViewDidChangeSelection:(UITextView *)textView
{
    if ([self.aDelegate respondsToSelector:@selector(textViewDidChangeSelection:)]) {
        [self.aDelegate textViewDidChangeSelection:textView];
    }
}

#pragma mark - Actions
- (BOOL)resignFirstResponder
{
    return [self.textView resignFirstResponder];
}

@end