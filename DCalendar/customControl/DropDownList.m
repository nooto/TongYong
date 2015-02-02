//
//  NIDropDown.m
//  NIDropDown
//
//  Created by Bijesh N on 12/28/12.
//  Copyright (c) 2012 Nitor Infotech. All rights reserved.
//

#import "DropDownList.h"
#import "QuartzCore/QuartzCore.h"

#define Heigh_cell 44
#define tag_left    2014
#define tag_right   2015

@interface DropDownListView ()<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong) UITableView *mTable;
@property(nonatomic, strong) UIButton *btnSender;
@property(nonatomic, strong, readwrite) NSArray *mList;

@property(nonatomic, assign) CGRect mFrame;

@end

@implementation DropDownListView

- (id)initDropDownListView:(UIButton *)b source:(NSArray *)arr {
    self = [super init];
    if (self) {
        // Initialization code
        _btnSender = b;
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
//        _mFrame = b.frame;
        float navBarHight = [Utility getNavBarHight];
        _mFrame = CGRectMake(0, [Utility getNavBarHight], ScreenWidth, ScreenHeight-navBarHight);//Heigh_cell*arr.count
        self.frame = _mFrame;//CGRectMake(_mFrame.origin.x, _mFrame.origin.y, _mFrame.size.width, 0);
        self.mList = [NSArray arrayWithArray:arr];
//        self.layer.masksToBounds = NO;
//        self.layer.cornerRadius = 8;
//        self.layer.shadowOffset = CGSizeMake(-5, 5);
//        self.layer.shadowRadius = 5;
//        self.layer.shadowOpacity = 0.5;
        
        UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, _mFrame.size.width, 0)];
        table.delegate = self;
        table.dataSource = self;
//        table.layer.cornerRadius = 5;
//        table.backgroundColor = [UIColor colorWithRed:0.239 green:0.239 blue:0.239 alpha:1];
        table.separatorStyle = UITableViewCellSeparatorStyleNone;
//        table.separatorColor = [Utility cellDevideLineColor];
        _mTable = table;
        
        self.alpha = 0;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:ANIMATIONDURATION/2];
        self.alpha = 1;
//        self.frame = _mFrame;
        float total = Heigh_cell*arr.count;
        if (total > _mFrame.size.height) {
            total = _mFrame.size.height;
        }
        _mTable.frame = CGRectMake(0, 0, _mFrame.size.width, total);
        [UIView commitAnimations];
        
//        [b.superview addSubview:self];
//        [_btnSender setTitle:[arr firstObject] forState:UIControlStateNormal];
        [self addSubview:table];
    }
    return self;
}

-(void)hideDropDownListView {
    CGRect tframe = _mTable.frame;
    self.alpha = 1;
//    ROOTVIEW.view.userInteractionEnabled = NO;
    [UIView animateWithDuration:ANIMATIONDURATION/2 animations:^{
//        self.frame = CGRectMake(tframe.origin.x, tframe.origin.y, tframe.size.width, 0);
        _mTable.frame = CGRectMake(0, 0, tframe.size.width, 0);
        self.alpha = 0;
    }completion:^(BOOL finished) {
//        ROOTVIEW.view.userInteractionEnabled = YES;
        [self removeFromSuperview];
    }];
}

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return 1;
//}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return Heigh_cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _mList.count;
}   

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"showDropDownListViewCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//        cell.textLabel.font = [UIFont systemFontOfSize:14];
//        cell.textLabel.textColor = [Utility colorFromColorString:@"#333333"];
//        cell.textLabel.textAlignment = NSTextAlignmentCenter;

        UILabel *leftLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 100, 44)];
        leftLab.font = [UIFont systemFontOfSize:14];
        leftLab.textColor = [Utility colorFromColorString:@"#333333"];
        leftLab.tag = tag_left;
        [cell.contentView addSubview:leftLab];
        
        UILabel *rightLab = [[UILabel alloc] initWithFrame:CGRectMake(115, 0, ScreenWidth-70, 44)];
        rightLab.font = leftLab.font;
        rightLab.textColor = leftLab.textColor;
        rightLab.tag = tag_right;
        [cell.contentView addSubview:rightLab];
        
        UIView *line =  [[UIView alloc] initWithFrame:CGRectMake(0 , 43.5, ScreenWidth, 0.5)];
        [line setBackgroundColor:[Utility cellDevideLineColor]];
        [cell.contentView addSubview:line];
    }

    if(_mList.count >indexPath.row){
        NSString *str = [_mList objectAtIndex:indexPath.row];
        NSArray *arr = [str componentsSeparatedByString:@":"];
        UILabel *left = (UILabel *)[cell.contentView viewWithTag:tag_left];
        left.text = [arr firstObject];
        UILabel *right = (UILabel *)[cell.contentView viewWithTag:tag_right];
        right.text = [arr lastObject];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self hideDropDownListView];
//    UITableViewCell *c = [tableView cellForRowAtIndexPath:indexPath];

    if (_selectBlock) {
        _selectBlock(indexPath.row);
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self hideDropDownListView];
    if (_selectBlock) {
        _selectBlock(-1);
    }
    /*
    
    //    NSSet *allTouches = [event allTouches];    //返回与当前接收者有关的所有的触摸对象
    //    UITouch *touch = [allTouches anyObject];   //视图中的所有对象
    UITouch *touch = [touches anyObject];
    NSUInteger tapCount = touch.tapCount;
    switch (tapCount) {
        case 1:{
            CGPoint point = [touch locationInView:self]; //返回触摸点在视图中的当前坐标
            CGFloat h = _mTable.frame.origin.y +_mTable.frame.size.height;
            if (h < point.y) {
                if (_selectBlock) {
                    _selectBlock(-1);
                }
            }
        }
            break;
        default:
            break;
    }*/
    [[self nextResponder] touchesEnded:touches withEvent:event];
}

@end
