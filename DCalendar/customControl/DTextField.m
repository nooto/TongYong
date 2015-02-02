//
//  DTextField.m
//  DCalendar
//
//  Created by GaoAng on 14-5-10.
//  Copyright (c) 2014年 richinfo.cn. All rights reserved.
//

#import "DTextField.h"
#define ZERO_WIDTH_SPACE_STRING @"\u200B"

@implementation DTextField
@synthesize textField, keylabel;
@synthesize DDelegate;
@synthesize eInputType;
@synthesize maxInputLength;

- (id)initWithFrame:(CGRect)frame label:(NSString*)key placeholder:(NSString*)placeholder wihtInputType:(EINPUTTYPE)inputtype delegate:(id)delegate
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
		DDelegate = delegate;
//		//背景
//		UIImageView *bgImage = [[UIImageView alloc] initWithFrame:self.bounds];
//		[self addSubview:bgImage];
//		
//		self.layer.borderWidth = 0.5;
//		self.layer.borderColor = [Utility colorFromColorString:@"#ccd1d9"].CGColor;
//		
		maxInputLength = 32;
		//
		CGFloat posx = 5;
		if (key.length > 0) {
			keylabel = [[UILabel alloc] initWithFrame:CGRectMake(posx, 5, 60, frame.size.height - 10)];
			[keylabel setTextColor:[Utility colorFromColorString:@"#434a54"]];
			[keylabel setTextAlignment:NSTextAlignmentCenter];
			[keylabel setBackgroundColor:[UIColor clearColor]];
			[keylabel setFont:[UIFont systemFontOfSize:16]];
			[keylabel setText:key];
			[self addSubview:keylabel];
			posx= posx+ keylabel.frame.size.width + 2;
			
			UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(posx, 5, 0.5, frame.size.height- 10)];
			[lineLabel setBackgroundColor:[Utility colorFromColorString:@"#ccd1d9"]];
			[self addSubview:lineLabel];
			posx = posx + 1+ 5;
		}
		
		//
		textField = [[UITextField alloc] initWithFrame:CGRectMake(posx, 5, frame.size.width - posx -10, frame.size.height - 10)];
		
		[textField setBorderStyle:UITextBorderStyleNone];
		[textField setTextColor:[Utility colorFromColorString:@"#434a54"]];
		[textField setBackgroundColor:[UIColor clearColor]];
		textField.delegate = self;
		textField.clearButtonMode = UITextFieldViewModeWhileEditing;
		[textField setFont:[UIFont systemFontOfSize:16]];
		[textField setPlaceholder:placeholder];
		[self addSubview:textField];
		
		if (inputtype == INPUT_MOBILENUMBER) {
			textField.keyboardType = UIKeyboardTypeNumberPad;
		}
		else if (inputtype == INPUT_EMAIL){
			textField.keyboardType = UIKeyboardTypeEmailAddress;
		}
        else if (inputtype == INPUT_PASSWORD){
            textField.keyboardType = UIKeyboardTypeEmailAddress;
        }
		eInputType = inputtype;

		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(handleTextDidChange:)
													 name:UITextFieldTextDidChangeNotification
												   object:textField];

		
		[self setBackgroundColor:[UIColor whiteColor]];
    }
	
    return self;
}

-(void)setTag:(NSInteger)tag{
	self.tag = tag;
	textField.tag = tag;
}
-(void)dealloc{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)handleTextDidChange:(NSNotification *)obj{
	UITextField *tempTextField = (UITextField *)obj.object;
	
	NSString *toBeString = tempTextField.text;
	NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage]; // 键盘输入模式
	if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
		UITextRange *selectedRange = [tempTextField markedTextRange];
		//获取高亮部分
		UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
		// 没有高亮选择的字，则对已输入的文字进行字数统计和限制
		if (!position) {
			if (toBeString.length > maxInputLength) {
				tempTextField.text = [toBeString substringToIndex:maxInputLength];
			}
		}
		// 有高亮选择的字符串，则暂不对文字进行统计和限制
		else{
			
		}
	}
	// 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
	else{
		if (toBeString.length > maxInputLength) {
			tempTextField.text = [toBeString substringToIndex:maxInputLength];
		}
	}
	
	if (DDelegate && [DDelegate respondsToSelector:@selector(DTextDidChange::)]) {
		[DDelegate DTextDidChange:self :self.textField.text];
	}

}

-(void)closeDTextFiledKeyBoard{
	[self.textField resignFirstResponder];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
	if (DDelegate && [DDelegate respondsToSelector:@selector(DTextFieldDidBeginEditing:)]) {
		[DDelegate DTextFieldDidBeginEditing:self];
	}
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
	if (eInputType == INPUT_ALL) {
		if (range.location > maxInputLength - 1) {
			return NO;
		}
		return YES;
	}
	else if (eInputType == INPUT_MOBILENUMBER){
		if (range.location> 10)
		{
			return  NO;
		}
		else
		{
			if ([string isEqual:@""]||
				[string isEqual:@"0"]||
				[string isEqual:@"1"]||
				[string isEqual:@"2"]||
				[string isEqual:@"3"]||
				[string isEqual:@"4"]||
				[string isEqual:@"5"]||
				[string isEqual:@"6"]||
				[string isEqual:@"7"]||
				[string isEqual:@"8"]||
				[string isEqual:@"9"]
				) {
				return YES;
			}
			else{
				return NO;
			}
		}
	}
    else if (eInputType == INPUT_PASSWORD){
        return ![Utility containChineseCharacter:string];
    }
	return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
	if (DDelegate && [DDelegate respondsToSelector:@selector(DTextFieldDidEndEditing:)]) {
		[DDelegate DTextFieldDidEndEditing:self];
	}
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
	if (DDelegate && [DDelegate respondsToSelector:@selector(DTextFieldShouldReturn:)]) {
		return  [DDelegate DTextFieldShouldReturn:self];
	}
	return YES;
}

@end
