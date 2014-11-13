//
//  MyNewSignViewController.m
//  UNITOA
//
//  Created by qidi on 14-11-11.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import "MyNewSignViewController.h"
#import "MemeberTableViewCell.h"
#import "QRCodeGenerator.h"
#import "UserListModel.h"
@interface MyNewSignViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSMutableArray *memberArray;
}
@end

@implementation MyNewSignViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self navigation];
    if (IOS7_LATER) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    memberArray = [[NSMutableArray alloc]init];
    [self layoutView];
    [self getMemeberIfo];

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
    loginLabel.text = LOCALIZATION(@"my_creat_signin");
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
    
    UIView *rightView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    rightView.backgroundColor = [UIColor clearColor];
    if([self.signModel.userId isEqualToString:GET_USER_ID]){
    UIButton * rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, (44-28)/2+1, 44, 28);
    rightBtn.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.2f];
    rightBtn.layer.cornerRadius = 4;
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [rightBtn setTitle:@"作废" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [rightBtn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [rightView addSubview:rightBtn];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightView];
    self.navigationItem.rightBarButtonItem = rightItem;
    }
    
}
- (void)tapAction{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)btnClick{
    NSDictionary *parameter = @{@"userId":GET_USER_ID,@"sid":GET_S_ID,@"signinId":self.signModel.signinId};
    [AFRequestService responseData:SIGNIN_INVALIDATE andparameters:parameter andResponseData:^(NSData *responseData) {
        NSDictionary *dict = (NSDictionary *)responseData;
        if (CODE_NUM == CODE_SUCCESS) {
            if (self.delegate&&[self.delegate respondsToSelector:@selector(refreshData)]) {
                [self.delegate refreshData];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
        else if (CODE_NUM == CODE_ERROE){
            [ZSTool presentAlert:@"作废操作失败"];
        }
    }];
}
- (void)layoutView{
    UILabel *reasonLable = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH - 20, 20)];
    reasonLable.text = self.signModel.reason;
    reasonLable.textColor = GETColor(120, 120, 120);
    reasonLable.font = [UIFont systemFontOfSize:16.0];
    reasonLable.backgroundColor = [UIColor clearColor];
    reasonLable.textAlignment =  NSTextAlignmentLeft;
    [self.view addSubview:reasonLable];
    
    UILabel *expireTimeLable = [[UILabel alloc]initWithFrame:CGRectMake(10, reasonLable.frame.origin.y + reasonLable.frame.size.height + 5, SCREEN_WIDTH - 20, 20)];
    expireTimeLable.text = [NSString stringWithFormat:@"过期时间：%@",self.signModel.expireDate];//self.signModel.reason;
    expireTimeLable.textColor = GETColor(163, 92, 180);
    expireTimeLable.font = [UIFont systemFontOfSize:14.0];
    expireTimeLable.backgroundColor = [UIColor clearColor];
    expireTimeLable.textAlignment =  NSTextAlignmentLeft;
    [self.view addSubview:expireTimeLable];
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(-1, expireTimeLable.frame.origin.y + expireTimeLable.frame.size.height + 5, SCREEN_WIDTH + 2, 200)];
    bgView.backgroundColor = [UIColor clearColor];
    bgView.layer.borderColor = [GETColor(222, 224, 229) CGColor];
    bgView.layer.borderWidth = 1;
    [self.view addSubview:bgView];
    
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake((bgView.frame.size.width - 180)/2, 10, 180, 180)];
    
    UIImage *imgCode = [QRCodeGenerator qrImageForString:self.signModel.barcode imageSize:imgView.frame.size.width];
    imgView.image = imgCode;
    [bgView addSubview:imgView];
    
    UIView *memberView = [[UIView alloc]initWithFrame:CGRectMake(-1, bgView.frame.origin.y + bgView.frame.size.height - 1, SCREEN_WIDTH + 2, 40)];
    memberView.backgroundColor = [UIColor clearColor];
    memberView.layer.borderColor = [GETColor(222, 224, 229) CGColor];
    memberView.layer.borderWidth = 1;
    [self.view addSubview:memberView];
    
    UILabel *numemberLable = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH - 20, 20)];
    numemberLable.text = [NSString stringWithFormat:@"签到人员"];
    numemberLable.textColor = GETColor(120, 120, 120);
    numemberLable.font = [UIFont systemFontOfSize:16.0];
    numemberLable.backgroundColor = [UIColor clearColor];
    numemberLable.textAlignment =  NSTextAlignmentLeft;
    [memberView addSubview:numemberLable];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, memberView.frame.origin.y + memberView.frame.size.height, SCREEN_WIDTH, SCREEN_HEIGHT  - memberView.frame.origin.y - memberView.frame.size.height - 64)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self setExtraCellLineHidden:_tableView];
    [self.view addSubview:_tableView];
    
}
- (void)getMemeberIfo{
    NSDictionary *parameter = @{@"userId":GET_USER_ID,@"sid":GET_S_ID,@"signinId":self.signModel.signinId,@"pageSize":[NSString stringWithFormat:@"%d",INT_MAX],@"page":@"1"};
    [AFRequestService responseData:FACE_SIGNIN_USERLIST andparameters:parameter andResponseData:^(NSData *responseData) {
        NSDictionary *dict = (NSDictionary *)responseData;
        if (CODE_NUM == CODE_SUCCESS) {
            id signinlist = [dict objectForKey:@"userlist"];
            if([signinlist isKindOfClass:[NSArray class]]){
                for (int i = 0; i<[signinlist count];i++ ) {
                    id signIfo = signinlist[i];
                    if ([signIfo isKindOfClass:[NSDictionary class]]) {
                        SinIn_NewModel * signModel = [[SinIn_NewModel alloc]init];
                        signModel.address = [signIfo objectForKey:@"address"];
                        signModel.signinDate = [signIfo objectForKey:@"signinDate"];
                        signModel.latitude = [signIfo objectForKey:@"latitude"];
                        signModel.longitude = [signIfo objectForKey:@"longitude"];
                        signModel.username = [signIfo objectForKey:@"username"];
                        signModel.userId = [signIfo objectForKey:@"userId"];
                        signModel.signinId = [signIfo objectForKey:@"signinId"];
                         signModel.logId = [signIfo objectForKey:@"logId"];
                        [memberArray addObject:signModel];
                    }
                }
            }
        }
        else if (CODE_NUM == CODE_ERROE){
            
        }
        [_tableView reloadData];
    }];
}
#pragma mark -------------UITableViewDelegate----------------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [memberArray count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellName = @"Fcell";
    MemeberTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (cell == nil) {
        //cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
        cell = [[[NSBundle mainBundle]loadNibNamed:@"MemeberTableViewCell" owner:self options:nil]lastObject];
    }
    SinIn_NewModel * model = (SinIn_NewModel *)memberArray[indexPath.row];
    cell.memeberNameLable.text = model.username;
    cell.addressLable.text = [NSString stringWithFormat:@"签到地点：%@",model.address];//model.address;
    cell.signDataLable.text = [NSString stringWithFormat:@"签到时间：%@",model.signinDate];//model.address;
    //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
#pragma mark -------- setExtraCellLineHidden -----------
- (void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    [tableView setTableHeaderView:view];
    view = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
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
