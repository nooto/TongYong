//
//  MLNavigationController.h
//  MultiLayerNavigation
//
//  Created by Feather Chan on 13-4-12.
//  Copyright (c) 2013年 Feather Chan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
	EDrag_No = 0,   //不允许通读哦
	EDrag_left,  //左边拖动
	EDrag_right,  //左边拖动
	EDrag_Vertical,   //垂直拖动
	EDrag_All,      //垂直+ 横向
}EDragType;

@interface MLNavigationController : UINavigationController

// Enable the drag to back interaction, Defalt is YES.
@property (nonatomic,assign) EDragType dragType;

-(void)releaseGestureRecognizer;
-(void)addGestureRecognizer;

- (void)pushViewControllerMust:(UIViewController *)viewController animated:(BOOL)animated;

@end
