//
//  DNullDataView.h
//  DCalendar
//
//  Created by GaoAng on 14-8-13.
//  Copyright (c) 2014年 richinfo.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DNullDataView : UIView

- (instancetype)initWithFrame:(CGRect)frame imageName:(NSString*)imageName;
@property (nonatomic, copy)  void (^didTouchNullDataView)(void);
@end
