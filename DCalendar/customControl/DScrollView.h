//
//  DScrollView.h
//  DCalendar
//
//  Created by GaoAng on 14-6-11.
//  Copyright (c) 2014年 richinfo.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface DScrollView : UIScrollView
{
//    NSMutableArray *arrImage;
	CGFloat itemWidth;
	CGFloat itemHeight;
}
@property (nonatomic, strong)     NSMutableArray *arrImage;
@property (copy, nonatomic)void(^didTouchScrollViewImage)(NSInteger row,NSInteger);

- (void)addImage:(UIImage *)image;
-(UIImageView*)getImageViewAtPoint:(CGPoint)point;
-(NSInteger)insertImage:(UIImage*)image withPoint:(CGPoint)point;
-(void)clearView;
@end