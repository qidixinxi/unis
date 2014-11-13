//
//  AllMattersViewController.m
//  Matters
//
//  Created by ianMac on 14-7-5.
//  Copyright (c) 2014年 ianMac. All rights reserved.
//

#import "AllMattersViewController.h"
#import "AllGetTableViewCell.h"
#import "MattersModel.h"
#import "DetailsViewController.h"
#import "Interface.h"

@interface AllMattersViewController ()

// 自定义导航栏
- (void)loadNavigationItem;

// 分段选择器
- (void)loadUISegmentedControl;

// tableView视图
- (void)loadTableView;

// 请求"收到事项"的数据
- (void)requestData;

// 请求"发出事项"的数据
- (void)putrequestData;

// 刷新UI
- (void)refreshUI;

// 计算时间之差
- (double)mxGetStringTimeDiff:(NSString*)timeS timeE:(NSString*)timeE;

// 数据加载遮罩
- (void)loadShadeView;

// 去掉tabelview多余的分割线
- (void)setExtraCellLineHidden: (UITableView *)tableView;

@end

@implementation AllMattersViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self loadShadeView];
        [self requestData];
    }
    return self;
}

// 自定义初始化方法
- (instancetype)initWithUserId:(NSString *)userId
{
    userIdStr = userId;
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
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 120-64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64-55) style:UITableViewStylePlain];
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
    title.text = LOCALIZATION(@"home_workLog");
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
    NSArray *array = [[NSArray alloc] initWithObjects:LOCALIZATION(@"home_getMatter"), LOCALIZATION(@"home_putMatter") ,nil];
    UISegmentedControl *seg = [[UISegmentedControl alloc] initWithItems:array];
    seg.frame = CGRectMake(10, 68-64, 300, 40);
    seg.selectedSegmentIndex = 0;
    [seg setTintColor:[UIColor colorWithRed:128/255.0 green:128/255.0 blue:128/255.0 alpha:0.4]];
    
    UIFont *font = [UIFont boldSystemFontOfSize:14.0f];
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:font
                                                           forKey:NSFontAttributeName];
    [seg setTitleTextAttributes:attributes
                       forState:UIControlStateNormal];
    
    UIColor *blackColor = [UIColor blackColor];
    NSDictionary *colorAttr = [NSDictionary dictionaryWithObject:blackColor forKey:NSForegroundColorAttributeName];
    [seg setTitleTextAttributes:colorAttr forState:UIControlStateNormal];
    
    [self.view addSubview:seg];
    
    // 添加事件
    [seg addTarget:self action:@selector(segValueChange:) forControlEvents:UIControlEventValueChanged];
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

- (void)requestData
{
    [_aiv startAnimating];
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
            if ([userIdStr floatValue] == 0.5) {
                
                [_MattersDataArray addObject:model];
                
            }else{
                
                if ([model.userId isEqualToString:userIdStr]) {
                    [_MattersDataArray addObject:model];
                }

            }

            //[self refreshUI];
        }
        [self refreshUI];
        [_aiv stopAnimating];
    } ];
    
}

- (void)putrequestData
{
    [_aiv startAnimating];
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
            
            if ([userIdStr floatValue] == 0.5) {
                
                [_MattersDataArray addObject:model];
                
            }else{
                
                if ([model.recvId isEqualToString:userIdStr]) {
                    [_MattersDataArray addObject:model];
                }
                
            }

            //[self refreshUI];
        }
        [self refreshUI];
        [_aiv stopAnimating];
    } ];
}

- (void)refreshUI
{
    [_tableView reloadData];
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

- (void)loadShadeView
{
    // 网络加载提示(小圈圈)
    _aiv = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _aiv.center = self.view.center;
    [self.view addSubview:_aiv];
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
        _MattersDataArray = nil;
        [self requestData];
    }else{
        _MattersDataArray = nil;
        [self putrequestData];
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
    return 150;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_isGet) {
        static NSString *str = @"AllGetCell";
        AllGetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
        if (cell == nil) {
            cell = [[AllGetTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
        }
        cell.mattersModel = [_MattersDataArray objectAtIndex:indexPath.row];
        return cell;
    }else{
        static NSString *str = @"ALLPutCell";
        AllGetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
        if (cell == nil) {
            cell = [[AllGetTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
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
