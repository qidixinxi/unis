//
//  SignInJoinListViewController.m
//  UNITOA
//
//  Created by qidi on 14-11-11.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import "SignInJoinListViewController.h"
#import "signListTableViewCell.h"
#import "MySignDetailViewController.h"
#import "PullTableView.h"
#import "SinIn_NewModel.h"
@interface SignInJoinListViewController ()<UITableViewDataSource,UITableViewDelegate,PullTableViewDelegate>
{
    PullTableView *_tableView;
    NSMutableArray *newSignList;
    NSUInteger currentPage;
}
@property(nonatomic,strong)PullTableView *tableView;
@end

@implementation SignInJoinListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    if (IOS7_LATER) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    currentPage = 1;
    [self navigation];
    newSignList = [[NSMutableArray alloc]init];
    self.tableView = [[PullTableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.pullDelegate = self;
    self.editing = NO;
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [self.tableView setSeparatorInset:(UIEdgeInsetsMake(0, 0, 0, 0))];
        
    }
    [self setExtraCellLineHidden:self.tableView];
    [self.view addSubview:self.tableView];
    [self getSigninList];
}
#pragma mark -------------getSigninList-----------------------
- (void)getSigninList{
    __weak typeof(self)bself = self;
    NSDictionary *parameter = @{@"userId":GET_USER_ID,@"sid":GET_S_ID,@"pageSize":[NSString stringWithFormat:@"%d",15],@"page":[NSString stringWithFormat:@"%d",currentPage]};
    [AFRequestService responseData:FACE_SIGNIN_joinlist andparameters:parameter andResponseData:^(NSData *responseData) {
        NSDictionary *dict = (NSDictionary *)responseData;
        [bself endPull];
        NSInteger recordCount = [[dict objectForKey:@"recordCount"]integerValue];
        if (CODE_NUM == CODE_SUCCESS) {
            
            if (currentPage == 1) {
                [newSignList removeAllObjects];
            }
            else{
                if (newSignList.count == recordCount) {
                    [ZSTool presentAlert:@"没有更多数据了"];
                    return ;
                }
            }
            id signinlist = [dict objectForKey:@"signinlist"];
            if([signinlist isKindOfClass:[NSArray class]]){
                for (int i = 0; i<[signinlist count];i++ ) {
                    id signIfo = signinlist[i];
                    if ([signIfo isKindOfClass:[NSDictionary class]]) {
                        SinIn_NewModel * signModel = [[SinIn_NewModel alloc]init];
                        signModel.barcode = [signIfo objectForKey:@"barcode"];
                        signModel.createDate = [signIfo objectForKey:@"createDate"];
                        signModel.expireDate = [signIfo objectForKey:@"expireDate"];
                        signModel.reason = [signIfo objectForKey:@"reason"];
                        signModel.signinId = [signIfo objectForKey:@"signinId"];
                        signModel.signinDate = [signIfo objectForKey:@"signinDate"];
                        signModel.latitude = [signIfo objectForKey:@"latitude"];
                        signModel.longitude = [signIfo objectForKey:@"longitude"];
                        signModel.address = [signIfo objectForKey:@"address"];
                        [newSignList addObject:signModel];
                    }
                }
            }
        }
        [self.tableView reloadData];
    }];
    
}
#pragma mark -------------UITableViewDelegate----------------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [newSignList count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellName = @"Fcell";
    signListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (cell == nil) {
        //cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
        cell = [[[NSBundle mainBundle]loadNibNamed:@"signListTableViewCell" owner:self options:nil]lastObject];
    }
    SinIn_NewModel * model = (SinIn_NewModel *)newSignList[indexPath.row];
    cell.reasonLable.text = model.reason;
    cell.expireDate.text = [NSString stringWithFormat:@"签到时间：%@",[[model.signinDate componentsSeparatedByString:@" "] firstObject]];//[[model.expireDate componentsSeparatedByString:@" "] firstObject];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     SinIn_NewModel * model = (SinIn_NewModel *)newSignList[indexPath.row];
    MySignDetailViewController *mySign = [MySignDetailViewController new];
    mySign.signModel = model;
    [self.navigationController pushViewController:mySign animated:YES];
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
#pragma mark ----------PullTableViewDelegate -----------
- (void)pullTableViewDidTriggerRefresh:(PullTableView*)pullTableView{
    currentPage = 1;
    [self getSigninList];
}
- (void)pullTableViewDidTriggerLoadMore:(PullTableView*)pullTableView{
    currentPage++;
    [self getSigninList];
}
- (void)endPull{
    _tableView.pullTableIsLoadingMore = NO;
    _tableView.pullTableIsRefreshing = NO;
    _tableView.pullLastRefreshDate = [NSDate date];
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
