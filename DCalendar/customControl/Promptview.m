//
//  SVProgressHUD.m
//
//  Created by Sam Vermette on 27.03.11.
//  Copyright 2011 Sam Vermette. All rights reserved.
//

#import "Promptview.h"
#import <QuartzCore/QuartzCore.h>

@interface Promptview (){
    UIFont *mFont;
}
@end

@implementation Promptview

//static waitingView *sharedView = nil;

+ (Promptview *)sharedView {
	
//	if(sharedView == nil)
		Promptview *sharedView = [[Promptview alloc] initWithFrame:CGRectZero];

	return sharedView ;
}

#pragma mark - Show Methods

+ (Promptview *)show {
	return [Promptview showInView:nil status:nil];
}

+ (Promptview *)showInView:(UIView*)view{
	return [Promptview showInView:view status:nil];
}

+ (Promptview *)showInView:(UIView*)view status:(NSString*)string {
	return [Promptview showInView:view status:string networkIndicator:YES];
}


+ (Promptview *)showInView:(UIView*)view status:(NSString*)string networkIndicator:(BOOL)show {
	return [Promptview showInView:view status:string networkIndicator:show posY:-1];
}

+ (Promptview *)showInView:(UIView*)view status:(NSString*)string networkIndicator:(BOOL)show posY:(CGFloat)posY{
	
    BOOL addingToWindow = NO;
    
    if(!view) {
        UIWindow* keyWindow = [UIApplication sharedApplication].keyWindow;
        addingToWindow = YES;
        
        if ([keyWindow respondsToSelector:@selector(rootViewController)]) {
            //Use the rootViewController to reflect the device orientation
            view = keyWindow.rootViewController.view;
        }
        
        if (view == nil) view = keyWindow;
    }
	
	if(posY == -1) {
		posY = floor(CGRectGetHeight(view.bounds)/2);
        
        if(addingToWindow)
            posY -= floor(CGRectGetHeight(view.bounds)/18);
    }

	return [[Promptview sharedView] showInView:view status:string networkIndicator:show posY:posY];
}

+ (Promptview *)showWithString:(NSString *)str afterDelay:(NSTimeInterval)seconds{
    
    Promptview *promp = [Promptview showInView:nil status:str networkIndicator:NO posY:-1];
    [promp performSelector:@selector(dismiss) withObject:nil afterDelay:seconds];
    
    return promp;
}

#pragma mark - Dismiss Methods

- (void)dismissWithSuccess:(NSString*)successString {
	[self dismissWithStatus:successString error:NO];
}

- (void)dismissWithSuccess:(NSString *)successString afterDelay:(NSTimeInterval)seconds {
    [self dismissWithStatus:successString error:NO afterDelay:seconds];
}

- (void)dismissWithError:(NSString*)errorString {
	[self dismissWithStatus:errorString error:YES];
}

- (void)dismissWithError:(NSString *)errorString afterDelay:(NSTimeInterval)seconds {
    [self dismissWithStatus:errorString error:YES afterDelay:seconds];
}


#pragma mark - Instance Methods

- (id)initWithFrame:(CGRect)frame {
	
    if ((self = [super initWithFrame:frame])) {
		self.layer.cornerRadius = 5;
        self.layer.masksToBounds = YES;
		self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
	//	self.userInteractionEnabled = NO;
//		self.layer.opacity = 0;
        self.autoresizingMask = (UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin |
                                 UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin);
        mFont = [UIFont systemFontOfSize:16];
    }
	
    return self;
}

- (void)setStatus:(NSString *)string {
	
 //   CGFloat hudWidth = 30;
    _text = string;
    CGSize size = [string sizeWithFont:mFont];
	
//	if(stringWidth > hudWidth)
//		hudWidth = ceil(stringWidth/2)*2;
	//self.bounds = CGRectMake(0, 0, 160, 30);
    self.bounds = CGRectMake(0, 0, size.width+50, size.height+24);
    
    UIWindow* keyWindow = [UIApplication sharedApplication].keyWindow;
	self.center = keyWindow.center;
//	self.imageView.center = CGPointMake(CGRectGetWidth(self.bounds)/2, 36);
    /*
	if(string)
		self.spinnerView.center = CGPointMake(ceil(CGRectGetWidth(self.bounds)/2)+0.5, 40.5);
	else
		self.spinnerView.center = CGPointMake(ceil(CGRectGetWidth(self.bounds)/2)+0.5, ceil(self.bounds.size.height/2)+0.5);*/
}

- (Promptview *)showInView:(UIView*)view status:(NSString*)string networkIndicator:(BOOL)show posY:(CGFloat)posY{
	
//	if(fadeOutTimer != nil)
//		[fadeOutTimer invalidate], [fadeOutTimer release], fadeOutTimer = nil;
	
//    [UIApplication sharedApplication].networkActivityIndicatorVisible = show;
/*	if(show)
		[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	else
		[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	
	self.imageView.hidden = YES;
	*/
	[self setStatus:string];
	/*
    if (!_maskView && maskType != SVProgressHUDMaskTypeNone) {
        _maskView = [[UIView alloc] initWithFrame:view.bounds];
        _maskView.backgroundColor = [UIColor clearColor];
        _maskView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [view addSubview:_maskView];
        [_maskView release];
    }
    */
	if(![self isDescendantOfView:view]) {
		self.layer.opacity = 0;
		[view addSubview:self];
	}
	
	if(self.layer.opacity != 1) {
		
		self.center = CGPointMake(CGRectGetWidth(self.superview.bounds)/2, posY);

		self.layer.transform = CATransform3DScale(CATransform3DMakeTranslation(0, 0, 0), 1.3, 1.3, 1);
		self.layer.opacity = 0.3;
		
		[UIView animateWithDuration:0//0.15
							  delay:0
							options:UIViewAnimationOptionTransitionNone//UIViewAnimationOptionAllowUserInteraction | UIViewAnimationCurveEaseOut
						 animations:^{	
							 self.layer.transform = CATransform3DScale(CATransform3DMakeTranslation(0, 0, 0), 1, 1, 1);
							 self.layer.opacity = 1;
                             
//                             if (_maskView && maskType == SVProgressHUDMaskTypeBlack) {
//                                 _maskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
//                             }
     
						 }
						 completion:NULL];
	}
    return self;
}


- (void)dismiss {
	
//	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

	[UIView animateWithDuration:0.15
						  delay:0
						options:UIViewAnimationOptionTransitionNone//UIViewAnimationCurveEaseIn | UIViewAnimationOptionAllowUserInteraction
					 animations:^{
					//	 self.layer.transform = CATransform3DScale(CATransform3DMakeTranslation(0, 0, 0), 0.8, 0.8, 1.0);
						 self.layer.opacity = 0;
//                         if (_maskView) {
//                             _maskView.backgroundColor = [UIColor clearColor];
//                         }
					 }
					 completion:^(BOOL finished){
                         if(self.layer.opacity == 0) {
                            // [_maskView removeFromSuperview];
                            // _maskView = nil;
                             [self removeFromSuperview];
                         }
                     }];
}


- (void)dismissWithStatus:(NSString*)string error:(BOOL)error {
	[self dismissWithStatus:string error:error afterDelay:0.9];
}


- (void)dismissWithStatus:(NSString *)string error:(BOOL)error afterDelay:(NSTimeInterval)seconds {
//    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	/*
	if(error)
		self.imageView.image = [UIImage imageNamed:@"SVProgressHUD.bundle/error.png"];
	else
		self.imageView.image = [UIImage imageNamed:@"SVProgressHUD.bundle/success.png"];
	
	self.imageView.hidden = NO;
	*/
	[self setStatus:string];
	
    
    [self performSelector:@selector(dismiss) withObject:nil afterDelay:seconds];

}

- (void)drawRect:(CGRect)rect{
    [[UIColor whiteColor] set];
    [_text drawAtPoint:CGPointMake(25, 12) withFont:mFont];
}

@end
