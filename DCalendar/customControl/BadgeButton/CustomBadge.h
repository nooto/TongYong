/*
 CustomBadge.h
 
 *** Description: ***
 With this class you can draw a typical iOS badge indicator with a custom text on any view.
 Please use the allocator customBadgeWithString to create a new badge.
 In this version you can modfiy the color inside the badge (insetColor),
 the color of the frame (frameColor), the color of the text and you can
 tell the class if you want a frame around the badge.
 
 *** License & Copyright ***
 Created by Sascha Paulus www.spaulus.com on 04/2011. Version 2.0
 This tiny class can be used for free in private and commercial applications.
 Please feel free to modify, extend or distribution this class.
 If you modify it: Please send me your modified version of the class.
 Please do not sell the source code solely and keep this text in
 your copyright section. Thanks.
 
 If you have any questions please feel free to contact me (open@spaulus.com).
 
 */

/*
// Create simple Badge
//CustomBadge *customBadge1 = [CustomBadge customBadgeWithString:@"2"];
CustomBadge *customBadge1 = [CustomBadge customBadgeWithString:@"2"
                                               withStringColor:[UIColor whiteColor]
                                                withInsetColor:[UIColor redColor]
                                                withBadgeFrame:YES
                                           withBadgeFrameColor:[UIColor whiteColor]
                                                     withScale:1.0
                                                   withShining:YES];

// Create advanced Badge

CustomBadge *customBadge2 = [CustomBadge customBadgeWithString:@"CustomBadge"
                                               withStringColor:[UIColor blackColor]
                                                withInsetColor:[UIColor greenColor]
                                                withBadgeFrame:YES
                                           withBadgeFrameColor:[UIColor yellowColor]
                                                     withScale:1.5
                                                   withShining:YES];


// Set Position of Badge 1
[customBadge1 setFrame:CGRectMake(self.view.frame.size.width/2-customBadge1.frame.size.width/2+customBadge2.frame.size.width/2, 110, customBadge1.frame.size.width, customBadge1.frame.size.height)];
[customBadge2 setFrame:CGRectMake(self.view.frame.size.width/2-customBadge2.frame.size.width/2, 110, customBadge2.frame.size.width, customBadge2.frame.size.height)];


// Add Badges to View
[self.view addSubview:customBadge2];
[self.view addSubview:customBadge1];
*/

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface CustomBadge : UIView {
    
	NSString *badgeText;
	UIColor *badgeTextColor;
	UIColor *badgeInsetColor;
	UIColor *badgeFrameColor;
	BOOL badgeFrame;
	BOOL badgeShining;
	CGFloat badgeCornerRoundness;
	CGFloat badgeScaleFactor;
}

@property(nonatomic,strong) NSString *badgeText;
@property(nonatomic,strong) UIColor *badgeTextColor;
@property(nonatomic,strong) UIColor *badgeInsetColor;
@property(nonatomic,strong) UIColor *badgeFrameColor;

@property(nonatomic,readwrite) BOOL badgeFrame;
@property(nonatomic,readwrite) BOOL badgeShining;

@property(nonatomic,readwrite) CGFloat badgeCornerRoundness;
@property(nonatomic,readwrite) CGFloat badgeScaleFactor;
//@property (nonatomic) BOOL hideWhenZero;

+ (CustomBadge*) customBadgeWithString:(NSString *)badgeString;
+ (CustomBadge*) customBadgeWithString:(NSString *)badgeString withStringColor:(UIColor*)stringColor withInsetColor:(UIColor*)insetColor withBadgeFrame:(BOOL)badgeFrameYesNo withBadgeFrameColor:(UIColor*)frameColor withScale:(CGFloat)scale withShining:(BOOL)shining;
- (void) autoBadgeSizeWithString:(NSString *)badgeString;

@end