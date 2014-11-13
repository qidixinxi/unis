//
//  SignListViewController.m
//  UNITOA
//
//  Created by qidi on 14-11-7.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import "SignListViewController.h"
#import "PullTableView.h"
#import "SignIfo.h"
#import "SignInViewController.h"
#import "SignInListTableViewCell.h"
#import "RefrashProtocol.h"
#import "SearchFriendsViewController.h"

@interface SignListViewController ()<PullTableViewDelegate,UITableViewDataSource,UITableViewDelegate,RefrashDelegate>
{
    PullTableView *_tableView;
    NSMutableArray *signArray;
    NSInteger pageCount;
}
@property(nonatomic,strong)PullTableView *tableView;
@end
@implementation SignListViewController
-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        pageCount = 1;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    if (IOS7_LATER) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    [self navigation];
    signArray = [[NSMutableArray alloc]init];
    [self getSignInList];
    [self createTableView];
    
    
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
    loginLabel.text = LOCALIZATION(@"sign_in");
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
#pragma mark -------- getSignInList---------------
- (void)getSignInList{
    __weak typeof(self)bself = self;
    NSDictionary *parameter = @{@"userId":GET_USER_ID,@"sid":GET_S_ID,@"dstUserId":self.friendID,@"pageSize":[NSString stringWithFormat:@"%d",15],@"page":[NSString stringWithFormat:@"%d",pageCount]};
    [AFRequestService responseData:SIGNIN_LIST_URL andparameters:parameter andResponseData:^(NSData *responseData) {
        NSDictionary *dict = (NSDictionary *)responseData;
         [bself endPull];
         NSInteger recordCount = [[dict objectForKey:@"recordCount"]integerValue];
        if (CODE_NUM == CODE_SUCCESS) {
           
            if (pageCount == 1) {
                [signArray removeAllObjects];
            }
            else{
                if (signArray.count == recordCount) {
                    [ZSTool presentAlert:@"没有更多数据了"];
                    return ;
                }
            }
            id signinlist = [dict objectForKey:@"signinlist"];
            if([signinlist isKindOfClass:[NSArray class]]){
                for (int i = 0; i<[signinlist count];i++ ) {
                    id signIfo = signinlist[i];
                    if ([signIfo isKindOfClass:[NSDictionary class]]) {
                        SignIfo *signModel = [[SignIfo alloc]init];
                        signModel.address = [signIfo objectForKey:@"address"];
                        signModel.createDate = [signIfo objectForKey:@"createDate"];
                        signModel.latitude = [signIfo objectForKey:@"latitude"];
                        signModel.longitude = [signIfo objectForKey:@"longitude"];
                        signModel.name = [signIfo objectForKey:@"name"];
                        if (signModel.name.length == 0) {
                            signModel.name = signModel.address;
                        }
                        signModel.signId = [signIfo objectForKey:@"signId"];
                        signModel.userId = [signIfo objectForKey:@"userId"];
                        NSLog(@"%@",signModel.name);
                        [signArray addObject:signModel];
                    }
            }
        }
        }
        [self.tableView reloadData];
    }];
}
#pragma mark ------------createTableView-------------------
- (void)createTableView{
    UIButton *otherSignBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    otherSignBtn.frame = CGRectMake(10, SCREEN_HEIGHT - 150, SCREEN_WIDTH - 20, 35);
    otherSignBtn.layer.cornerRadius = 5;
    otherSignBtn.backgroundColor = GETColor(245, 245, 245);
    otherSignBtn.tag = 101;
    otherSignBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [otherSignBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [otherSignBtn setTitle:@"查看他人签到" forState:UIControlStateNormal];
     [otherSignBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:otherSignBtn];
    
    
    UIButton *signBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    signBtn.frame = CGRectMake(10, SCREEN_HEIGHT - 105, SCREEN_WIDTH - 20, 35);
    signBtn.layer.cornerRadius = 5;
    signBtn.backgroundColor = GETColor(19, 179, 92);
    signBtn.tag = 102;
    signBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [signBtn setTitle:@"签到" forState:UIControlStateNormal];
    [signBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:signBtn];
    if(![self.friendID isEqualToString:GET_USER_ID]){
        otherSignBtn.hidden = YES;
        signBtn.hidden = YES;
        self.tableView = [[PullTableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
    }
    else{
    self.tableView = [[PullTableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 155) style:UITableViewStylePlain];
    }
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.pullDelegate = self;
    self.editing = NO;
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
        
    }
    [self setExtraCellLineHidden:self.tableView];
    [self.view addSubview:self.tableView];
}
- (void)clickBtn:(UIButton *)sender{
    if (sender.tag == 101) {
        SearchFriendsViewController *searchSignin = [[SearchFriendsViewController alloc]init];
        searchSignin.fromType = frome_sigin;
        [self.navigationController pushViewController:searchSignin animated:YES];
    }
    else if(sender.tag == 102){
        SignInViewController *signVc = [[SignInViewController alloc]init];
        signVc.delegate = self;
        [self.navigationController pushViewController:signVc animated:YES];
    }
}
#pragma make -------------RefrashDelegate-------------------
- (void)refreshData{
    [self getSignInList];
}
#pragma mark -------------UITableViewDelegate----------------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [signArray count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    SignIfo *model = (SignIfo *)signArray[indexPath.row];
    return [SignInListTableViewCell cellHeight:model];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellName = @"Fcell";
    SignInListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (cell == nil) {
         cell = [[SignInListTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
    }
    SignIfo *model = (SignIfo *)signArray[indexPath.row];
    //if (model != nil) {
        cell.postModel = model;
   // }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}
#pragma mark -------------PullTableViewDelegate------------------
- (void)pullTableViewDidTriggerRefresh:(PullTableView*)pullTableView{
    pageCount = 1;
    [self getSignInList];
}
- (void)pullTableViewDidTriggerLoadMore:(PullTableView*)pullTableView{
    pageCount++;
    [self getSignInList];
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
