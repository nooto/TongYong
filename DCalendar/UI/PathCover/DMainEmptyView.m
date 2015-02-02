//
//  DMainEmptyView.m
//  DCalendar
//
//  Created by GaoAng on 14-7-3.
//  Copyright (c) 2014年 richinfo.cn. All rights reserved.
//

#import "DMainEmptyView.h"

@implementation DMainEmptyView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
		[self setBackgroundColor:[UIColor whiteColor]];
		UIImageView *bgView = [[UIImageView alloc] init];
		[bgView setFrame:CGRectMake((ScreenWidth-142)/2, 100, 142, 43)];
		[bgView setImage:[UIImage imageNamed:@"empty_Default"]];
		[self addSubview:bgView];
    }
    return self;
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
	[super touchesEnded:touches withEvent:event];
	self.didTouchToCreateNewData();
}
@end
