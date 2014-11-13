//
//  GeventListViewController.m
//  GUKE
//
//  Created by gaomeng on 14-10-5.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import "GeventListViewController.h"

#import "GeventDetailViewController.h"

@interface GeventListViewController ()
{
    int _page;//第几页
    int _pageCapacity;//一页请求几条数据
    NSArray *_dataArray;//数据源
}

@end

@implementation GeventListViewController

-(void)dealloc{
    
    _tableView.dataSource = nil;
    _tableView.delegate = nil;
    
    NSLog(@"%s",__FUNCTION__);
}


-(void)viewWillAppear:(BOOL)animated{
    
//    if (_tableView) {
//        [_tableView showRefreshHeader:YES];
//    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    if (IOS7_LATER) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    
    self.aTitle = @"会议日程";
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    _tableView.separatorColor = [UIColor clearColor];
    
   // _tableView.refreshDelegate = self;//用refreshDelegate替换UITableViewDelegate
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    _page = 1;
    _pageCapacity = 20;
    
   // [_tableView showRefreshHeader:YES];//进入界面先刷新数据
    
    
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//通知方法
-(void)notificationMethod{
    [_tableView removeFromSuperview];
   // _tableView.refreshDelegate = nil;
    _tableView.dataSource = nil;
    
   // _tableView = [[RefreshTableView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    _tableView.separatorColor = [UIColor clearColor];
    
   // _tableView.refreshDelegate = self;//用refreshDelegate替换UITableViewDelegate
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    _page = 1;
    _pageCapacity = 20;
    
   // [_tableView showRefreshHeader:YES];//进入界面先刷新数据
}




#pragma mark - 下拉刷新上提加载更多
/**
 *  刷新数据列表
 *
 *  @param dataArr  新请求的数据
 *  @param isReload 判断在刷新或者加载更多
 */
- (void)reloadData:(NSArray *)dataArr isReload:(BOOL)isReload
{
    if (isReload) {
        
        _dataArray = dataArr;
        
    }else
    {
        NSMutableArray *newArr = [NSMutableArray arrayWithArray:_dataArray];
        [newArr addObjectsFromArray:dataArr];
        _dataArray = newArr;
    }
    
    [_tableView performSelector:@selector(finishReloadigData) withObject:nil afterDelay:1.0];
}



//请求网络数据
-(void)prepareNetData{
    
    NSString *pageCapacityStr = [NSString stringWithFormat:@"%d",_pageCapacity];
    NSString *pageStr = [NSString stringWithFormat:@"%d",_page];
    
    NSString *dateStr = [NSString stringWithFormat:@"%d-%d-%d",[self.calDay getYear],[self.calDay getMonth],[self.calDay getDay]];
    
    
    NSLog(@"%@",dateStr);
    
    NSDictionary *parameters = @{@"userId":GET_U_ID,@"sid":GET_S_ID,@"date":dateStr,@"pageSize":pageCapacityStr,@"page":pageStr};
    
    __weak typeof (self)bself = self;
    [AFRequestService responseData:CALENDAR_ACTIVITIESTABLEVIEW andparameters:parameters andResponseData:^(id responseData) {
        
        NSDictionary * dict = (NSDictionary *)responseData;
        NSString * code = [dict objectForKey:@"code"];
        if ([code intValue]==0)//说明请求数据成功
        {
            NSLog(@"loadSuccess");
            NSLog(@"活动列表  %@",dict);
            
            NSArray *eventArray = [dict objectForKey:@"eventlist"];
            NSMutableArray *dataArray  = [NSMutableArray arrayWithCapacity:1];
            for (NSDictionary *dic in eventArray) {
                GeventModel *m = [[GeventModel alloc]initWithDic:dic];
                [dataArray addObject:m];
            }
            
            if (dataArray.count < _pageCapacity) {
                
                //_tableView.isHaveMoreData = NO;
                
            }else
            {
                //_tableView.isHaveMoreData = YES;
            }
            
           // [bself reloadData:dataArray isReload:_tableView.isReloadData];
            
            
        }else{
            NSLog(@"%d",[code intValue]);
//            if (_tableView.isReloadData) {
//                
//                _page --;
//                
//                [_tableView performSelector:@selector(finishReloadigData) withObject:nil afterDelay:1.0];
//            }
        }
    }];
    
    
    
    
    
}



- (CGFloat)heightForRowIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = 0;
    if (indexPath.row == 0) {
        height = 65;
        
    }else{
        height = 50;
    }
    
    return height;
}





#pragma - mark RefreshDelegate <NSObject>

- (void)loadNewData
{
    
    
    _page = 1;
    
    
    [self prepareNetData];
    
    
}

- (void)loadMoreData
{
    NSLog(@"loadMoreData");
    
    _page ++;
    
    [self prepareNetData];
}





#pragma mark -  UITableViewDataSource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        if (IOS7_LATER) {
            cell.separatorInset = UIEdgeInsetsZero;
        }
    }
    
    
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    if (indexPath.row == 0) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15,17, 320, 40)];
        NSString *weekDay = nil;
        switch ([self.calDay getWeekDay]) {
            case 1:
                weekDay = @"一";
                break;
            case 2:
                weekDay = @"二";
                break;
            case 3:
                weekDay = @"三";
                break;
            case 4:
                weekDay = @"四";
                break;
            case 5:
                weekDay = @"五";
                break;
            case 6:
                weekDay = @"六";
                break;
            case 7:
                weekDay = @"日";
                break;
            default:
                break;
        }
        
        label.text = [NSString stringWithFormat:@"%d年%d月%d日  星期%@",[self.calDay getYear],[self.calDay getMonth],[self.calDay getDay],weekDay];
        label.textColor = RGB(41, 139, 170);
        label.font = [UIFont boldSystemFontOfSize:17];
        
        [cell.contentView addSubview:label];
        
        UIView *fenLine = [[UIView alloc]initWithFrame:CGRectMake(0, 64, 320, 1)];
        fenLine.backgroundColor = RGB(205, 205, 205);
        [cell.contentView addSubview:fenLine];
        
        
        
        
    }else{
        //活动名称
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 15, 270, 20)];
        titleLabel.font = [UIFont systemFontOfSize:16];
        titleLabel.textColor = RGB(127, 126, 126);
        titleLabel.numberOfLines = 1;
        GeventModel *m = _dataArray[indexPath.row - 1];
        titleLabel.text = m.eventTitle;
        [cell.contentView addSubview:titleLabel];
        
        //是否报名
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(15, 20, 10, 10)];
        if ([m.userExists intValue] == 0) {
            
            view.backgroundColor = RGB(255, 204, 204);
            
        }else if ([m.userExists intValue] == 1){
            
            view.backgroundColor = RGB(137, 192, 136);
            
        }
        [cell.contentView addSubview:view];
        
        
        //分割线
        UIView *fenLine = [[UIView alloc]initWithFrame:CGRectMake(0, 49, 320, 1)];
        fenLine.backgroundColor = RGB(242, 242, 242);
        [cell.contentView addSubview:fenLine];
        
    }
    
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count+1;
}



-(void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%@",indexPath);
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row > 0) {
        GeventDetailViewController *aaa = [[GeventDetailViewController alloc]init];
        
        aaa.dataModel = _dataArray[indexPath.row -1];
        
        [self.navigationController pushViewController:aaa animated:YES];
    }
    
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}














@end
