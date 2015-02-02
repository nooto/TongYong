//
//  DNullDataView.m
//  DCalendar
//
//  Created by GaoAng on 14-8-13.
//  Copyright (c) 2014年 richinfo.cn. All rights reserved.
//

#import "DNullDataView.h"

@implementation DNullDataView

- (instancetype)initWithFrame:(CGRect)frame imageName:(NSString*)imageName
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
		[self setBackgroundColor:[UIColor whiteColor]];
		UIImageView *bgView = [[UIImageView alloc] init];
		if (imageName.length <= 0) {
			[bgView setImage:[UIImage imageNamed:@"empty_Default"]];
		}
		else{
			[bgView setImage:[UIImage imageNamed:imageName]];
		}
		[bgView setFrame:CGRectMake(0,0, bgView.image.size.width, bgView.image.size.height)];
//		
//		bgView.center = CGPointMake(self.center.x, self.center.y - bgView.image.size.height/2);
		[self addSubview:bgView];
    }
    return self;
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
	[super touchesEnded:touches withEvent:event];
	if (self.didTouchNullDataView) {
		self.didTouchNullDataView();
	}
}
@end

