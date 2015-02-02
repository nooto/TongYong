//
//  DMainViewTableViewCell.h
//  DCalendar
//
//  Created by GaoAng on 14-7-2.
//  Copyright (c) 2014年 richinfo.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DMainViewTableViewCell : UITableViewCell


-(void)loadDataWithEventData:(DEventData*)curData lastEventData:(DEventData*)lastData isLastRow:(BOOL)islast;
@end
