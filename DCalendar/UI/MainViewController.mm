//
//  ViewController.m
//  MultiLayerNavigation
//
//  Created by Feather Chan on 13-4-12.
//  Copyright (c) 2013年 Feather Chan. All rights reserved.
//

#import "MainViewController.h"
#import "CAppDelegate.h"
#import "CTestViewController.h"

@interface MainViewController ()
@property (nonatomic, weak) DPopoverView  *popoverView;
@property(nonatomic, strong) UIButton  *todayBtn;
@property(nonatomic, strong) UIButton  *createBtn;
@property (nonatomic, strong) NSMutableArray *arrEvent;
@end

@implementation MainViewController
@synthesize todayBtn, createBtn;
@synthesize arrEvent;
//@synthesize unReadNumBtn;
@synthesize popoverView;

-(NSMutableArray*)arrEvent{
	if (arrEvent == nil) {
		arrEvent = [[NSMutableArray alloc] initWithCapacity:1];
	}
	return arrEvent;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    todayBtn = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    todayBtn.backgroundColor = [UIColor redColor];
    [todayBtn addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:todayBtn];
}

-(void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	[self.navigationController.navigationBar setHidden:YES];
}
-(void)buttonAction{
    CTestViewController *vc = [[CTestViewController alloc] init];
    [self pushToViewControllerCustom:vc animated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
