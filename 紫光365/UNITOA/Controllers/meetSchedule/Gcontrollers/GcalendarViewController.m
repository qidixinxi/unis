//
//  GcalendarViewController.m
//  GUKE
//
//  Created by gaomeng on 14-9-30.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import "GcalendarViewController.h"

#import "ITTBaseDataSourceImp.h"

#import "GeventSingleModel.h"

#import "GeventListViewController.h"

#import "MBProgressHUD.h"

@interface GcalendarViewController ()
{
    ITTCalendarView *_calendarView;
    MBProgressHUD *_hud;
    
    
}
@end






@implementation GcalendarViewController


-(void)dealloc{
    
    _calendarView.dataSource = nil;
    _calendarView.delegate = nil;
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"GMJOINSUCCESS" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"GMESCSUCCESS" object:nil];
    NSLog(@"%s",__FUNCTION__);
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    if(IOS7_LATER){
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    [self loadNavigation];
    
    NSDate *date = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: date];
    NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
    NSString *ldateStr = [[NSString stringWithFormat:@"%@",localeDate]substringToIndex:10];
    
    
    
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(prepareNetData) name:@"GMJOINSUCCESS" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(prepareNetData) name:@"GMESCSUCCESS" object:nil];
    
    
    
    [self networkWithDate:ldateStr];
    
    
    
    
    
    
    
    
}


-(void)prepareNetData{
    NSDate *date = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: date];
    NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
    NSString *ldateStr = [[NSString stringWithFormat:@"%@",localeDate]substringToIndex:10];
    
    NSLog(@"===============%@",ldateStr);
    [self networkWithDate:ldateStr];
}




//请求网络数据
-(void)networkWithDate:(NSString *)theDate{
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _hud.labelText = @"正在加载";
    
    NSDictionary *parameters = @{@"userId":GET_U_ID,@"sid":GET_S_ID,@"eventDate":theDate};
    
    
    [AFRequestService responseData:CALENDAR_ACTIVITIES andparameters:parameters andResponseData:^(id responseData) {
        
        NSDictionary * dict = (NSDictionary *)responseData;
        NSString * code = [dict objectForKey:@"code"];
        if ([code intValue]==0)//说明请求数据成功
        {
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            NSLog(@"loadSuccess");
            
            NSLog(@"%@",dict);
            
            if ([dict isKindOfClass:[NSDictionary class]]) {
                NSArray *dataArray = [dict objectForKey:@"eventlist"];
                NSMutableArray *dicArray = [NSMutableArray arrayWithCapacity:1];
                for (NSDictionary *dic in dataArray) {
                    [dicArray addObject:dic];
                }
                
                GeventSingleModel *singelModel = [GeventSingleModel sharedManager];
                singelModel.eventDateDicArray = dicArray;

                
                NSLog(@"%d",singelModel.eventDateDicArray.count);
                
            }
            
            
            _calendarView = [ITTCalendarView viewFromNib];
            ITTBaseDataSourceImp *dataSource = [[ITTBaseDataSourceImp alloc] init];
            //    _calendarView.date = [NSDate dateWithTimeIntervalSinceNow:2*24*60*60];
            _calendarView.date = [NSDate date];
            _calendarView.dataSource = dataSource;
            _calendarView.delegate = self;
            _calendarView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 0);
            _calendarView.allowsMultipleSelection = TRUE;
            [_calendarView showInView:self.view];
            
            
            
            
        }else{
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            UIAlertView *al = [[UIAlertView alloc]initWithTitle:@"提示" message:@"加载失败,请重新加载" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [al show];
            
            NSLog(@"%d",[code intValue]);
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)calendarViewDidSelectDay:(ITTCalendarView*)calendarView calDay:(ITTCalDay*)calDay{
    
    NSLog(@"--------- %@",calDay);
    
    NSLog(@"%d",[calDay getDay]);
    NSLog(@"%d",[calDay getMonth]);
    NSLog(@"%d",[calDay getYear]);
    NSString *monthStr = nil;
    NSString *dayStr = nil;
    if ([calDay getMonth]<10) {
        monthStr = [NSString stringWithFormat:@"0%d",[calDay getMonth]];
    }else{
        monthStr = [NSString stringWithFormat:@"%d",[calDay getMonth]];
    }
    if ([calDay getDay]<10) {
        dayStr = [NSString stringWithFormat:@"0%d",[calDay getDay]];
        
    }else{
        dayStr = [NSString stringWithFormat:@"%d",[calDay getDay]];
    }
    
    NSString *calDayStr = [NSString stringWithFormat:@"%d-%@-%@",[calDay getYear],monthStr,dayStr];
    
    
    
    
    for (NSDictionary *dic in [GeventSingleModel sharedManager].eventDateDicArray) {
        
        NSLog(@"%@",dic);
        NSString *dateStr = [dic objectForKey:@"eventDate"];
        
        NSLog(@"单例中的时间 dateStr:%@",dateStr);
        NSLog(@"日历中的时间 calDayStr:%@",calDayStr);
        
        if ([calDayStr isEqualToString:dateStr]) {
            
            GeventListViewController *gdvc = [[GeventListViewController alloc]init];
            gdvc.calDay = calDay;
            
            [self.navigationController pushViewController:gdvc animated:YES];
            break;
        }
        
        
        
    }
    
    
    
}

//- (void)calendarViewDidSelectPeriodType:(ITTCalendarView*)calendarView periodType:(PeriodType)periodType{
//    NSLog(@"%s",__FUNCTION__);
//}






// 导航的设置
- (void)loadNavigation
{
    UIView *bgNavi = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 190, 44)];
    bgNavi.backgroundColor = [UIColor clearColor];
    bgNavi.userInteractionEnabled = YES;
    
    UIImageView *logoView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"return_unis_logo"]];
    UIImage *image = [UIImage imageNamed:@"return_unis_logo"];
    logoView.backgroundColor = [UIColor clearColor];
    logoView.frame = CGRectMake(0, (44 - image.size.height)/2, image.size.width, image.size.height);
    logoView.contentMode = UIViewContentModeScaleAspectFit;
    logoView.userInteractionEnabled = YES;
    
    
    UILabel *loginLabel = [[UILabel alloc]initWithFrame:CGRectMake(image.size.width + 5, 7, 160, 30)];
    loginLabel.text = @"会议日程";
    loginLabel.textColor = [UIColor whiteColor];
    loginLabel.backgroundColor = [UIColor clearColor];
    loginLabel.font = [UIFont systemFontOfSize:16];
    [bgNavi addSubview:logoView];
    [bgNavi addSubview:loginLabel];
    loginLabel = nil;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gPoPu)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [bgNavi addGestureRecognizer:tap];
    tap = nil;
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:bgNavi];
    self.navigationItem.leftBarButtonItem = leftItem;
}

-(void)gPoPu{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
