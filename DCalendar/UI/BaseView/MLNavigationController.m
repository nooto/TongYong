//
//  MLNavigationController.m
//  MultiLayerNavigation
//
//  Created by Feather Chan on 13-4-12.
//  Copyright (c) 2013年 Feather Chan. All rights reserved.
//

#import "MLNavigationController.h"
#import <QuartzCore/QuartzCore.h>
#import <math.h>
#import "BaseViewController.h"

@interface MLNavigationController ()
{
    CGPoint startTouch;
    
    UIImageView *lastScreenShotView;
    UIView *blackMask;
}

@property (nonatomic,retain) UIView *backgroundView;
@property (nonatomic,retain) NSMutableArray *screenShotsList;
@property (nonatomic, strong) UIPanGestureRecognizer *recognizer;
@property (nonatomic,assign) BOOL isMoving;
@property (nonatomic, weak) UIViewController *topViewCtl;

@end

@implementation MLNavigationController
@synthesize recognizer;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.screenShotsList = [[NSMutableArray alloc]initWithCapacity:2];
        self.dragType = EDrag_right;
    }
    return self;
}

- (void)dealloc
{
    self.screenShotsList = nil;
    
    [self.backgroundView removeFromSuperview];
    self.backgroundView = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    if ([Utility isSystemVersionSeven]) {
		UIImageView *shadowImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"leftside_shadow_bg"]];
		shadowImageView.frame = CGRectMake(-10, 0, 10, self.view.frame.size.height);
		[self.view addSubview:shadowImageView];
	}
}

-(void)addGestureRecognizer{
    if (recognizer == nil) {
        recognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self
                                                            action:@selector(paningGestureReceive:)];
        [recognizer delaysTouchesBegan];
        [self.view addGestureRecognizer:recognizer];
    }
	[self setDragType:EDrag_right];
}

-(void)releaseGestureRecognizer{
	if (recognizer) {
		[self.view removeGestureRecognizer:recognizer];
        recognizer = nil;
	}
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// override the push method
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([_topViewCtl isKindOfClass:[BaseViewController class]]){
        if (((BaseViewController*)_topViewCtl).bAnimating) {
            
        }
        else{
            id obj = [self capture];
            if (obj) {
                [self.screenShotsList addObject:obj];
                
                if ([viewController isKindOfClass:[BaseViewController class]]) {
                    ((BaseViewController*)viewController).bAnimating = YES;
                }
                _topViewCtl = viewController;
                [super pushViewController:viewController animated:animated];
            }
        }
    }
    else {
        id obj = [self capture];
        if (obj) {
            [self.screenShotsList addObject:obj];
            _topViewCtl = viewController;
            [super pushViewController:viewController animated:animated];
        }
    }
}

- (void)pushViewControllerMust:(UIViewController *)viewController animated:(BOOL)animated
{
   [super pushViewController:viewController animated:animated];
}

// override the pop method
- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
     if ([_topViewCtl isKindOfClass:[BaseViewController class]]){
         if (((BaseViewController*)_topViewCtl).bAnimating) {
             return nil;
         }
         else {
             [self.screenShotsList removeLastObject];
             
             _topViewCtl = [super popViewControllerAnimated:animated];
             if ([_topViewCtl isKindOfClass:[BaseViewController class]]) {
                 ((BaseViewController*)_topViewCtl).bAnimating = YES;
             }
             return _topViewCtl;
         }
     }
     else {
         [self.screenShotsList removeLastObject];
         
         _topViewCtl = [super popViewControllerAnimated:animated];
         return _topViewCtl;
     }
}

#pragma mark - Utility Methods -

// get the current view screen shot
- (UIImage *)capture
{
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, self.view.opaque, 0.0);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
}

// set lastScreenShotView 's position and alpha when paning
- (void)moveViewWithPoint:(CGPoint)pos
{
	if (self.dragType == EDrag_No) {
		return;
	}
	
    CGRect frame = self.view.frame;
	if (self.dragType == EDrag_right) {
		if (pos.x < 0) {
			return;
		}
		frame.origin.x = pos.x;
	}
	else if (self.dragType == EDrag_left){
		if (pos.x >= 0) {
			return;
		}
		frame.origin.x = pos.x;
	}
	else if (self.dragType == EDrag_Vertical){
		frame.origin.y = pos.y;

		
	}
	else if (self.dragType == EDrag_All){
		frame.origin.x = pos.x;
		frame.origin.y = pos.y;
	}
	
    self.view.frame = frame;

    float m =fabsf(pos.x);
    float scale = (m/6400)+0.95;
    float alpha = 0.4 - (m/800);
	lastScreenShotView.transform = CGAffineTransformMakeScale(scale, scale);
    blackMask.alpha = alpha;
}

#pragma mark - Gesture Recognizer -

- (void)paningGestureReceive:(UIPanGestureRecognizer *)recoginzer
{
    // If the viewControllers has only one vc or disable the interaction, then return.
    if (self.viewControllers.count <= 1 ||  self.dragType == EDrag_No) return;
    
    // we get the touch position by the window's coordinate
    CGPoint touchPoint = [recoginzer locationInView:KEY_WINDOW];
    
	CGFloat  moveWidth = ScreenWidth /3;
	CGPoint gapPoint;
    // begin paning, show the backgroundView(last screenshot),if not exist, create it.
    if (recoginzer.state == UIGestureRecognizerStateBegan) {
        
        _isMoving = YES;
        startTouch = touchPoint;
        
        if (!self.backgroundView)
        {
            CGRect frame = self.view.frame;
            
            self.backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width , frame.size.height)];
            [self.view.superview insertSubview:self.backgroundView belowSubview:self.view];
            
            blackMask = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width , frame.size.height)];
            blackMask.backgroundColor = [UIColor blackColor];
            [self.backgroundView addSubview:blackMask];
        }
        
        self.backgroundView.hidden = NO;
        
        if (lastScreenShotView) [lastScreenShotView removeFromSuperview];
        
        UIImage *lastScreenShot = [self.screenShotsList lastObject];
        lastScreenShotView = [[UIImageView alloc]initWithImage:lastScreenShot];
        [self.backgroundView insertSubview:lastScreenShotView belowSubview:blackMask];
        
        //End paning, always check that if it should move right or move left automatically
    }else if (recoginzer.state == UIGestureRecognizerStateEnded){
        
        if (touchPoint.x - startTouch.x > moveWidth)
        {
            [UIView animateWithDuration:0.3 animations:^{
				[self moveViewWithPoint:CGPointMake(320, gapPoint.y)];
            } completion:^(BOOL finished) {
                
                [self popViewControllerAnimated:NO];
                CGRect frame = self.view.frame;
                frame.origin.x = 0;
                self.view.frame = frame;
                
                _isMoving = NO;
            }];
        }
//		else if (startTouch.x - touchPoint.x > 50){
//            [UIView animateWithDuration:0.3 animations:^{
//				[self moveViewWithPoint:CGPointMake(-320, gapPoint.y)];
//            } completion:^(BOOL finished) {
//                
//                [self popViewControllerAnimated:NO];
//                CGRect frame = self.view.frame;
//                frame.origin.x = 0;
//                self.view.frame = frame;
//                _isMoving = NO;
//            }];
//		}
        else
        {
			
            [UIView animateWithDuration:0.3 animations:^{
				[self moveViewWithPoint:CGPointZero];
            } completion:^(BOOL finished) {
                _isMoving = NO;
                self.backgroundView.hidden = YES;
            }];
            
        }
        return;
        
        // cancal panning, alway move to left side automatically
    }else if (recoginzer.state == UIGestureRecognizerStateCancelled){
        
        [UIView animateWithDuration:0.3 animations:^{
			[self moveViewWithPoint:CGPointZero];
        } completion:^(BOOL finished) {
            _isMoving = NO;
            self.backgroundView.hidden = YES;
        }];
        
        return;
    }
    
    // it keeps move with touch
    if (_isMoving) {
		gapPoint = CGPointMake(touchPoint.x- startTouch.x, startTouch.y);
		[self moveViewWithPoint:gapPoint];
    }
}

@end
