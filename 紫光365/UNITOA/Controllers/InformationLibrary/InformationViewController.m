//
//  InformationViewController.m
//  GUKE
//  资料库
//  Created by ianMac on 14-9-24.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import "InformationViewController.h"
#import "InformationTableViewCell.h"
#import "MBProgressHUD.h"
#import "Interface.h"
#import "InformationModel.h"
#import "PullTableView.h"

@interface InformationViewController ()<MBProgressHUDDelegate, UITableViewDataSource, UITableViewDelegate,PullTableViewDelegate>
{
    MBProgressHUD *HUD;
    
    int currentPage;
}

// 创建资料库的列表
@property (nonatomic, strong) PullTableView *tableView;
// 创建资料库的数据源
@property (nonatomic, strong) NSMutableArray *dataArray;

// 自定义导航栏
- (void)loadNavigation;
// 创建资料库列表
- (void)loadUITableView;
// "新建资料"按钮
- (void)loadNewInformationBtn;
// 获取"资料库"文章数据
- (void)getArticleList;

@end

@implementation InformationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.dataArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    view.backgroundColor = [UIColor whiteColor];
    self.view = view;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"navi_bg"] forBarMetrics:UIBarMetricsDefault];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    if(IOS7_LATER){
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    currentPage = 1;
    
    [self loadNavigation];
    [self loadUITableView];
    [self loadNewInformationBtn];
    [self getArticleList];
    
}
// 重新加载数据
- (void)repeatLoadData{
    [self getArticleList];
}
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

    loginLabel.text = @"资料库";
    loginLabel.textColor = [UIColor whiteColor];
    loginLabel.backgroundColor = [UIColor clearColor];
    loginLabel.font = [UIFont systemFontOfSize:16];
    [bgNavi addSubview:logoView];
    [bgNavi addSubview:loginLabel];
    loginLabel = nil;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [logoView addGestureRecognizer:tap];
    tap = nil;
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:bgNavi];
    self.navigationItem.leftBarButtonItem = leftItem;
}
// 创建资料库列表
- (void)loadUITableView
{
    self.tableView = [[PullTableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-120) style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.pullDelegate = self;
    // 解决IOS7下tableview分割线左边短了一点
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [_tableView setSeparatorInset:UIEdgeInsetsZero];
        
    }
    [self setExtraCellLineHidden:self.tableView];

    [self.view addSubview:self.tableView];
    
}

// "新建资料"按钮
- (void)loadNewInformationBtn
{
    UIButton *NewInformationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    NewInformationBtn.frame = CGRectMake(20, SCREEN_HEIGHT-40-64, SCREEN_WIDTH-40, 30);
    NewInformationBtn.layer.cornerRadius = 5.0f;
    NewInformationBtn.backgroundColor = GETColor(39, 207, 104);
    [NewInformationBtn setTitle:@"新建资料" forState:UIControlStateNormal];
    [NewInformationBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [NewInformationBtn addTarget:self action:@selector(Click) forControlEvents:UIControlEventTouchUpInside];
    NewInformationBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [self.view addSubview:NewInformationBtn];
}

// 获取"资料库"文章数据
- (void)getArticleList
{
    [self creatHUD:LOCALIZATION(@"chat_loading")];
    if (currentPage == 1) {
         [HUD show:YES];
    }
    __weak typeof(self)bself = self;
     NSDictionary *parameters = @{@"userId": GET_USER_ID,@"sid": GET_S_ID,@"pageSize":[NSString stringWithFormat:@"%d",20],@"page":[NSString stringWithFormat:@"%d",currentPage]};
    
    [AFRequestService responseData:@"infolist.php" andparameters:parameters andResponseData:^(NSData *responseData) {
        
        [bself endPull];
        
        NSDictionary *articleDict = (NSDictionary *)responseData;
        NSInteger codeNum = [[articleDict objectForKey:@"code"]integerValue];
        if(codeNum == CODE_SUCCESS){
            if (currentPage == 1) {
                [bself.dataArray removeAllObjects];
            }
            
            NSArray *articleList = [articleDict objectForKey:@"infolist"];
            for (NSDictionary *article in articleList) {
                
                InformationModel *model = [[InformationModel alloc] init];
                model.content = [article objectForKey:@"content"];
                model.createDate = [article objectForKey:@"createDate"];
                model.deleteFlag = [article objectForKey:@"deleteFlag"];
                model.firstname = [article objectForKey:@"firstname"];
                model.infoId = [article objectForKey:@"infoId"];
                model.title = [article objectForKey:@"title"];
                model.userId = [article objectForKey:@"userId"];
                model.weight = [article objectForKey:@"weight"];
                [bself.dataArray addObject:model];
            }

            [HUD hide:YES];
        }
        else if (codeNum == CODE_ERROE){
            NSString *alertcontext = @"网络连接失败";
            NSString *alertText = LOCALIZATION(@"dialog_prompt");
            NSString *alertOk = LOCALIZATION(@"dialog_ok");
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:alertText message:alertcontext delegate:nil cancelButtonTitle:alertOk otherButtonTitles:nil];
            [alert show];
            [HUD hide:YES];
        }
        [self.tableView reloadData];
    }];

}
// 手势事件
- (void)tapAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

// "新建资料"的点击事件
- (void)Click
{
    CreatNewInfoViewController *creatVC = [[CreatNewInfoViewController alloc] init];
    creatVC.delegate = self;
    [self.navigationController pushViewController:creatVC animated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    InformationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"informationCell"];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"InformationTableViewCell" owner:self options:nil] lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    InformationModel *model = (InformationModel *)[self.dataArray objectAtIndex:indexPath.row];
    
    cell.mainTitleLabel.text = [NSString stringWithFormat:@"%@",model.title];
    cell.nameAndTimeLabel.text = [NSString stringWithFormat:@"%@ %@",model.firstname,model.createDate];
    NSMutableAttributedString * attributeString = [[NSMutableAttributedString alloc]initWithString:model.content attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15]}];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:7];//调整行间距
    [attributeString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [model.content length])];
    cell.ContentLabel.attributedText = attributeString;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    InformationModel *model = (InformationModel *)[self.dataArray objectAtIndex:indexPath.row];
    InfoDetailViewController *InfoDetailVC = [[InfoDetailViewController alloc] initWithModel:model];
    InfoDetailVC.delegate = self;
    [self.navigationController pushViewController:InfoDetailVC animated:YES];
}

#pragma mark - PullTableViewDelegate
- (void)pullTableViewDidTriggerRefresh:(PullTableView*)pullTableView
{
    currentPage = 1;
    [self getArticleList];
}
- (void)pullTableViewDidTriggerLoadMore:(PullTableView*)pullTableView
{
    currentPage++;
    [self getArticleList];
}
- (void)endPull{
    _tableView.pullTableIsLoadingMore = NO;
    _tableView.pullTableIsRefreshing = NO;
    _tableView.pullLastRefreshDate = [NSDate date];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)creatHUD:(NSString *)hud{
    if (!HUD) {
        HUD = [[MBProgressHUD alloc] initWithView:self.view] ;
        [self.view addSubview:HUD];
        HUD.delegate = self;
    }
    HUD.labelText = hud;
}
- (void)hudWasHidden:(MBProgressHUD *)hud {
    if (HUD && HUD.superview) {
        [HUD removeFromSuperview];
        HUD = nil;
    }
}

- (void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    [tableView setTableHeaderView:view];
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
