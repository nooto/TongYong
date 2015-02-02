//
//  DEventIntroduceViewCell.h
//  DCalendar
//
//  Created by GaoAng on 14-6-16.
//  Copyright (c) 2014年 richinfo.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "../../NetWork/UIKit+AFNetworking/UIImageView+AFNetworking.h"
#import "DescribeView/shotImage/CXImage.h"
#import "../../common/DLocalFileManager.h"
@interface DEventIntroduceViewCell : UITableViewCell{
    BOOL isCreateViewCell;
}

@property (nonatomic, strong) NSMutableArray *arrImageContent;
@property (copy, nonatomic) void (^didPreviewImage)(NSMutableArray*, NSInteger);

-(CGFloat)loadCellFramContent:(NSMutableArray*)arr withGid:(NSString*)gid hight:(BOOL)isGet;
-(CGFloat)detailCellFramContent:(NSMutableArray*)arr withGid:(NSString*)gid hight:(BOOL)isGet;

- (void)reloadDetailViewCellRow;

@end
