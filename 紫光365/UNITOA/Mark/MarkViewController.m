//
//  MarkViewController.m
//  UNITOA
//  "打分"
//  Created by ianMac on 14-7-15.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import "MarkViewController.h"
#import "BlockButton.h"
#import "Interface.h"


@interface MarkViewController ()

// 自定义导航栏
- (void)loadNavigationItem;

@end

@implementation MarkViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (instancetype)initWithtaskId:(NSString *)taskId
{
    _taskId = [NSString stringWithFormat:@"%@",taskId];
    NSLog(@"测试看看task:%@",_taskId);
    if (self = [super init]) {

    }
    return self;
}

- (void)loadView
{
    UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    view.backgroundColor = [UIColor whiteColor];
    self.view = view;
    
    // "好评"按钮
    BlockButton *btn1 = [[BlockButton alloc] init];
    btn1.frame = CGRectMake(50, 10, 60, 60);
    [btn1 setBackgroundImage:[UIImage imageNamed:@"rate_good"] forState:UIControlStateNormal];
    btn1.block = ^(BlockButton *btn){
        NSLog(@"好评!");
        [self submitMark:@"1"];
    };
    [self.view addSubview:btn1];
    
    // "好评"标签
    UILabel *label1 = [[UILabel alloc] init];
    label1.frame = CGRectMake(50, 10+60, 60, 20);
    label1.text = @"好评";
    label1.textAlignment = NSTextAlignmentCenter;
    label1.font = [UIFont systemFontOfSize:14.0f];
    [self.view addSubview:label1];
    
    // "中评"按钮
    BlockButton *btn2 = [[BlockButton alloc] init];
    btn2.frame = CGRectMake(50+80, 10, 60, 60);
    [btn2 setBackgroundImage:[UIImage imageNamed:@"rate_normal"] forState:UIControlStateNormal];
    btn2.block = ^(BlockButton *btn){
        NSLog(@"中评!");
        [self submitMark:@"2"];
    };
    [self.view addSubview:btn2];
    
    // "中评"标签
    UILabel *label2 = [[UILabel alloc] init];
    label2.frame = CGRectMake(50+80, 10+60, 60, 20);
    label2.text = @"中评";
    label2.textAlignment = NSTextAlignmentCenter;
    label2.font = [UIFont systemFontOfSize:14.0f];
    [self.view addSubview:label2];
    
    // "差评"按钮
    BlockButton *btn3 = [[BlockButton alloc] init];
    btn3.frame = CGRectMake(50+80+80, 10, 60, 60);
    [btn3 setBackgroundImage:[UIImage imageNamed:@"rate_bad"] forState:UIControlStateNormal];
    btn3.block = ^(BlockButton *btn){
        NSLog(@"差评!");
        [self submitMark:@"3"];
    };
    [self.view addSubview:btn3];
    
    // "差评"标签
    UILabel *label3 = [[UILabel alloc] init];
    label3.frame = CGRectMake(50+80+80, 10+60, 60, 20);
    label3.text = @"差评";
    label3.textAlignment = NSTextAlignmentCenter;
    label3.font = [UIFont systemFontOfSize:14.0f];
    [self.view addSubview:label3];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadNavigationItem];
    // Do any additional setup after loading the view.
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
    title.text = @"打分";
    title.font = [UIFont systemFontOfSize:16.0f];
    [title setTextColor:[UIColor whiteColor]];
    
    UIBarButtonItem *negativeSeperator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSeperator.width = -12;
    
    UIBarButtonItem *leftButton1 = [[UIBarButtonItem alloc] initWithCustomView:left];
    UIBarButtonItem *leftButton2 = [[UIBarButtonItem alloc] initWithCustomView:title];
    
    NSArray *array = [NSArray arrayWithObjects:negativeSeperator, leftButton1, leftButton2,nil];
    self.navigationItem.leftBarButtonItems = array;
}

- (void)submitMark:(NSString *)mark
{

    NSDictionary *parameters = @{@"userId":GET_USER_ID,@"sid":GET_U_ID,@"taskId":_taskId,@"rate":mark};
    
    [AFRequestService responseData:@"taskrate.php" andparameters:parameters andResponseData:^(id responseData){
        NSDictionary *dict =(NSDictionary *)responseData;
        NSString *data = [dict objectForKey:@"code"];
        NSLog(@"测试一下:%@",data);
        if ([data intValue]==0) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"评价成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            // 显示
            [alert show];
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"评价失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            // 显示
            [alert show];
        }

    }];
}

// 返回点击事件
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
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
