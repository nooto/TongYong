//
//  NIDropDown.h
//  NIDropDown
//
//  Created by Bijesh N on 12/28/12.
//  Copyright (c) 2012 Nitor Infotech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DropDownListView : UIView

@property (nonatomic, copy)void (^selectBlock)(NSInteger index);


- (id)initDropDownListView:(UIButton *)b source:(NSArray *)arr;
- (void)hideDropDownListView;

@end
