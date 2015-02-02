//
//  ButtonSelectControl.m
//  KDSPad
//
//  Created by zhong xl on 11-9-22.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "ButtonSelectControl.h"

#define kSelectFont 14.0f
#define kNomalFont 12.0f

@interface ButtonSelectControl(Private)
- (void)selectAction:(UIButton*)sender;
- (void)addButtonView:(UIButton *)button;
@end

@implementation ButtonSelectControl
@synthesize delegate = delegate_;
@synthesize fSelFontSize = fSelFontSize_;
@synthesize selectColor = selectColor_;
@synthesize normalColor = normalColor_;
@synthesize normalFontSize = normalFontSize_;
@synthesize shade = shade_;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        vertical_ = NO;
        // Initialization code
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame direction:(BOOL)vertical {
    self = [super initWithFrame:frame];
    if (self) {
        buttonArray_ = [[NSMutableArray alloc] init];
        vertical_ = vertical;
        x_ = 0.0f;
        y_ = 0.0f;
        normalFontSize_ = kNomalFont;
        fSelFontSize_ = kSelectFont;
        shade_ = NO;
    }
    return self;
}

- (void)addButton:(UIButton *)button {
    [self addButtonView:button];
    [buttonArray_ addObject:button];
    [button addTarget:self 
               action:@selector(selectAction:) 
     forControlEvents:UIControlEventTouchUpInside];
}

-(void)removeAllObjects {
    for (UIView* view in self.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            [view removeFromSuperview];
        }
    }
    x_ = 0.0f;
    y_ = 0.0f;
    [buttonArray_ removeAllObjects];
}

- (UIButton *)buttonWithIndex:(NSInteger)index {
    if (index < [buttonArray_ count]) {
        return  (UIButton *)[buttonArray_ objectAtIndex:index];
    }
    return nil;
}

#pragma mark -
#pragma mark Private

- (void)addButtonView:(UIButton *)button {
    if ([buttonArray_ count] >0) {
        UIButton *tempButton = nil;
 
        tempButton = [buttonArray_ lastObject];

        CGRect buttonFrame = tempButton.frame;
       
        if (vertical_) {
            y_ +=tempButton.frame.size.height;
            buttonFrame.origin.y = y_;
        } else {
            x_ +=tempButton.frame.size.width;
            buttonFrame.origin.x = x_;
        }
        [button setFrame:buttonFrame];
    }
    [button.titleLabel setFont:[UIFont boldSystemFontOfSize:normalFontSize_]];
    [self addSubview:button];
}


- (void)selectAction:(UIButton*)sender {
    NSInteger selectButtonIndex = [buttonArray_ indexOfObject:sender];
    if (selectButtonIndex != NSNotFound) {
        for (int i=0; i<[buttonArray_ count]; i++) {
            UIButton *button = [buttonArray_ objectAtIndex:i];
            if (i != selectButtonIndex) {
                if (self.normalColor) {
                    [button setTitleColor:self.normalColor forState:UIControlStateNormal];
                }
                [button.titleLabel setFont:[UIFont boldSystemFontOfSize:self.normalFontSize]];
                [button setSelected:NO];
                button.titleLabel.shadowOffset = CGSizeMake(0, 0);
            } else {
                if (self.selectColor) {
                    [button setTitleColor:self.selectColor  forState:UIControlStateSelected];
                    [button setTitleColor:self.selectColor  forState:UIControlStateHighlighted];
                }
                [button.titleLabel setFont:[UIFont boldSystemFontOfSize:self.fSelFontSize]];
                if (shade_) {
//                    button.titleLabel.shadowColor = [UIColor redColor];
//                    button.titleLabel.shadowOffset = CGSizeMake(0, 1);
                } else {
                    button.titleLabel.shadowOffset = CGSizeMake(0, 0);
                }
                [sender setSelected:YES]; 
            }
        }
        if (delegate_ && [(id)delegate_ respondsToSelector:@selector(clickButtonAt:index:)]) {
            [delegate_ clickButtonAt:sender index:selectButtonIndex];
        }
    }
}

- (void)selectAtIndex:(NSInteger)index {
    if (index < [buttonArray_ count]) {
        for (int i=0; i<[buttonArray_ count]; i++) {
            UIButton *button = [buttonArray_ objectAtIndex:i];
            if (i != index) {
                if (self.normalColor) {
                    [button setTitleColor:self.normalColor forState:UIControlStateNormal];
                }
                [button.titleLabel setFont:[UIFont boldSystemFontOfSize:self.normalFontSize]];
                [button setSelected:NO];
                button.titleLabel.shadowOffset = CGSizeMake(0, 0);
            } else {
                if (self.selectColor) {
                    [button setTitleColor:self.selectColor  forState:UIControlStateSelected];
                    [button setTitleColor:self.selectColor  forState:UIControlStateHighlighted];
                }
                [button.titleLabel setFont:[UIFont boldSystemFontOfSize:self.fSelFontSize]];
                if (shade_) {
//                    button.titleLabel.shadowColor = [UIColor redColor];
//                    button.titleLabel.shadowOffset = CGSizeMake(0, 1);
                } else {
//                    button.titleLabel.shadowOffset = CGSizeMake(0, 0);
                }
                [button setSelected:YES]; 
            }
        }
    }
}

- (void)layoutVer:(BOOL)her rect:(CGRect)rect {
    if (her) {
        CGFloat width = 0.0f;
        for (int i=0; i < [buttonArray_ count]; i++) {
            UIButton *button = [buttonArray_ objectAtIndex:i];
            UIImage *buttonImage = nil;
            if (button.selected) {
                buttonImage = [button imageForState:UIControlStateSelected];
            } else {
                buttonImage = [button imageForState:UIControlStateNormal];
            }
            CGSize imageSize = buttonImage.size;
            width += imageSize.width;
        }
        CGFloat space = (rect.size.width - width)/([buttonArray_ count] + 1);
        
        CGFloat x = space;
        for (int i=0; i < [buttonArray_ count]; i++) {
            UIButton *button = [buttonArray_ objectAtIndex:i];
            UIImage *buttonImage = nil;
            if (button.selected) {
                buttonImage = [button imageForState:UIControlStateSelected];
            } else {
                buttonImage = [button imageForState:UIControlStateNormal];
            }
            CGSize imageSize = buttonImage.size;
            [button setFrame:CGRectMake(x, (self.frame.size.height - imageSize.height)/2.0f, imageSize.width, imageSize.height)];
            x +=(imageSize.width + space);
        }
    } else {
       
    }
}

- (void)noChoose {
    for (int i=0; i<[buttonArray_ count]; i++) {
        UIButton *button = [buttonArray_ objectAtIndex:i];
        [button setSelected:NO];
    }
    if (delegate_ && [(id)delegate_ respondsToSelector:@selector(buttonSelectNoChoose)]) {
        [delegate_ buttonSelectNoChoose];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)drawRect:(CGRect)rect{
    
}

- (void)dealloc
{
    self.selectColor = nil;
    self.normalColor = nil;
}

@end
