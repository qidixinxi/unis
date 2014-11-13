//
//  CreatSignViewController.m
//  UNITOA
//
//  Created by qidi on 14-11-10.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import "CreatSignViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "selectDateTimeViewController.h"
#import "SinIn_NewModel.h"
#import "QREncoder.h"
#import "ZSCustomDatePickerView.h"
#import "QRCodeGenerator.h"
@interface CreatSignViewController ()<selectDateTimeViewDelegate>
{
    UITextView *email;
    UITextField *trueName;
    UIImageView *codeImgView;
    //  时间选择
    ZSCustomDatePickerView * datePicker;
}
@end

@implementation CreatSignViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    if (IOS7_LATER) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    [self navigation];
    [self createUI];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [super viewWillAppear:animated];
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"navi_bg"] forBarMetrics:UIBarMetricsDefault];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
}
- (void)createUI{
    // 姓名
    UILabel *reasonLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 30, 70, 15)];
    reasonLabel.text = LOCALIZATION(@"resean_signin");
    reasonLabel.textAlignment = NSTextAlignmentLeft;
    reasonLabel.textColor = [UIColor blackColor];
    reasonLabel.font = [UIFont systemFontOfSize:14.0f];
    
    trueName = [[UITextField alloc]initWithFrame:CGRectMake(80, 45/2, SCREEN_WIDTH-100, (235-175)/2)];
    [trueName setBorderStyle:UITextBorderStyleLine];
    trueName.layer.borderColor = [GETColor(234, 234, 234) CGColor];
    trueName.layer.cornerRadius = 3;
    trueName.layer.borderWidth = 1;
    trueName.tag = 101;
    trueName.font = [UIFont systemFontOfSize:14.0f];
    trueName.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
    // 分割线1
    UIView *lineView1 = [[UIView alloc] init];
    lineView1.backgroundColor = GETColor(234, 234, 234);
    lineView1.frame = CGRectMake(0, (255-130)/2, viewSize.width, 1);
    
    //邮箱
    UILabel *emailLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 30+(270-175+5)/2, 70, 15)];
    emailLabel.text = LOCALIZATION(@"expireDate");
    emailLabel.textAlignment = NSTextAlignmentLeft;
    emailLabel.textColor = [UIColor blackColor];
    emailLabel.font = [UIFont systemFontOfSize:14.0f];
    emailLabel.userInteractionEnabled = YES;
    
    email = [[UITextView alloc]initWithFrame:CGRectMake(80, 45/2+(270-175+5)/2, SCREEN_WIDTH-100, (235-175)/2)];
    email.layer.borderColor = [GETColor(234, 234, 234) CGColor];
    email.layer.borderWidth = 1;
    email.editable = NO;
    email.userInteractionEnabled = YES;
    email.layer.cornerRadius = 3;
    email.tag = 102;
    email.font = [UIFont systemFontOfSize:14.0f];

    
    UITapGestureRecognizer * tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseDateTime:)];
    tap1.numberOfTapsRequired = 1;
    tap1.numberOfTouchesRequired = 1;
    [email addGestureRecognizer:tap1];
    
    // 分割线2
    UIView *lineView2 = [[UIView alloc] init];
    lineView2.backgroundColor = GETColor(234, 234, 234);
    lineView2.frame = CGRectMake(0, (255-130)/2+(270-175+4)/2, SCREEN_WIDTH, 1);
    
    UIButton *newCode = [UIButton buttonWithType:UIButtonTypeCustom];
    newCode.frame = CGRectMake(10, lineView2.frame.origin.y + 20, SCREEN_WIDTH - 20, 40);
    [newCode addTarget:self action:@selector(newCode:) forControlEvents:UIControlEventTouchUpInside];
    [newCode setTitle:@"生成二维码" forState:UIControlStateNormal];
    newCode.layer.cornerRadius = 5;
    newCode.tag = 201;
    newCode.backgroundColor = GETColor(19, 179, 91);
    
    codeImgView = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 200)/2, lineView2.frame.origin.y + 20, 200, 200)];
    codeImgView.hidden = YES;
    [self.view addSubview:codeImgView];
    
    [self.view addSubview:newCode];
    [self.view addSubview:reasonLabel];
    [self.view addSubview:trueName];
    [self.view addSubview:lineView1];
    [self.view addSubview:emailLabel];
    [self.view addSubview:email];
    [self.view addSubview:lineView2];
}
- (void)newCode:(UIButton *)sender{
    [trueName resignFirstResponder];
    [email resignFirstResponder];
    if (trueName.text.length == 0) {
        [ZSTool presentAlert:@"请输入签到事由!"];
        return;
    }
    if (email.text.length == 0) {
        [ZSTool presentAlert:@"请输入过期时间!"];
        return;
    }
    [self getSignCode];
}
//选择时间
- (void)chooseDateTime:(UITapGestureRecognizer *)gesture{
    selectDateTimeViewController *controller = [[selectDateTimeViewController alloc]init];
    controller.delegate = self;
    [self.navigationController presentViewController:controller animated:YES completion:nil];
}
- (void)sendTime:(NSString *)date{
    email.text = date;
    [datePicker removeFromSuperview];
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
    loginLabel.text = LOCALIZATION(@"creat_signin");
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
#pragma mark ------------getSignCode-------------------------
- (void)getSignCode{
    NSDictionary *parameters= @{@"userId":GET_USER_ID,@"sid":GET_S_ID,@"reason":trueName.text,@"expireDate":email.text};
    [AFRequestService responseData:FACE_SIGNIN_NEW andparameters:parameters andResponseData:^(NSData *responseData) {
        NSDictionary *dict = (NSDictionary *)responseData;
        if (CODE_NUM == CODE_SUCCESS) {
            NSDictionary *signin = [dict objectForKey:@"signin"];
            SinIn_NewModel * signModel = [[SinIn_NewModel alloc]init];
            signModel.barcode = [signin objectForKey:@"barcode"];
            signModel.createDate = [signin objectForKey:@"createDate"];
            signModel.expireDate = [signin objectForKey:@"expireDate"];
            signModel.reason = [signin objectForKey:@"reason"];
            signModel.signinId = [signin objectForKey:@"signinId"];
            signModel.userId = [signin objectForKey:@"userId"];
            
            // 隐掉提交按钮
            UIButton *btn = (UIButton *)[self.view viewWithTag:201];
            btn.hidden = YES;
            codeImgView.hidden = NO;
            UIImage *codeImage = [QRCodeGenerator qrImageForString:signModel.barcode imageSize:codeImgView.bounds.size.width];
            //UIImage *code = [QREncoder encode:signModel.barcode size:8 correctionLevel:QRCorrectionLevelHigh];
            codeImgView.image = codeImage;
            
        }
    }];
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [trueName resignFirstResponder];
    [email resignFirstResponder];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
#pragma <#arguments#>
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
