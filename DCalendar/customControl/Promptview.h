//
//  SVProgressHUD.h
//
//  Created by Sam Vermette on 27.03.11.
//  Copyright 2011 Sam Vermette. All rights reserved.
//

@interface Promptview : UIView

@property (nonatomic, strong)NSString *text;

/* 
showInView:(UIView*)                → the view you're adding the HUD to. By default, it's added to the keyWindow rootViewController, or the keyWindow if the rootViewController is nil
status:(NSString*)                  → a loading status for the HUD (different from the success and error messages)
networkIndicator:(BOOL)             → whether or not the HUD also triggers the UIApplication's network activity indicator (default is YES)
posY:(CGFloat)                      → the vertical position of the HUD (default is viewHeight/2-viewHeight/8)
maskType:(SVProgressHUDMaskType)    → set whether to allow user interactions while HUD is displayed
*/

+ (Promptview *)showWithString:(NSString *)str afterDelay:(NSTimeInterval)seconds;


@end
