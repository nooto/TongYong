//
//  CircularProgressView.m
//  CircularProgressView
//
//  Created by nijino saki on 13-3-2.
//  Copyright (c) 2013年 nijino. All rights reserved.
//  QQ:20118368
//  http://nijino.cn

#import "PopInputView.h"

@interface PopInputView ()<UITextFieldDelegate>{
    PopView_TYPE mType;
}

@property (nonatomic, weak) UITextField *mField;

@end

#define FORMATE_RECEIVE @"收到 %@ 的活动费用"
#define FORMATE_MODIFY  @"修改 %@ 的活动费用"
#define FORMATE_CANCEL  @"取消 %@ 的收款记录"

@implementation PopInputView

- (id) initWithFrame:(CGRect)frame withFee:(double)fee name:(NSString *)name type:(PopView_TYPE)t{
    self = [super initWithFrame:frame];
    if (self) {

        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
//        _rectColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
//        _font = [UIFont systemFontOfSize:17];
        
        UIView *bkview = [[UIView alloc] initWithFrame:CGRectMake(10, 60, 300, 243)];
        [self addSubview:bkview];
        bkview.backgroundColor = [UIColor whiteColor];
        bkview.layer.cornerRadius = 4;
        bkview.layer.masksToBounds = YES;
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(130, 30, 60, 60)];
        [self addSubview:imageView];
        
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(24, 40, bkview.frame.size.width-48, 40)];
        [bkview addSubview:label];
        label.font = [UIFont systemFontOfSize:17];
        
        UIButton *cancel = [UIButton buttonWithType:UIButtonTypeCustom];
        [bkview addSubview:cancel];
        cancel.frame = CGRectMake(9, 158, 136, 47);
        cancel.backgroundColor = [Utility colorFromColorString:@"#CECECE"];
        [cancel setTitle:@"取消" forState:UIControlStateNormal];
        [cancel addTarget:self action:@selector(cancelButtonPressedDown:) forControlEvents:UIControlEventTouchDown];
        [cancel addTarget:self action:@selector(cancelBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        cancel.layer.cornerRadius = 4;
        cancel.layer.masksToBounds = YES;
        
        UIButton *ok = [UIButton buttonWithType:UIButtonTypeCustom];
        [bkview addSubview:ok];
        ok.frame = CGRectMake(155, 158, 136, 47);
        ok.backgroundColor = [UIColor colorWithRed:22/255.0f green:203/255.0f blue:150/255.0f alpha:1.0f];
        [ok setTitle:@"确认" forState:UIControlStateNormal];
        [ok addTarget:self action:@selector(okBtnPressedDown:) forControlEvents:UIControlEventTouchDown];
        [ok addTarget:self action:@selector(okBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        ok.layer.cornerRadius = 4;
        ok.layer.masksToBounds = YES;
        
        mType = t;
        if (PopView_Zero == mType) {
            imageView.image = [UIImage imageNamed:@"fee_alter.png"];
            imageView.frame = CGRectMake(130, 175, 60, 60);
            bkview.frame = CGRectMake(10, 205, 300, 164);
            label.frame = CGRectMake(0, 45, bkview.frame.size.width, 40);
            label.textAlignment = NSTextAlignmentCenter;
            cancel.frame = CGRectMake(9, 108, 136, 40);
            ok.frame = CGRectMake(155, 108, 136, 40);
            
            label.text = [NSString stringWithFormat:FORMATE_CANCEL,name];
        }
        else{
            imageView.image = [UIImage imageNamed:@"fee_edit.png"];
            
            UILabel *paddingView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20, 25)];
            paddingView.text = @"  ¥   ";
            paddingView.textColor = [Utility colorFromColorString:@"#656d78"];
            
            UITextField *field = [[UITextField alloc] initWithFrame:CGRectMake(24, 90, bkview.frame.size.width-48, 40)];
            [bkview addSubview:field];
            field.placeholder = [NSString stringWithFormat:@"%.2f", fee];
            field.font = [UIFont systemFontOfSize:16];
            field.textColor = [Utility colorFromColorString:@"#656d78"];
            field.layer.borderWidth = 1;
            field.layer.borderColor = [UIColor grayColor].CGColor;
            field.leftView = paddingView;
            field.leftViewMode = UITextFieldViewModeAlways;
            field.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
            [field becomeFirstResponder];
            field.delegate = self;
            _mField = field;
            
            if (PopView_Input == mType) {
                label.text = [NSString stringWithFormat:FORMATE_RECEIVE,name];
            }
            else{
                label.text = [NSString stringWithFormat:FORMATE_MODIFY,name];
            }
        }
        _maxCount = 8;
    }
    return self;
}

/*
- (void)viewDidDisappear:(BOOL)animated{
//    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [super viewWillDisappear:animated];
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];

    CGPoint center = CGPointMake(CGRectGetWidth(self.bounds) / 2, CGRectGetHeight(self.bounds) / 2);
    
    UIBezierPath *back = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(center.x-62.5, center.y-49.5, 125, 99) byRoundingCorners:(UIRectCornerTopLeft|UIRectCornerTopRight|UIRectCornerBottomLeft|UIRectCornerBottomRight) cornerRadii:CGSizeMake(10, 10)];
    [self.rectColor setStroke];
    [back fillWithBlendMode:kCGBlendModeColor alpha:0.7];
    [back stroke];
}*/

- (void)cancelButtonPressedDown:(UIButton *)btn{
    btn.backgroundColor = [Utility colorFromColorString:@"#AFAFAF"];
}
    
- (void)cancelBtnPressed:(UIButton *)btn{
    btn.backgroundColor = [Utility colorFromColorString:@"#CECECE"];
    if ([_delegate respondsToSelector:@selector(cancelBtnPressed:charge:type:)]) {
        [_delegate cancelBtnPressed:self.tag charge:_mField.text.doubleValue type:mType];
    }
    [self removeFromSuperview];
}
    
- (void)okBtnPressedDown:(UIButton *)btn{
    btn.backgroundColor = [Utility colorFromColorString:@"#13AD80"];
}

- (void)okBtnPressed:(UIButton *)btn{
    btn.backgroundColor = [Utility colorFromColorString:@"#16CC95"];
    if ([_delegate respondsToSelector:@selector(okBtnPressed:charge:type:)]) {
        double ret = _mField.text.doubleValue;
        if (0.0 == ret) {
            ret = _mField.placeholder.doubleValue;
        }
        [_delegate okBtnPressed:self.tag charge:ret type:mType];
    }
    
    [self removeFromSuperview];
}

#pragma mark - UITextViewDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return NO;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
{
//    if ([string isEqualToString:@"\n"])
//    {
//        return YES;
//    }
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (_mField == textField)
    {
        if ([toBeString length] > _maxCount) {
            return NO;
        }
        else if ([toBeString length] > 5){
            NSString *sub = [toBeString substringFromIndex:5];
            if ([sub hasPrefix:@"."]) {
                return YES;
            }
            return NO;
        }
    }
    return YES;
}

/*
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)text{
    //       NSLog(@"----1:%@",textView.text);
    
    //    if ((range.location >= _maxCount) && (text.length))
    //    {
    //        [Promptview showWithString:[NSString stringWithFormat:STR_MAX_TEXT,(int)_maxCount] afterDelay:2];
    //        return NO;
    //    }
    
    NSInteger textLength = 0;
    UITextRange *markRange = textField.markedTextRange;
    int pos = [textField offsetFromPosition:markRange.start
                                toPosition:markRange.end];
    if (0 != pos) {
        textLength = textField.text.length;
    }
    
    if(textField.text.length-pos<_maxCount)return YES;
    
    //获取高亮部分
    if (text.length > 0) {
        //输入状态
        if (textField.text.length > pos) { //候选词替换高亮拼音时
            NSString *newStr = [NSString stringWithFormat:@"%@%@",[textField.text substringToIndex:range.location],
                                text];
            textLength = newStr.length;
        }else {
            textLength += text.length;
        }
    }else {
        //删除状态
        if (textField.text.length > 0) {
            textLength = [[textField.text substringToIndex:range.location] length];
        }
    }
    
    if (textLength > _maxCount) {
        //如果输入的字符长度超过限制长度，则进行截取
        if (textField.text.length >= range.location) {
            textField.text = [NSString stringWithFormat:@"%@%@",[textField.text substringToIndex:range.location],text];
        }
        textField.text = [textField.text substringToIndex:_maxCount];
//        [Promptview showWithString:[NSString stringWithFormat:STR_MAX_TEXT,(int)_maxCount] afterDelay:2];
        return NO;
    }
    
    return YES;
}*/

/*
- (void)textViewDidChange:(UITextView *)textView{
    //    NSLog(@"----1:%@",textView.text);
    UITextRange *markRange = textView.markedTextRange;
    int pos = [textView offsetFromPosition:markRange.start
                                toPosition:markRange.end];
    int nLength = textView.text.length - pos;
    if (nLength > _maxCount && pos==0) {
        textView.text = [textView.text substringToIndex:_maxCount];
        nLength = _maxCount;
    }
    mTailLabel.text = [NSString stringWithFormat:@"%@/%@",@(nLength),@(_maxCount)];
}
*/
@end
