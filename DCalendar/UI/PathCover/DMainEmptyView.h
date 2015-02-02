//
//  DMainEmptyView.h
//  DCalendar
//
//  Created by GaoAng on 14-7-3.
//  Copyright (c) 2014年 richinfo.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DMainEmptyView : UIView

@property (nonatomic, copy)  void (^didTouchToCreateNewData)(void);
@end
