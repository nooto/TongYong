//
//  DEventIntroduceViewCell+Cache.h
//  DCalendar
//
//  Created by hunanldc on 14-10-16.
//  Copyright (c) 2014年 richinfo.cn. All rights reserved.
//

#import "DEventIntroduceViewCell.h"

@interface DEventIntroduceViewCell (Cache)

- (UIImageView *)imageViewWithGid:(NSString *)gid name:(NSString *)imageName originY:(CGFloat)framHight;



- (CGSize)contrainSize:(CGSize)maxSize image:(UIImage *)image;

@end
