//
//  FriendDetailViewController.m
//  UNITOA
//
//  Created by qidi on 14-6-26.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import "FriendDetailViewController.h"
#import "UIImageView+WebCache.h"
#import "SearchFriendsViewController.h"
#import "VChatViewController.h"
#import "UserLoginViewController.h"
#import "AppInPhone.h"
#import "Interface.h"
#import "FriendCircleDetailViewController.h"
#import "InferiorsTableViewController.h"
#import "UserInfoDB.h"
#import "addNewContact.h"
#import "AppDelegate.h"

#define CALL_BTN_TAG 201
#define MSG_BTN_TAG 202
#define TEL_BTN_TAG 203
#define MSG_BTN1_TAG 204
#define MAIL_BTN_TAG 205
#define SENDER_BTN1_TAG 206
#define SENDER_BTN2_TAG 207
#define ALERT_ADDSUCCESS_TAG 301
#define ALERT_ADDERROR_TAG 302
#define CALL_USER_TAG 303
#define TEL_USER_TAG 304
#define SIX_BG_VIEW 305
#define SIX_PARENTDETAIL 306
#define BGVIEW_TAG 307
#define UIIMAGEVIEW_TAG 308
#define FIRST_BG_VIEW 309
#define NAMELABLE_TAG 310
#define SECOND_BG_TAG 320
#define CALL_TAG 321
#define THIRD_BG_TAG 322
#define TEL_TAG 323
#define FOUR_BG_VIEW 324
#define MAIL_TAG 325
#define FIVE_BG_TAG 326
#define CITY_TAG 327
#define SEVEN_BG_TAG 328
#define INFERIORS_NUM_TAG 329
#define ALERT_FRIENDCIRCLE_TAG 330

@interface FriendDetailViewController ()
{
    UserIfo *userModel;
    
    NSString *tempUserId;
    NSString *tempUserName;
    
    UIButton *senderBtn;
    UIButton *senderBtn1;
    
    MBProgressHUD *HUD;
    
    // 下级用户数量
    NSString *num;
    
}

// 取得下级用户数量
- (void)getInferiorsNum;
@end

@implementation FriendDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        tempUserId = nil;
    }
    return self;
}

- (instancetype)initWithUserId:(NSString *)userId
{
    if (self = [super init]) {
        tempUserId = [NSString stringWithFormat:@"%@",userId];
    }
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self creatUI];
    [self getFriendDetail];
    [self navigetion];
    // 监听网络数据是否发生了变化
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataChange:) name:IS_DATACHANG object:nil];
}
// 执行方法，重新加载数据
- (void)dataChange:(NSNotification *)noti{
    [self getFriendDetail];
}
- (void)navigetion
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
    
    UILabel *loginLabel = [[UILabel alloc]initWithFrame:CGRectMake(image.size.width+5, 7, 160, 30)];
    loginLabel.text = LOCALIZATION(@"friend_detail_ifo");
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
- (void)creatUI
{
    UITableView *bgView = nil;
    if (currentDev || currentDev1) {
        bgView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, viewSize.width, viewSize.height-64)];
    }
    else{
        bgView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, viewSize.width, viewSize.height-44)];
    }
    bgView.separatorStyle = UITableViewCellSeparatorStyleNone;
    bgView.tag = BGVIEW_TAG;
    UIView *firstBgView = [[UIView alloc]initWithFrame:CGRectMake(-1, 0, viewSize.width+2, 90)];
    firstBgView.layer.borderWidth = 2;
    firstBgView.layer.borderColor = [GETColor(242, 243, 247) CGColor];
    firstBgView.tag = FIRST_BG_VIEW;
    
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 70, 70)];
    imgView.tag = UIIMAGEVIEW_TAG;
    
    
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(87, 10, 150, 20)];
    nameLabel.tag = NAMELABLE_TAG;
    nameLabel.textColor = [UIColor blackColor];
    nameLabel.font = [UIFont systemFontOfSize:16];
    [firstBgView addSubview:imgView];
    [firstBgView addSubview:nameLabel];
    imgView = nil;
    nameLabel = nil;
    
    // 办公电话
    UIView *secondBgView = [[UIView alloc]initWithFrame:CGRectMake(-1, 89, viewSize.width+2, 40)];
    secondBgView.tag = SECOND_BG_TAG;
    secondBgView.layer.borderWidth = 1;
    secondBgView.layer.borderColor = [GETColor(242, 243, 247) CGColor];
    UILabel *callLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, 70, 20)];
    callLabel.text = LOCALIZATION(@"userinfo_phone");
    callLabel.textColor = [UIColor blackColor];
    callLabel.backgroundColor = [UIColor clearColor];
    callLabel.font = [UIFont systemFontOfSize:16];
    
    UILabel *call = [[UILabel alloc]initWithFrame:CGRectMake(80, 10, 180, 20)];
    call.tag = CALL_TAG;
    call.textColor = [UIColor grayColor];
    callLabel.backgroundColor = [UIColor clearColor];
    call.font = [UIFont systemFontOfSize:14];
    
    UIButton *callBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *callimage = [UIImage imageNamed:@"friend_phone_ico"];
    callBtn.frame = CGRectMake(245, (40 - callimage.size.height)/2, callimage.size.width, callimage.size.height);
    [callBtn setImage:callimage forState:UIControlStateNormal];
   // callBtn.imageEdgeInsets = UIEdgeInsetsMake(3, 5, 7, 5);
    callBtn.tag = CALL_BTN_TAG;
    [callBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [callBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    callBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    UIButton *msgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *msgimage = [UIImage imageNamed:@"friend_chat_ico"];
    msgBtn.frame = CGRectMake(280, (40 - msgimage.size.height)/2, msgimage.size.width, msgimage.size.height);
    [msgBtn setImage:msgimage forState:UIControlStateNormal];
    //msgBtn.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    
    //msgBtn.frame = CGRectMake(280, 5, 30, 30);
    msgBtn.tag = MSG_BTN_TAG;
    [msgBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [msgBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    msgBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [secondBgView addSubview:callLabel];
    [secondBgView addSubview:call];
    [secondBgView addSubview:callBtn];
    [secondBgView addSubview:msgBtn];
    
    callLabel = nil;
    call = nil;
    callBtn = nil;
    msgBtn = nil;
    
    // 手机
    UIView *thirdBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 130, viewSize.width, 40)];
    thirdBgView.tag = THIRD_BG_TAG;
    UILabel *telLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, 70, 20)];
    telLabel.text = LOCALIZATION(@"userinfo_mobile");
    telLabel.textColor = [UIColor blackColor];
    telLabel.backgroundColor = [UIColor clearColor];
    telLabel.font = [UIFont systemFontOfSize:16];
    
    UILabel *tel = [[UILabel alloc]initWithFrame:CGRectMake(90, 10, 170, 20)];
    tel.tag = TEL_TAG;
    tel.textColor = [UIColor grayColor];
    tel.backgroundColor = [UIColor clearColor];
    tel.font = [UIFont systemFontOfSize:14];
    
    UIButton *telBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *telimage = [UIImage imageNamed:@"friend_phone_ico"];
    telBtn.frame = CGRectMake(245, (40 - callimage.size.height)/2, callimage.size.width, callimage.size.height);
    [telBtn setImage:telimage forState:UIControlStateNormal];
   // telBtn.imageEdgeInsets = UIEdgeInsetsMake(3, 5, 7, 5);
    
    //telBtn.frame = CGRectMake(245, 5, 30, 30);
    telBtn.tag = TEL_BTN_TAG;
    [telBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [telBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    telBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    UIButton *msgBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [msgBtn1 setImage:[UIImage imageNamed:@"friend_chat_ico"] forState:UIControlStateNormal];
    msgBtn1.frame = CGRectMake(280, (40 - msgimage.size.height)/2, msgimage.size.width, msgimage.size.height);

   // msgBtn1.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    msgBtn1.tag = MSG_BTN1_TAG;
    [msgBtn1 setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [msgBtn1 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    msgBtn1.titleLabel.textAlignment = NSTextAlignmentCenter;
    [thirdBgView addSubview:telLabel];
    [thirdBgView addSubview:tel];
    [thirdBgView addSubview:telBtn];
    [thirdBgView addSubview:msgBtn1];
    telLabel = nil;
    tel = nil;
    telBtn = nil;
    msgBtn1 = nil;
    
    // 邮箱
    UIView *fourBgView = [[UIView alloc]initWithFrame:CGRectMake(-1, 170, viewSize.width+2, 40)];
    fourBgView.userInteractionEnabled = YES;
    fourBgView.tag = FOUR_BG_VIEW;
    fourBgView.layer.borderWidth = 1;
    fourBgView.layer.borderColor = [GETColor(242, 243, 247) CGColor];
    UILabel *mailLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, 70, 20)];
    mailLabel.text = LOCALIZATION(@"userinfo_email");
    mailLabel.textColor = [UIColor blackColor];
    mailLabel.backgroundColor = [UIColor clearColor];
    mailLabel.font = [UIFont systemFontOfSize:16];
    
    UILabel *mail = [[UILabel alloc]initWithFrame:CGRectMake(90, 10, 170, 20)];
    mail.tag = MAIL_TAG;
    mail.textColor = [UIColor grayColor];
    mail.backgroundColor = [UIColor clearColor];
    mail.font = [UIFont systemFontOfSize:14];
    
    UIButton *mailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [mailBtn setImage:[UIImage imageNamed:@"friend_message_ico"] forState:UIControlStateNormal];
    mailBtn.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    
    [mailBtn addTarget:self action:@selector(sendMail) forControlEvents:UIControlEventTouchUpInside];
    mailBtn.frame = CGRectMake(280, 5, 30, 30);
    [mailBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    
    mailBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    UITapGestureRecognizer *tap4 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(sendMail)];
    [fourBgView addGestureRecognizer:tap4];
    tap4 = nil;
    
    [fourBgView addSubview:mailLabel];
    [fourBgView addSubview:mail];
    [fourBgView addSubview:mailBtn];
    mailLabel = nil;
    mail = nil;
    mailBtn = nil;
    
    // 城市
    UIView *fiveBgView = [[UIView alloc]initWithFrame:CGRectMake(-1, 209, viewSize.width+2, 40)];
    fiveBgView.tag = FIVE_BG_TAG;
    fiveBgView.layer.borderWidth = 1;
    fiveBgView.layer.borderColor = [GETColor(242, 243, 247) CGColor];
    UILabel *cityLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, 70, 20)];
    cityLabel.text = LOCALIZATION(@"userinfo_city");
    cityLabel.textColor = [UIColor blackColor];
    cityLabel.backgroundColor = [UIColor clearColor];
    cityLabel.font = [UIFont systemFontOfSize:16];
    
    UILabel *cityName = [[UILabel alloc]initWithFrame:CGRectMake(90, 10, 170, 20)];
    cityName.tag = CITY_TAG;
    cityName.textColor = [UIColor grayColor];
    cityName.backgroundColor = [UIColor clearColor];
    cityName.font = [UIFont systemFontOfSize:13];
    [fiveBgView addSubview:cityLabel];
    [fiveBgView addSubview:cityName];
    
    // 上级
    UIView *sixBgView = [[UIView alloc]initWithFrame:CGRectMake(-1, 257, viewSize.width+2, 40)];
    sixBgView.layer.borderWidth = 1;
    sixBgView.layer.borderColor = [GETColor(242, 243, 247) CGColor];
    sixBgView.userInteractionEnabled = YES;
    sixBgView.tag = SIX_BG_VIEW;
    
    UIView *view = [[UIView alloc] init];
    view.frame = CGRectMake(0, 256, SCREEN_WIDTH, 2);
    view.backgroundColor = GETColor(219, 219, 219);
    
    if ([userModel.parentId isEqualToString:@"0"]) {
        sixBgView.hidden = NO;
    }
    UILabel *parentLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, 70, 20)];
    parentLabel.text = LOCALIZATION(@"userinfo_parent");
    parentLabel.textColor = [UIColor blackColor];
    parentLabel.backgroundColor = [UIColor clearColor];
    parentLabel.font = [UIFont systemFontOfSize:16];
    
    
    UILabel *parentDetail = [[UILabel alloc]initWithFrame:CGRectMake(240, 10, 70, 20)];
    parentDetail.textAlignment = NSTextAlignmentRight;
    parentDetail.textColor = [UIColor grayColor];
    parentDetail.backgroundColor = [UIColor clearColor];
    parentDetail.font = [UIFont systemFontOfSize:14];
    parentDetail.tag = SIX_PARENTDETAIL;
    
    [sixBgView addSubview:parentLabel];
    [sixBgView addSubview:parentDetail];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestrueAction)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [sixBgView addGestureRecognizer:tap];
    tap = nil;
    
    
    // 添加"下级"视图
    UIView *sevenBgView = [[UIView alloc]initWithFrame:CGRectMake(-1, 296, viewSize.width+2, 40)];
    sevenBgView.tag = SEVEN_BG_TAG;
    sevenBgView.layer.borderWidth = 1;
    sevenBgView.layer.borderColor = [GETColor(242, 243, 247) CGColor];
    sevenBgView.userInteractionEnabled = YES;
    
    UILabel *parentLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, 70, 20)];
    parentLabel2.text = LOCALIZATION(@"userinfo_sub");
    parentLabel2.textColor = [UIColor blackColor];
    parentLabel2.backgroundColor = [UIColor clearColor];
    parentLabel2.font = [UIFont systemFontOfSize:16];
    
    UILabel *parentDetail2 = [[UILabel alloc]initWithFrame:CGRectMake(240, 10, 70, 20)];
    parentDetail2.tag = INFERIORS_NUM_TAG;
    parentDetail2.textAlignment = NSTextAlignmentRight;
    parentDetail2.textColor = [UIColor grayColor];
    parentDetail2.backgroundColor = [UIColor clearColor];
    parentDetail2.font = [UIFont systemFontOfSize:14];
    
    [sevenBgView addSubview:parentLabel2];
    [sevenBgView addSubview:parentDetail2];
    parentLabel2 = nil;
    parentDetail2 = nil;
    
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap2GestrueAction)];
    tap2.numberOfTapsRequired = 1;
    tap2.numberOfTouchesRequired = 1;
    [sevenBgView addGestureRecognizer:tap2];
    tap2 = nil;
    
    // 添加"朋友圈"视图
    UIView *eightBgView = [[UIView alloc]initWithFrame:CGRectMake(-1, 335, viewSize.width+2, 40)];
    eightBgView.layer.borderWidth = 1;
    eightBgView.layer.borderColor = [GETColor(242, 243, 247) CGColor];
    eightBgView.userInteractionEnabled = YES;
    
    UILabel *parentLabel3 = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, 70, 20)];
    parentLabel3.text = LOCALIZATION(@"friend_group");
    parentLabel3.textColor = [UIColor blackColor];
    parentLabel3.backgroundColor = [UIColor clearColor];
    parentLabel3.font = [UIFont systemFontOfSize:16];
    
    
    UILabel *parentDetail3 = [[UILabel alloc]initWithFrame:CGRectMake(230, 10, 70, 20)];
    parentDetail3.text = LOCALIZATION(@"userinfo_viewdetail");
    parentDetail3.textAlignment = NSTextAlignmentRight;
    parentDetail3.textColor = [UIColor grayColor];
    parentDetail3.backgroundColor = [UIColor clearColor];
    parentDetail3.font = [UIFont systemFontOfSize:14];
    
    UIImageView *arrowView = [[UIImageView alloc]initWithFrame:CGRectMake(300, 15, 10, 10)];
    arrowView.image = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"task_arrow@2x" ofType:@"png"]];
    
    [eightBgView addSubview:parentLabel3];
    [eightBgView addSubview:parentDetail3];
    [eightBgView addSubview:arrowView];
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapFriendAction)];
    tap3.numberOfTapsRequired = 1;
    tap3.numberOfTouchesRequired = 1;
    [eightBgView addGestureRecognizer:tap3];
    tap3 = nil;
    
    
    
    senderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [senderBtn setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"task_btn_reject_big@2x" ofType:@"png"]] forState:UIControlStateNormal];
    senderBtn.frame = CGRectZero;
    senderBtn.tag = SENDER_BTN1_TAG;
    [senderBtn setTitle:LOCALIZATION(@"userinfo_chat") forState:UIControlStateNormal];
    [senderBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [senderBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    senderBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    senderBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    senderBtn.hidden = YES;
    
    senderBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [senderBtn1 setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"task_btn_reject_big@2x" ofType:@"png"]] forState:UIControlStateNormal];
    
    senderBtn1.frame = CGRectZero;
    [senderBtn1 setTitle:LOCALIZATION(@"userinfo_addaddress") forState:UIControlStateNormal];
    [senderBtn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [senderBtn1 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    senderBtn1.titleLabel.textAlignment = NSTextAlignmentCenter;
    senderBtn1.titleLabel.font = [UIFont systemFontOfSize:16];
    senderBtn1.tag = SENDER_BTN2_TAG;
    senderBtn1.hidden = YES;
    
    [bgView addSubview:firstBgView];
    [bgView addSubview:secondBgView];
    [bgView addSubview:thirdBgView];
    [bgView addSubview:fourBgView];
    [bgView addSubview:fiveBgView];
    [bgView addSubview:sixBgView];
    [bgView addSubview:sevenBgView];
    [bgView addSubview:eightBgView];
    [bgView addSubview:senderBtn];
    [bgView addSubview:senderBtn1];
    [bgView addSubview:view];
    firstBgView = nil;
    secondBgView = nil;
    thirdBgView = nil;
    firstBgView = nil;
    fourBgView = nil;
    fiveBgView = nil;
    sixBgView = nil;
    sevenBgView = nil;
    eightBgView = nil;
    [self.view addSubview:bgView];
    [self initData];
}
// 加载本地数据进行初始话
- (void)initData
{
    UIImageView *imgView = (UIImageView *)[[[self.view viewWithTag:BGVIEW_TAG] viewWithTag:FIRST_BG_VIEW] viewWithTag:UIIMAGEVIEW_TAG];
    [imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGE_BASE_URL,[UserInfoDB selectFeildString:@"icon" andcuId:GET_USER_ID anduserId:self.friendModel.dstUserId]]] placeholderImage:[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"user_default_ico@2x" ofType:@"png"]]];
    
    UILabel *nameLabel = (UILabel *)[[[self.view viewWithTag:BGVIEW_TAG] viewWithTag:FIRST_BG_VIEW] viewWithTag:NAMELABLE_TAG];
    nameLabel.text = [UserInfoDB selectFeildString:@"firstname" andcuId:GET_USER_ID anduserId:self.friendModel.dstUserId];

    UILabel *call = (UILabel *)[[[self.view viewWithTag:BGVIEW_TAG] viewWithTag:SECOND_BG_TAG] viewWithTag:CALL_TAG];
    call.text = [UserInfoDB selectFeildString:@"telephone" andcuId:GET_USER_ID anduserId:self.friendModel.dstUserId];
    UILabel *tel = (UILabel *)[[[self.view viewWithTag:BGVIEW_TAG] viewWithTag:THIRD_BG_TAG] viewWithTag:TEL_TAG];
    tel.text = [UserInfoDB selectFeildString:@"mobile" andcuId:GET_USER_ID anduserId:self.friendModel.dstUserId];
    ;

    UILabel *mail = (UILabel *)[[[self.view viewWithTag:BGVIEW_TAG] viewWithTag:FOUR_BG_VIEW] viewWithTag:MAIL_TAG];
    mail.text = [UserInfoDB selectFeildString:@"email" andcuId:GET_USER_ID anduserId:self.friendModel.dstUserId];

    UILabel *cityName = (UILabel *)[[[self.view viewWithTag:BGVIEW_TAG] viewWithTag:FIVE_BG_TAG] viewWithTag:CITY_TAG];
    cityName.text = [UserInfoDB selectFeildString:@"cityName" andcuId:GET_USER_ID anduserId:self.friendModel.dstUserId];
    if ([[UserInfoDB selectFeildString:@"userId" andcuId:GET_USER_ID anduserId:self.friendModel.dstUserId] isEqualToString:GET_USER_ID]) {
        senderBtn.hidden = YES;
        senderBtn1.hidden = YES;
    }
    else{
    if ([[UserInfoDB selectFeildString:@"isFriend" andcuId:GET_USER_ID anduserId:self.friendModel.dstUserId] isEqualToString:@"1"]) {
        senderBtn.hidden = NO;
        senderBtn.frame = CGRectMake(30, 995/2-66, viewSize.width-60, 30);
        if (SCREEN_HEIGHT<568) {
            senderBtn.frame = CGRectMake(30, 480-64-35, viewSize.width-60, 30);
        }
        senderBtn.userInteractionEnabled = YES;
        
        senderBtn1.frame = CGRectZero;
        senderBtn1.hidden = YES;
        senderBtn1.userInteractionEnabled = NO;
        senderBtn1.alpha = 0;
    }
    else {
        senderBtn.frame = CGRectZero;
        senderBtn.hidden = YES;
        senderBtn.userInteractionEnabled = NO;
        
        senderBtn1.hidden = NO;
        senderBtn1.userInteractionEnabled = YES;
        senderBtn1.frame = CGRectMake(30, 995/2-66, viewSize.width-60, 30);
        if (SCREEN_HEIGHT<568) {
            senderBtn1.frame = CGRectMake(30, 480-64-35, viewSize.width-60, 30);
        }
        
    }
    }
}
// 更新请求完毕后的网络数据
- (void)updateData
{
    UIImageView *imgView = (UIImageView *)[[[self.view viewWithTag:BGVIEW_TAG] viewWithTag:FIRST_BG_VIEW] viewWithTag:UIIMAGEVIEW_TAG];
    [imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGE_BASE_URL,userModel.icon]] placeholderImage:[UIImage imageNamed:@"portrait_ico"]];
    
    UILabel *nameLabel = (UILabel *)[[[self.view viewWithTag:BGVIEW_TAG] viewWithTag:FIRST_BG_VIEW] viewWithTag:NAMELABLE_TAG];
    nameLabel.text = userModel.firstname;
    
    UILabel *call = (UILabel *)[[[self.view viewWithTag:BGVIEW_TAG] viewWithTag:SECOND_BG_TAG] viewWithTag:CALL_TAG];
    call.text = userModel.telephone;
    
    UILabel *tel = (UILabel *)[[[self.view viewWithTag:BGVIEW_TAG] viewWithTag:THIRD_BG_TAG] viewWithTag:TEL_TAG];
    tel.text = userModel.mobile;
    
    UILabel *mail = (UILabel *)[[[self.view viewWithTag:BGVIEW_TAG] viewWithTag:FOUR_BG_VIEW] viewWithTag:MAIL_TAG];
    mail.text = userModel.email;
    
    UILabel *cityName = (UILabel *)[[[self.view viewWithTag:BGVIEW_TAG] viewWithTag:FIVE_BG_TAG] viewWithTag:CITY_TAG];
    cityName.text = userModel.cityName;
    
    
    UILabel *parentDetail = (UILabel *)[[[self.view viewWithTag:BGVIEW_TAG] viewWithTag:SIX_BG_VIEW] viewWithTag:SIX_PARENTDETAIL];
    parentDetail.text = [NSString stringWithFormat:@"%@",tempUserName];
    if ([userModel.parentId isEqualToString:@"0"]) {
        parentDetail.text = LOCALIZATION(@"no_parent");
    }
    
    UILabel *parentDetail2 = (UILabel *)[[[self.view viewWithTag:BGVIEW_TAG] viewWithTag:SEVEN_BG_TAG] viewWithTag:INFERIORS_NUM_TAG];
    parentDetail2.text = [num stringByAppendingString:@"人"];
    if ([num isEqualToString:@"0"]) {
        parentDetail2.text = @"无下级";
    }
    if ([self.friendModel.dstUserId isEqualToString:GET_USER_ID]) {
        senderBtn.hidden = YES;
        senderBtn1.hidden = YES;

    }
    else{
    if ([userModel.isFriend isEqualToString:@"1"]) {
        senderBtn.hidden = NO;
        senderBtn.frame = CGRectMake(30, 995/2-66, viewSize.width-60, 30);
        if (SCREEN_HEIGHT<568) {
            senderBtn.frame = CGRectMake(30, 480-64-35, viewSize.width-60, 30);
        }
        senderBtn.userInteractionEnabled = YES;
        
        senderBtn1.frame = CGRectZero;
        senderBtn1.hidden = YES;
        senderBtn1.userInteractionEnabled = NO;
        senderBtn1.alpha = 0;
    }
    else {
        senderBtn.frame = CGRectZero;
        senderBtn.hidden = YES;
        senderBtn.userInteractionEnabled = NO;
        
        senderBtn1.hidden = NO;
        senderBtn1.userInteractionEnabled = YES;
        senderBtn1.frame = CGRectMake(30, 995/2-66, viewSize.width-60, 30);
        if (SCREEN_HEIGHT<568) {
            senderBtn1.frame = CGRectMake(30, 480-64-35, viewSize.width-60, 30);
        }
    }
    }
}
// 取得下级用户数量
- (void)getInferiorsNum
{
    [HUD show:YES];
    if (!tempUserId) {
        tempUserId = self.friendModel.dstUserId;
    }
    NSDictionary *parameters = @{@"userId":GET_USER_ID,@"sid":GET_S_ID,@"dstUserId":tempUserId};
    [AFRequestService responseData:SUB_USER_COUNT_URL andparameters:parameters andResponseData:^(id responseData){
        NSDictionary *dict =(NSDictionary *)responseData;
        if ([self getInferiorsIfo:dict]) {
            [self updateData];
        }
        [HUD hide:YES];
    }];
}

- (BOOL)getInferiorsIfo:(NSDictionary *)dict
{
    NSUInteger codeNum = [[dict objectForKey:@"code"] integerValue];
    if (codeNum == CODE_SUCCESS) {
        num = [dict objectForKey:@"count"];
        return YES;
    }
    else if (codeNum == CODE_ERROE){
        SqliteFieldAndTable *sqliteAndtable = [[SqliteFieldAndTable alloc]init];
        FriendDetailViewController __weak *_Self = self;
        [sqliteAndtable repeatLogin:^(BOOL flag) {
            if (flag) {
                [_Self getInferiorsNum];
            }
            else{
                UserLoginViewController *login = [[UserLoginViewController alloc]init];
                [_Self.navigationController pushViewController:login animated:YES];
                login = nil;
            }
            
        }];
        return NO;
    }
    else{
        return NO;
    }
    
}

- (void)btnClick:(UIButton *)sender
{
    switch (sender.tag) {
        case CALL_BTN_TAG:{
            if ([userModel.telephone isEqualToString:@""] || userModel.telephone == nil) {
                NSString * alertText= LOCALIZATION(@"dialog_prompt");
                NSString * alertcontext= LOCALIZATION(@"userinfo_mobile_empty");
                NSString *alertOk = LOCALIZATION(@"dialog_ok");
                NSString *alertNO= LOCALIZATION(@"dialog_cancel");
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:alertText message:alertcontext delegate:nil cancelButtonTitle:alertOk otherButtonTitles:alertNO,nil];
                [alert show];
            }
            else{
                
                NSString *alertcontext = [NSString stringWithFormat:LOCALIZATION(@"userinfo_call_confirm"),userModel.firstname];
                NSString * alertText= LOCALIZATION(@"dialog_prompt");
                NSString *alertOk = LOCALIZATION(@"dialog_ok");
                NSString *alertNO= LOCALIZATION(@"dialog_cancel");
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:alertText message:alertcontext delegate:self cancelButtonTitle:alertOk otherButtonTitles:alertNO,nil];
                alert.tag = CALL_BTN_TAG;
                [alert show];
                
            }
        }
            break;
        case MSG_BTN_TAG:{
            if ([userModel.telephone isEqualToString:@""] || userModel.telephone == nil) {
                NSString * alertText= LOCALIZATION(@"dialog_prompt");
                NSString * alertcontext= LOCALIZATION(@"userinfo_mobile_empty");
                NSString *alertOk = LOCALIZATION(@"dialog_ok");
                NSString *alertNO= LOCALIZATION(@"dialog_cancel");
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:alertText message:alertcontext delegate:nil cancelButtonTitle:alertOk otherButtonTitles:alertNO,nil];
                [alert show];
            }
            else{
                [AppInPhone smsInPhone:userModel.telephone];
            }
        }
            
            break;
        case TEL_BTN_TAG:{
            if ([userModel.mobile isEqualToString:@""] || userModel.mobile == nil) {
                NSString * alertText= LOCALIZATION(@"dialog_prompt");
                NSString * alertcontext= LOCALIZATION(@"userinfo_mobile_empty");
                NSString *alertOk = LOCALIZATION(@"dialog_ok");
                NSString *alertNO= LOCALIZATION(@"dialog_cancel");
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:alertText message:alertcontext delegate:nil cancelButtonTitle:alertOk otherButtonTitles:alertNO,nil];
                [alert show];
            }
            else{
                NSString *alertcontext = [NSString stringWithFormat:LOCALIZATION(@"userinfo_call_confirm"),userModel.firstname];
                NSString * alertText= LOCALIZATION(@"dialog_prompt");
                NSString *alertOk = LOCALIZATION(@"dialog_ok");
                NSString *alertNO= LOCALIZATION(@"dialog_cancel");
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:alertText message:alertcontext delegate:self cancelButtonTitle:alertOk otherButtonTitles:alertNO,nil];
                alert.tag = TEL_BTN_TAG;
                [alert show];
                //
            }
        }
            
            break;
        case MSG_BTN1_TAG:{
            if ([userModel.mobile isEqualToString:@""] || userModel.mobile == nil) {
                NSString * alertText= LOCALIZATION(@"dialog_prompt");
                NSString * alertcontext= LOCALIZATION(@"userinfo_mobile_empty");
                NSString *alertOk = LOCALIZATION(@"dialog_ok");
                NSString *alertNO= LOCALIZATION(@"dialog_cancel");
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:alertText message:alertcontext delegate:nil cancelButtonTitle:alertOk otherButtonTitles:alertNO,nil];
                [alert show];
            }
            else{
                [AppInPhone smsInPhone:userModel.mobile];
            }
        }
            
            break;
        case MAIL_BTN_TAG:{
            Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
            
            if (mailClass != nil)
            {
                // We must always check whether the current device is configured for sending emails
                if ([mailClass canSendMail])
                {
                    [self displayComposerSheet];
                }
                else
                {
                    [self launchMailAppOnDevice];
                }
            }
            else
            {
                [self launchMailAppOnDevice];
            }
        }
            break;
        case SENDER_BTN1_TAG:
        {
            
            if (_friendModel.dstUser.length <= 0 || userModel.username.length <= 0) {
                [self.navigationController popViewControllerAnimated:YES];
         }
            else{
                VChatViewController *vc = [[VChatViewController alloc] init];
                // 添加好友到联系人列表
                [addNewContact addUserContact:userModel.userId];
                vc.type = VChatType_pChat;
                vc.recvId = [NSNumber numberWithInt:[_friendModel.dstUserId intValue]];
                vc.recvName = _friendModel.dstUser;
                vc.recvFirstName = _friendModel.dstUserName;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
            
            break;
        case SENDER_BTN2_TAG:{
            @try {
                [self addFriend];
            }
            @catch (NSException *exception) {
                return;
            }
            @finally {
                
            }
            
            
        }
            break;
        default:
            break;
    }
}
- (void)addFriend{
    NSDictionary *parameter = @{@"userId":GET_USER_ID,@"sid":GET_S_ID,@"dstUserId": userModel.userId};
    [AFRequestService responseData:FRIEND_ADD_URL andparameters:parameter andResponseData:^(NSData *responseData) {
        NSDictionary *dict = (NSDictionary *)responseData;
        NSUInteger codeNum = [[dict objectForKey:@"code"] integerValue];
        if (codeNum == CODE_SUCCESS) {
            NSString *alertcontext = LOCALIZATION(@"friend_verify_success");
            NSString *alertText = LOCALIZATION(@"dialog_prompt");
            NSString *alertOk = LOCALIZATION(@"dialog_ok");
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:alertText message:alertcontext delegate:self cancelButtonTitle:alertOk otherButtonTitles:nil];
            alert.tag = ALERT_ADDSUCCESS_TAG;
            [alert show];
        }
        else if(codeNum == CODE_ERROE){
            SqliteFieldAndTable *sqliteAndtable = [[SqliteFieldAndTable alloc]init];
            FriendDetailViewController __weak *_Self = self;
            [sqliteAndtable repeatLogin:^(BOOL flag) {
                if (flag) {
                    [_Self addFriend];
                }
                else{
                    UserLoginViewController *login = [[UserLoginViewController alloc]init];
                    [_Self.navigationController pushViewController:login animated:YES];
                    login = nil;
                }
                
            }];

        }
    }];

}
- (void)tapGestrueAction
{
    if (![userModel.parentId isEqualToString:@"0"]) {
        FriendDetailViewController *fdvc = [[FriendDetailViewController alloc] initWithUserId:userModel.parentId];
        [self.navigationController pushViewController:fdvc animated:YES];
    }
    
}

- (void)tap2GestrueAction
{
    if (![num isEqualToString:@"0"]) {
        InferiorsTableViewController *itc = [[InferiorsTableViewController alloc] initWithDstUserId:userModel.userId];
        [self.navigationController pushViewController:itc animated:YES];
    }
}

- (void)tapFriendAction
{

    FriendCircleDetailViewController *fcdc = [[FriendCircleDetailViewController alloc] initWithModel:tempUserId];
        [self.navigationController pushViewController:fcdc animated:YES];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (alertView.tag) {
        case ALERT_ADDSUCCESS_TAG:
            //[self.navigationController popViewControllerAnimated:NO];
           
        {// 跳转到主界面
            AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [appDelegate showControlView:Root_friend];
        }
            break;
        case ALERT_ADDERROR_TAG:
            
            break;
        case CALL_BTN_TAG:
            if (buttonIndex == 0) {
                [AppInPhone telInPhone:userModel.telephone];
            }
            else{
                return;
            }
            break;
        case TEL_BTN_TAG:
            if (buttonIndex == 0) {
                [AppInPhone telInPhone:userModel.mobile];
            }
            else{
                return;
            }
            
            break;
        default:
            break;
    }
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)sendMail{
    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
    
    if (mailClass != nil)
    {
        // We must always check whether the current device is configured for sending emails
        if ([mailClass canSendMail])
        {
            [self displayComposerSheet];
        }
        else
        {
            [self launchMailAppOnDevice];
        }
    }
    else
    {
        [self launchMailAppOnDevice];
    }
}
- (void)tapAction
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)getFriendDetail
{
    [HUD show:YES];
    if (!tempUserId) {
        tempUserId = self.friendModel.dstUserId;
    }
    NSDictionary *parameters = @{@"userId":GET_USER_ID,@"sid":GET_S_ID,@"viewId":tempUserId};
    [AFRequestService responseData:USER_INFO_BYID_URL andparameters:parameters andResponseData:^(id responseData){
        NSDictionary *dict =(NSDictionary *)responseData;
        if ([self getUserIfo:dict]) {
                [self getInferiorsNum];
            if (![userModel.parentId isEqualToString:@"0"]) {
                [self getUserNameByUserId:userModel.parentId];
            }
        }
        [HUD hide:YES];
    }   andCathtype:[GET_USER_ID integerValue] andID:[tempUserId integerValue] andtypeName: [UserInfoDB selectFeildString:@"firstname" andcuId:GET_U_ID anduserId:tempUserId]
        ];// 被添加好友的id和用户名
}
//获取用户详细信息
- (BOOL)getUserIfo:(NSDictionary *)userIfo
{
    
    NSUInteger codeNum = [[userIfo objectForKey:@"code"] integerValue];
    if (codeNum == CODE_SUCCESS) {
        // 将数据库中没有的写到数据库中
        SqliteFieldAndTable *addUser = [[SqliteFieldAndTable alloc]init];
        [addUser getFeildandValueById:userIfo];
        
        NSDictionary *userDetail = [userIfo objectForKey:@"user"];
        userModel = [[UserIfo alloc]init];
        userModel.address = [userDetail valueForKey:@"address"];
        userModel.allowPosition = [userDetail valueForKey:@"allowPosition"];
        userModel.articleBg = [userDetail valueForKey:@"articleBg"];
        userModel.bgUpdateTime = [userDetail valueForKey:@"bgUpdateTime"];
        userModel.chkATime = [userDetail valueForKey:@"chkATime"];
        userModel.cityName = [userDetail valueForKey:@"cityName"];
        userModel.companyId = [userDetail valueForKey:@"companyId"];
        userModel.createDate = [userDetail valueForKey:@"createDate"];
        userModel.deletePerm = [userDetail valueForKey:@"deletePerm"];
        userModel.district = [userDetail valueForKey:@"district"];
        userModel.email = [userDetail valueForKey:@"email"];
        userModel.firstname = [userDetail valueForKey:@"firstname"];
        userModel.firstnameen = [userDetail valueForKey:@"firstnameen"];
        userModel.icon = [userDetail valueForKey:@"icon"];
        userModel.iconUpdateTime = [userDetail valueForKey:@"iconUpdateTime"];
        userModel.inviteCodeId = [userDetail valueForKey:@"inviteCodeId"];
        userModel.invitePerm = [userDetail valueForKey:@"invitePerm"];
        userModel.itcode = [userDetail valueForKey:@"itcode"];
        userModel.isFriend = [userDetail valueForKey:@"isFriend"];
        userModel.lastChkETime = [userDetail valueForKey:@"lastChkETime"];
        userModel.lastLogin = [userDetail valueForKey:@"lastLogin"];
        userModel.lastLoginIP = [userDetail valueForKey:@"lastLoginIP"];
        userModel.latitude = [userDetail valueForKey:@"latitude"];
        userModel.loginCount = [userDetail valueForKey:@"loginCount"];
        userModel.longitude = [userDetail valueForKey:@"longitude"];
        userModel.mailStatus = [userDetail valueForKey:@"mailStatus"];
        userModel.memo = [userDetail valueForKey:@"memo"];
        userModel.mobile = [userDetail valueForKey:@"mobile"];
        userModel.organization = [userDetail valueForKey:@"organization"];
        userModel.organizationen = [userDetail valueForKey:@"organizationen"];
        userModel.parentCode = [userDetail valueForKey:@"parentCode"];
        userModel.parentId = [userDetail valueForKey:@"parentId"];
        userModel.position = [userDetail valueForKey:@"position"];
        userModel.positionen = [userDetail valueForKey:@"positionen"];
        userModel.province = [userDetail valueForKey:@"province"];
        userModel.sex = [userDetail valueForKey:@"sex"];
        userModel.showMobile = [userDetail valueForKey:@"showMobile"];
        userModel.sid = [userDetail valueForKey:@"sid"];
        userModel.status = [userDetail valueForKey:@"status"];
        userModel.street = [userDetail valueForKey:@"street"];
        userModel.street_number = [userDetail valueForKey:@"street_number"];
        userModel.sysAdmin = [userDetail valueForKey:@"sysAdmin"];
        userModel.telephone = [userDetail valueForKey:@"telephone"];
        userModel.userId = [userDetail valueForKey:@"userId"];
        userModel.userType = [userDetail valueForKey:@"userType"];
        userModel.username = [userDetail valueForKey:@"username"];
        userModel.versionName = [userDetail valueForKey:@"versionName"];
        [UserInfoDB selectUserInfo:USERIFO_TABLE andkeyValue:userModel andkeyArray:nil];
        return YES;
    }
    else if (codeNum == CODE_ERROE){
        SqliteFieldAndTable *sqliteAndtable = [[SqliteFieldAndTable alloc]init];
        FriendDetailViewController __weak *_Self = self;
        [sqliteAndtable repeatLogin:^(BOOL flag) {
            if (flag) {
                [_Self getFriendDetail];
            }
            else{
                UserLoginViewController *login = [[UserLoginViewController alloc]init];
                [_Self.navigationController pushViewController:login animated:YES];
                login = nil;
            }
            
        }];
       return NO;
    }
    else{
        return NO;
    }
    
}

- (void)getUserNameByUserId:(NSString *)userId
{
    NSDictionary *parameters = @{@"userId":GET_USER_ID,@"sid":GET_S_ID,@"viewId":userId};
    [AFRequestService responseData:USER_INFO_BYID_URL andparameters:parameters andResponseData:^(id responseData){
        NSDictionary *dict =(NSDictionary *)responseData;
        NSUInteger codeNum = [[dict objectForKey:@"code"] integerValue];
        if (codeNum == CODE_SUCCESS) {
            NSDictionary *userDetail = [dict objectForKey:@"user"];
            tempUserName = [userDetail objectForKey:@"firstname"];
        }
        else if(codeNum == CODE_ERROE){
            
            SqliteFieldAndTable *sqliteAndtable = [[SqliteFieldAndTable alloc]init];
            FriendDetailViewController __weak *_Self = self;
            [sqliteAndtable repeatLogin:^(BOOL flag) {
                if (flag) {
                    [_Self getFriendDetail];
                }
                else{
                    UserLoginViewController *login = [[UserLoginViewController alloc]init];
                    [_Self.navigationController pushViewController:login animated:YES];
                    login = nil;
                }
                
            }];
        }

        [self updateData];
    }
     
     ];
}

-(void)displayComposerSheet

{
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    
    picker.mailComposeDelegate = self;
    
    
    
    NSArray *toRecipients = [NSArray arrayWithObject:userModel.email];
    
    
    
    [picker setToRecipients:toRecipients];
    
    NSString *emailBody = @"This is email body!";
    
    [picker setMessageBody:emailBody isHTML:NO];
    
    [self presentViewController:picker animated:YES completion:nil];
    
}

// Dismisses the email composition interface when users tap Cancel or Send. Proceeds to update the message field with the result of the operation.

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error

{
    //NSString *message;
    
    switch (result)
    {
        case MFMailComposeResultCancelled:
            
            break;
            
        case MFMailComposeResultSaved:
            
            break;
            
        case MFMailComposeResultSent:
            
            break;
            
        case MFMailComposeResultFailed:
            
            break;
            
        default:
            //message = @"Result: not sent";
            break;
            
    }
    //[self alertWithTitle:nil withMessage:message];
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)alertWithTitle:(NSString *)_Title_ withMessage:(NSString *)msg{
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:_Title_ message:msg delegate:nil cancelButtonTitle:LOCALIZATION(@"dialog_ok") otherButtonTitles: nil];
    [alert show];
    alert = nil;
}


#pragma mark -

#pragma mark Workaround

// Launches the Mail application on the device.

-(void)launchMailAppOnDevice

{
    
    NSString *recipients = @"mailto:first@example.com&subject=my email!";
    //@"mailto:first@example.com?cc=second@example.com,third@example.com&subject=my email!";
    NSString *body = @"&body=email body!";
    
    NSString *email = [NSString stringWithFormat:@"%@%@", recipients, body];
    email = [email stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:email]];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    if(self.isViewLoaded && !self.view.window){
        userModel = nil;
        
        tempUserId = nil;
        tempUserName = nil;
        
        HUD = nil;
        num = nil;
        self.view = nil;
    }

    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    userModel = nil;
    
    tempUserId = nil;
    tempUserName = nil;
    
    HUD = nil;
    num = nil;
}

@end
