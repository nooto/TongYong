//
//  CXAlertView.h
//  AlertTest
//
//  Created by  on 12-5-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CXAlertView.h"

//@protocol CXAlertViewDelegate <NSObject>

//@optional
//- (void)alertView:(UIView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
//
//@end

@interface CXCheckView : UIView

@property (nonatomic, weak)id<CXAlertViewDelegate> delegate;

- (id)initWithMessage:(NSString *)message delegate:(id)delegate buttonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;
- (void)show;

@end
