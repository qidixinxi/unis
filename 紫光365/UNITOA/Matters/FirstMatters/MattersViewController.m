//
//  MattersViewController.m
//  Matters
//
//  Created by ianMac on 14-7-4.
//  Copyright (c) 2014年 ianMac. All rights reserved.
//

#import "MattersViewController.h"
#import "GetTableViewCell.h"
#import "PutTableViewCell.h"
#import "MattersModel.h"
#import "GroupListModel.h"
#import "AllMattersViewController.h"
#import "DetailsViewController.h"
#import "NameMatterViewController.h"
#import "Interface.h"
#import "SDWebImageManager.h"


@interface MattersViewController ()

// 自定义导航栏
- (void)loadNavigationItem;

// 分段选择器
- (void)loadUISegmentedControl;

// tableView视图
- (void)loadTableView;

// 未收 待办 退回
- (void)loadNumView;

// 最下方滚动头像视图
- (void)loadScrollView;

// 请求"收到事项"的数据
- (void)requestData;

// 请求"发出事项"的数据
- (void)putrequestData;

// 刷新UI
- (void)refreshUI;

// 数据加载遮罩
- (void)loadShadeView;

// 获取"审核通过用户列表"数据
- (void)requestUserData;

// 获取"用户加入及创建的群组列表"数据
- (void)requestGrouplistData;


// 获取发出信息用户的头像
- (void)getUserIcon:(NSString *)userId andTag:(int)tag;

// 去掉tabelview多余的分割线
- (void)setExtraCellLineHidden:(UITableView *)tableView;

@end

@implementation MattersViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self loadShadeView];
        [self requestData];
        [self requestUserData];
        //[self requestGrouplistData];
    }
    return self;
}

- (void)loadView
{
    UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    view.backgroundColor = [UIColor whiteColor];
    self.view = view;
    
    //取消ios7的导航控制器的特性
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 120-64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64-140) style:UITableViewStylePlain];
    }
    
    // 在tableView的上方画一条横向
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 119-64, 320, 0.5)];
    lineView.backgroundColor = [UIColor colorWithRed:128/255.0 green:128/255.0 blue:128/255.0 alpha:0.8];
    [self.view addSubview:lineView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadNavigationItem];
    [self loadUISegmentedControl];
    [self loadTableView];
    [self loadNumView];
    [self setExtraCellLineHidden:_tableView];
    //[self loadScrollView];
}

#pragma mark --Private method--

- (void)loadNavigationItem
{
    // 返回小箭头
    UIButton *left = [UIButton buttonWithType:UIButtonTypeCustom];
    [left setFrame:CGRectMake(0, 0, 48, 20)];
    [left setImage:[UIImage imageNamed:@"top_logo_arrow"] forState:UIControlStateNormal];
    [left addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    // 事项Label
    UILabel *title = [[UILabel alloc] init];
    title.frame = CGRectMake(0, 0, 40, 20);
    title.backgroundColor = [UIColor clearColor];
    title.text = LOCALIZATION(@"home_matter");
    title.font = [UIFont systemFontOfSize:16.0f];
    [title setTextColor:[UIColor whiteColor]];
    
    UIBarButtonItem *negativeSeperator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSeperator.width = -12;
    
    UIBarButtonItem *leftButton1 = [[UIBarButtonItem alloc] initWithCustomView:left];
    UIBarButtonItem *leftButton2 = [[UIBarButtonItem alloc] initWithCustomView:title];
    
    NSArray *array = [NSArray arrayWithObjects:negativeSeperator, leftButton1, leftButton2,nil];
    self.navigationItem.leftBarButtonItems = array;
}

- (void)loadUISegmentedControl
{
    NSArray *array = [[NSArray alloc] initWithObjects:LOCALIZATION(@"home_getMatter"), LOCALIZATION(@"home_putMatter"), LOCALIZATION(@"home_allMatter"), nil];
    _seg = [[UISegmentedControl alloc] initWithItems:array];
    _seg.frame = CGRectMake(10, 68-64, 300, 40);
    _seg.selectedSegmentIndex = 0;
    [_seg setTintColor:[UIColor colorWithRed:128/255.0 green:128/255.0 blue:128/255.0 alpha:0.4]];
    
    UIFont *font = [UIFont boldSystemFontOfSize:14.0f];
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:font
                                                           forKey:NSFontAttributeName];
    [_seg setTitleTextAttributes:attributes
                               forState:UIControlStateNormal];
    
    UIColor *blackColor = [UIColor blackColor];
    NSDictionary *colorAttr = [NSDictionary dictionaryWithObject:blackColor forKey:NSForegroundColorAttributeName];
    [_seg setTitleTextAttributes:colorAttr forState:UIControlStateNormal];
    // 添加事件
    [_seg addTarget:self action:@selector(segValueChange:) forControlEvents:UIControlEventValueChanged];
    
    // 在"所有事项"上添加一个透明的button
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor clearColor];
    btn.frame = CGRectMake(210, 69-64, 100, 40);
    [btn addTarget:self action:@selector(segClick) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:_seg];
    [self.view addSubview:btn];
}

- (void)loadTableView
{
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    // 解决IOS7下tableview分割线左边短了一点
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [_tableView setSeparatorInset:UIEdgeInsetsZero];
        
    }
    
    [self.view addSubview:_tableView];

}

- (void)loadNumView
{
    UIView *numView = [[UIView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-64-20-64, [UIScreen mainScreen].bounds.size.width, 30)];
    numView.backgroundColor = [UIColor colorWithRed:128/255.0 green:128/255.0 blue:128/255.0 alpha:0.4];
    [self.view addSubview:numView];
    
    label1 = [[UILabel alloc] initWithFrame:CGRectMake(185, 7.5, 140, 15)];

    label1.text = [NSString stringWithFormat:@"%@:%d %@:%d %@:%d",LOCALIZATION(@"button_uncollected"),uncollected_num,LOCALIZATION(@"button_backLog"),backLog_num,LOCALIZATION(@"button_reject"),reject_num];
    label1.font = [UIFont systemFontOfSize:13.0f];
    [numView addSubview:label1];
}

- (void)loadScrollView
{
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-64-20+30-64, [UIScreen mainScreen].bounds.size.width, 55)];
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.contentSize = CGSizeMake(50*_scrollViewArray.count, 55);
    _scrollView.delegate = self;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.tag = 1001;
    //NSLog(@"看看这里的用户数量:%d",_scrollViewArray.count);
    for (int i = 0; i<_scrollViewArray.count; i++) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(i*50+5, 5, 36, 36);
        btn.tag = i;
        [btn addTarget:self action:@selector(ScrollViewClick:) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:btn];
        [self getUserIcon:((UserIfo *)[_scrollViewArray objectAtIndex:i]).userId andTag:i];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(i*50+5, 42, 36, 10)];
        label.text = [NSString stringWithFormat:@"%@",((UserIfo *)[_scrollViewArray objectAtIndex:i]).firstname];
        label.font = [UIFont systemFontOfSize:9.0f];
        label.textAlignment = NSTextAlignmentCenter;
        [_scrollView addSubview:label];
        
    }
    
    [self.view addSubview:_scrollView];
}

- (void)requestData
{
    [_aiv startAnimating];
    uncollected_num = 0;
    backLog_num = 0;
    reject_num = 0;
    
    _isGet = YES;
    
    _MattersDataArray = [[NSMutableArray alloc] init];
    NSDictionary *parameters = @{@"userId":GET_USER_ID,@"sid":GET_S_ID,@"pageSize":[NSString stringWithFormat:@"%d",INT_MAX],@"page":[NSString stringWithFormat:@"%d",1],@"recvType":[NSString stringWithFormat:@"%d",1]};
    
//    NSString *imageUrl = [self getTableUserIcon:model.userId];
    [AFRequestService responseData:MATTER_LIST andparameters:parameters andResponseData:^(id responseData){
        NSDictionary *dict =(NSDictionary *)responseData;
        NSArray *taskList = [dict objectForKey:@"tasklist"];
        for (NSDictionary *grouplist in taskList) {
            MattersModel *model = [[MattersModel alloc] init];
            if (((NSArray *)[grouplist objectForKey:@"attachlist"]).count) {
                model.attachlist = [grouplist objectForKey:@"attachlist"];
            }
            model.userId = [grouplist objectForKey:@"userId"];
            model.recvId = [grouplist objectForKey:@"recvId"];
            model.taskId = [grouplist objectForKey:@"taskId"];
            model.name = [grouplist objectForKey:@"username"];
            model.getName = [grouplist objectForKey:@"recvname"];
            model.content = [grouplist objectForKey:@"context"];
            model.state = [grouplist objectForKey:@"status"];
            model.rate = [grouplist objectForKey:@"rate"];
            if ([model.state isEqualToString:@"1"]) {
                backLog_num++;
            }
            if (![model.state isEqualToString:@"1"]) {
                
                if ([model.state isEqualToString:@"0"]) {
                    uncollected_num++;
                }
                if ([model.state isEqualToString:@"2"]) {
                    model.state = [NSString stringWithFormat:@"%@",LOCALIZATION(@"matter_status2")];
                }
                if ([model.state isEqualToString:@"3"]) {
                    reject_num ++;
                    model.state = [NSString stringWithFormat:@"%@",LOCALIZATION(@"matter_status3")];
                }
            }
            // "打分详情"的相关数据
            model.putTime = [grouplist objectForKey:@"sendTime"];
            model.getTime = [grouplist objectForKey:@"recvTime"];
            
            if ([self mxGetStringTimeDiff:model.putTime timeE:model.getTime]<60 && [self mxGetStringTimeDiff:model.putTime timeE:model.getTime]!=0) {
                model.responseTime = @"0分";
            }
            if ([self mxGetStringTimeDiff:model.putTime timeE:model.getTime]>=60){
                model.responseTime = [NSString stringWithFormat:@"%d分",((int)[self mxGetStringTimeDiff:model.putTime timeE:model.getTime])/60];
            }
            
            if([self mxGetStringTimeDiff:model.putTime timeE:model.getTime]==0){
                model.getTime = @"";
                model.responseTime = @"";
            }
            
            model.resolutionTime = [grouplist objectForKey:@"finishTime"];
            if ([model.resolutionTime isEqualToString:model.putTime]) {
                model.resolutionTime = @"";
            }
            model.executionTime = [grouplist objectForKey:@"timeElapse"];
            
//            NSString *str = [self getTableUserIcon:model.userId];
//            NSLog(@"-------%@",str);
//            model.putIconImage = [NSString stringWithFormat:@"%@",str];
//            model.getIconImage = [NSString stringWithFormat:@"%@",imageUrl];
            
            [_MattersDataArray addObject:model];

            //[self refreshUI];
        }
        [self refreshUI];
        // 刷新显示数量的Label
        label1.text = [NSString stringWithFormat:@"%@:%d %@:%d %@:%d",LOCALIZATION(@"button_uncollected"),uncollected_num,LOCALIZATION(@"button_backLog"),backLog_num,LOCALIZATION(@"button_reject"),reject_num];
        [_aiv stopAnimating];
    } ];
}

- (void)putrequestData
{
    [_aiv startAnimating];
    uncollected_num = 0;
    backLog_num = 0;
    reject_num = 0;
    
    _isGet = NO;
    _MattersDataArray = [[NSMutableArray alloc] init];
    NSDictionary *parameters = @{@"userId":GET_USER_ID,@"sid":GET_S_ID,@"pageSize":[NSString stringWithFormat:@"%d",INT_MAX],@"page":[NSString stringWithFormat:@"%d",1],@"recvType":[NSString stringWithFormat:@"%d",0]};
    
//    NSString *imageUrl = [self getTableUserIcon:model.userId];
    
    [AFRequestService responseData:MATTER_LIST andparameters:parameters andResponseData:^(id responseData){
        NSDictionary *dict =(NSDictionary *)responseData;
        NSArray *taskList = [dict objectForKey:@"tasklist"];
        for (NSDictionary *grouplist in taskList) {
            MattersModel *model = [[MattersModel alloc] init];
            if (((NSArray *)[grouplist objectForKey:@"attachlist"]).count) {
                model.attachlist = [grouplist objectForKey:@"attachlist"];
            }
            model.userId = [grouplist objectForKey:@"userId"];
            model.recvId = [grouplist objectForKey:@"recvId"];
            model.taskId = [grouplist objectForKey:@"taskId"];
            model.name = [grouplist objectForKey:@"username"];
            model.getName = [grouplist objectForKey:@"recvname"];
            model.content = [grouplist objectForKey:@"context"];
            model.state = [grouplist objectForKey:@"status"];
            model.rate = [grouplist objectForKey:@"rate"];
            if ([model.state isEqualToString:@"0"]) {
                uncollected_num ++;
                backLog_num ++;
                model.state = [NSString stringWithFormat:@"%@",LOCALIZATION(@"matter_status0")];
            }
            if ([model.state isEqualToString:@"1"]) {
                backLog_num ++;
                model.state = [NSString stringWithFormat:@"%@",@"已收,待办"];
            }
            if ([model.state isEqualToString:@"2"]) {
                model.state = [NSString stringWithFormat:@"%@",@"已收,完成"];
            }
            if ([model.state isEqualToString:@"3"]) {
                reject_num ++;
                model.state = [NSString stringWithFormat:@"%@",LOCALIZATION(@"matter_status3")];
            }

            // "打分详情"的相关数据
            model.putTime = [grouplist objectForKey:@"sendTime"];
            model.getTime = [grouplist objectForKey:@"recvTime"];
            //NSLog(@"----------------------%@",model.getTime);
            
            if ([self mxGetStringTimeDiff:model.putTime timeE:model.getTime]<60 && [self mxGetStringTimeDiff:model.putTime timeE:model.getTime]!=0) {
                model.responseTime = @"0分";
            }
            if ([self mxGetStringTimeDiff:model.putTime timeE:model.getTime]>=60){
                model.responseTime = [NSString stringWithFormat:@"%d分",((int)[self mxGetStringTimeDiff:model.putTime timeE:model.getTime])/60];
            }
            
            if([self mxGetStringTimeDiff:model.putTime timeE:model.getTime]==0){
                model.getTime = @"";
                model.responseTime = @"";
            }
            
            model.resolutionTime = [grouplist objectForKey:@"finishTime"];
            if ([model.resolutionTime isEqualToString:model.putTime]) {
                model.resolutionTime = @"";
            }
            model.executionTime = [grouplist objectForKey:@"timeElapse"];
            
//            model.putIconImage = [NSString stringWithFormat:@"%@",imageUrl];
//            model.getIconImage = [self getTableUserIcon:model.recvId];
            
            [_MattersDataArray addObject:model];

        }
        [self refreshUI];
        // 刷新显示数量的Label
        label1.text = [NSString stringWithFormat:@"%@:%d %@:%d %@:%d",LOCALIZATION(@"button_uncollected"),uncollected_num,LOCALIZATION(@"button_backLog"),backLog_num,LOCALIZATION(@"button_reject"),reject_num];
        [_aiv stopAnimating];
    }];

}

- (void)refreshUI
{
    [_tableView reloadData];
}

- (void)loadShadeView
{
    // 网络加载提示(小圈圈)
    _aiv = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _aiv.center = self.view.center;
    [self.view addSubview:_aiv];
}

// 计算时间之差
- (double)mxGetStringTimeDiff:(NSString*)timeS timeE:(NSString*)timeE
{
    double timeDiff = 0.0;
    
    NSDateFormatter *formatters = [[NSDateFormatter alloc]init];
    [formatters setDateFormat:@"yyyy-M-d HH:mm:ss"];
    NSDate *dateS = [formatters dateFromString:timeS];
    
    NSDateFormatter *formatterE = [[NSDateFormatter alloc]init];
    [formatterE setDateFormat:@"yyyy-M-d HH:mm:ss"];
    NSDate *dateE = [formatterE dateFromString:timeE];
    
    timeDiff = [dateE timeIntervalSinceDate:dateS ];
    
    //单位秒
    return timeDiff;
}


- (void)requestUserData
{
    _scrollViewArray = [[NSMutableArray alloc] init];
    NSDictionary *parameters = @{@"userId":GET_USER_ID,@"sid":GET_S_ID};
    [AFRequestService responseData:@"userlist.php" andparameters:parameters andResponseData:^(id responseData){
        NSDictionary *dict =(NSDictionary *)responseData;
        NSArray *userlist = [dict objectForKey:@"userlist"];
        for (NSDictionary *userlist2 in userlist) {
            UserIfo *model = [[UserIfo alloc] init];
            model.address = [userlist2 objectForKey:@"address"];
            model.allowPosition = [userlist2 objectForKey:@"allowPosition"];
            model.articleBg = [userlist2 objectForKey:@"articleBg"];
            model.bgUpdateTime = [userlist2 objectForKey:@"bgUpdateTime"];
            model.chkATime = [userlist2 objectForKey:@"chkATime"];
            model.cityName = [userlist2 objectForKey:@"cityName"];
            model.company = [userlist2 objectForKey:@"company"];
            model.companyId = [userlist2 objectForKey:@"companyId"];
            model.district = [userlist2 objectForKey:@"district"];
            model.email = [userlist2 objectForKey:@"email"];
            model.firstname = [userlist2 objectForKey:@"firstname"];
            model.firstnameen = [userlist2 objectForKey:@"firstnameen"];
            model.icon = [userlist2 objectForKey:@"icon"];
            model.iconUpdateTime = [userlist2 objectForKey:@"iconUpdateTime"];
            model.inviteCodeId = [userlist2 objectForKey:@"inviteCodeId"];
            model.itcode = [userlist2 objectForKey:@"itcode"];
            model.lastChkETime = [userlist2 objectForKey:@"lastChkETime"];
            model.latitude = [userlist2 objectForKey:@"latitude"];
            model.longitude = [userlist2 objectForKey:@"longitude"];
            model.memo = [userlist2 objectForKey:@"memo"];
            model.mobile = [userlist2 objectForKey:@"mobile"];
            model.organization = [userlist2 objectForKey:@"organization"];
            model.organizationen = [userlist2 objectForKey:@"organizationen"];
            model.parentCode = [userlist2 objectForKey:@"parentCode"];
            model.parentId = [userlist2 objectForKey:@"parentId"];
            model.position = [userlist2 objectForKey:@"position"];
            model.positionen = [userlist2 objectForKey:@"positionen"];
            model.province = [userlist2 objectForKey:@"province"];
            model.sex = [userlist2 objectForKey:@"sex"];
            model.showMobile = [userlist2 objectForKey:@"showMobile"];
            model.street = [userlist2 objectForKey:@"street"];
            model.street_number = [userlist2 objectForKey:@"\"street_number\""];
            model.sysAdmin = [userlist2 objectForKey:@"sysAdmin"];
            model.telephone = [userlist2 objectForKey:@"telephone"];
            model.userId = [userlist2 objectForKey:@"userId"];
            model.username = [userlist2 objectForKey:@"username"];
            model.versionName = [userlist2 objectForKey:@"versionName"];
//            UserIfo *models = [[UserIfo alloc] init];
//            models = [self getScrollIcon:model];
//            [_scrollViewArray addObject:models];
            [_scrollViewArray addObject:model];
            //NSLog(@"用户:%@",[userlist2 objectForKey:@"firstname"]);
        }
        //NSLog(@"用户数量:%d",_scrollViewArray.count);
        [self loadScrollView];
    }];

}

- (void)requestGrouplistData
{
    _scrollGroupArray = [[NSMutableArray alloc] init];
    NSDictionary *parameters = @{@"userId":GET_USER_ID,@"sid":GET_S_ID,@"pageSize":[NSString stringWithFormat:@"%d",INT_MAX]};
    [AFRequestService responseData:@"useraddedgrouplist.php" andparameters:parameters andResponseData:^(id responseData){
        NSDictionary *dict =(NSDictionary *)responseData;
        NSArray *groupList = [dict objectForKey:@"grouplist"];
        
        for (NSDictionary *grouplist2 in groupList) {
            GroupListModel *model = [[GroupListModel alloc] init];
            model.addTime = [grouplist2 objectForKey:@"addTime"];
            model.createDate = [grouplist2 objectForKey:@"createDate"];
            model.creator = [grouplist2 objectForKey:@"creator"];
            model.creatorName = [grouplist2 objectForKey:@"creatorName"];
            model.denytalk = [grouplist2 objectForKey:@"denytalk"];
            model.groupId = [grouplist2 objectForKey:@"groupId"];
            model.groupName = [grouplist2 objectForKey:@"groupName"];
            model.groupType = [grouplist2 objectForKey:@"groupType"];
            model.isCreator = [grouplist2 objectForKey:@"isCreator"];
            model.latestMsg = [grouplist2 objectForKey:@"latestMsg"];
            model.latestMsgTime = [grouplist2 objectForKey:@"latestMsgTime"];
            model.latestMsgUser = [grouplist2 objectForKey:@"latestMsgUser"];
            model.membermemo = [grouplist2 objectForKey:@"membermemo"];
            model.memo = [grouplist2 objectForKey:@"memo"];
            
            [_scrollGroupArray addObject:model];
            //NSLog(@"群组ID:%@",[grouplist2 objectForKey:@"groupName"]);
        }
    }];
}

- (void)getUserIcon:(NSString *)userId andTag:(int)tag
{
    __block NSString *imageUrl = nil;
    NSDictionary *parameters = @{@"userId":GET_USER_ID,@"sid":GET_S_ID,@"viewId":userId};
    [AFRequestService responseData:USER_INFO_BYID_URL andparameters:parameters andResponseData:^(id responseData){
        NSDictionary *dict =(NSDictionary *)responseData;
        NSUInteger codeNum = [[dict objectForKey:@"code"] integerValue];
        if (codeNum == CODE_SUCCESS) {
            NSDictionary *userDetail = [dict objectForKey:@"user"];
            imageUrl = [IMAGE_BASE_URL stringByAppendingString:[userDetail valueForKey:@"icon"]];
            NSURL *url1 = [NSURL URLWithString:imageUrl];
            SDWebImageManager *manager1 = [SDWebImageManager sharedManager];
            [manager1 downloadWithURL:url1 options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
                
                if (image) {;
                    [(UIButton *)[[self.view viewWithTag:1001] viewWithTag:tag] setBackgroundImage:image forState:UIControlStateNormal];
                    
                }else{
                    [(UIButton *)[[self.view viewWithTag:1001] viewWithTag:tag] setBackgroundImage:[UIImage imageNamed:@"user_default_small_64"] forState:UIControlStateNormal];
                }
                
            }];
        }
        else if (codeNum == CODE_ERROE){
            NSString *alertcontext = LOCALIZATION(@"get_data_error");
            NSString *alertText = LOCALIZATION(@"dialog_prompt");
            NSString *alertOk = LOCALIZATION(@"dialog_ok");
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:alertText message:alertcontext delegate:self cancelButtonTitle:alertOk otherButtonTitles:nil];
            [alert show];
        }
        else {
            
        }
        
    } ];
    
}


- (void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    [tableView setTableHeaderView:view];
}

// 返回点击事件
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

// 分段控制器事件
- (void)segValueChange:(UISegmentedControl *)seg
{
    //根据选中的的分段的下标，拿到分段的标题
    NSString * string = [seg titleForSegmentAtIndex:seg.selectedSegmentIndex];
    //显示一下即可
    NSLog(@"当前选中为:%@",string);
    if (seg.selectedSegmentIndex == 0) {

        [self requestData];
    }else{

        [self putrequestData];
    }
}

// "所有事项"的点击事件
- (void)segClick
{
    NSString *str = @"0.5";
    AllMattersViewController *avc = [[AllMattersViewController alloc] initWithUserId:str];
    [self.navigationController pushViewController:avc animated:YES];
}

// 最下面滚动视图的点击事件
- (void)ScrollViewClick:(UIButton *)btn
{
    //NSLog(@"点击的头像是:%d",btn.tag);
    NameMatterViewController *nvc = [[NameMatterViewController alloc] initWithUserModel:((UserIfo *)[_scrollViewArray objectAtIndex:btn.tag])];
    [self.navigationController pushViewController:nvc animated:YES];
}

#pragma mark --tableView delegate--
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _MattersDataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (_isGet) {
        //static NSString *str = @"getCell";
        NSString *str = [NSString stringWithFormat:@"getCell%d%d", [indexPath section], [indexPath row]];//以indexPath来唯一确定cell
        GetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
        if (cell == nil) {
            cell = [[GetTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
        }
        cell.mattersModel = [_MattersDataArray objectAtIndex:indexPath.row];
        return cell;
    }else{
        //static NSString *str = @"putCell";
        NSString *str = [NSString stringWithFormat:@"putCell%d%d", [indexPath section], [indexPath row]];//以indexPath来唯一确定cell
        PutTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
        if (cell == nil) {
            cell = [[PutTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
        }
        cell.mattersModel = [_MattersDataArray objectAtIndex:indexPath.row];
        return cell;
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"选中了第 %d个 分段中的第 %d 行",indexPath.section,indexPath.row);
    DetailsViewController *dvc = [[DetailsViewController alloc] initWithArray:_MattersDataArray andNum:indexPath.row];
    [self.navigationController pushViewController:dvc animated:YES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
