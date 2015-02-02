//
//  DTextField.h
//  DCalendar
//
//  Created by GaoAng on 14-5-10.
//  Copyright (c) 2014年 richinfo.cn. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum{
	INPUT_MOBILENUMBER,   //只允许输入数字  0  1 2 3 4 5 6 7 8 9
	INPUT_EMAIL,           //必须有 ***@***
    INPUT_PASSWORD,        //密码
	INPUT_ALL,             //
}EINPUTTYPE;
@protocol DTextFiledDelegate;
@interface DTextField : UIView<UITextFieldDelegate>
- (id)initWithFrame:(CGRect)frame label:(NSString*)key placeholder:(NSString*)placeholder wihtInputType:(EINPUTTYPE)inputtype delegate:(id)delegate;

@property(nonatomic, readonly) UITextField *textField;
@property(nonatomic, readonly) UILabel     *keylabel;
@property(nonatomic, assign) id<DTextFiledDelegate> DDelegate;
@property (nonatomic, assign) EINPUTTYPE  eInputType;
@property (nonatomic, assign) NSInteger  maxInputLength;

-(void)closeDTextFiledKeyBoard;
@end

@protocol DTextFiledDelegate <NSObject>

-(void)DTextFieldDidBeginEditing:(DTextField *)textField;
-(void)DTextFieldDidEndEditing:(DTextField *)textField;
-(BOOL)DTextFieldShouldReturn:(DTextField *)textField;
-(void)DTextDidChange:(DTextField *)textField :(NSString*)text;
@end

