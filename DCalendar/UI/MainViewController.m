//
//  ViewController.m
//  MultiLayerNavigation
//
//  Created by Feather Chan on 13-4-12.
//  Copyright (c) 2013年 Feather Chan. All rights reserved.
//

#import "MainViewController.h"
#import "DInviteViewController.h"

@interface MainViewController (){
	NSInteger m_pageFlag;
	double m_Version;
	
	NSInteger m_MessagePageFlag;
	NSInteger m_MessageID;

}
@property (nonatomic, weak) DPopoverView  *popoverView;
@property (nonatomic, strong) XHPathCover *pathCover;
@property(nonatomic, strong) UIButton  *todayBtn;
@property(nonatomic, strong) UIButton  *createBtn;
@property(nonatomic, strong) UIButton  *unReadNumBtn;
@property (nonatomic, strong) UITableView *activieylistView;
@property (nonatomic, strong) NSMutableArray *arrEvent;
@property (nonatomic, strong) DMainEmptyView *emptyView;
@end

@implementation MainViewController
@synthesize todayBtn, createBtn;
@synthesize activieylistView;
@synthesize arrEvent;
@synthesize emptyView;
@synthesize unReadNumBtn;
@synthesize popoverView;

-(NSMutableArray*)arrEvent{
	if (arrEvent == nil) {
		arrEvent = [[NSMutableArray alloc] initWithCapacity:1];
	}
	
	if ([arrEvent count] > 0) {
		[self isNeedShowEmptyView:NO];
	}
	else{
		[self isNeedShowEmptyView:YES];
	}
	
	return arrEvent;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	self.showNetWorkingAnimated = NO;
	
	//日期
	UIButton  *timeBtn = [[UIButton alloc] initWithFrame:CGRectMake(-10, 10, 80, 44)];
	[timeBtn setBackgroundColor:[UIColor clearColor]];
	[timeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[timeBtn setTitle:@"小D活动" forState:UIControlStateNormal];
    timeBtn.titleLabel.font = [UIFont systemFontOfSize:20.9f];
	[timeBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
	timeBtn.tag = MV_Btn_time_Tag;
	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:timeBtn];
	
	
	//
	CGFloat gap = 0;
	UIView* buttonView = [[UIView alloc] initWithFrame:CGRectMake(0, -2.5, 150, 50)];
	[buttonView setBackgroundColor:[UIColor clearColor]];
	
	//按钮
	createBtn = [[UIButton alloc] initWithFrame:CGRectMake(30, 0, 45, 50)];
	[createBtn setBackgroundColor:[UIColor clearColor]];
	[createBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[createBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
	createBtn.tag = MV_Btn_create_tag;
	[createBtn setImage:[UIImage imageNamed:@"ic_create_sel"] forState:UIControlStateNormal];
	[createBtn setImage:[UIImage imageNamed:@"ic_create_nor"] forState:UIControlStateHighlighted];
	[buttonView addSubview:createBtn];
	
	UIButton  *msgboxBtn = [[UIButton alloc] initWithFrame:CGRectMake(createBtn.frame.origin.x + createBtn.frame.size.width+ gap,
																	  createBtn.frame.origin.y,
																	  createBtn.frame.size.width,
																	  createBtn.frame.size.height)];
    
	[msgboxBtn setBackgroundColor:[UIColor clearColor]];
	[msgboxBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[msgboxBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
	[msgboxBtn setImage:[UIImage imageNamed:@"ic_msg_nor"] forState:UIControlStateNormal];
	[msgboxBtn setImage:[UIImage imageNamed:@"ic_msg_sel"] forState:UIControlStateHighlighted];
	msgboxBtn.tag = MV_Btn_msgbox_tag;
	[buttonView addSubview:msgboxBtn];
	
    unReadNumBtn = [[UIButton alloc] initWithFrame:CGRectMake(msgboxBtn.frame.origin.x+25, msgboxBtn.frame.origin.y + 10, 15, 12)];
    unReadNumBtn.tag = MV_Btn_unreadmsg_tag;
    [unReadNumBtn setUserInteractionEnabled:NO];
	[unReadNumBtn.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [unReadNumBtn.titleLabel setFont:[UIFont systemFontOfSize:8]];
    [buttonView addSubview:unReadNumBtn];
    
    //设置按钮
	UIButton  *moreButton = [[UIButton alloc] initWithFrame:CGRectMake(msgboxBtn.frame.origin.x + msgboxBtn.frame.size.width+ gap,
																	  msgboxBtn.frame.origin.y,
																	  msgboxBtn.frame.size.width,
																	  msgboxBtn.frame.size.height)];
	[moreButton setBackgroundColor:[UIColor clearColor]];
	moreButton.tag = MV_Btn_More_tag;
	[moreButton  setBackgroundImage:[UIImage imageNamed:@"detail_more_nor"] forState:UIControlStateNormal];
	[moreButton  setBackgroundImage:[UIImage imageNamed:@"detail_more_sel"] forState:UIControlStateHighlighted];
	[moreButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
	[buttonView addSubview:moreButton];

	
	
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:buttonView];

	
	todayBtn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth-80,
														  ScreenHeight - 80,50,50)];
	if (![Utility isSystemVersionSeven]) {
		[todayBtn setFrame:CGRectMake(ScreenWidth-80, ScreenHeight - 80 - 64,50,50)];
	}
	
	[todayBtn setBackgroundColor:MainTitleBgColor];
	[todayBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
	[todayBtn setImage:[UIImage imageNamed:@"ic_today_nor"] forState:UIControlStateNormal];
	[todayBtn setImage:[UIImage imageNamed:@"ic_today_sel"] forState:UIControlStateHighlighted];
	todayBtn.tag = MV_Btn_today_Tag;
	[self.view addSubview:todayBtn];
	
	
	//设置按钮
	UIButton  *refeshbtn = [[UIButton alloc] initWithFrame:CGRectMake(0,ScreenHeight - 50,50,50)];
	[refeshbtn setBackgroundColor:[UIColor redColor]];
	[refeshbtn setTitle:@"刷新" forState:UIControlStateNormal];
	[refeshbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[refeshbtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
	refeshbtn.tag = 100;
	[self.view addSubview:refeshbtn];
	
	
	//活动列表页面
	activieylistView = [[UITableView alloc] initWithFrame:CGRectMake(0,
																	 [Utility getNavBarHight],
																	 ScreenWidth,
																	 ScreenHeight - [Utility getNavBarHight])];
	activieylistView.delegate = self;
	activieylistView.dataSource = self;
	if ([Utility isSystemVersionSeven]) {
		activieylistView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
	}
	activieylistView.separatorStyle = UITableViewCellSeparatorStyleNone;
	[activieylistView setBackgroundColor:[UIColor whiteColor]];
	
    UIImage *coverImage = [UIImage imageNamed:@"default_main"];
    CGFloat height = self.view.bounds.size.width/coverImage.size.width * coverImage.size.height;
	_pathCover = [[XHPathCover alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), height)];
	[_pathCover setBackgroundImage:coverImage];
	[_pathCover setAvatarNormalImage:[UIImage imageNamed:@"日历icon-up"] HightImage:[UIImage imageNamed:@"日历icon-down"]];
	[_pathCover setFirstLineTextLabel:[self getFirstlineLabelText] SecondLabel:[Utility getChineseCalendarWithDate:[NSDate date]]];
	[_pathCover setHandleavatarButton:^(void){
		NSLog(@" 日历按钮按下。");
	}];
	
	self.activieylistView.tableHeaderView = self.pathCover;
	[self.view addSubview:activieylistView];
	
	__weak MainViewController *wself = self;
	[_pathCover setHandleRefreshEvent:^{
		[wself _refreshing];
	}];
	
	
	//活动空白页面。
	emptyView = [[DMainEmptyView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(_pathCover.frame)+[Utility getNavBarHight], ScreenWidth, ScreenHeight -CGRectGetHeight(_pathCover.frame))];
	__weak MainViewController *_self = self;
	[emptyView setDidTouchToCreateNewData:^(){
		[_self pushToCreateViewController];
	}];
	
	[self.view addSubview:emptyView];

	
	if ([DAccountManagerInstance appIsFirstUse]) {
        CGuideViewController *guideViewController = [[CGuideViewController alloc]init];
		[self.navigationController pushViewController:guideViewController animated:NO];
	}
	else{
	}
	
	
	//第一次进来则进行登录。
	if ([DAccountManagerInstance curAccountInfoAccount].length > 0 &&
		[DAccountManagerInstance curAccountInfoPassword].length > 0) {
		[self loginDCalenderWithDefaultAccount];
	}
	[self reloadEventDataFromDB];
}


-(void)updateUnReadMsgNum{
    CGRect rect = unReadNumBtn.frame;
    int unReadMsg = [DDBConfigInstance queryNumberOfUnreadMessageId];
    if (unReadMsg>0) {
        unReadNumBtn.hidden = NO;
        if (unReadMsg>99) {
            [unReadNumBtn setFrame:CGRectMake(rect.origin.x, rect.origin.y, 19, rect.size.height)];
            [unReadNumBtn setBackgroundImage:[UIImage imageNamed:@"unRead_msg_more"] forState:UIControlStateNormal];
            [unReadNumBtn setTitle:@"99+" forState:UIControlStateNormal];
        }else{
            [unReadNumBtn setFrame:CGRectMake(rect.origin.x, rect.origin.y, 12, rect.size.height)];
            [unReadNumBtn setBackgroundImage:[UIImage imageNamed:@"unRead_msg"] forState:UIControlStateNormal];
            [unReadNumBtn setTitle:[NSString stringWithFormat:@"%d",unReadMsg] forState:UIControlStateNormal];
        }
    }else{
        unReadNumBtn.hidden = YES;
    }
}
- (void)_refreshing {
	// refresh your data sources
	
	if ([DAccountManagerInstance curAccountIsLogin]) {
		[self syncEventWithFlag:m_pageFlag Version:m_Version];
	}
	else{
		__weak MainViewController *wself = self;
		double delayInSeconds = 0.5;
		dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
		dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
			[wself.pathCover stopRefresh];
		});
	}
}

-(void)isNeedShowEmptyView:(BOOL)show{
	if (show) {
		[emptyView setHidden:NO];
		[activieylistView setScrollEnabled:NO];
	}
	else{
		[emptyView setHidden:YES];
		[activieylistView setScrollEnabled:YES];
	}
}

-(void)reloadEventDataFromDB{
	[self.arrEvent removeAllObjects];
	arrEvent = [DDBConfigInstance QueryEventByDtStart];
	[activieylistView reloadData];
	
	[self isNeedShowEmptyView:[arrEvent count] >0 ? NO: YES];
}

-(NSString*)getFirstlineLabelText{
	NSCalendar *calendar = [NSCalendar currentCalendar];
	unsigned int flag = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit;
	NSDateComponents *dc = [calendar components:flag fromDate:[NSDate date]];
	NSString* lineText= [NSString stringWithFormat:@"%d年%d月%d日",dc.year, dc.month,dc.day];
	[lineText stringByAppendingString:@"  "];
	NSInteger w = [dc weekday];
	switch (w) {
		case 1:
			lineText = [lineText stringByAppendingString:@"周日"];
			break;
		case 2:
			lineText = [lineText stringByAppendingString:@"周一"];
			break;
		case 3:
			lineText = [lineText stringByAppendingString:@"周二"];
			break;
		case 4:
			lineText = [lineText stringByAppendingString:@"周三"];
			break;
		case 5:
			lineText = [lineText stringByAppendingString:@"周四"];
			break;
		case 6:
			lineText = [lineText stringByAppendingString:@"周五"];
			break;
		case 7:
			lineText = [lineText stringByAppendingString:@"周六"];
			break;
	}
	return lineText;
}

-(void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	[self removeGestureRecognizerFromView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - User Interaction -

- (void)buttonAction:(UIButton *)sender
{
	switch (sender.tag) {
		case MV_Btn_time_Tag:{
//			[self showQRCodeScannerView];
		}
			break;
			
		case MV_Btn_today_Tag:{
			NSLog(@"today buttonActin:");
		}
			break;
		case MV_Btn_setting_tag:{
			CSettingViewController *vc = [[CSettingViewController alloc]init];
			__weak MainViewController *_self = self;
			[vc setDidLoginSuccessFromSettingView:^(){
				//
				[_self syncDataLoginSuccess];
			}];
			
			[vc setDidLogOutFromSettingView:^(){
				[_self.arrEvent removeAllObjects];
				[_self.activieylistView reloadData];
			}];
			
			[self.navigationController pushViewController:vc animated:YES];
		}
			break;
		case MV_Btn_msgbox_tag:{
			if (![DAccountManagerInstance curAccountIsLogin]) {
				DLoginViewController *nav = [[DLoginViewController alloc] init];
				[self.navigationController pushViewController:nav animated:YES];
			}
			else{
				DMsgBoxViewController *VC = [[DMsgBoxViewController alloc] init];
				[self.navigationController pushViewController:VC animated:YES];
			}
			NSLog(@"msgbox buttonActin:");
		}
			break;
		case MV_Btn_create_tag:{
			[self pushToCreateViewController];
		}
			break;
			
		case MV_Btn_More_tag:{
		
			ButtonSelectControl *buttonSelectControl_= [[ButtonSelectControl alloc] initWithFrame:CGRectMake(ScreenWidth - 80, [Utility getNavBarHight],80, 80) direction:YES];
			buttonSelectControl_.delegate = self;
			buttonSelectControl_.normalColor = [UIColor colorWithRed:103/255.0f green:103/255.0f blue:103/255.0f alpha:1.0f];
			buttonSelectControl_.selectColor = [UIColor whiteColor];
			buttonSelectControl_.fSelFontSize = 12;
			[buttonSelectControl_ setBackgroundColor:MainTitleBgColor];
			
			
			
			CGFloat width, hight;
			width = buttonSelectControl_.frame.size.width;
			hight = buttonSelectControl_.frame.size.height /3;
			UIEdgeInsets edgeinset =UIEdgeInsetsMake(0,0,0,15);
			UIButton *btn0 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 40)];
			btn0.imageEdgeInsets = edgeinset;
			[btn0 setImage:[UIImage imageNamed:@"二维码-up"] forState:UIControlStateNormal];
			[btn0 setImage:[UIImage imageNamed:@"二维码-down"] forState:UIControlStateHighlighted];
			[btn0 setTitle:@"扫一扫" forState:UIControlStateNormal];
			[btn0 setTitle:@"扫一扫" forState:UIControlStateHighlighted];
			[btn0.titleLabel setFont:[UIFont systemFontOfSize:16.0f]];
			btn0.tag = MV_Btn_QRCode_tag;
			[buttonSelectControl_ addButton:btn0];
			
			UIButton *btn1 = [[UIButton alloc] initWithFrame:CGRectMake(0,40,
																		CGRectGetWidth(btn0.frame),
																		CGRectGetHeight(btn0.frame))];
			[btn1 setImage:[UIImage imageNamed:@"ic_setting_up"] forState:UIControlStateNormal];
			btn1.imageEdgeInsets = edgeinset;
			[btn1 setTitle:@"设置" forState:UIControlStateNormal];
			[btn1 setTitle:@"设置" forState:UIControlStateHighlighted];
			[btn1.titleLabel setFont:[UIFont systemFontOfSize:16.0f]];
			btn1.tag =MV_Btn_setting_tag;
			[buttonSelectControl_ addButton:btn1];
			
			DPopoverView *popoverView1 = [[DPopoverView alloc] initWithFrame:CGRectZero];
			popoverView = popoverView1;
			[popoverView1 showPopoverAtPoint:CGPointMake(ScreenWidth - 20, [Utility getNavBarHight]/2) inView:self.view withContentView:buttonSelectControl_];

		}
			break;
			
		case MV_Btn_QRCode_tag:{
			[self showQRCodeScannerView];
		}
			break;
			
		case 100:{
			if ([DAccountManagerInstance curAccountIsLogin]) {
			}
			else{
				[Utility showMessage:@"请先登录"];
			}
		}
			break;
			
		default:
			break;
	}
}

-(void)pushToCreateViewController{
	__weak MainViewController *_self = self;
	DCreateViewController *vc = [[DCreateViewController alloc] init];
	vc.isCreatView = YES;
	[vc setDidCreateEventFinished:^(){
		[_self reloadEventDataFromDB];
		
	}];
	[self.navigationController pushViewController:vc animated:YES];
}

-(void)loginDCalenderWithDefaultAccount{
	DRequestLogin *req = [[DRequestLogin alloc] init];
	[req setDeviceToken:[Utility GetDeviceToken]];
	[req setModel:[NSString stringWithFormat:@"%@ %@",[UIDevice currentDevice].model, [UIDevice currentDevice].systemVersion]];
	[req setUserName:[DAccountManagerInstance curAccountInfoAccount]];
	[req setPwd:[DAccountManagerInstance curAccountInfoPassword]];
	[self requestWithBaseReq:req];
}

- (void)syncEventWithFlag:(NSInteger)pageFlag Version:(double)version{
	DRequestSyncEvent *syncEvetn = [[DRequestSyncEvent alloc] init];
	syncEvetn.version =version;
	[syncEvetn setPageFlag:pageFlag];
	[syncEvetn setPageSize:KPAGESIZE];
	[syncEvetn setTimestamp:[Utility getTimestamp]];
	[self requestWithBaseReq:syncEvetn];
}

-(void)syncDataLoginSuccess{
	
	[self reloadEventDataFromDB];
	
	//第一次登录没有version 记录 拿全量数据。
	m_Version = [DDBConfigInstance queryVersionFromDB];
	if (m_Version <= 0) {
		m_pageFlag = 1;
	}
	else{
		m_pageFlag = 0;
	}
	[self syncEventWithFlag:m_pageFlag Version:m_Version];
	
	
	//获取消息列表。
	m_MessageID = [DDBConfigInstance queryMaxMessageId];
	[self syncMessageData];
}

-(void)syncMessageData{
	DRequestQueryMsgBatch *req = [[DRequestQueryMsgBatch alloc] init];
	req.msgId = m_MessageID;
	[req setPageflag:m_MessagePageFlag];
	[req setPageSize:KPAGESIZE];
	
	[self requestWithBaseReq:req];
}

-(void)URLDataReceiverDidFinish:(DBaseResponsed *)receiverData{
	[super URLDataReceiverDidFinish:receiverData];
	if ([receiverData isKindOfClass:[DResponsedLogin class]]) {
		DResponsedLogin  *res = (DResponsedLogin*)receiverData;
		if (res.issuccess) {
			NSLog(@"登录成功！");
            [self updateUnReadMsgNum];
			[DAccountManagerInstance saveCurAccountInfo:res withName:nil passwrod:nil];

			//开始刷新数据。
			[self syncDataLoginSuccess];
		}
		else{
			NSLog(@"%@",res.summary);
		}
	}
	else if ([receiverData isKindOfClass:[DResponsedSyncEvent class]]){
		DResponsedSyncEvent *res = (DResponsedSyncEvent*)receiverData;
		
		//更新本地version
		double newVersion = res.version;
		if (newVersion > m_Version) {
			m_Version = newVersion;
			[[DDBConfig shareInstace] upDateEventVersionToDB:m_Version];
		}
		
		//判断是否继续取 如有则保持原来查询的方向继续查询。
		if (res.isHasNextPage == 1) {
			[self syncEventWithFlag:m_pageFlag Version:newVersion];
		}
		//如果无。且查询方向是 向下查询  则转向查询
		else if (res.isHasNextPage == 0 && m_pageFlag != 0){
		  //转向
			m_pageFlag = 0;
			[self syncEventWithFlag:m_pageFlag Version:m_Version];
		}
		else{
			//停止加载显示。
			[self.pathCover stopRefresh];

			//重新加载数据
			[self reloadEventDataFromDB];
		}
		
	}else if ([receiverData isKindOfClass:[DResponsedQueryEventBatch class]]){
        DResponsedQueryEventBatch *responseQueryEvent = (DResponsedQueryEventBatch *)receiverData;
        if (responseQueryEvent.issuccess) {
            DEventData *event = responseQueryEvent.arrEvents[0];
            DDetailEventViewController *detailEvent = nil;
            id viewController = [[self.navigationController viewControllers] lastObject];
            if ([viewController isKindOfClass:[DDetailEventViewController class]]) {
                detailEvent = (DDetailEventViewController *)viewController;
                detailEvent.m_eventData = event;
                [detailEvent reloadEventTable];
            }else{
                detailEvent = [[DDetailEventViewController alloc] init];
                detailEvent.m_eventData = event;
                [self.navigationController pushViewController:detailEvent animated:YES];
            }
        }
	}else if ([receiverData isKindOfClass:[DResponsedQueryMsgBatch class]]){
		DResponsedQueryMsgBatch *res = (DResponsedQueryMsgBatch*)receiverData;
		
		//继续获取。
		if (res.issuccess && [res.arrMessage count] >= KPAGESIZE) {
			m_MessageID = [DDBConfigInstance queryMaxMessageId];
			[self syncMessageData];
		}
		
	}

	
}

-(void)backBtn:(id)sender{
	[super backAction:sender];
}

- (void)clickButtonAt:(UIButton*)button index:(NSInteger)index{
	[popoverView dismiss];
	[self buttonAction:button];
}

#pragma  mark - 二维码 扫描功能。
-(void)showQRCodeScannerView{
	ZBarReaderViewController *reader = [[ZBarReaderViewController alloc] init];
	reader.readerDelegate =self;
	reader.supportedOrientationsMask =ZBarOrientationMaskAll;
	ZBarImageScanner *scanner = reader.scanner;
	[scanner setSymbology:ZBAR_I25 config:ZBAR_CFG_ENABLE to:0];
	[self presentViewController:reader animated:YES completion:nil];
	
	//增加title
	UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 20)];
	[labelTitle setText:@"二维码扫描"];
	[labelTitle setBackgroundColor:[UIColor clearColor]];
	[labelTitle setFont:[UIFont systemFontOfSize:19.0]];
	[labelTitle setTextColor:[UIColor whiteColor]];
	[labelTitle setTextAlignment:NSTextAlignmentCenter];
	
	UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 64)];
	[toolBar setBarStyle:UIBarStyleBlackTranslucent];
	UIBarButtonItem *toolBarTitle = [[UIBarButtonItem alloc] initWithCustomView:labelTitle];
	[toolBar setItems:[NSArray arrayWithObject:toolBarTitle]];
	[toolBar setBackgroundColor:[UIColor clearColor]];
	[toolBar setTintColor:[UIColor redColor]];
	UIImage *toolBarIMG = [UIImage imageNamed: @"button_Sure"];
	
	if ([toolBar respondsToSelector:@selector(setBackgroundImage:forToolbarPosition:barMetrics:)]) {
		[toolBar setBackgroundImage:toolBarIMG forToolbarPosition:0 barMetrics:0];
	}
	[reader.view addSubview:toolBar];
	
	
	//去掉i幫助信息按鈕
	int i = 0;
	for (UIView *temp in [reader.view subviews]) {
		for (UIView *v in [temp subviews]) {
			if ([v isKindOfClass:[UIToolbar class]]) {
				
				//
				UIToolbar*buttomToolBar = (UIToolbar*)v;
				
				if ([buttomToolBar respondsToSelector:@selector(setBackgroundImage:forToolbarPosition:barMetrics:)]) {
					[buttomToolBar setBackgroundImage:toolBarIMG forToolbarPosition:0 barMetrics:0];
				}
				for (UIView *ev in [v subviews]) {
					if (i== 3) {
						[ev removeFromSuperview];
					}
					i++;
				}
			}
		}
	}
}
	
- (void) imagePickerController: (UIImagePickerController*) reader
 didFinishPickingMediaWithInfo: (NSDictionary*) info
{
	id<NSFastEnumeration> results = [info objectForKey:ZBarReaderControllerResults];
	ZBarSymbol *symbol =nil;
	for(symbol in results)
		break;
	[reader dismissViewControllerAnimated:YES completion:nil];
	
	NSString *scannerUrl = symbol.data;

	//分别处理。。
	NSRange  range = [scannerUrl rangeOfString:Servers_URl];
	//判断是小D活动连接。
	if (range.length > 0) {
		scannerUrl =[scannerUrl substringFromIndex:range.location + range.length];
		
		//http://apps.richinfo.cn/?uuid=ca49eb9a76b74dcbb0f173b02a7225a1
		range= [scannerUrl rangeOfString:@"uuid="];
		//二维码登录。
		if (range.length > 0) {
			scannerUrl =[scannerUrl substringFromIndex:range.location + range.length];
			if ([DAccountManagerInstance curAccountIsLogin]) {
				DQRCodeLoginViewController *vc = [[DQRCodeLoginViewController alloc] initWithUUid:scannerUrl];
				[vc setDoReScanQRCode:^(){
					[self showQRCodeScannerView];
				}];
				[self pushToViewControllerCustom:vc animated:YES];
			}
			else{
				[self pushToLoginViewController];
			}
		}
		//活动扫描
		else{
			range= [scannerUrl rangeOfString:@"/p/"];
			if (range.length > 0) {
				scannerUrl =[scannerUrl substringFromIndex:range.location + range.length];
				DDetailEventViewController * vc = [[DDetailEventViewController alloc] init];
				[vc requestEventDataWithEventSign:scannerUrl];
				[self pushToViewControllerCustom:vc animated:YES];
			}
		}
	}
	else{
		[Utility showMessage:@"无效的二维码"];
	}
	
}


#pragma mark- DLoginViewController delegate
-(void)pushToLoginViewController{
	DLoginViewController *nav = [[DLoginViewController alloc] init];
	nav.loginNoticeDelegate = self;
	[self.navigationController pushViewController:nav animated:YES];
}

-(void)loginSuccessNotice:(DResponsedLogin *)res success:(BOOL)success{
	
	if (res.issuccess) {
		[self updateUnReadMsgNum];
		[DAccountManagerInstance saveCurAccountInfo:res withName:nil passwrod:nil];
		
		//开始刷新数据。
		[self syncDataLoginSuccess];
	}
	
}

#pragma mark- scroll delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	[_pathCover scrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
	[_pathCover scrollViewDidEndDecelerating:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
	[_pathCover scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
	[_pathCover scrollViewWillBeginDragging:scrollView];
}

#pragma mark - UITableView Datasource & Delegate -
#pragma mark -UITableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
	return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	return [self.arrEvent count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
		return 56;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	static NSString *CellIdentifier = @"DMainViewTableViewCell";
	DMainViewTableViewCell *cell =(DMainViewTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[DMainViewTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
		[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
	}
	
	if (indexPath.row >=0 && indexPath.row < [arrEvent count]) {
		DEventData *data = [arrEvent objectAtIndex:indexPath.row];
		
		DEventData *lastData = nil;
		NSInteger lastIndex = indexPath.row -1;
		if (lastIndex >= 0 && lastIndex < [arrEvent count]) {
			lastData = [arrEvent objectAtIndex:lastIndex];
		}
	
		BOOL islastRow = (indexPath.row == [arrEvent count] - 1) ? YES:NO;
		[cell loadDataWithEventData:data lastEventData:lastData isLastRow:islastRow];
	}
	
	return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	DDetailEventViewController *vc = [[DDetailEventViewController alloc] init];
	[vc setDidDeleteEventWithGid:^(NSString* gid){
		[self reloadEventDataFromDB];
	}];
	
	[vc  setDidEditEventWithGid:^(NSString* gid){
		[self reloadEventDataFromDB];
	}];
	
	DEventData* data = [arrEvent objectAtIndex:indexPath.row];
	[vc setM_eventData:[DDBConfigInstance queryEventByGid:data.gid]];
	[vc requestEventDataWithEventSign:data.eventSign];
	[self.navigationController pushViewController:vc animated:YES];
	
}

#pragma mark - 通知中心的跳转
-(void)jumpToViewController:(DMessageData *)msgdata{
    /*type  活动邀请 0
     活动更新 1
     活动取消 2
     新评论 3
     加入活动 4
     退出活动 5
     发起人创建投票信息 6
     参与人投票信息 7
     上传消息 100
     */
    if (msgdata.type == 0 || msgdata.type == 1 || msgdata.type == 4 || msgdata.type == 5) {//跳转到活动详情
        DRequestQueryEventBatch *queryEvent = [[DRequestQueryEventBatch alloc] init];
        
        [queryEvent setTimestamp:[Utility getTimestamp]];
        [queryEvent setGidList:msgdata.gid];
        
        [self requestWithBaseReq:queryEvent];
		
    }else if (msgdata.type == 2){//跳转到消息列表
        [DDBConfigInstance insertMessageToDB:msgdata];
        
        DMsgBoxViewController *msgBox = nil;
        id viewController = [[self.navigationController viewControllers] lastObject];
        if ([viewController isKindOfClass:[DMsgBoxViewController class]]) {
            msgBox = (DMsgBoxViewController *)viewController;
            [msgBox reloadMessageTable];
        }else{
            msgBox = [[DMsgBoxViewController alloc] init];
            [self.navigationController pushViewController:msgBox animated:YES];
        }
    }else if (msgdata.type == 3){//跳转到评论
        DCommentViewController *comment = nil;
        id viewController = [[self.navigationController viewControllers] lastObject];
        if ([viewController isKindOfClass:[DCommentViewController class]]) {
            comment = (DCommentViewController *)viewController;
            comment.gid = msgdata.gid;
            [comment requestCommentEvent];
        }else{
            comment = [[DCommentViewController alloc] init];
            comment.gid = msgdata.gid;
            [self.navigationController pushViewController:comment animated:YES];
        }
    }else if (msgdata.type == 6 || msgdata.type == 7){//跳转到投票界面
        
    }
}



@end
