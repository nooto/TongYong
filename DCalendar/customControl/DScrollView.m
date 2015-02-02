//
//  DScrollView.m
//  DCalendar
//
//  Created by GaoAng on 14-6-11.
//  Copyright (c) 2014年 richinfo.cn. All rights reserved.
//
#define PADDING 5
#import "DScrollView.h"

@implementation DScrollView
@synthesize arrImage;
- (id)initWithFrame:(CGRect)frame;
{
    self = [super initWithFrame:frame];
    if ( self )
    {
        arrImage = [[NSMutableArray alloc] initWithCapacity:5];
        
        self.backgroundColor = [UIColor cyanColor];
        self.scrollEnabled = YES;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
		itemHeight = 54;//frame.size.height;
		itemWidth = 54;//frame.size.height;
    }
    
    return self;
}

- (void)addImage:(UIImage *)image
{
    if (image == nil) {
        return;
    }
    
    NSInteger width = PADDING;
    UIImageView  *lastImage = [arrImage lastObject];
    if ( lastImage )
    {
        width += lastImage.frame.origin.x + lastImage.frame.size.width;
    }
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(PADDING, 3, itemWidth, itemHeight)];
	imageView.image = image;
    CGRect frame = imageView.frame;
    frame.origin.x = width;
    imageView.frame = frame;
    
    [self addSubview:imageView];
    
    [arrImage addObject:imageView];
    
    //设置可滑动大小
    if ( width > self.frame.size.width )
    {
        self.contentSize = CGSizeMake(width + imageView.frame.size.width + PADDING, self.frame.size.height);
    }
}

-(UIImageView*)getImageViewAtPoint:(CGPoint)point{
	if (arrImage.count <= 0) {
		return nil;
	}
	UIImageView *copyeView = [[UIImageView alloc] init];
	NSInteger i = 0;
	for (UIImageView *view in arrImage) {
		if (CGRectContainsPoint(view.frame, point)) {
			copyeView.frame = view.frame;
			copyeView.image = view.image;
			copyeView.tag=  i;
			[arrImage removeObject:view];
			[self resetView];
			return copyeView;
		}
		i++;
	}
	return nil;
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
	[super touchesEnded:touches withEvent:event];
	UITouch *touch = [touches anyObject];
	CGPoint pos = [touch locationInView:self];
	for (NSInteger i = 0; i <[arrImage count]; i++) {
		UIImageView* itemView = [arrImage objectAtIndex:i];
		if (CGRectContainsPoint(itemView.frame, pos)) {
            if (self.didTouchScrollViewImage) {
                self.didTouchScrollViewImage(self.tag, i);
            }
		}
	}
}

-(NSInteger)insertImage:(UIImage*)image withPoint:(CGPoint)point{
    if (image == nil) {
        return 0;
    }
    
	BOOL insertSuccess = NO;
	NSInteger indexo = 0;
	for (NSInteger i = 0; i <[arrImage count]; i++) {
		UIImageView* itemView = [arrImage objectAtIndex:i];
		if (CGRectContainsPoint(itemView.frame, point)) {
			indexo = i;
			UIImageView *newImageView = [[UIImageView alloc] initWithFrame:CGRectMake(point.x, 0, itemWidth, itemHeight)];
			newImageView.image = image;
			[arrImage insertObject:newImageView atIndex:i];
			[self resetView];
			insertSuccess = YES;
			break;
		}
	}
	
	if (!insertSuccess) {
		UIImageView *newImageView = [[UIImageView alloc] initWithFrame:CGRectMake(point.x, 0, itemWidth, itemHeight)];
		newImageView.image = image;
		[arrImage addObject:newImageView];
		[self resetView];
        indexo = [arrImage count] - 1;
	}
	return indexo;
}

-(void)clearView{
	for (id view in self.subviews) {
		[view removeFromSuperview];
	}
	[arrImage removeAllObjects];
}

-(void)resetView{
	for (id view in self.subviews) {
		[view removeFromSuperview];
	}
	
	for (NSInteger i = 0; i <[arrImage count]; i++) {
		UIImageView* itemView = [arrImage objectAtIndex:i];
		[UIView animateWithDuration:0.3f animations:^(){
			[itemView setFrame:CGRectMake(PADDING + ((itemView.frame.size.width + PADDING) *i ),
										  itemView.frame.origin.y,
										  itemHeight,
										  itemHeight)];
		}completion:^(BOOL finised){
			[self addSubview:itemView];
		}];
	}
	
	//设置可滑动大小
        self.contentSize = CGSizeMake( PADDING + [arrImage count] * (PADDING + itemWidth) , self.contentSize.height);
}

@end
