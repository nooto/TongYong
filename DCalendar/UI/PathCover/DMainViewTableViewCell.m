//
//  DMainViewTableViewCell.m
//  DCalendar
//
//  Created by GaoAng on 14-7-2.
//  Copyright (c) 2014年 richinfo.cn. All rights reserved.
//

#import "DMainViewTableViewCell.h"

@interface DMainViewTableViewCell ()
@property (nonatomic, strong) UILabel *monthLabel;
@property (nonatomic, strong) UILabel *dayLabel;
@property (nonatomic, strong) UILabel *linelabel;
@property (nonatomic, strong) UIImageView *typeImage;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIImageView *invateImage;
@property (nonatomic, strong) UIButton *yearGapButton;

@property (nonatomic, strong) UILabel *separatorTopLineLabel;


@property (nonatomic, strong) UILabel *separatorBottomLineLabel;

@end


@implementation DMainViewTableViewCell
@synthesize monthLabel, dayLabel, linelabel, typeImage, titleLabel, timeLabel, invateImage;
@synthesize separatorTopLineLabel, separatorBottomLineLabel, yearGapButton;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
		
        CGSize leftSize = CGSizeMake(60, 56); // 内容居中显示
        CGSize typeImageSize = CGSizeMake(26, 26);
        
		monthLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, (leftSize.height - 30)/2, leftSize.width - typeImageSize.width/2, 15)];
		[monthLabel setTextAlignment:NSTextAlignmentCenter];
		[monthLabel setFont:[UIFont systemFontOfSize:12]];
        monthLabel.textColor = [UIColor colorWithRed:200./255. green:200./255. blue:200./255. alpha:1];
		[monthLabel setBackgroundColor:[UIColor clearColor]];
		[self.contentView addSubview:monthLabel];
		
		dayLabel = [[UILabel alloc] initWithFrame:CGRectMake(monthLabel.frame.origin.x, CGRectGetMaxY(monthLabel.frame), monthLabel.frame.size.width, 15)];
		[dayLabel setTextAlignment:NSTextAlignmentCenter];
		[dayLabel setFont:[UIFont boldSystemFontOfSize:16]];
		[dayLabel setBackgroundColor:[UIColor clearColor]];
		[self.contentView addSubview:dayLabel];
		//
		linelabel = [[UILabel alloc] initWithFrame:CGRectMake(leftSize.width, 0, 1, leftSize.height)];
		[linelabel setBackgroundColor:[Utility cellDevideLineColor]];
		[self.contentView addSubview:linelabel];
		
		typeImage = [[UIImageView alloc] initWithFrame:CGRectMake(leftSize.width, (leftSize.height - typeImageSize.width)/2, typeImageSize.width, typeImageSize.width)];
		typeImage.center = linelabel.center;
		[typeImage setImage:[UIImage imageNamed:@"其它"]];
		[self.contentView addSubview:typeImage];
		
		//
		titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(typeImage.frame) + 10.f, (leftSize.height - 40.f)/2, 220, 20)];
		[titleLabel setText:@"去活动去爬山，去徒步"];
		[titleLabel setFont:[UIFont boldSystemFontOfSize:14.5]];
		[titleLabel setBackgroundColor:[UIColor clearColor]];
		[self.contentView addSubview:titleLabel];
		
		timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleLabel.frame.origin.x, CGRectGetMaxY(titleLabel.frame), CGRectGetWidth(titleLabel.frame)-20, 20)];
		[timeLabel setFont:[UIFont systemFontOfSize:12]];
		[timeLabel setBackgroundColor:[UIColor clearColor]];
		[self.contentView addSubview:timeLabel];
		
		invateImage = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth - 50, timeLabel.frame.origin.y-5, 15, 15)];
		[invateImage setImage:[UIImage imageNamed:@"sponsor"]];
		[self.contentView addSubview:invateImage];
		
		separatorTopLineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 1)];
		[separatorTopLineLabel setBackgroundColor:linelabel.backgroundColor];
		[self.contentView addSubview:separatorTopLineLabel];
		
//		separatorBottomLineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 49, ScreenWidth, 1)];
//		[separatorBottomLineLabel setBackgroundColor:separatorTopLineLabel.backgroundColor];
//		[self.contentView addSubview:separatorBottomLineLabel];

		yearGapButton = [[UIButton alloc] initWithFrame:CGRectMake(10, -5, 40, 10)];
		[yearGapButton setEnabled:NO];
		[yearGapButton.titleLabel setFont:[UIFont systemFontOfSize:8]];
		[yearGapButton.titleLabel setTextAlignment:NSTextAlignmentLeft];
		[yearGapButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
		[yearGapButton setTitle:@"2014" forState:UIControlStateDisabled];
		[yearGapButton setBackgroundImage:[UIImage imageNamed:@"主界面-年度轴"] forState:UIControlStateDisabled];
		[self.contentView addSubview:yearGapButton];

        
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)loadDataWithEventData:(DEventData*)curData lastEventData:(DEventData*)lastData isLastRow:(BOOL)islast{
	if (curData == nil) {
		return;
	}
	
	//月 日。。标签。
	NSCalendar *calendar = [NSCalendar currentCalendar];

	//当前活动
	NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:curData.dtStart];
	NSDateComponents *component = [calendar components:NSCalendarUnitMonth|NSCalendarUnitYear| NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute fromDate:startDate];
	
	if (lastData) {
		NSDate *lastStartDate = [NSDate dateWithTimeIntervalSince1970:lastData.dtStart];
        if ([[NSDate date] timeIntervalSince1970] > [lastStartDate timeIntervalSince1970]) {
            timeLabel.textColor = titleLabel.textColor = [UIColor colorWithRed:200./255. green:200./255. blue:200./255. alpha:1];
        }else {
            timeLabel.textColor = titleLabel.textColor = [UIColor blackColor];
        }
        
		NSDateComponents *lastComponent = [calendar components:NSCalendarUnitMonth|NSCalendarUnitYear| NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute fromDate:lastStartDate];
		if (lastComponent.year == component.year &&
			lastComponent.month == component.month &&
			lastComponent.day == component.day) {
			[monthLabel setHidden:YES];
			[dayLabel setHidden:YES];
			
			[separatorTopLineLabel setFrame:CGRectMake(linelabel.frame.origin.x, 0, ScreenWidth -CGRectGetWidth(linelabel.frame), 1)];
		}
		else{
			[monthLabel setHidden:NO];
			[dayLabel setHidden:NO];
			[separatorTopLineLabel setFrame:CGRectMake(0, 0, ScreenWidth, 1)];
		}
		
		//年度轴
		if (lastComponent.year != component.year) {
			[yearGapButton setHidden:NO];
		}
		else{
			[yearGapButton setHidden:YES];
		}
	}
	else{
		[yearGapButton.titleLabel setText:[NSString stringWithFormat:@"%d",component.year]];
		[yearGapButton setHidden:YES];
		[monthLabel setHidden:NO];
		[dayLabel setHidden:NO];
	}
	
	
	[monthLabel setText:[NSString stringWithFormat:@"%d月",component.month]];
	NSTimeInterval val =[[NSDate date] timeIntervalSince1970];
	NSInteger temp1 = val / (60 * 60 * 24);
	NSInteger temp2 = curData.dtStart /(60 * 60 * 24);
	if (temp1 == temp2){
		[dayLabel setText:@"今天"];
	}
	else{
		[dayLabel setText:[NSString stringWithFormat:@"%d",component.day]];
	}

	//
	typeImage.image = [Utility getImageByEventType:curData.eventType];
	
	[titleLabel setText:curData.title];
	[timeLabel setText:[NSString stringWithFormat:@"%02d:%02d",component.hour, component.minute]];
	
	
	if ([curData.inviterInfo count]> 1) {
		[invateImage setHidden:NO];
	}
	else{
		[invateImage setHidden:YES];
	}
	
	
	
	[separatorBottomLineLabel setHidden:!islast];
}

@end
