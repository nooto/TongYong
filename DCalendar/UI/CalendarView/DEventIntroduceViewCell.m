//
//  DEventIntroduceViewCell.m
//  DCalendar
//
//  Created by GaoAng on 14-6-16.
//  Copyright (c) 2014年 richinfo.cn. All rights reserved.
//

#define ITEMGAP 15

#import "DEventIntroduceViewCell.h"
#import "DEventIntroduceViewCell+Cache.h"


@interface DEventIntroduceViewCell ()<UIGestureRecognizerDelegate>
@property (nonatomic, strong) UITapGestureRecognizer *longPressGestureRecognizer;
@end
@implementation DEventIntroduceViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

-(void)dealloc{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(NSMutableArray*)arrImageContent{
	if (_arrImageContent == nil) {
		_arrImageContent = [[NSMutableArray alloc] initWithCapacity:1];
	}
	return _arrImageContent;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(UITapGestureRecognizer*)longPressGestureRecognizer{
    if (_longPressGestureRecognizer == nil) {
        _longPressGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGestureRecognizer:)];
        [_longPressGestureRecognizer setDelegate:self];
//        [_longPressGestureRecognizer setMinimumPressDuration:0.1];
    }
    return _longPressGestureRecognizer;
}

/**
 *  新建活动
 *
 *  @param arr   <#arr description#>
 *  @param gid   <#gid description#>
 *  @param isGet <#isGet description#>
 *
 *  @return <#return value description#>
 */
-(CGFloat)loadCellFramContent:(NSMutableArray*)arr withGid:(NSString*)gid hight:(BOOL)isGet{
    isCreateViewCell = YES;
    if (!isGet) {
        for (UIView *view in self.contentView.subviews) {
            [view removeFromSuperview];
        }
    }
    CGFloat framHight = GAPX;;
    
    
    if ([arr count] <= 0) {
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(16, 11, 25, 25)];
        image.image = [UIImage imageNamed:@"introduce"];
        [self.contentView addSubview:image];
        
        UILabel *titelLabe = [[UILabel alloc] init];
        [titelLabe setText:@"活动介绍"];
        [titelLabe setFrame:CGRectMake(image.frame.origin.x+image.frame.size.width+13, 10, 100, 30)];
        [titelLabe setTextColor:[Utility colorFromColorString:@"#96a0ac"]];
        titelLabe.textAlignment = NSTextAlignmentLeft;
        [titelLabe setFont:[UIFont systemFontOfSize:14.f]];
        if (!isGet) {
            [self.contentView addSubview:titelLabe];
        }
        framHight += titelLabe.frame.size.height+ ITEMGAP;
    }
    
    //
    for (NSInteger i = 0; i < [arr count]; i++) {
        id item = (DEventContent*)[arr objectAtIndex:i];
        if ([item isKindOfClass:[DEventContent class]]) {
            DEventContent *content =(DEventContent*)item;
            if (content.type == 1) {
                if ([content.ctx count] > 0) {
                    Ctx *ctxItem =(Ctx*) [content.ctx objectAtIndex:0];
                    if (ctxItem.val.length > 0) {
                        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, framHight, 320 - 16*2, 200)];
                        [textLabel setText:ctxItem.val];
                        [textLabel setFont:[UIFont systemFontOfSize:14]];
                        [textLabel setUserInteractionEnabled:NO];
                        CGSize size = [ctxItem.val boundingRectWithSize:CGSizeMake(300, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:textLabel.font} context:nil].size;
                        textLabel.numberOfLines = ceilf(size.height/textLabel.font.lineHeight);
                        textLabel.frame = CGRectMake(textLabel.frame.origin.x, textLabel.frame.origin.y, textLabel.frame.size.width, size.height);
                        if (!isGet) {
                            [self.contentView addSubview:textLabel];
                        }
                        [textLabel setBackgroundColor:[UIColor clearColor]];
                        framHight = framHight + textLabel.frame.size.height+ ITEMGAP;
                    }
                }
            }
            else if (content.type == 2) {
                for (NSInteger i = 0; i < [content.ctx count]; i++) {
                    
                    UIImageView *imageView = [[UIImageView alloc] init];
                    [imageView setFrame:CGRectMake(16, framHight, 300, 40)];
                    
                    Ctx *ctxItem = (Ctx*)[content.ctx objectAtIndex:i];
                    UIImage *locimage= [DFileManager queryImageByGid:gid withName:ctxItem.val];
                    if (locimage) {
                        CGSize imageSize = [self contrainSize:CGSizeMake(300.f, 200.f) image:locimage];
                        imageView.frame = CGRectMake((ScreenWidth - imageSize.width)/2, framHight + 10, imageSize.width, imageSize.height);
                        [imageView setImage:locimage];
                    }
                    else{
                        NSString *urlStr = [NSString stringWithFormat:IMAGESERVERURL,ctxItem.val];
                        NSURL *URL= [NSURL URLWithString:urlStr];
                        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
                        [imageView setImageWithURLRequest:request placeholderImage:[UIImage imageNamed:@"上传失败-默认图片"]
                                                  success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                      [DFileManager saveImageByGid:gid withName:ctxItem.val image:image];
                                                      [self reloadCreateViewCellRow];
                                                  }
                                                  failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                                  }];
                    }
                    
                    if (!isGet) {
                        [self.contentView addSubview:imageView];
                    }
                    framHight = framHight + imageView.frame.size.height + ITEMGAP;
                }
            }
        }
    }
    framHight = framHight + ITEMGAP;
    return framHight;
}

- (void)reloadCreateViewCellRow
{
    UITableView *superView = (UITableView *)self.superview;
    if ([superView isKindOfClass:[UITableView class]]) {
        [superView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[superView indexPathForCell:self]] withRowAnimation:UITableViewRowAnimationMiddle];
    }
    else{
        UITableView *superspuerView = (UITableView*)superView.superview;
        if ([superspuerView isKindOfClass:[UITableView class]]) {
            NSIndexPath *temPindex = [superspuerView indexPathForCell:self];
            NSLog(@"%@ %d %d", temPindex, temPindex.section, temPindex.row);
            if (temPindex &&  temPindex.section == 4 && temPindex.row == 0) {
                [superspuerView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[superspuerView indexPathForCell:self]] withRowAnimation:UITableViewRowAnimationNone];
            }
        }
    }
}

/**
 *  详情
 *
 *  @param arr   <#arr description#>
 *  @param gid   <#gid description#>
 *  @param isGet <#isGet description#>
 *
 *  @return <#return value description#>
 */
-(CGFloat)detailCellFramContent:(NSMutableArray*)arr withGid:(NSString*)gid hight:(BOOL)isGet{
    isCreateViewCell = NO;
    if (!isGet) {
        for (UIView *view in self.contentView.subviews) {
            [view removeFromSuperview];
        }
    }
    
    
    if (self.longPressGestureRecognizer != nil && isCreateViewCell == NO) {
        [self.contentView addGestureRecognizer:self.longPressGestureRecognizer];
    }
    //
	CGFloat framHight = GAPX;;
	if (!isGet) {
        UILabel *topLine = [[UILabel alloc] initWithFrame:CGRectMake(16, 1, ScreenWidth - 16*2, 0.5)];
        topLine.layer.cornerRadius = 1.0f;
        [topLine setBackgroundColor:[Utility cellDevideLineColor]];
		[self.contentView addSubview:topLine];;
	}
	
	if (!isGet) {
        UILabel *lineLabel = [[UILabel alloc] init];
        [lineLabel setFrame:CGRectMake(16, 15, 2, 13)];
        [lineLabel setBackgroundColor:[Utility colorFromColorString:@"56cc56"]];

        [self.contentView addSubview:lineLabel];
	}
	framHight = framHight + 13 + ITEMGAP;
	
	if (!isGet) {
        UILabel *titelLabe = [[UILabel alloc] init];
        [titelLabe setText:@"活动介绍"];
        [titelLabe setFrame:CGRectMake(23, 5, 100, 30)];
        [titelLabe setTextColor:[Utility colorFromColorString:@"56cc56"]];
        titelLabe.textAlignment = NSTextAlignmentLeft;
        [titelLabe setFont:[UIFont systemFontOfSize:14.f]];
		[self.contentView addSubview:titelLabe];
	}
	
	//空内容显示  无内容。
	if ([arr count] <= 0) {
        
        UIFont *tempfont = [UIFont systemFontOfSize:14];
        NSString *text = @"无内容";
        CGSize size = [text boundingRectWithSize:CGSizeMake(300, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:tempfont} context:nil].size;

		if (!isGet) {
            UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, framHight, 300, 200)];
            [textLabel setText:text];
            [textLabel setFont:tempfont];
            [textLabel setUserInteractionEnabled:NO];
            textLabel.numberOfLines = ceilf(size.height/textLabel.font.lineHeight);
            textLabel.frame = CGRectMake(textLabel.frame.origin.x, textLabel.frame.origin.y, textLabel.frame.size.width, size.height);
			[self.contentView addSubview:textLabel];
            [textLabel setBackgroundColor:[UIColor clearColor]];
		}
        
		framHight = framHight + size.height+ ITEMGAP;
	}
	
	
	for (NSInteger i = 0; i < [arr count]; i++) {
		id item = (DEventContent*)[arr objectAtIndex:i];
		if ([item isKindOfClass:[DEventContent class]]) {
			DEventContent *content =(DEventContent*)item;
			if (content.type == 1) {
				if ([content.ctx count] > 0) {
					Ctx *ctxItem =(Ctx*) [content.ctx objectAtIndex:0];
					
                    if (ctxItem.val.length > 0) {
                        
                        UIFont*tempFont = [UIFont systemFontOfSize:14];
                        CGSize size = [ctxItem.val boundingRectWithSize:CGSizeMake(300, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:tempFont} context:nil].size;
                        CGFloat   labelNewHight = size.height;
                        if (!isGet) {
                            UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, framHight+3, 300, 200)];
                            [textLabel setText:ctxItem.val];
                            [textLabel setFont:tempFont];
                            [textLabel setUserInteractionEnabled:NO];
                            textLabel.numberOfLines = ceilf(size.height/textLabel.font.lineHeight);
                            textLabel.frame = CGRectMake(textLabel.frame.origin.x, textLabel.frame.origin.y, textLabel.frame.size.width, labelNewHight);
                            [textLabel setBackgroundColor:[UIColor clearColor]];
                            [self.contentView addSubview:textLabel];
                        }
                        
                        framHight = framHight + labelNewHight+ ITEMGAP;
                    }
                }
			}
			else if (content.type == 2) {
				for (NSInteger i = 0; i < [content.ctx count]; i++) {
                    Ctx *ctxItem = (Ctx*)[content.ctx objectAtIndex:i];
                    NSString *imageName = ctxItem.val;
                    UIImageView *imageView = [self imageViewWithGid:gid name:imageName originY:framHight];
					if (!isGet) {
                        imageView.tag = 1;
						[self.contentView addSubview:imageView];
					}
					framHight = framHight + imageView.frame.size.height + ITEMGAP;
                }
            }
        }
	}
    framHight = framHight + ITEMGAP;
	return framHight;
}

- (void)reloadDetailViewCellRow
{
    id superView = (UIView *)self.superview;
    if ([superView isKindOfClass:[UITableView class]]) {
        
        UITableView*  tableView = (UITableView*)superView;
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[superView indexPathForCell:self]] withRowAnimation:UITableViewRowAnimationMiddle];
    }
    else{
        id superspuerView = (UIView *)self.superview.superview;
        if ([superspuerView isKindOfClass:[UITableView class]]) {
            
            UITableView*  tableView = (UITableView*)superspuerView;

            NSIndexPath *temPindex = [superspuerView indexPathForCell:self];
            if ( temPindex &&  temPindex.section == 3 && temPindex.row == 0) {
                [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[tableView indexPathForCell:self]] withRowAnimation:UITableViewRowAnimationNone];
            }
        }
    }
}
- (void)longPressGestureRecognizer:(UITapGestureRecognizer *)longPressGestureRecognizer {
if (longPressGestureRecognizer.state == UIGestureRecognizerStateEnded) {
    
    CGPoint currentPoint = [longPressGestureRecognizer locationInView:self.contentView];
    if (!isCreateViewCell) {
        if (self.didPreviewImage) {

            [self.arrImageContent removeAllObjects];
            NSInteger selIndex = 0;
            BOOL showPres = NO;
            for (UIView *item in self.contentView.subviews) {
                if ([item isKindOfClass:[UIImageView class]]) {
                    UIImageView* imageView = (UIImageView*)item;
                    //记录选中的图片 index 并标记 显示预览
                    if (CGRectContainsPoint(imageView.frame, currentPoint)) {
                         selIndex = [self.arrImageContent count];
                        showPres =YES;
                    }
                    //0 表示未获取到图片  是默认的图片。
                    if (imageView.tag == 0) {
                        [self.arrImageContent addObject:[UIImage imageNamed:@"全屏看图-默认"]];
                    }
                    else{
                        [self.arrImageContent addObject:imageView.image];
                    }
                }
            }
            if (showPres &&  [self.arrImageContent count] > 0 && selIndex < [self.arrImageContent count]) {
                self.didPreviewImage(self.arrImageContent, selIndex);
            }
        }
    }
}
    
}

@end
