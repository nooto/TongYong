/*
 CustomBadge.m
 
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


#import "CustomBadge.h"

#define KFOUNT_SIZE 13

@interface CustomBadge()


- (void) drawRoundedRectWithContext:(CGContextRef)context withRect:(CGRect)rect;
- (void) drawFrameWithContext:(CGContextRef)context withRect:(CGRect)rect;
@end

@implementation CustomBadge

@synthesize badgeText;
@synthesize badgeTextColor;
@synthesize badgeInsetColor;
@synthesize badgeFrameColor;
@synthesize badgeFrame;
@synthesize badgeCornerRoundness;
@synthesize badgeScaleFactor;
@synthesize badgeShining;

// I recommend to use the allocator customBadgeWithString
- (id) initWithString:(NSString *)badgeString withScale:(CGFloat)scale withShining:(BOOL)shining
{
	self = [super initWithFrame:CGRectMake(-14, 0, 25, 25)];
	if(self!=nil) {
        self.userInteractionEnabled = NO;
		self.contentScaleFactor = [[UIScreen mainScreen] scale];
		self.backgroundColor = [UIColor clearColor];
		self.badgeText = badgeString;
		self.badgeTextColor = [UIColor whiteColor];
		self.badgeFrame = YES;
		self.badgeFrameColor = [UIColor whiteColor];
		self.badgeInsetColor = [UIColor redColor];
		self.badgeCornerRoundness = 0.4;
		self.badgeScaleFactor = scale;
		self.badgeShining = shining;
//        self.hideWhenZero = YES;
		[self autoBadgeSizeWithString:badgeString];
	}
	return self;
}

// I recommend to use the allocator customBadgeWithString
- (id) initWithString:(NSString *)badgeString withStringColor:(UIColor*)stringColor withInsetColor:(UIColor*)insetColor withBadgeFrame:(BOOL)badgeFrameYesNo withBadgeFrameColor:(UIColor*)frameColor withScale:(CGFloat)scale withShining:(BOOL)shining
{
	self = [super initWithFrame:CGRectMake(35, -8, 25, 25)];
	if(self!=nil) {
        self.userInteractionEnabled = NO;
		self.contentScaleFactor = [[UIScreen mainScreen] scale];
		self.backgroundColor = [UIColor clearColor];
		self.badgeText = badgeString;
		self.badgeTextColor = stringColor;
		self.badgeFrame = badgeFrameYesNo;
		self.badgeFrameColor = frameColor;
		self.badgeInsetColor = insetColor;
		self.badgeCornerRoundness = 0.40;
		self.badgeScaleFactor = scale;
		self.badgeShining = shining;
		[self autoBadgeSizeWithString:badgeString];
	}
	return self;
}

// Use this method if you want to change the badge text after the first rendering
- (void) autoBadgeSizeWithString:(NSString *)badgeString
{
	CGSize retValue;
	CGFloat rectWidth, rectHeight;
	CGSize stringSize = [badgeString sizeWithFont:[UIFont boldSystemFontOfSize:KFOUNT_SIZE]];
	CGFloat flexSpace;
	if ([badgeString length]>=2) {
		flexSpace = [badgeString length];
		rectWidth = 12 + (stringSize.width + flexSpace); rectHeight = 25;
		retValue = CGSizeMake(rectWidth*badgeScaleFactor, rectHeight*badgeScaleFactor);
	} else {
		retValue = CGSizeMake(25*badgeScaleFactor, 25*badgeScaleFactor);
	}

#if 1
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, retValue.width, retValue.height);
    if (self.badgeText.length <= 0 && badgeString.length > 0) {//显示
        self.hidden = NO;
    }
    else if (self.badgeText.length > 0 && badgeString.length <= 0) {//消失
        self.hidden = YES;
    }
    else if(self.badgeText.length <=0 && (badgeString.length <= 0)){
        self.hidden = YES;
    }
    
    if (self.badgeText.length > 0 && [badgeString isEqualToString:[NSString stringWithFormat:@"%d",KDotMaxInterge]]) {
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y,10, 10);
    }
#else
    [self.layer removeAllAnimations];
    self.transform = CGAffineTransformIdentity;
	self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, retValue.width, retValue.height);
   if (self.badgeText.length <= 0 && badgeString.length > 0) {//显示

        self.transform = CGAffineTransformScale(self.transform, 0.1, 0.1);
        [UIView animateWithDuration:ANIMATIONDURATION/2 animations:^{
            self.transform = CGAffineTransformIdentity;
        }completion:^(BOOL finished) {
            self.transform = CGAffineTransformIdentity;
            self.hidden = NO;
        }];

    }
    else if (self.badgeText.length > 0 && badgeString.length <= 0) {//消失

        self.transform = CGAffineTransformIdentity;
        [UIView animateWithDuration:ANIMATIONDURATION/2 animations:^{
            self.transform = CGAffineTransformScale(self.transform, 0.1, 0.1);
        }completion:^(BOOL finished) {
            self.transform = CGAffineTransformIdentity;
            self.hidden = YES;
        }];
    }
    else if(self.badgeText.length <=0 && (badgeString.length <= 0)){
        self.hidden = YES;
    }
    else if (self.badgeText.length > 0 && badgeString.length > 0) {//缩放
        self.hidden = NO;
        self.transform = CGAffineTransformIdentity;
        [UIView animateWithDuration:ANIMATIONDURATION/2 animations:^{
            self.transform = CGAffineTransformScale(self.transform, 0.1, 0.1);
        }completion:^(BOOL finished) {
            [UIView animateWithDuration:ANIMATIONDURATION/2 animations:^{
                self.transform = CGAffineTransformIdentity;
            }completion:nil];
        }];
    }
#endif
    
    self.badgeText = badgeString;
	[self setNeedsDisplay];
}

// Creates a Badge with a given Text
+ (CustomBadge*) customBadgeWithString:(NSString *)badgeString
{
	return [[self alloc] initWithString:badgeString withScale:1.0 withShining:YES];
}


// Creates a Badge with a given Text, Text Color, Inset Color, Frame (YES/NO) and Frame Color
+ (CustomBadge*) customBadgeWithString:(NSString *)badgeString withStringColor:(UIColor*)stringColor withInsetColor:(UIColor*)insetColor withBadgeFrame:(BOOL)badgeFrameYesNo withBadgeFrameColor:(UIColor*)frameColor withScale:(CGFloat)scale withShining:(BOOL)shining
{
	return [[self alloc] initWithString:badgeString withStringColor:stringColor withInsetColor:insetColor withBadgeFrame:badgeFrameYesNo withBadgeFrameColor:frameColor withScale:scale withShining:shining];
}

// Draws the Badge with Quartz
-(void) drawRoundedRectWithContext:(CGContextRef)context withRect:(CGRect)rect
{
	CGContextSaveGState(context);
    
	CGFloat radius = CGRectGetMaxY(rect)*self.badgeCornerRoundness;
	CGFloat puffer = CGRectGetMaxY(rect)*0.10;
	CGFloat maxX = CGRectGetMaxX(rect) - puffer;
	CGFloat maxY = CGRectGetMaxY(rect) - puffer;
	CGFloat minX = CGRectGetMinX(rect) + puffer;
	CGFloat minY = CGRectGetMinY(rect) + puffer;
    
    CGContextBeginPath(context);
	CGContextSetFillColorWithColor(context, [self.badgeInsetColor CGColor]);
	CGContextAddArc(context, maxX-radius, minY+radius, radius, M_PI+(M_PI/2), 0, 0);
	CGContextAddArc(context, maxX-radius, maxY-radius, radius, 0, M_PI/2, 0);
	CGContextAddArc(context, minX+radius, maxY-radius, radius, M_PI/2, M_PI, 0);
	CGContextAddArc(context, minX+radius, minY+radius, radius, M_PI, M_PI+M_PI/2, 0);
	//CGContextSetShadowWithColor(context, CGSizeMake(1.0,1.0), 3, [[UIColor blackColor] CGColor]);
    CGContextFillPath(context);
    
	CGContextRestoreGState(context);
}

// Draws the Badge Shine with Quartz
-(void) drawShineWithContext:(CGContextRef)context withRect:(CGRect)rect
{
	CGContextSaveGState(context);
    
	CGFloat radius = CGRectGetMaxY(rect)*self.badgeCornerRoundness;
	CGFloat puffer = CGRectGetMaxY(rect)*0.10;
	CGFloat maxX = CGRectGetMaxX(rect) - puffer;
	CGFloat maxY = CGRectGetMaxY(rect) - puffer;
	CGFloat minX = CGRectGetMinX(rect) + puffer;
	CGFloat minY = CGRectGetMinY(rect) + puffer;
	CGContextBeginPath(context);
	CGContextAddArc(context, maxX-radius, minY+radius, radius, M_PI+(M_PI/2), 0, 0);
	CGContextAddArc(context, maxX-radius, maxY-radius, radius, 0, M_PI/2, 0);
	CGContextAddArc(context, minX+radius, maxY-radius, radius, M_PI/2, M_PI, 0);
	CGContextAddArc(context, minX+radius, minY+radius, radius, M_PI, M_PI+M_PI/2, 0);
	CGContextClip(context);
    
    
	size_t num_locations = 2;
	CGFloat locations[2] = { 0.0, 0.4 };
	CGFloat components[8] = {  0.92, 0.92, 0.92, 1.0, 0.82, 0.82, 0.82, 0.4 };
    
	CGColorSpaceRef cspace;
	CGGradientRef gradient;
	cspace = CGColorSpaceCreateDeviceRGB();
	gradient = CGGradientCreateWithColorComponents (cspace, components, locations, num_locations);
    
	CGPoint sPoint, ePoint;
	sPoint.x = 0;
	sPoint.y = 0;
	ePoint.x = 0;
	ePoint.y = maxY;
	CGContextDrawLinearGradient (context, gradient, sPoint, ePoint, 0);
    
	CGColorSpaceRelease(cspace);
	CGGradientRelease(gradient);
    
	CGContextRestoreGState(context);
}


// Draws the Badge Frame with Quartz
-(void) drawFrameWithContext:(CGContextRef)context withRect:(CGRect)rect
{
	CGFloat radius = CGRectGetMaxY(rect)*self.badgeCornerRoundness;
	CGFloat puffer = CGRectGetMaxY(rect)*0.10;
    
	CGFloat maxX = CGRectGetMaxX(rect) - puffer;
	CGFloat maxY = CGRectGetMaxY(rect) - puffer;
	CGFloat minX = CGRectGetMinX(rect) + puffer;
	CGFloat minY = CGRectGetMinY(rect) + puffer;
    
    
    CGContextBeginPath(context);
	CGFloat lineSize = 2;
	if(self.badgeScaleFactor>1) {
		lineSize += self.badgeScaleFactor*0.25;
	}
	CGContextSetLineWidth(context, lineSize);
	CGContextSetStrokeColorWithColor(context, [self.badgeFrameColor CGColor]);
	CGContextAddArc(context, maxX-radius, minY+radius, radius, M_PI+(M_PI/2), 0, 0);
	CGContextAddArc(context, maxX-radius, maxY-radius, radius, 0, M_PI/2, 0);
	CGContextAddArc(context, minX+radius, maxY-radius, radius, M_PI/2, M_PI, 0);
	CGContextAddArc(context, minX+radius, minY+radius, radius, M_PI, M_PI+M_PI/2, 0);
	CGContextClosePath(context);
	CGContextStrokePath(context);
}

- (void)drawRect:(CGRect)rect {

	CGContextRef context = UIGraphicsGetCurrentContext();
	[self drawRoundedRectWithContext:context withRect:rect];
    
    if ([self.badgeText isEqualToString:[NSString stringWithFormat:@"%d",KDotMaxInterge]]) {
        return;
    }
//	if(self.badgeShining) {
//		[self drawShineWithContext:context withRect:rect];
//	}
    
//	if (self.badgeFrame)  {
//		[self drawFrameWithContext:context withRect:rect];
//	}
    
	if ([self.badgeText length]>0) {
		[badgeTextColor set];
		CGFloat sizeOfFont = KFOUNT_SIZE*badgeScaleFactor;
//		if ([self.badgeText length]<2) {
//			sizeOfFont += sizeOfFont*0.20;
//		}
		UIFont *textFont = [UIFont boldSystemFontOfSize:sizeOfFont];
		CGSize textSize = [self.badgeText sizeWithFont:textFont];
		[self.badgeText drawAtPoint:CGPointMake((rect.size.width/2-textSize.width/2), (rect.size.height/2-textSize.height/2)) withFont:textFont];
//        [self.badgeText drawAtPoint:CGPointMake((rect.size.width-textSize.width/2), (rect.size.height/2-textSize.height/2)) withFont:textFont];

	}
}

@end