//
//  InfoDetailViewController.m
//  GUKE
//  资料库 详情页
//  Created by ianMac on 14-9-24.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import "InfoDetailViewController.h"
#import "MBProgressHUD.h"
#import "interface.h"
#import "InformationDetailModel.h"
#import "InfoFileTableViewCell.h"
#import "ShareCircleViewController.h"
#import "customActionSheet.h"
#import "SNGroupsViewController.h"
#import "CreatNewInfoViewController.h"
@interface InfoDetailViewController ()<UITableViewDataSource, UITableViewDelegate,MBProgressHUDDelegate,InfoFileTableViewCellDelegate,CreatNewInfoViewDelegate>
{
    MBProgressHUD *HUD;
    
    UIScrollView *_InfoDetailView;
    
    UIView *_titleView;
    
    UITableView *_fileTableView;
    
    UIView *_contentView;
    
    InformationDetailModel *_detailModel;
}

@property (nonatomic, strong) InformationModel *model;

// 获取"资料正文"数据
- (void)getArticleList;

// 自定义导航栏
- (void)loadNavigation;

// 初始化整个背景视图
- (void)loadInfoDetailView;

// 标题和姓名时间的视图
- (void)loadTitleView;

// 附件的视图
- (void)loadFileTableView;

// 文章内容
- (void)loadContentView;
@end

@implementation InfoDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

// 自定义初始化方法(传入model值)
- (instancetype)initWithModel:(InformationModel *)model
{
    if (self = [super init]) {
        self.model = model;
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"navi_bg"] forBarMetrics:UIBarMetricsDefault];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
}
- (void)loadView
{
    UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    view.backgroundColor = [UIColor whiteColor];
    self.view = view;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    if(IOS7_LATER){
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    
    UIBarButtonItem * spaceButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spaceButton.width = IOS7_OR_LATER ? -15:5;
    
    UIButton * right_button = [UIButton buttonWithType:UIButtonTypeCustom];
    right_button.frame = CGRectMake(0,0,50,30);
    [right_button setImage:[UIImage imageNamed:@"guke_ic_share"] forState:UIControlStateNormal];
    [right_button addTarget:self action:@selector(showActionSheet:forEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem * right_item = [[UIBarButtonItem alloc] initWithCustomView:right_button];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:spaceButton,right_item,nil];
    
    [self loadNavigation];
    [self getArticleList];
}

#pragma mark - 分享按钮
-(void) showActionSheet:(id)sender forEvent:(UIEvent*)event
{
    [self.view endEditing:YES];
    __weak typeof(self)bself = self;
    customActionSheet *actionSheet = [[customActionSheet alloc] init];
    NSString *share1 = @"分享到诊疗圈";
    NSString *share2 = @"分享到讨论组";
    NSString *edit = @"编辑资料";
    NSString * delete = @"删除资料";
    [actionSheet addButtonWithTitle:share1 icon:@"guke_ic_share_article" block:^{
        ShareCircleViewController * share = [[ShareCircleViewController alloc] initWithNibName:@"ShareCircleViewController" bundle:nil];
        share.share_content = _detailModel.title;
        share.theId = self.model.infoId;
        share.type = @"3";
        [bself.navigationController pushViewController:share animated:YES];
    }];
    [actionSheet addButtonWithTitle:share2 icon:@"guke_ic_share_group" block:^{
        
        SNGroupsViewController * list = [[SNGroupsViewController alloc] init];
        list.theId = self.model.infoId;
        list.type = @"1";
        [bself.navigationController pushViewController:list animated:YES];
        
    }];
    
    
    if ([self.model.userId isEqualToString:GET_U_ID])
    {
        [actionSheet addButtonWithTitle:edit icon:@"guke_ic_edit" block:^{
            
            CreatNewInfoViewController * create = [[CreatNewInfoViewController alloc] init];
            create.info = _detailModel;
            create.delegate = self;
            [bself.navigationController pushViewController:create animated:YES];
            
        }];
        
        [actionSheet addButtonWithTitle:delete icon:@"guke_ic_delete" block:^{
            [bself deleteZiLiao];
        }];
        
    }
    
    actionSheet.cornerRadius = 0;
    
    [actionSheet showWithTouch:event];
}

- (void)repeatLoadData{
    [self getArticleList];
}


// 获取"资料正文"数据
- (void)getArticleList
{
    [self creatHUD:LOCALIZATION(@"chat_loading")];
    [HUD show:YES];
    NSDictionary *parameters = @{@"userId": GET_USER_ID,@"sid": GET_S_ID,@"infoId":[NSString stringWithFormat:@"%@",self.model.infoId]};
    
    [AFRequestService responseData:@"info.php" andparameters:parameters andResponseData:^(NSData *responseData) {
        
        NSDictionary *articleDict = (NSDictionary *)responseData;
        NSLog(@"资料详情页数据 -----  %@",articleDict);
        NSInteger codeNum = [[articleDict objectForKey:@"code"]integerValue];
        if(codeNum == CODE_SUCCESS){
            
            NSDictionary *articleList = [articleDict objectForKey:@"info"];
            _detailModel = [[InformationDetailModel alloc] init];
            _detailModel.attachlist = [articleList objectForKey:@"attachlist"];
            _detailModel.content = [articleList objectForKey:@"content"];
            _detailModel.createDate = [articleList objectForKey:@"createDate"];
            _detailModel.deleteFlag = [articleList objectForKey:@"deleteFlag"];
            _detailModel.firstname = [articleList objectForKey:@"firstname"];
            _detailModel.infoId = [articleList objectForKey:@"infoId"];
            _detailModel.title = [articleList objectForKey:@"title"];
            _detailModel.userId = [articleList objectForKey:@"userId"];
            _detailModel.weight = [articleList objectForKey:@"weight"];
        }
        else if (codeNum == CODE_ERROE){
            NSString *alertcontext = @"网络连接失败";
            NSString *alertText = LOCALIZATION(@"dialog_prompt");
            NSString *alertOk = LOCALIZATION(@"dialog_ok");
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:alertText message:alertcontext delegate:nil cancelButtonTitle:alertOk otherButtonTitles:nil];
            [alert show];
            
        }
        [self loadInfoDetailView];
        [self loadTitleView];
        [self loadFileTableView];
        _fileTableView.frame = CGRectMake(0, _titleView.frame.origin.y+_titleView.frame.size.height, SCREEN_WIDTH, _detailModel.attachlist.count*70);
        [_fileTableView reloadData];
        [self loadContentView];
        _InfoDetailView.contentSize = CGSizeMake(SCREEN_WIDTH, _contentView.frame.origin.y+_contentView.frame.size.height+15);
        [HUD hide:YES];
    }];

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

// 初始化整个背景视图
- (void)loadInfoDetailView
{
    _InfoDetailView = [[UIScrollView alloc] init];
    _InfoDetailView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64);
    _InfoDetailView.backgroundColor = [UIColor whiteColor];
    _InfoDetailView.scrollEnabled = YES;
    [self.view addSubview:_InfoDetailView];
}

// 标题和姓名时间的视图
- (void)loadTitleView
{
    _titleView = [[UIView alloc] init];
    _titleView.frame = CGRectZero;
    _titleView.backgroundColor = [UIColor whiteColor];
    [_InfoDetailView addSubview:_titleView];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.frame = CGRectMake(10, 10, SCREEN_WIDTH-20, [SingleInstance customFontHeightFont:[NSString stringWithFormat:@"%@",_detailModel.title] andFontSize:17.0f andLineWidth:SCREEN_WIDTH-20]);
    titleLabel.backgroundColor = [UIColor whiteColor];
    titleLabel.text = [NSString stringWithFormat:@"%@",_detailModel.title];
    titleLabel.font = [UIFont boldSystemFontOfSize:15.0f];
    titleLabel.numberOfLines = 0;
    [_titleView addSubview:titleLabel];
    
    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.frame = CGRectMake(10, titleLabel.frame.origin.y+titleLabel.frame.size.height+5, SCREEN_WIDTH-20, 15);
    timeLabel.backgroundColor = [UIColor whiteColor];
    timeLabel.text = [NSString stringWithFormat:@"%@ %@", _detailModel.firstname,_detailModel.createDate];
    timeLabel.numberOfLines = 0;
    timeLabel.textColor = [UIColor lightGrayColor];
    timeLabel.font = [UIFont systemFontOfSize:13.0f];
    [_titleView addSubview:timeLabel];
    
    _titleView.frame = CGRectMake(0, 0, SCREEN_WIDTH, timeLabel.frame.origin.y+timeLabel.frame.size.height+10);
}

// 附件的视图
- (void)loadFileTableView
{
    _fileTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _fileTableView.backgroundColor = [UIColor clearColor];
    _fileTableView.delegate = self;
    _fileTableView.dataSource = self;
    _fileTableView.alwaysBounceVertical = NO;
    // 解决IOS7下tableview分割线左边短了一点
    if ([_fileTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [_fileTableView setSeparatorInset:UIEdgeInsetsZero];
        
    }
    [_InfoDetailView addSubview:_fileTableView];
}

// 文章内容
- (void)loadContentView
{
    _contentView = [[UIView alloc] init];
    _contentView.frame = CGRectZero;
    [_InfoDetailView addSubview:_contentView];
    
    NSMutableAttributedString * attributeString = [[NSMutableAttributedString alloc]initWithString:_detailModel.content attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15]}];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:7];//调整行间距
    [attributeString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [_detailModel.content length])];
   CGRect rectr = [attributeString boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0,SCREEN_WIDTH-20, rectr.size.height)];
    contentLabel.numberOfLines = 0;
    contentLabel.textColor = GETColor(156, 156, 156);
    contentLabel.font = [UIFont systemFontOfSize:14.0f];
    contentLabel.attributedText = attributeString;
    [_contentView addSubview:contentLabel];
    [contentLabel sizeToFit];
    _contentView.frame = CGRectMake(0, _fileTableView.frame.origin.y+_fileTableView.frame.size.height + 15, SCREEN_WIDTH, contentLabel.frame.origin.y+contentLabel.frame.size.height);

}

#pragma mark - 删除资料
-(void)deleteZiLiao
{
    NSDictionary *parameters = @{@"userId":GET_U_ID,@"sid":GET_S_ID,@"infoId":_detailModel.infoId};
    
    __weak typeof(self)wself=self;
    
    [AFRequestService responseData:INFORM_DEL_URL andparameters:parameters andResponseData:^(id responseData) {
        
        NSDictionary * dict = (NSDictionary *)responseData;
        NSString * code=[NSString stringWithFormat:@"%@",[dict objectForKey:@"code"]];
        
        if ([code intValue]==0)//说明请求数据成功
        {
            if (wself.delegate && [wself.delegate respondsToSelector:@selector(repeatLoadData)]) {
                [wself.delegate repeatLoadData];
            }
            [wself.navigationController popViewControllerAnimated:YES];
            
        }
    }];

}

// 手势事件
- (void)tapAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _detailModel.attachlist.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellName = @"infoFileCell";
    InfoFileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (!cell) {
        __weak typeof(self)wself=self;

        cell = [[InfoFileTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName thebloc:^(NSString *playfilepath) {
            [wself playVideWithString:playfilepath];

        }];
        
        cell.delegate=self;
   
    }

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.fileDic = [_detailModel.attachlist objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

#pragma mark---播放视频

-(void)playVideWithString:(NSString *)thestrUrl{
    
    
    
    
    
    
    NSURL *videoUrl=[NSURL URLWithString:thestrUrl];
    MPMoviePlayerViewController *movieVc=[[MPMoviePlayerViewController alloc]initWithContentURL:videoUrl];
    //弹出播放器
    [self presentMoviePlayerViewControllerAnimated:movieVc];
}



#pragma mark--播放视频方法结束
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
