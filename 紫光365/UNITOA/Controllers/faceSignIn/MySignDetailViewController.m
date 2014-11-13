//
//  MySignDetailViewController.m
//  UNITOA
//
//  Created by qidi on 14-11-11.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import "MySignDetailViewController.h"

@interface MySignDetailViewController ()

@end

@implementation MySignDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self navigation];
    if (IOS7_LATER) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    [self layoutView];
}
#pragma mark -------- navigation---------------
- (void)navigation
{
    UIView *bgNavi = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 190, 40)];
    bgNavi.backgroundColor = [UIColor clearColor];
    bgNavi.userInteractionEnabled = YES;
    
    UIImage *image = [UIImage imageNamed:@"return_unis_logo"];
    UIImageView *logoView = [[UIImageView alloc]initWithImage:image];
    
    
    logoView.backgroundColor = [UIColor clearColor];
    logoView.frame = CGRectMake(0, (44 - image.size.height)/2, image.size.width, image.size.height);
    logoView.contentMode = UIViewContentModeScaleAspectFit;
    logoView.userInteractionEnabled = YES;
    
    
    UILabel *loginLabel = [[UILabel alloc]initWithFrame:CGRectMake(image.size.width + 5, 7, 160, 30)];
    loginLabel.text = LOCALIZATION(@"partin_signin");
    loginLabel.textColor = [UIColor whiteColor];
    loginLabel.backgroundColor = [UIColor clearColor];
    loginLabel.font = [UIFont systemFontOfSize:16];
    [bgNavi addSubview:logoView];
    [bgNavi addSubview:loginLabel];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [bgNavi addGestureRecognizer:tap];
    tap = nil;
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:bgNavi];
    self.navigationItem.leftBarButtonItem = leftItem;
}
- (void)tapAction{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)layoutView{
    UILabel *reasonLable = [[UILabel alloc]initWithFrame:CGRectMake(10, 15, SCREEN_WIDTH - 20, 20)];
    reasonLable.text = self.signModel.reason;
    reasonLable.textColor = GETColor(120, 120, 120);
    reasonLable.font = [UIFont systemFontOfSize:18.0];
    reasonLable.backgroundColor = [UIColor clearColor];
    reasonLable.textAlignment =  NSTextAlignmentLeft;
    [self.view addSubview:reasonLable];
    
    UILabel *expireTimeLable = [[UILabel alloc]initWithFrame:CGRectMake(10, reasonLable.frame.origin.y + reasonLable.frame.size.height + 5, SCREEN_WIDTH - 20, 20)];
    expireTimeLable.text = [NSString stringWithFormat:@"签到时间：%@",self.signModel.signinDate];//self.signModel.reason;
    expireTimeLable.textColor = GETColor(163, 92, 180);
    expireTimeLable.font = [UIFont systemFontOfSize:14.0];
    expireTimeLable.backgroundColor = [UIColor clearColor];
    expireTimeLable.textAlignment =  NSTextAlignmentLeft;
    [self.view addSubview:expireTimeLable];
    
    UILabel *addressLable = [[UILabel alloc]initWithFrame:CGRectMake(10, expireTimeLable.frame.origin.y + expireTimeLable.frame.size.height + 5, SCREEN_WIDTH - 20, 20)];
    addressLable.text = [NSString stringWithFormat:@"签到地点：%@",self.signModel.address];//self.signModel.reason;
    addressLable.textColor = GETColor(163, 92, 180);
    addressLable.font = [UIFont systemFontOfSize:14.0];
    addressLable.backgroundColor = [UIColor clearColor];
    addressLable.textAlignment =  NSTextAlignmentLeft;
    [self.view addSubview:addressLable];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
