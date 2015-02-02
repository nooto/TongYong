//
//  RFStatusBar.h
//  DCalendar
//
//  Created by yq on 13-9-13.
//
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface RFStatusBar : UIWindow {
    UIView *contentView;
    
    UIView *view;
    UIImageView *imageView;
    UIButton *mButton;
}

+(RFStatusBar*)sharedInstance;
- (void)showMessage:(NSString *)message;

@end

#define g_pStatusBar [RFStatusBar sharedInstance]
