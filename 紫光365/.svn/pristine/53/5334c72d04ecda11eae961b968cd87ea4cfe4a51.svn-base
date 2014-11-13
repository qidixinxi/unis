//
//  NameMatterViewController.m
//  UNITOA
//
//  Created by ianMac on 14-7-14.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import "NameMatterViewController.h"
#import "AllMattersViewController.h"
#import "GetTableViewCell.h"
#import "PutTableViewCell.h"
#import "MattersModel.h"
#import "AllMattersViewController.h"
#import "DetailsViewController.h"
#import "Interface.h"
#import "UIImageView+WebCache.h"
#import "TextViewController.h"


@interface NameMatterViewController ()

// 自定义导航栏
- (void)loadNavigationItem;

// "头像"和"姓名"的视图
- (void)loadFaviconAndNameView;

// 分段选择器
- (void)loadUISegmentedControl;

// tableView视图
- (void)loadTableView;

// 未收 待办 退回
- (void)loadNumView;

// 按钮事件
- (void)loadButtonView;

// 请求"收到事项"的数据
- (void)requestData;

// 请求"发出事项"的数据
- (void)putrequestData;

// 刷新UI
- (void)refreshUI;

// 去掉tabelview多余的分割线
- (void)setExtraCellLineHidden: (UITableView *)tableView;

@end

@implementation NameMatterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self loadShadeView];
        [self requestData];
    }
    return self;
}

// 重写初始化方法传值
- (instancetype)initWithUserModel:(UserIfo *)userModel
{
    userInfoModel = [[UserIfo alloc] init];
    userInfoModel = userModel;

    if (self = [super init]) {

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
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 190-64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-160-30-190) style:UITableViewStylePlain];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self loadUISegmentedControl];
    [self loadTableView];
    [self loadNumView];
    [self loadButtonView];
    [self loadFaviconAndNameView];
    [self loadNavigationItem];
    [self setExtraCellLineHidden:_tableView];
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
    title.frame = CGRectMake(0, 0, 100, 20);
    title.backgroundColor = [UIColor clearColor];
    title.text = @"事项";
    title.font = [UIFont systemFontOfSize:16.0f];
    [title setTextColor:[UIColor whiteColor]];
    
    UIBarButtonItem *negativeSeperator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSeperator.width = -12;
    
    UIBarButtonItem *leftButton1 = [[UIBarButtonItem alloc] initWithCustomView:left];
    UIBarButtonItem *leftButton2 = [[UIBarButtonItem alloc] initWithCustomView:title];
    
    NSArray *array = [NSArray arrayWithObjects:negativeSeperator, leftButton1, leftButton2,nil];
    self.navigationItem.leftBarButtonItems = array;
}

- (void)loadFaviconAndNameView
{
    _FaviconAndNameView = [[UIView alloc] init];
    _FaviconAndNameView.frame = CGRectMake(0, 64-64, 320, 80);
    //_FaviconAndNameView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:_FaviconAndNameView];
    
    // 创建头像
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame = CGRectMake(10, 5, 70, 70);
    NSURL *url = [NSURL URLWithString:[IMAGE_BASE_URL stringByAppendingString:userInfoModel.icon]];
    [imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"portrait_ico"]];
    [_FaviconAndNameView addSubview:imageView];
    
    // 创建姓名的Label
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(85, 20, 40, 20);
    label.text = @"姓 名:";
    label.font = [UIFont systemFontOfSize:15.0f];
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = [UIColor blackColor];
    [_FaviconAndNameView addSubview:label];
    
    // 创建姓名内容的Label
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.frame = CGRectMake(130, 20, 60, 20);
    nameLabel.text = userInfoModel.firstname;
    nameLabel.tag = 999;
    nameLabel.font = [UIFont systemFontOfSize:15.0f];
    nameLabel.textAlignment = NSTextAlignmentLeft;
    nameLabel.textColor = [UIColor grayColor];
    [_FaviconAndNameView addSubview:nameLabel];
}

- (void)loadUISegmentedControl
{
    NSArray *array = [[NSArray alloc] initWithObjects:LOCALIZATION(@"home_getMatter"), LOCALIZATION(@"home_putMatter"), LOCALIZATION(@"home_allMatter"), nil];
    _seg = [[UISegmentedControl alloc] initWithItems:array];
    _seg.frame = CGRectMake(10, 144-64, 300, 40);
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
    btn.frame = CGRectMake(210, 145-64, 100, 40);
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
    UIView *numView = [[UIView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-160-30-64, 320, 30)];
    numView.backgroundColor = [UIColor colorWithRed:128/255.0 green:128/255.0 blue:128/255.0 alpha:0.4];
    [self.view addSubview:numView];
    
    label1 = [[UILabel alloc] initWithFrame:CGRectMake(185, 7.5, 140, 15)];
    
    label1.text = [NSString stringWithFormat:@"%@:%d %@:%d %@:%d",LOCALIZATION(@"button_uncollected"),uncollected_num,LOCALIZATION(@"button_backLog"),backLog_num,LOCALIZATION(@"button_reject"),reject_num];
    label1.font = [UIFont systemFontOfSize:13.0f];
    [numView addSubview:label1];
}

- (void)loadButtonView
{
    UIView *buttonView = [[UIView alloc] init];
    buttonView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height-160-64, 320, 160);
    buttonView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:buttonView];
    
    // 添加按钮
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame = CGRectMake(10, 5, 60, 60);
    btn1.tag = 1;
    [btn1 setBackgroundImage:[UIImage imageNamed:@"ic_task_urgent"] forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(Click:) forControlEvents:UIControlEventTouchUpInside];
    [buttonView addSubview:btn1];
    
    UILabel *btnLabel1 = [[UILabel alloc] init];
    btnLabel1.frame = CGRectMake(10, 5+59, 60, 15);
    btnLabel1.text = @"急呼";
    btnLabel1.font = [UIFont systemFontOfSize:13.0f];
    btnLabel1.textColor = [UIColor blackColor];
    btnLabel1.textAlignment = NSTextAlignmentCenter;
    [buttonView addSubview:btnLabel1];
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn2.frame = CGRectMake(10+80, 5, 60, 60);
    btn2.tag = 2;
    [btn2 setBackgroundImage:[UIImage imageNamed:@"ic_task_text"] forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(Click:) forControlEvents:UIControlEventTouchUpInside];
    [buttonView addSubview:btn2];
    
    UILabel *btnLabel2 = [[UILabel alloc] init];
    btnLabel2.frame = CGRectMake(10+80, 5+59, 60, 15);
    btnLabel2.text = @"文本";
    btnLabel2.font = [UIFont systemFontOfSize:13.0f];
    btnLabel2.textColor = [UIColor blackColor];
    btnLabel2.textAlignment = NSTextAlignmentCenter;
    [buttonView addSubview:btnLabel2];
    
    UIButton *btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn3.frame = CGRectMake(10+80*2, 5, 60, 60);
    btn3.tag = 3;
    [btn3 setBackgroundImage:[UIImage imageNamed:@"ic_task_voice"] forState:UIControlStateNormal];
    [btn3 addTarget:self action:@selector(Click:) forControlEvents:UIControlEventTouchUpInside];
    [buttonView addSubview:btn3];
    
    UILabel *btnLabel3 = [[UILabel alloc] init];
    btnLabel3.frame = CGRectMake(10+80*2, 5+59, 60, 15);
    btnLabel3.text = @"语音";
    btnLabel3.font = [UIFont systemFontOfSize:13.0f];
    btnLabel3.textColor = [UIColor blackColor];
    btnLabel3.textAlignment = NSTextAlignmentCenter;
    [buttonView addSubview:btnLabel3];
    
    UIButton *btn4 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn4.frame = CGRectMake(10+80*3, 5, 60, 60);
    btn4.tag = 4;
    [btn4 setBackgroundImage:[UIImage imageNamed:@"ic_task_file"] forState:UIControlStateNormal];
    [btn4 addTarget:self action:@selector(Click:) forControlEvents:UIControlEventTouchUpInside];
    [buttonView addSubview:btn4];
    
    UILabel *btnLabel4 = [[UILabel alloc] init];
    btnLabel4.frame = CGRectMake(10+80*3, 5+59, 60, 15);
    btnLabel4.text = @"文件";
    btnLabel4.font = [UIFont systemFontOfSize:13.0f];
    btnLabel4.textColor = [UIColor blackColor];
    btnLabel4.textAlignment = NSTextAlignmentCenter;
    [buttonView addSubview:btnLabel4];
    
    UIButton *btn5 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn5.frame = CGRectMake(10, 5+77, 60, 60);
    btn5.tag = 5;
    [btn5 setBackgroundImage:[UIImage imageNamed:@"ic_task_phone"] forState:UIControlStateNormal];
    [btn5 addTarget:self action:@selector(Click:) forControlEvents:UIControlEventTouchUpInside];
    [buttonView addSubview:btn5];
    
    UILabel *btnLabel5 = [[UILabel alloc] init];
    btnLabel5.frame = CGRectMake(10, 5+59+80, 60, 15);
    btnLabel5.text = @"通话";
    btnLabel5.font = [UIFont systemFontOfSize:13.0f];
    btnLabel5.textColor = [UIColor blackColor];
    btnLabel5.textAlignment = NSTextAlignmentCenter;
    [buttonView addSubview:btnLabel5];
    
    UIButton *btn6 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn6.frame = CGRectMake(10+80, 5+77, 60, 60);
    btn6.tag = 6;
    [btn6 setBackgroundImage:[UIImage imageNamed:@"ic_task_mail"] forState:UIControlStateNormal];
    [btn6 addTarget:self action:@selector(Click:) forControlEvents:UIControlEventTouchUpInside];
    [buttonView addSubview:btn6];
    
    UILabel *btnLabel6 = [[UILabel alloc] init];
    btnLabel6.frame = CGRectMake(10+80, 5+59+80, 60, 15);
    btnLabel6.text = @"邮件";
    btnLabel6.font = [UIFont systemFontOfSize:13.0f];
    btnLabel6.textColor = [UIColor blackColor];
    btnLabel6.textAlignment = NSTextAlignmentCenter;
    [buttonView addSubview:btnLabel6];
    
    UIButton *btn7 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn7.frame = CGRectMake(10+80*2, 5+77, 60, 60);
    btn7.tag = 7;
    [btn7 setBackgroundImage:[UIImage imageNamed:@"ic_task_sms"] forState:UIControlStateNormal];
    [btn7 addTarget:self action:@selector(Click:) forControlEvents:UIControlEventTouchUpInside];
    [buttonView addSubview:btn7];
    
    UILabel *btnLabel7 = [[UILabel alloc] init];
    btnLabel7.frame = CGRectMake(10+80*2, 5+59+80, 60, 15);
    btnLabel7.text = @"短信";
    btnLabel7.font = [UIFont systemFontOfSize:13.0f];
    btnLabel7.textColor = [UIColor blackColor];
    btnLabel7.textAlignment = NSTextAlignmentCenter;
    [buttonView addSubview:btnLabel7];
    
    UIButton *btn8 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn8.frame = CGRectMake(10+80*3, 5+77, 60, 60);
    btn8.tag = 8;
    [btn8 setBackgroundImage:[UIImage imageNamed:@"ic_task_chat"] forState:UIControlStateNormal];
    [btn8 addTarget:self action:@selector(Click:) forControlEvents:UIControlEventTouchUpInside];
    [buttonView addSubview:btn8];
    
    UILabel *btnLabel8 = [[UILabel alloc] init];
    btnLabel8.frame = CGRectMake(10+80*3, 5+59+80, 60, 15);
    btnLabel8.text = @"V信";
    btnLabel8.font = [UIFont systemFontOfSize:13.0f];
    btnLabel8.textColor = [UIColor blackColor];
    btnLabel8.textAlignment = NSTextAlignmentCenter;
    [buttonView addSubview:btnLabel8];
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
            
            if ([model.userId isEqualToString:userInfoModel.userId]) {
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

                [_MattersDataArray addObject:model];
            }
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
            
            if ([model.recvId isEqualToString:userInfoModel.userId]) {
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

                [_MattersDataArray addObject:model];
            }
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

- (void)setExtraCellLineHidden: (UITableView *)tableView
{
    
    UIView *view =[ [UIView alloc]init];
    
    view.backgroundColor = [UIColor clearColor];
    
    [tableView setTableFooterView:view];
    
    [tableView setTableHeaderView:view];
    
}


#pragma mark --相关的点击事件--

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
    AllMattersViewController *avc = [[AllMattersViewController alloc] initWithUserId:userInfoModel.userId];
    [self.navigationController pushViewController:avc animated:YES];
}

// "按钮视图"的点击事件
- (void)Click:(UIButton *)btn
{
    TextViewController *tvc = [[TextViewController alloc] initWithModel:userInfoModel];
    switch (btn.tag) {
        case 1:
            NSLog(@"点击了按钮%d",btn.tag);
            break;
        case 2:
            NSLog(@"文本");
            [self.navigationController pushViewController:tvc animated:YES];
            break;
        case 3:
            NSLog(@"点击了按钮%d",btn.tag);
            break;
        case 4:
            NSLog(@"点击了按钮%d",btn.tag);
            break;
        case 5:
            NSLog(@"打电话");
            
            if ([userInfoModel.mobile isEqualToString:@""] || userInfoModel.mobile == nil) {
                NSString * alertText= LOCALIZATION(@"dialog_prompt");
                NSString * alertcontext= LOCALIZATION(@"userinfo_mobile_empty");
                NSString *alertOk = LOCALIZATION(@"dialog_ok");
                NSString *alertNO= LOCALIZATION(@"dialog_cancel");
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:alertText message:alertcontext delegate:nil cancelButtonTitle:alertOk otherButtonTitles:alertNO,nil];
                [alert show];
            }
            else{
                NSString *alertcontext = [NSString stringWithFormat:LOCALIZATION(@"userinfo_call_confirm"),userInfoModel.firstname];
                NSString * alertText= LOCALIZATION(@"dialog_prompt");
                NSString *alertOk = LOCALIZATION(@"dialog_ok");
                NSString *alertNO= LOCALIZATION(@"dialog_cancel");
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:alertText message:alertcontext delegate:self cancelButtonTitle:alertOk otherButtonTitles:alertNO,nil];
                alert.tag = 5;
                [alert show];
                //
            }
            
            break;
        case 6:
            NSLog(@"发送邮件");
            
            Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
            
            if (mailClass != nil)
            {
                // We must always check whether the current device is configured for sending emails
                if ([mailClass canSendMail])
                {
                    [self displayComposerSheet];
                }
                else
                {
                    [self launchMailAppOnDevice];
                }
            }
            else
            {
                [self launchMailAppOnDevice];
            }

            break;
        case 7:
            NSLog(@"点击了按钮%d",btn.tag);
            break;
        case 8:
            NSLog(@"点击了按钮%d",btn.tag);
            break;
        default:
            break;
    }
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
            cell = [[GetTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:str];
        }
        cell.mattersModel = [_MattersDataArray objectAtIndex:indexPath.row];
        return cell;
    }else{
        //static NSString *str = @"putCell";
        NSString *str = [NSString stringWithFormat:@"putCell%d%d", [indexPath section], [indexPath row]];//以indexPath来唯一确定cell
        PutTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
        if (cell == nil) {
            cell = [[PutTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:str];
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

#pragma mark -- 邮件发送 --
-(void)displayComposerSheet

{
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    
    picker.mailComposeDelegate = self;
    
    // Set Subject
    //[picker setSubject:@"!"];
    
    
    // Set up recipients
    
    NSArray *toRecipients = [NSArray arrayWithObject:userInfoModel.email];
    
    // NSArray *ccRecipients = [NSArray arrayWithObjects:@"second@example.com", @"third@example.com", nil];
    
    //NSArray *bccRecipients = [NSArray arrayWithObject:@"fourth@example.com"];
    
    [picker setToRecipients:toRecipients];
    //[picker setCcRecipients:ccRecipients];
    //[picker setBccRecipients:bccRecipients];
    
    // Attach an image to the email
    //NSString *path = [[NSBundle mainBundle] pathForResource:@"rainy" ofType:@"png"];
    
    //NSData *myData = [NSData dataWithContentsOfFile:path];
    
    //[picker addAttachmentData:myData mimeType:@"image/png" fileName:@"rainy"];
    
    // Fill out the email body text
    NSString *emailBody = @"This is email body!";
    
    [picker setMessageBody:emailBody isHTML:NO];
    
    [self presentViewController:picker animated:YES completion:^{
        
    }];
    
    picker = nil;
    
}

// Dismisses the email composition interface when users tap Cancel or Send. Proceeds to update the message field with the result of the operation.

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error

{
    NSString *message;
    
    // Notifies users about errors associated with the interface
    
    switch (result)
    {
        case MFMailComposeResultCancelled:
            message = @"Result: canceled";
            break;
            
        case MFMailComposeResultSaved:
            message = @"Result: saved";
            break;
            
        case MFMailComposeResultSent:
            message= @"Result: sent";
            break;
            
        case MFMailComposeResultFailed:
            message = @"Result: failed";
            break;
            
        default:
            message = @"Result: not sent";
            break;
            
    }
    [self alertWithTitle:nil withMessage:message];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

-(void)alertWithTitle:(NSString *)_Title_ withMessage:(NSString *)msg{
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:_Title_ message:msg delegate:nil cancelButtonTitle:LOCALIZATION(@"dialog_ok")  otherButtonTitles: nil];
    [alert show];
    alert = nil;
}

// Launches the Mail application on the device.

-(void)launchMailAppOnDevice

{
    
    NSString *recipients = @"";
    
    NSString *body = @"";
    
    NSString *email = [NSString stringWithFormat:@"%@%@", recipients, body];
    
    email = [email stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:email]];
    
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
