//
//  UserContactViewController.m
//  UNITOA
//
//  Created by qidi on 14-6-30.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import "UserContactViewController.h"
#import "UIImageView+WebCache.h"
#import "TSPopoverController.h"
#import "TSActionSheet.h"
#import "UserLoginViewController.h"

#import "SearchFriendsViewController.h"
#import "SetUpViewController.h"
#import "FriendListViewController.h"
#import "SearchFriendsViewController.h"
#import "VChatViewController.h"
#import "MattersViewController.h"
#import "AddGroupMemberViewController.h"
#import "FirendCircleHomeTableViewController.h"
#import "SqliteFieldAndTable.h"
#import "UserAddedGroupDB.h"
#import "userContactDB.h"
#import "GetDateFormater.h"
#import "SqliteFieldAndTable.h"

#import "SetUpViewController.h"

#import "UserContact.h"
#import "CachatTableViewCell.h"
#import "QiDiPopoverView.h"
#import "SqliteBase.h"
#import "Interface.h"

#define TOP_CHAT_TAG 12345678
#define CACLETOP_CHAT_TAG 123456789
static NSInteger arrayCount = 0;

@interface UserContactViewController ()
{
    MBProgressHUD *HUD;
    QiDiPopoverView *popOver;
    UIView *head_bg;
    NSMutableDictionary *newArticleDic;
    UITextField *groupName;
    UITableView *_tableView;
    NSMutableArray *UserContactArray;
    NSMutableArray *groupArray;
    NSMutableArray *groupToContactArray;
}
@end

@implementation UserContactViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.index = 0;
        UserContactArray = [[NSMutableArray alloc]init];
        groupArray = [[NSMutableArray alloc]init];
        groupToContactArray = [[NSMutableArray alloc]init];
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushNew:) name:PUSH_NEW object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterForGroud:) name:ENTERFORGROUD object:nil];
    /*
     是否显示小红点的标记
     */
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:@"isShowRed"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self creatTable];
    [self addRedLable];
    [self getUserADDGroupList];
    [self SetTablePosition];
}
// 红点的标记
- (void)addRedLable{
    UIView *oldRedLable =(UIView *)[head_bg viewWithTag:615];
    [oldRedLable removeFromSuperview];
    UIView *redLabel = [[UIView alloc]initWithFrame:CGRectZero];
    redLabel.backgroundColor = [UIColor redColor];
    redLabel.tag = 615;
    [head_bg addSubview:redLabel];
    redLabel = nil;
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"isShowRed"] boolValue]) {
        UIView *redLable = (UIView *)[head_bg viewWithTag:615];
        if (redLable.frame.size.width == 0) {
            redLable.frame = CGRectMake(285, 5, 12, 12);
            redLable.layer.cornerRadius = 6;
        }
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // 如果是因推送启动的程序
    if (self.index == 1) {
        [self pushVachat];
    }
    self.view.backgroundColor = [UIColor whiteColor];
    [self navigation];
    [self creatHead];
}
// 程序由推送启动跳转到聊天的界面
- (void)pushVachat
{
    NSDictionary *dict = (NSDictionary *)[[NSUserDefaults standardUserDefaults] objectForKey:LANUCH];
    NSDictionary *remoteInfo = [dict objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    NSDictionary *information = [remoteInfo objectForKey:@"info"];
    NSString *recvId = [information objectForKey:@"dataId"];
    NSUInteger typeId = [[information objectForKey:@"typeId"] integerValue];
    VChatViewController *vc = [[VChatViewController alloc] init];
    // 聊天广场
    if (typeId == VCHATTYPE_VC) {
        vc.type = VChatType_VC;
        vc.recvFirstName = LOCALIZATION(@"chat_expressname");
    }
    // 群组聊天
    else if (typeId == VCHATTYPE_PGROUP) {
        vc.type = VChatType_pGroup;
        vc.recvName = @"dsvsdv";
        vc.recvFirstName = [userContactDB selectFeildbyelement:@"groupName" andcuId:GET_USER_ID andGroupId:recvId];
        
    }
    // 个人俩天
    else if (typeId == VCHATTYPE_PCHAT) {
        vc.type = VChatType_pChat;
        vc.recvName = @"dsvsdv";
        vc.recvFirstName = [UserInfoDB selectFeildString:@"firstname" andcuId:GET_USER_ID anduserId:recvId];
        
    }
    else{
        return;
    }
    vc.recvId = [NSNumber numberWithInt:[recvId intValue]];
    [self.navigationController pushViewController:vc animated:YES];
    
}
// 导航栏
- (void)navigation
{
    UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
    leftView.backgroundColor = [UIColor clearColor];
    UIImage *imageNav = [UIImage imageNamed:@"unis_logo"];
    UIImageView *logoView = [[UIImageView alloc]initWithImage:imageNav];
    
    logoView.frame = CGRectMake(0, (44 - imageNav.size.height)/2, imageNav.size.width, imageNav.size.height);
    logoView.contentMode = UIViewContentModeScaleAspectFit;
    
    UILabel *loginLabel = [[UILabel alloc]initWithFrame:CGRectMake(imageNav.size.width + 5, 7, 160, 30)];
    loginLabel.text = LOCALIZATION(@"home_chat");
    loginLabel.textColor = [UIColor whiteColor];
    loginLabel.backgroundColor = [UIColor clearColor];
    loginLabel.font = [UIFont systemFontOfSize:16.0f];
    [leftView addSubview:logoView];
    [leftView addSubview:loginLabel];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftView];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIView *rightView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 88+44, 44)];
    rightView.backgroundColor = [UIColor clearColor];
    
    UIButton * rightBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *searchImage = [UIImage imageNamed:@"search_ico"];
    rightBtn1.frame = CGRectMake(0, (44 - searchImage.size.height)/2, searchImage.size.width, searchImage.size.height);
    rightBtn1.backgroundColor = [UIColor clearColor];
    [rightBtn1 setImage:searchImage forState:UIControlStateNormal];
    
    
    //[rightBtn1 setImageEdgeInsets:UIEdgeInsetsMake(9.5, 16, 9.5, 3)];
    rightBtn1.tag =SEARCH_BTN_TAG;
    
    [rightBtn1 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn1 setShowsTouchWhenHighlighted:YES];
    
    UIButton * rightBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *addfriImage = [UIImage imageNamed:@"addfri_ico"];
    rightBtn2.frame = CGRectMake(50,(44 - addfriImage.size.height)/2, addfriImage.size.width, addfriImage.size.height);
    rightBtn2.tag =ADD_BTN_TAG;
    [rightBtn2 setImage:addfriImage forState:UIControlStateNormal];
    
    //[rightBtn2 setImageEdgeInsets:UIEdgeInsetsMake(9.5, 16, 9.5, 3)];
    [rightBtn2 addTarget:self action:@selector(showActionSheet:forEvent:) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn2 setShowsTouchWhenHighlighted:YES];
    
    UIButton * rightBtn3 = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *setfriImage = [UIImage imageNamed:@"set_ico"];
    rightBtn3.frame = CGRectMake(100, (44 - setfriImage.size.height)/2, setfriImage.size.width, setfriImage.size.height);
    rightBtn3.tag =SET_BTN_TAG;
    [rightBtn3 setImage:[UIImage imageNamed:@"set_ico"] forState:UIControlStateNormal];
    
    //[rightBtn3 setImageEdgeInsets:UIEdgeInsetsMake(9.5, 16, 9.5, 3)];
    [rightBtn3 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn3 setShowsTouchWhenHighlighted:YES];
    [rightView addSubview:rightBtn1];
    [rightView addSubview:rightBtn2];
    [rightView addSubview:rightBtn3];
    UIBarButtonItem* rightitem = [[UIBarButtonItem alloc]initWithCustomView:rightView];
    self.navigationItem.rightBarButtonItem = rightitem;
    
}
// 创建头部视图
- (void)creatHead
{
    head_bg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, viewSize.width, 40)];
    [head_bg setBackgroundColor:GETColor(245, 245, 245)];
    
    UIImageView *imgView = [[UIImageView alloc]initWithImage:[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"navline_ico@2x" ofType:@"png"]]];
    
    CGFloat buttonWidth = SCREEN_WIDTH/3;
    imgView.frame =CGRectMake(buttonWidth*2, 34, buttonWidth, 6);
    // 通讯录
    NSString *ContactsText = LOCALIZATION(@"home_friend");
    UIButton *Contacts = [UIButton buttonWithType:UIButtonTypeCustom];
    Contacts.tag = CONTACT_BTN_TAG;
    Contacts.backgroundColor = [UIColor clearColor];
    Contacts.frame = CGRectMake(0, 0, buttonWidth, 40);
    [Contacts setTitle:ContactsText forState:UIControlStateNormal];
    [Contacts setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    Contacts.titleLabel.textAlignment = NSTextAlignmentCenter;
    Contacts.titleLabel.font = [UIFont systemFontOfSize:16];
    [Contacts setShowsTouchWhenHighlighted:YES];
    UITapGestureRecognizer * ContactsGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gestureClick:)];
    
    ContactsGesture.view.tag = CONTACT_BTN_TAG;
    [Contacts addGestureRecognizer:ContactsGesture];
    // 朋友圈
    NSString *MomentsText = LOCALIZATION(@"home_group");
    UIButton *Moments = [UIButton buttonWithType:UIButtonTypeCustom];
    Moments.tag = MOMENTS_BTN_TAG;
    Moments.backgroundColor = [UIColor clearColor];
    Moments.frame = CGRectMake(buttonWidth, 0, buttonWidth, 40);
    [Moments setTitle:MomentsText forState:UIControlStateNormal];
    [Moments setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
    Moments.titleLabel.textAlignment = NSTextAlignmentCenter;
    Moments.titleLabel.font = [UIFont systemFontOfSize:16];
    [Moments setShowsTouchWhenHighlighted:YES];
    UITapGestureRecognizer * MomentsGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gestureClick:)];
    MomentsGesture.view.tag = MOMENTS_BTN_TAG;
    [Moments addGestureRecognizer:MomentsGesture];
    // 聊天
    UIButton *Cochat = [UIButton buttonWithType:UIButtonTypeCustom];
    Cochat.tag = COCHAT_BTN_TAG;
    Cochat.backgroundColor = [UIColor clearColor];
    Cochat.userInteractionEnabled = NO;
    Cochat.frame = CGRectMake(buttonWidth*2, 0, buttonWidth, 40);
    NSString *CochatText = LOCALIZATION(@"home_chat");
    [Cochat setTitle:CochatText forState:UIControlStateNormal];
    [Cochat setTitleColor:GETColor(144, 84, 158) forState:UIControlStateNormal];
    Cochat.titleLabel.textAlignment = NSTextAlignmentCenter;
    Cochat.titleLabel.font = [UIFont systemFontOfSize:16];
    [Cochat setShowsTouchWhenHighlighted:YES];
    UITapGestureRecognizer * CochatGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gestureClick:)];
    CochatGesture.view.tag = COCHAT_BTN_TAG;
    [Cochat addGestureRecognizer:CochatGesture];
    
    [head_bg addSubview:Cochat];
    [head_bg addSubview:Moments];
    [head_bg addSubview:Contacts];
    [head_bg addSubview:imgView];
    Cochat = nil;
    Moments = nil;
    Contacts = nil;
    [self.view addSubview:head_bg];
    
}
// 事件点击
- (void)gestureClick:(UITapGestureRecognizer *)tapSender
{
    if (tapSender.view.tag == CONTACT_BTN_TAG){
        FriendListViewController *friendList = [[FriendListViewController alloc]init];
        [self.navigationController pushViewController:friendList animated:NO];
        friendList = nil;
    }
    else if (tapSender.view.tag == MOMENTS_BTN_TAG){
        FirendCircleHomeTableViewController *friendCircle = [[FirendCircleHomeTableViewController alloc]init];
        [self.navigationController pushViewController:friendCircle animated:YES];
        friendCircle = nil;
    }
    else if (tapSender.view.tag == COCHAT_BTN_TAG){
        UserContactViewController *userContact = [[UserContactViewController alloc]init];
        [self.navigationController pushViewController:userContact animated:NO];
        userContact = nil;
    }
    
}
- (void)btnClick:(UIButton *)sender
{
    switch (sender.tag) {
        case SEARCH_BTN_TAG: {
            SearchFriendsViewController *search = [[SearchFriendsViewController alloc]init];
            CATransition *animation = [CATransition animation];
            [animation setDuration:0.3];
            [animation setType: kCATransitionMoveIn];
            [animation setSubtype: kCATransitionFromTop];
            [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
            [self.navigationController pushViewController:search animated:NO];
            [self.navigationController.view.layer addAnimation:animation forKey:nil];
        }
            break;
        case ADD_BTN_TAG: {
            
        }
            break;
        case SET_BTN_TAG: {
            SetUpViewController *setUp = [[SetUpViewController alloc]init];
            [self.navigationController pushViewController:setUp animated:YES];
        }
            break;
        case CONTACT_BTN_TAG: {
            FriendListViewController *friendList = [[FriendListViewController alloc]init];
            [self.navigationController pushViewController:friendList animated:NO];
        }
            break;
            // 事项
        case MATTER_BTN_TAG: {
            
            MattersViewController *mvc = [[MattersViewController alloc] init];
            [self.navigationController pushViewController:mvc animated:YES];
        }
            break;
        case MOMENTS_BTN_TAG: {
            FirendCircleHomeTableViewController *friendCircle = [[FirendCircleHomeTableViewController alloc]init];
            [self.navigationController pushViewController:friendCircle animated:YES];
        }
            break;
        case COCHAT_BTN_TAG: {
            
        }
            break;
        case DIALOG_Btn_TAG: {
            [popOver dismiss];
        }
            break;
        case SUBMIT_BTN_TAG:
        {
            [popOver dismiss];
            [self creatGroup];
        }
            break;
        default:
            break;
    }
    
}
// 创建群组，并加到数据库中
- (void)creatGroup
{
    NSDictionary *parameters = @{@"userId":GET_USER_ID,@"sid":GET_S_ID,@"groupName":groupName.text,@"groupType":[NSString stringWithFormat:@"%d",0]};
    [AFRequestService responseData:CREATE_GROUP andparameters:parameters andResponseData:^(id responseData){
        NSDictionary *dict =(NSDictionary *)responseData;
        NSUInteger codeNum = [[dict objectForKey:@"code"] integerValue];
        if (codeNum == CODE_SUCCESS) {
            NSDictionary *groupDict = (NSDictionary *)[dict objectForKey:@"group"];
            //开个子线程将数据添加到数据库中
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                SqliteFieldAndTable *sqliteAndtable = [[SqliteFieldAndTable alloc]init];
                [sqliteAndtable getReturnAddGroup:groupDict];
                sqliteAndtable = nil;
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                });
                
            });
            //  跳转到群组成员添加页面
            AddGroupMemberViewController *addGroupMember = [[AddGroupMemberViewController alloc]init];
            addGroupMember.groupId = [groupDict objectForKey:@"groupId"];
            addGroupMember.groupName = [groupDict objectForKey:@"groupName"];
            addGroupMember.flag = 2;
            [self.navigationController pushViewController:addGroupMember animated:YES];
        }
        else if (codeNum == CODE_ERROE){
            SqliteFieldAndTable *sqliteAndtable = [[SqliteFieldAndTable alloc]init];
            UserContactViewController __weak *_Self = self;
            [sqliteAndtable repeatLogin:^(BOOL flag) {
                if (flag) {
                    [_Self creatGroup];
                }
                else{
                    UserLoginViewController *login = [[UserLoginViewController alloc]init];
                    [_Self.navigationController pushViewController:login animated:YES];
                    login = nil;
                }
                
            }
             ];
        }
    }];
}
// 创建数据表
- (void)creatTable
{
    
    UserContactArray = [[NSMutableArray alloc]init];
    CGFloat height = head_bg.frame.size.height + head_bg.frame.origin.y;

    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, height, viewSize.width, viewSize.height-height) style:UITableViewStylePlain];

    _tableView.delegate = self;
    _tableView.dataSource = self;
    // 解决IOS7下tableview分割线左边短了一点
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [_tableView setSeparatorInset:UIEdgeInsetsZero];
        
    }
    [self setExtraCellLineHidden:_tableView];
    [self.view addSubview:_tableView];
    
}
// 滚动的代理方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
{
    CGFloat offset_Y = _tableView.contentOffset.y;
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithFloat:offset_Y] forKey:@"Contact_Y"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}
- (void)SetTablePosition{
    CGPoint OffSet;
    OffSet.y = [[[NSUserDefaults standardUserDefaults] objectForKey:@"Contact_Y"] floatValue];
    OffSet.x = _tableView.contentOffset.x;
    _tableView.contentOffset = OffSet;
    
}
// 将新的聊天好友添加到本地数据库中
- (void)addUserContact{
    NSString *contactId = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"dataId"]];
    if (contactId == nil || [contactId isEqualToString:@"(null)"] || [contactId isEqual:[NSNull null]]) {
        return;
    }
    else{
        // 保存到本地
        UserContact *model = [[UserContact alloc]init];
        model.contactId = contactId;
        model.contactName = [UserInfoDB selectFeildString:@"firstname" andcuId:GET_USER_ID anduserId:contactId];
        model.contactType = @"6";
        model.contactUsername = [UserInfoDB selectFeildString:@"username" andcuId:GET_USER_ID anduserId:contactId];
        model.creatDate = [NSString stringWithFormat:@"%@",[NSDate date]];
        model.creator = @"0";
        model.creatorName = @"";
        model.creatorUsername = @"";
        model.groupType = @"0";
        model.lastMsg = @"";
        model.lastMsgTime = @"";
        model.lastMsgTime = @"";
        model.lastMsgUserFirstname = @"";
        model.lastMsgUserUsername = @"";
        model.isTop = @"0";
        model.topOperateTime = @"0";
        model.isMute = @"0";
        model.lastMsgNum = @"0";
        if( [userContactDB selectuserContactInfo:USERCONTACT_TABLE andkeyValue:model andkeyArray:[self getFieldArray]]){
            [self getUserADDGroupList];
        }
        // 保存到服务器上
        NSDictionary *paramter = @{@"userId":GET_USER_ID,@"sid":GET_S_ID,@"contactId":contactId};
        [AFRequestService responseData:USER_CONTACT_SAVE andparameters:paramter andResponseData:^(NSData *responseData) {
            NSDictionary *dict =(NSDictionary *)responseData;
            NSUInteger codeNum = [[dict objectForKey:@"code"] integerValue];
            if (codeNum == CODE_SUCCESS) {
                    return ;
            }
            else if (codeNum == CODE_ERROE){
                SqliteFieldAndTable *sqliteAndtable = [[SqliteFieldAndTable alloc]init];
                UserContactViewController __weak *_Self = self;
                [sqliteAndtable repeatLogin:^(BOOL flag) {
                    if (flag) {
                        NSDictionary *paramter = @{@"userId":GET_USER_ID,@"sid":GET_S_ID,@"contactId":contactId};
                        [AFRequestService responseData:USER_CONTACT_SAVE andparameters:paramter andResponseData:^(NSData *responseData) {
                            NSDictionary *dict =(NSDictionary *)responseData;
                            NSUInteger codeNum = [[dict objectForKey:@"code"] integerValue];
                            if (codeNum == CODE_ERROE){
                                UserLoginViewController *login = [[UserLoginViewController alloc]init];
                                [_Self.navigationController pushViewController:login animated:YES];
                                login = nil;
                            }
                        }];
                    }
                    else{
                        UserLoginViewController *login = [[UserLoginViewController alloc]init];
                        [_Self.navigationController pushViewController:login animated:YES];
                        login = nil;
                    }
                    
                }
                 ];
            }
        }];
    }
}
// 设置数据库字段数组
- (NSArray *)getFieldArray{
    return @[
             @"cuId",
             @"contactId",
             @"contactName",
             @"contactType",
             @"contactUsername",
             @"createDate",
             @"creator",
             @"creatorName",
             @"creatorUsername",
             @"groupType",
             @"lastMsg",
             @"lastMsgTime",
             @"lastMsgUser",
             @"lastMsgUserFirstname",
             @"lastMsgUserUsername",
             @"isTop",
             @"topOperateTime",
             @"isMute",
             @"lastMsgNum"
             ];
}
// 被邀请和加入的群组加入群组列表中
- (void)writeGroupIntoLocal{
    NSDictionary *params = @{@"userId":GET_USER_ID,@"sid":GET_S_ID, @"pageSize":[NSString stringWithFormat:@"%d",INT_MAX],@"page":[NSString stringWithFormat:@"%d",1]};
    [AFRequestService responseData:USER_ADDED_GROUP_LIST andparameters:params andResponseData:^(id responseData){
        NSDictionary *dict =(NSDictionary *)responseData;
         NSUInteger codeNum = [[dict objectForKey:@"code"] integerValue];
        if (codeNum == CODE_SUCCESS) {
            if ([[[SqliteFieldAndTable alloc]init] getGroupFeildandValue:dict]) {
                [self getUserADDGroupList];
            }
            else{
                return ;
            }
        }
        else if (codeNum == CODE_ERROE){
            SqliteFieldAndTable *sqliteAndtable = [[SqliteFieldAndTable alloc]init];
            UserContactViewController __weak *_Self = self;
            [sqliteAndtable repeatLogin:^(BOOL flag) {
                if (flag) {
                    [_Self writeGroupIntoLocal];
                }
                else{
                    UserLoginViewController *login = [[UserLoginViewController alloc]init];
                    [_Self.navigationController pushViewController:login animated:YES];
                    login = nil;
                }
                
            }
             ];
        }
    } ];
}
// 获取用户加入及创建的群组列表
- (void)getUserADDGroupList
{
    [groupArray removeAllObjects];
    [groupToContactArray removeAllObjects];
    [groupArray addObjectsFromArray:[UserAddedGroupDB selectFeildString:nil andcuId:GET_USER_ID]];
    for (int i = 0; i < [groupArray count]; i++) {
        GroupList *groupmModel = (GroupList *)groupArray[i];
        UserContact *model = [[UserContact alloc]init];
        model.creator = groupmModel.creator;
        model.creatorName = groupmModel.creatorName;
        model.contactId = groupmModel.groupId;
        model.groupType = groupmModel.groupType;
        model.contactType = PUSH_GPCHAT;
        model.lastMsgUser = groupmModel.latestMsgUser;
        model.lastMsgUserUsername = groupmModel.latestMsgUserName;
        model.contactName = groupmModel.groupName;
        model.memo = groupmModel.memo;
        model.icon = [UserInfoDB selectFeildString:@"icon" andcuId:GET_U_ID anduserId:model.contactId];
        // 将群组添加到用户联系人的数据库中（没有重的数据便插入）
        [userContactDB selectuserContactInfo:USERCONTACT_TABLE andkeyValue:model andkeyArray:[self getFieldArray]];
    }
    [UserContactArray removeAllObjects];
    
    // 将正在聊天的人员加入到数组中
    [UserContactArray addObjectsFromArray:[userContactDB selectFeildString:nil andcuId:GET_U_ID andGroupId:nil]];
    
    // 获取最新的消息
    [self getNewArticle:UserContactArray];
    // 动态确定tableView的高度
    [self tableHeight];
}
// 得到最新的聊天信息(从聊天的数据库中的数据库中)
- (void)getNewArticle:(NSMutableArray *)userArray
{
    // 将聊天广场的内容添加到数组源数组中
    [self getVCData:userArray];
    // 对整个数据源数组进行处理
    for (NSInteger i = 0; i < [UserContactArray count]; i++)
    {
        
        UserContact *userContact = (UserContact *)userArray[i];
        // 不是推送获取的数据
        if (([userContact.contactType isEqualToString:PUSH_GCHAT] ||[userContact.contactType isEqualToString:PUSH_GPCHAT])&& ![[[NSUserDefaults standardUserDefaults] objectForKey:@"ison0"] boolValue]) {
            
        }
        else{
            [self GetData:userContact andIndex:i];
        }
        
    }
}
// 处理聊天广场的数据
- (void)getVCData:(NSMutableArray *)userArray{
    // 提取聊天广场的数据
    UserContact *vcContact = [[UserContact alloc]init];
    
    [self dicWithVType:VChatType_VC andRecvId:[NSNumber numberWithInt:0]];
    [newArticleDic setObject:@"0" forKey:@"articleId"];
    [newArticleDic setObject:GET_U_ID forKey:@"userId"];
    NSArray *array1 = [SqliteBase readbase:TABLE_HD query:newArticleDic count:1];
    VChatModel *model = (VChatModel *)[array1 firstObject];
    VChatAttachModel *att = (VChatAttachModel *)[model.attachlist lastObject];
    
    vcContact.creatDate = model.creatDate;
    vcContact.contactId = @"0";
    vcContact.context = model.context;
    vcContact.contactType = PUSH_GCHAT;
    vcContact.typeId =model.typeId;
    vcContact.firstUsername = model.firstname;
    vcContact.filename = [[att.filename componentsSeparatedByString:@"."] lastObject];
    [userArray addObject:vcContact];
}
#pragma mark =========if there is not data in database,we write the data pushed into the database
- (void)pushGetData{
    [newArticleDic setValue:GET_S_ID forKey:@"sid"];
    [newArticleDic setValue:GET_USER_ID forKey:@"userId"];
    [newArticleDic setObject:[NSNumber numberWithInteger:0] forKey:@"articleId"];
    [newArticleDic setObject:[NSNumber numberWithInteger:1] forKey:@"sort"];
    [newArticleDic setObject:[NSNumber numberWithInteger:1] forKey:@"order"];
    [newArticleDic setObject:[NSNumber numberWithInteger:1] forKey:@"recordCount"];
    // 获取数据库中的数据
    
    [AFRequestService responseData:NEW_ARTICLE_LIST andparameters:newArticleDic andResponseData:^(NSData *responseData) {
        NSDictionary *dict = (NSDictionary *)responseData;
        id article  = [dict objectForKey:@"articlelist"];
        if ([article isKindOfClass:[NSArray class]]) {
            [SqliteBase witeInbase:TABLE_HD withData:[VChatModel vChatMakeModel:article]];
            [SingleInstance shareManager].articleId = 0;
            [self isPushGetData];
        }
    }
     // 网络请求失败，加载本地数据
    andFailfailWithRequest:^{
            }
     ];
    
}
// 得到数据和内容
- (void)getDataAndcontent:(UserContact *)userContact andDict:(NSDictionary *)dict1 and:(NSInteger)articleId andIndex:(NSInteger)i{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:dict1];
    [dict setValue:GET_S_ID forKey:@"sid"];
    [dict setValue:GET_USER_ID forKey:@"userId"];
    [dict setObject:[NSNumber numberWithInteger:articleId] forKey:@"articleId"];
    [dict setObject:[NSNumber numberWithInteger:1] forKey:@"sort"];
    [dict setObject:[NSNumber numberWithInteger:0] forKey:@"order"];
    [dict setObject:[NSNumber numberWithInteger:100] forKey:@"recordCount"];
    // 获取数据库中的数据
    
    [AFRequestService responseData:NEW_ARTICLE_LIST andparameters:newArticleDic andResponseData:^(NSData *responseData) {
        NSDictionary *dict = (NSDictionary *)responseData;
        // 得到聊天信息的总条数
        NSInteger totalCount = [[dict objectForKey:@"articlelist"] count];
        userContact.lastMsgNum = [NSString stringWithFormat:@"%d",totalCount];
        // 如果服务器没有新的数据，则加载本地最新一条数据
        if (totalCount == 0) {
            NSArray *array = [SqliteBase readbase:TABLE_HD query:dict count:1];
            VChatModel *model = (VChatModel *)[array firstObject];
            VChatAttachModel *att = (VChatAttachModel *)[model.attachlist lastObject];
            userContact.creatDate = model.creatDate;
            userContact.context = model.context;
            userContact.typeId =model.typeId;
            userContact.firstUsername = model.firstname;
            
            if (att.filename != nil)
            {
                userContact.filename = [[att.filename componentsSeparatedByString:@"."] lastObject];
            }
            //更新最近一条信息的时间到联系人的数据库中
            [userContactDB updateuserContactInfo:nil andkeyValue:userContact];
        }
        else{
            NSDictionary *articlelist = [[dict objectForKey:@"articlelist"] lastObject];
            userContact.creatDate = [articlelist objectForKey:@"createDate"];
            userContact.context = [articlelist objectForKey:@"context"];
            userContact.typeId = [articlelist objectForKey:@"typeId"];
            userContact.firstUsername = [articlelist objectForKey:@"firstname"];
            NSDictionary *attachlist = [[articlelist objectForKey:@"attachlist"] firstObject];
            userContact.filename = [[[attachlist objectForKey:@"filename"] componentsSeparatedByString:@"."] lastObject];
            //更新最近一条信息的时间到联系人的数据库中
            [userContactDB updateuserContactInfo:nil andkeyValue:userContact];
            // 上侧显示红点
            UIView *redLable = (UIView *)[head_bg viewWithTag:615];
            if (redLable.frame.size.width == 0) {
                redLable.frame = CGRectMake(285, 5, 12, 12);
                redLable.layer.cornerRadius = 6;
                [[NSNotificationCenter defaultCenter] postNotificationName:@"redLabel" object:nil userInfo:nil];
            }
            
        }
        [_tableView reloadData];
        
    }
     // 网络请求失败，加载本地数据
            andFailfailWithRequest:^{
                NSArray *array = [SqliteBase readbase:TABLE_HD query:dict count:1];
                VChatModel *model = (VChatModel *)[array firstObject];
                VChatAttachModel *att = (VChatAttachModel *)[model.attachlist lastObject];
                
                userContact.lastMsgNum = [NSString stringWithFormat:@"%d",0];
                userContact.creatDate = model.creatDate;
                userContact.context = model.context;
                userContact.typeId =model.typeId;
                userContact.firstUsername = model.firstname;
                if (att.filename != nil)
                {
                    userContact.filename = [[att.filename componentsSeparatedByString:@"."] lastObject];
                }
                NSIndexPath *indexPath = nil;
                if (i == [UserContactArray count] - 1) {
                    indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
                }
                else{
                    // 刷新指定的单元格（单元格数大于数据源数组元素的1）
                    indexPath=[NSIndexPath indexPathForRow:i + 1 inSection:0];
                }
                [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
            }
     ];
    
}
#pragma mark ==============当没有推送过来时加载的数据
- (void)GetData:(UserContact *)userContact andIndex:(NSInteger)i{
    
    // 个人聊天
    if ([userContact.contactType isEqualToString:ORDINARY_USER_CODE]) {
        [self dicWithVType:VChatType_pChat andRecvId:[NSNumber numberWithInt:[userContact.contactId intValue]]];
        
    }
    // 群组聊天
    else if ([userContact.contactType isEqualToString:ORDINARY_GROUP_CODE]){
        [self dicWithVType:VChatType_pGroup andRecvId:[NSNumber numberWithInt:[userContact.contactId intValue]]];
    }
    // 聊天广场
    else{
        [self dicWithVType:VChatType_VC andRecvId:[NSNumber numberWithInt:[userContact.contactId intValue]]];
    }
    // 取得数据库中信息id最大的一条信息
    [newArticleDic setObject:@"0" forKey:@"articleId"];
    NSDictionary *dictData = [newArticleDic copy];
    NSArray *array = [SqliteBase readbase:TABLE_HD query:newArticleDic count:1];
    if([array isEqual:[NSNull null]]){
        return;
    }
    NSInteger articleId = ((VChatModel *)[array firstObject]).articleId;
    //本地数据库之前本没有数据
    if (articleId <=0) {
        // 则在服务器中取出最近一条加到数据库中
        if ([userContact.contactId isEqualToString:[SingleInstance shareManager].recvId]) {
        [newArticleDic setValue:GET_S_ID forKey:@"sid"];
        [newArticleDic setValue:GET_USER_ID forKey:@"userId"];
        [newArticleDic setObject:[NSNumber numberWithInteger:0] forKey:@"articleId"];
        [newArticleDic setObject:[NSNumber numberWithInteger:1] forKey:@"sort"];
        [newArticleDic setObject:[NSNumber numberWithInteger:1] forKey:@"order"];
        [newArticleDic setObject:[NSNumber numberWithInteger:1] forKey:@"recordCount"];
        // 先获取数据库中的数据
        [self getLocalData:userContact andDict:dictData andIndex:i];
        
        [AFRequestService responseData:NEW_ARTICLE_LIST andparameters:newArticleDic andResponseData:^(NSData *responseData) {
            NSDictionary *dict = (NSDictionary *)responseData;
            // 得到聊天信息的总条数
            NSInteger totalCount = [[dict objectForKey:@"articlelist"] count];
            userContact.lastMsgNum = [NSString stringWithFormat:@"%d",totalCount];
            // 如果服务器没有新的数据，则加载本地最新一条数据
            if (totalCount == 0) {
                NSArray *array = [SqliteBase readbase:TABLE_HD query:dictData count:1];
                VChatModel *model = (VChatModel *)[array firstObject];
                VChatAttachModel *att = (VChatAttachModel *)[model.attachlist lastObject];
                userContact.creatDate = model.creatDate;
                userContact.context = model.context;
                userContact.typeId =model.typeId;
                userContact.firstUsername = model.firstname;
                
                if (att.filename != nil)
                {
                    userContact.filename = [[att.filename componentsSeparatedByString:@"."] lastObject];
                }
                //更新最近一条信息的时间到联系人的数据库中
                [userContactDB updateuserContactInfo:nil andkeyValue:userContact];
            }
            else{
                NSDictionary *articlelist = [[dict objectForKey:@"articlelist"] lastObject];
                userContact.creatDate = [articlelist objectForKey:@"createDate"];
                userContact.context = [articlelist objectForKey:@"context"];
                userContact.typeId = [articlelist objectForKey:@"typeId"];
                userContact.firstUsername = [articlelist objectForKey:@"firstname"];
                NSDictionary *attachlist = [[articlelist objectForKey:@"attachlist"] firstObject];
                userContact.filename = [[[attachlist objectForKey:@"filename"] componentsSeparatedByString:@"."] lastObject];
                //更新最近一条信息的时间到联系人的数据库中
                [userContactDB updateuserContactInfo:nil andkeyValue:userContact];
                // 上侧显示红点
                UIView *redLable = (UIView *)[head_bg viewWithTag:615];
                if (redLable.frame.size.width == 0) {
                    redLable.frame = CGRectMake(285, 5, 12, 12);
                    redLable.layer.cornerRadius = 6;
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"redLabel" object:nil userInfo:nil];
                }
                
            }
            [_tableView reloadData];
            
        }
         // 网络请求失败，加载本地数据
                andFailfailWithRequest:^{
                    [self getLocalData:userContact andDict:dictData andIndex:i];
                }
         ];

        }
    }
    else{
        [newArticleDic setValue:GET_S_ID forKey:@"sid"];
        [newArticleDic setValue:GET_USER_ID forKey:@"userId"];
        [newArticleDic setObject:[NSNumber numberWithInteger:articleId] forKey:@"articleId"];
        [newArticleDic setObject:[NSNumber numberWithInteger:1] forKey:@"sort"];
        [newArticleDic setObject:[NSNumber numberWithInteger:0] forKey:@"order"];
        [newArticleDic setObject:[NSNumber numberWithInteger:100] forKey:@"recordCount"];
        // 先获取数据库中的数据
        [self getLocalData:userContact andDict:dictData andIndex:i];
        
        [AFRequestService responseData:NEW_ARTICLE_LIST andparameters:newArticleDic andResponseData:^(NSData *responseData) {
            NSDictionary *dict = (NSDictionary *)responseData;
            // 得到聊天信息的总条数
            NSInteger totalCount = [[dict objectForKey:@"articlelist"] count];
            userContact.lastMsgNum = [NSString stringWithFormat:@"%d",totalCount];
            // 如果服务器没有新的数据，则加载本地最新一条数据
            if (totalCount == 0) {
                NSArray *array = [SqliteBase readbase:TABLE_HD query:dictData count:1];
                VChatModel *model = (VChatModel *)[array firstObject];
                VChatAttachModel *att = (VChatAttachModel *)[model.attachlist lastObject];
                userContact.creatDate = model.creatDate;
                userContact.context = model.context;
                userContact.typeId =model.typeId;
                userContact.firstUsername = model.firstname;
                
                if (att.filename != nil)
                {
                    userContact.filename = [[att.filename componentsSeparatedByString:@"."] lastObject];
                }
                //更新最近一条信息的时间到联系人的数据库中
                [userContactDB updateuserContactInfo:nil andkeyValue:userContact];
            }
            else{
                NSDictionary *articlelist = [[dict objectForKey:@"articlelist"] lastObject];
                userContact.creatDate = [articlelist objectForKey:@"createDate"];
                userContact.context = [articlelist objectForKey:@"context"];
                userContact.typeId = [articlelist objectForKey:@"typeId"];
                userContact.firstUsername = [articlelist objectForKey:@"firstname"];
                NSDictionary *attachlist = [[articlelist objectForKey:@"attachlist"] firstObject];
                userContact.filename = [[[attachlist objectForKey:@"filename"] componentsSeparatedByString:@"."] lastObject];
                //更新最近一条信息的时间到联系人的数据库中
                [userContactDB updateuserContactInfo:nil andkeyValue:userContact];
                // 上侧显示红点
                UIView *redLable = (UIView *)[head_bg viewWithTag:615];
                if (redLable.frame.size.width == 0) {
                    redLable.frame = CGRectMake(285, 5, 12, 12);
                    redLable.layer.cornerRadius = 6;
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"redLabel" object:nil userInfo:nil];
                }

            }
            [_tableView reloadData];
            
        }
         // 网络请求失败，加载本地数据
                andFailfailWithRequest:^{
                    [self getLocalData:userContact andDict:dictData andIndex:i];
                }
         ];
    }
    
}
// 获取本地的数据
- (void)getLocalData:(UserContact *)userContact andDict:(NSDictionary *)dict andIndex:(NSInteger)i{
    NSArray *array = [SqliteBase readbase:TABLE_HD query:dict count:1];
    VChatModel *model = (VChatModel *)[array firstObject];
    VChatAttachModel *att = (VChatAttachModel *)[model.attachlist lastObject];
    
    userContact.lastMsgNum = [NSString stringWithFormat:@"%d",0];
    userContact.creatDate = model.creatDate;
    userContact.context = model.context;
    userContact.typeId =model.typeId;
    userContact.firstUsername = model.firstname;
    if (att.filename != nil)
    {
        userContact.filename = [[att.filename componentsSeparatedByString:@"."] lastObject];
    }
    NSIndexPath *indexPath = nil;
    if (i == [UserContactArray count] - 1) {
        indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
    }
    else{
        // 刷新指定的单元格（单元格数大于数据源数组元素的1）
        indexPath=[NSIndexPath indexPathForRow:i + 1 inSection:0];
    }
    [_tableView reloadData];
}
// 是推送获取的数据
- (void)isPushGetData{
    for (NSInteger i = 0; i < [UserContactArray count]; i++)
    {
        
        UserContact *userContact = (UserContact *)UserContactArray[i];
        // 则在服务器中取出最近一条加到服务器重 判断是哪个好友发来的信息
        if ([userContact.contactId isEqualToString:[SingleInstance shareManager].recvId]) {
            // 个人聊天
            if ([userContact.contactType isEqualToString:ORDINARY_USER_CODE]) {
                [self dicWithVType:VChatType_pChat andRecvId:[NSNumber numberWithInt:[userContact.contactId intValue]]];
                
            }
            // 群组聊天
            else if ([userContact.contactType isEqualToString:ORDINARY_GROUP_CODE]){
                [self dicWithVType:VChatType_pGroup andRecvId:[NSNumber numberWithInt:[userContact.contactId intValue]]];
            }
            // 聊天广场
            else{
                [self dicWithVType:VChatType_VC andRecvId:[NSNumber numberWithInt:[userContact.contactId intValue]]];
            }
            // 取得数据库中信息id最大的一条信息
            [newArticleDic setObject:@"0" forKey:@"articleId"];
            NSDictionary *dictData = [newArticleDic copy];
            NSArray *array = [SqliteBase readbase:TABLE_HD query:newArticleDic count:1];
            if([array isEqual:[NSNull null]]){
                return;
            }
            NSInteger articleId = ((VChatModel *)[array firstObject]).articleId;
            if ([SingleInstance shareManager].articleId == 0) {
                articleId -= 1;
                [SingleInstance shareManager].articleId = articleId;
            }
            
            //本地数据库之前本没有数据
            if (articleId <=0) {
                // 推送获取的信息
                [self pushGetData];  
            }
            else{
                [newArticleDic setValue:GET_S_ID forKey:@"sid"];
                [newArticleDic setValue:GET_USER_ID forKey:@"userId"];
                [newArticleDic setObject:[NSNumber numberWithInteger:articleId] forKey:@"articleId"];
                [newArticleDic setObject:[NSNumber numberWithInteger:1] forKey:@"sort"];
                [newArticleDic setObject:[NSNumber numberWithInteger:0] forKey:@"order"];
                [newArticleDic setObject:[NSNumber numberWithInteger:100] forKey:@"recordCount"];
                // 获取数据库中的数据
                
                [AFRequestService responseData:NEW_ARTICLE_LIST andparameters:newArticleDic andResponseData:^(NSData *responseData) {
                    NSDictionary *dict = (NSDictionary *)responseData;
                    // 得到聊天信息的总条数
                    NSInteger totalCount = [[dict objectForKey:@"articlelist"] count];
                    userContact.lastMsgNum = [NSString stringWithFormat:@"%d",totalCount];
                    // 如果服务器没有新的数据，则加载本地最新一条数据
                    if (totalCount == 0) {
                        NSArray *array = [SqliteBase readbase:TABLE_HD query:dictData count:1];
                        VChatModel *model = (VChatModel *)[array firstObject];
                        VChatAttachModel *att = (VChatAttachModel *)[model.attachlist lastObject];
                        userContact.creatDate = model.creatDate;
                        userContact.context = model.context;
                        userContact.typeId =model.typeId;
                        userContact.firstUsername = model.firstname;
                        
                        if (att.filename != nil)
                        {
                            userContact.filename = [[att.filename componentsSeparatedByString:@"."] lastObject];
                        }
                        //更新最近一条信息的时间到联系人的数据库中
                        [userContactDB updateuserContactInfo:nil andkeyValue:userContact];
                    }
                    else{
                        NSDictionary *articlelist = [[dict objectForKey:@"articlelist"] lastObject];
                        userContact.creatDate = [articlelist objectForKey:@"createDate"];
                        userContact.context = [articlelist objectForKey:@"context"];
                        userContact.typeId = [articlelist objectForKey:@"typeId"];
                        userContact.firstUsername = [articlelist objectForKey:@"firstname"];
                        NSDictionary *attachlist = [[articlelist objectForKey:@"attachlist"] firstObject];
                        userContact.filename = [[[attachlist objectForKey:@"filename"] componentsSeparatedByString:@"."] lastObject];
                        //更新最近一条信息的时间到联系人的数据库中
                        [userContactDB updateuserContactInfo:nil andkeyValue:userContact];
                        // 上侧显示红点
                        UIView *redLable = (UIView *)[head_bg viewWithTag:615];
                        if (redLable.frame.size.width == 0) {
                            redLable.frame = CGRectMake(285, 5, 12, 12);
                            redLable.layer.cornerRadius = 6;
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"redLabel" object:nil userInfo:nil];
                        }
                        
                    }
                    [self pushArraySort:userContact];
                    //[_tableView reloadData];
                    
                }
                 // 网络请求失败，加载本地数据
                        andFailfailWithRequest:^{
                            NSArray *array = [SqliteBase readbase:TABLE_HD query:dictData count:1];
                            VChatModel *model = (VChatModel *)[array firstObject];
                            VChatAttachModel *att = (VChatAttachModel *)[model.attachlist lastObject];
                            
                            userContact.lastMsgNum = [NSString stringWithFormat:@"%d",0];
                            userContact.creatDate = model.creatDate;
                            userContact.context = model.context;
                            userContact.typeId =model.typeId;
                            userContact.firstUsername = model.firstname;
                            if (att.filename != nil)
                            {
                                userContact.filename = [[att.filename componentsSeparatedByString:@"."] lastObject];
                            }
                            NSIndexPath *indexPath = nil;
                            if (i == [UserContactArray count] - 1) {
                                indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
                            }
                            else{
                                // 刷新指定的单元格（单元格数大于数据源数组元素的1）
                                indexPath=[NSIndexPath indexPathForRow:i + 1 inSection:0];
                            }
                            [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
                        }
                 ];
            }
        }
    }
}
// 是推送获得的数据，要对推送来的数组进行排序，最新消息排在最前面
- (void)pushArraySort:(UserContact *)model{
    if ([model.contactType isEqualToString:PUSH_GCHAT]) {
        [_tableView reloadData];
    }
    else{
        [UserContactArray removeObject:model];
        [UserContactArray insertObject:model atIndex:0];
        [_tableView reloadData];
    }
}
- (void)tableHeight
{
    CGFloat height = head_bg.frame.size.height + head_bg.frame.origin.y;
    if (currentDev) {
        if (([UserContactArray count]) * 65 < viewSize.height-height) {
            _tableView.frame = CGRectMake(_tableView.frame.origin.x, _tableView.frame.origin.y, _tableView.frame.size.width, ([UserContactArray count]) * 65);
        }
        else{
            _tableView.frame = CGRectMake(_tableView.frame.origin.x, _tableView.frame.origin.y, _tableView.frame.size.width, viewSize.height-height);
        }
        
    }
    else if (currentDev1)
    {
        if (([UserContactArray count]) * 65 < viewSize.height-height) {
            _tableView.frame = CGRectMake(_tableView.frame.origin.x, _tableView.frame.origin.y, _tableView.frame.size.width, ([UserContactArray count]) * 65);
        }
        else{
            _tableView.frame = CGRectMake(_tableView.frame.origin.x, _tableView.frame.origin.y, _tableView.frame.size.width, viewSize.height-height);
        }
    }
    else{
        if (([UserContactArray count]) * 65 < viewSize.height-height) {
            _tableView.frame = CGRectMake(_tableView.frame.origin.x, _tableView.frame.origin.y, _tableView.frame.size.width, ([UserContactArray count]) * 65);
        }
        else{
            _tableView.frame = CGRectMake(_tableView.frame.origin.x, _tableView.frame.origin.y, _tableView.frame.size.width, viewSize.height-height);
        }
    }
}
#pragma mark ====== TableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [UserContactArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellName = @"cell";
    CachatTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"CachatTableViewCell" owner:self options:nil]lastObject];
    }
    UserContact *model = nil;
    if (indexPath.row == 0) {
        model  = (UserContact *)[UserContactArray lastObject];
        cell.imgView.image = [UIImage imageNamed:@"group@2x.png"];
        cell.nameLabel.text = LOCALIZATION(@"chat_expressname");
        cell.nameLabel.backgroundColor = [UIColor clearColor];
        cell.timeLable.text = [SingleInstance handleDate:model.creatDate];
        cell.timeLable.textColor = [SingleInstance colorFromHexRGB:@"9a9a9a"];
        cell.nameLabel.textColor = [UIColor blackColor];
        cell.typeLable.hidden = YES;
        if (model.filename == nil || [model.filename isEqualToString:@""]) {
            if (model.context == nil || [model.context isEqualToString:@""]) {
                cell.connectLable.hidden = YES;
                cell.timeLable.hidden = YES;
            }
            cell.connectLable.text = [NSString stringWithFormat:@"%@:%@",model.firstUsername,model.context];
        }
        else if([model.filename isEqualToString:@"jpg"]) {
            cell.connectLable.text = [NSString stringWithFormat:@"%@:%@",model.firstUsername,LOCALIZATION(@"chattype_photo")];
        }
        else if ([model.filename isEqualToString:@"amr"]){
            cell.connectLable.text = [NSString stringWithFormat:@"%@:[%@]",model.firstUsername,LOCALIZATION(@"setting_notify_voice")];
        }
        else{
            cell.connectLable.hidden = YES;
            cell.timeLable.hidden = YES;
        }
        cell.connectLable.textColor = [UIColor colorWithRed:128/255.0 green:128/255.0 blue:128/255.0 alpha:0.8];
    }
    else{
        cell.accessoryType =  UITableViewCellAccessoryNone;
        model = (UserContact *)[UserContactArray objectAtIndex:indexPath.row-1];
        cell.nameLabel.text = model.contactName;
        cell.nameLabel.backgroundColor = [UIColor clearColor];
        cell.timeLable.text = [SingleInstance handleDate:model.creatDate];
        if ([model.contactType isEqualToString:ORDINARY_GROUP_CODE]) {
            cell.imgView.image = [UIImage imageNamed:@"group"];
            if ([model.groupType isEqualToString:GROUPTYPE_SYSTEM_CODE]) {
                cell.typeLable.text = LOCALIZATION(@"chat_grouptype_system");
            }
            else if([model.groupType isEqualToString:GROUPTYPE_NORMAL_CODE])
            {
                cell.typeLable.text = LOCALIZATION(@"chat_grouptype_normal");
            }
        }
        else if ([model.contactType isEqualToString:ORDINARY_USER_CODE]){
            cell.typeLable.text = @"";
            [cell.imgView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGE_BASE_URL,model.icon]] placeholderImage:[UIImage imageNamed:@"portrait_ico"]];
        }
        cell.timeLable.textColor = [SingleInstance colorFromHexRGB:@"9a9a9a"];
        cell.nameLabel.textColor = [UIColor blackColor];
        cell.typeLable.textColor = [SingleInstance colorFromHexRGB:@"9a9a9a"];
        if (model.filename == nil || [model.filename isEqualToString:@""]) {
            if (model.context == nil || [model.context isEqualToString:@""]) {
                cell.connectLable.hidden = YES;
                cell.timeLable.hidden = YES;
            }
            cell.connectLable.text = [NSString stringWithFormat:@"%@:%@",model.firstUsername,model.context];
        }
        else if([model.filename isEqualToString:@"jpg"]) {
            cell.connectLable.text = [NSString stringWithFormat:@"%@:%@",model.firstUsername,LOCALIZATION(@"chattype_photo")];
        }
        else if ([model.filename isEqualToString:@"amr"]){
            cell.connectLable.text = [NSString stringWithFormat:@"%@:[%@]",model.firstUsername,LOCALIZATION(@"setting_notify_voice")];
        }
        else{
            cell.connectLable.hidden = YES;
            cell.timeLable.hidden = YES;
        }
        cell.connectLable.textColor = [UIColor colorWithRed:128/255.0 green:128/255.0 blue:128/255.0 alpha:0.8];
    }
   
    //判断是否有新消息，显示信息的提示小图标
    if ([model.lastMsgNum intValue]>0) {
        cell.numLable.hidden = NO;
        cell.numLable.layer.cornerRadius = 8;
        if ([model.lastMsgNum integerValue] == 100) {
            cell.numLable.frame = CGRectMake(cell.numLable.frame.origin.x - 4, cell.numLable.frame.origin.y, cell.numLable.frame.size.width + 4, cell.numLable.frame.size.height);
            cell.numLable.text = @"99+";
            if (indexPath.row == 0) {
                cell.numLable.frame = CGRectMake(cell.numLable.frame.origin.x - 4, cell.numLable.frame.origin.y + 4, cell.numLable.frame.size.width + 5, cell.numLable.frame.size.height);
            }
        }
        else{
            cell.numLable.text = model.lastMsgNum;
            if (indexPath.row == 0) {
                cell.numLable.frame = CGRectMake(cell.numLable.frame.origin.x, cell.numLable.frame.origin.y + 3, cell.numLable.frame.size.width, cell.numLable.frame.size.height);
            }
        }
        
    }
    else{
        // 暂时先把"小红点"隐藏掉
        cell.numLable.hidden = YES;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    VChatViewController *vc = [[VChatViewController alloc] init];
    if (indexPath.row) {
        UserContact *model = (UserContact *)[UserContactArray objectAtIndex:indexPath.row-1];
        // 未读数据清零
        model.lastMsgNum = @"0";
        // 个人聊天
        if ([model.contactType isEqualToString:ORDINARY_USER_CODE]) {
            vc.type = VChatType_pChat;
            vc.recvId = [NSNumber numberWithInt:[model.contactId intValue]];
            vc.recvName = model.contactUsername;
            vc.recvFirstName = model.contactName;
        }
        // 群组聊天
        else if ([model.contactType isEqualToString:ORDINARY_GROUP_CODE]){
            
            if ([model.groupType isEqualToString:GROUPTYPE_NORMAL_CODE]) {
                vc.type = VChatType_pGroup;
                vc.recvId = [NSNumber numberWithInt:[model.contactId intValue]];
                vc.recvName = model.contactUsername;
                vc.recvFirstName = model.contactName;
            }
            else if ([model.groupType isEqualToString:GROUPTYPE_SYSTEM_CODE]){
                vc.type = VChatType_pGroup;
                vc.recvId = [NSNumber numberWithInt:[model.contactId intValue]];
                vc.recvFirstName = model.contactName;
            }
            else{
                return;
            }
        
        }
        else{
            
        }
    }
    // 聊天广场
    else{
         UserContact *model = (UserContact *)[UserContactArray lastObject];
        vc.recvFirstName = LOCALIZATION(@"chat_expressname");
        vc.recvName = model.contactUsername;
        vc.type = VChatType_VC;
    }
    [self.navigationController pushViewController:vc animated:YES];
    SSRCRelease(vc)
    
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
     if (indexPath == 0) {
         return NO;
     }
     else{
    return YES;
     }
}
//打开编辑模式后，默认情况下每行左边会出现红的删除按钮，这个方法就是关闭这些按钮的
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView
           editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath == 0) {
         return UITableViewCellEditingStyleNone;
    }
    else{
    return UITableViewCellEditingStyleDelete;
    }
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return;
    }
    else{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
      
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        if(!window) {
            window = [[UIApplication sharedApplication].windows objectAtIndex:0];
        }
        popOver = [[QiDiPopoverView alloc] init];
        [popOver showPopoverAtPoint:CGPointMake(viewSize.width, 0) inView:self.view withContentView:[self creatMoreOperationView:indexPath.row - 1]];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
    }
}
    
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return LOCALIZATION(@"chat_group_operatetitle");
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 65;
    }
    else{
    return 60;
    }
}
-(void)showPopover:(id)sender forEvent:(UIEvent*)event
{
    UITableViewController *tableViewController = [[UITableViewController alloc] initWithStyle:UITableViewStylePlain];
    tableViewController.view.frame = CGRectMake(0,0, 320, 400);
    TSPopoverController *popoverController = [[TSPopoverController alloc] initWithContentViewController:tableViewController];
    
    popoverController.cornerRadius = 0;
    popoverController.titleText = @"change order";
    popoverController.popoverBaseColor = [UIColor lightGrayColor];
    popoverController.popoverGradient= NO;
    [popoverController showPopoverWithTouch:event];
    
}

-(void) showActionSheet:(id)sender forEvent:(UIEvent*)event
{
    TSActionSheet *actionSheet = [[TSActionSheet alloc] init];
    NSString *addFriend = LOCALIZATION(@"home_addfriend");
    NSString *createGroup = LOCALIZATION(@"home_addgroup");
    [actionSheet addButtonWithTitle:addFriend icon:@"add_icon.png" block:^{
        SearchFriendsViewController *search = [[SearchFriendsViewController alloc]init];
        CATransition *animation = [CATransition animation];
        [animation setDuration:0.3];
        [animation setType: kCATransitionMoveIn];
        [animation setSubtype: kCATransitionFromTop];
        [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
        [self.navigationController pushViewController:search animated:NO];
        [self.navigationController.view.layer addAnimation:animation forKey:nil];
        
    }];
    [actionSheet addButtonWithTitle:createGroup icon:@"group_icon.png" block:^{
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        if(!window) {
            window = [[UIApplication sharedApplication].windows objectAtIndex:0];
        }
        popOver = [[QiDiPopoverView alloc] init];
        [popOver showPopoverAtPoint:CGPointMake(viewSize.width, 0) inView:self.view withContentView:[self creatGroupView]];
    }];
    actionSheet.cornerRadius = 0;
    
    [actionSheet showWithTouch:event];
}
- (UIView *)creatGroupView{
    UIView *contaiterView = [[UIView alloc]initWithFrame:CGRectMake(30, 64, viewSize.width-60, 170)];
    contaiterView.backgroundColor = [UIColor blackColor];
    UILabel *groupNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, 150, 40)];
    groupNameLabel.text = LOCALIZATION(@"chat_groupname");
    groupNameLabel.textColor = [UIColor whiteColor];
    groupNameLabel.backgroundColor = [UIColor clearColor];
    groupNameLabel.font = [UIFont systemFontOfSize:16];
    [contaiterView addSubview:groupNameLabel];
    
    UIImageView *lineBg1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 45, contaiterView.frame.size.width, 2)];
    lineBg1.image = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"searchbglinered@2x" ofType:@"png"]];
    
    [contaiterView addSubview:lineBg1];
    
    groupName = [[UITextField alloc]initWithFrame:CGRectMake(5, 60, contaiterView.frame.size.width-10, 30)];
    [groupName setBorderStyle:UITextBorderStyleLine];
    groupName.layer.borderColor = [[UIColor orangeColor]CGColor];
    groupName.font = [UIFont systemFontOfSize:16];
    groupName.autocapitalizationType = UITextAutocapitalizationTypeNone;
    groupName.keyboardAppearance = UIKeyboardAppearanceDefault;
    groupName.keyboardType = UIKeyboardTypeDefault;
    groupName.textColor = [UIColor whiteColor];
    groupName.returnKeyType = UIReturnKeyGo;
    [groupName becomeFirstResponder];
    groupName.tag = 101;
    groupName.delegate = self;
    [contaiterView addSubview:groupName];
    
    UIImageView *lineBg2 = [[UIImageView alloc]initWithFrame:CGRectMake(6, 90, contaiterView.frame.size.width-10, 4)];
    lineBg2.image = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"searchbglinered@2x" ofType:@"png"]];
    
    [contaiterView addSubview:lineBg2];
    
    UIButton *dialogBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    dialogBtn.frame = CGRectMake(30, 120, 70, 40);
    dialogBtn.backgroundColor = [UIColor clearColor];
    dialogBtn.tag = DIALOG_Btn_TAG;
    [dialogBtn setTitle:LOCALIZATION(@"dialog_cancel") forState:UIControlStateNormal];
    [dialogBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [dialogBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    dialogBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    dialogBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    
    UIButton *subMitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    subMitBtn.frame = CGRectMake(150, 120, 70, 40);
    subMitBtn.backgroundColor = [UIColor clearColor];
    subMitBtn.tag = SUBMIT_BTN_TAG;
    [subMitBtn setTitle:LOCALIZATION(@"button_submit") forState:UIControlStateNormal];
    [subMitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [subMitBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    subMitBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    subMitBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [contaiterView addSubview:dialogBtn];
    [contaiterView addSubview:subMitBtn];
    
    return contaiterView;
}

- (UIView *)creatMoreOperationView:(NSInteger)index{
    UIView *contaiterView = [[UIView alloc]initWithFrame:CGRectMake(30, 110, viewSize.width-60, 170)];
    contaiterView.backgroundColor = [UIColor whiteColor];
    CGFloat width = contaiterView.frame.size.width;
    
    UIView *firstView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, width, 40)];
    firstView.layer.borderWidth = 1;
    firstView.backgroundColor = [UIColor blackColor];
    
    UILabel *headLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, width - 10, 30)];
    headLabel.text = LOCALIZATION(@"chat_group_operatetitle");
    headLabel.backgroundColor = [UIColor clearColor];
    headLabel.textColor = [UIColor whiteColor];
    headLabel.font = [UIFont boldSystemFontOfSize:20];
    [firstView addSubview:headLabel];
    
   
    
    UIView *secondView = [[UIView alloc]initWithFrame:CGRectMake(0.5, 45, width-1, 35)];
    secondView.layer.borderWidth = 1;
    secondView.tag = TOP_CHAT_TAG + index;
    secondView.layer.borderColor = [[UIColor grayColor] CGColor];
    secondView.backgroundColor = [UIColor whiteColor];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(topAction:)];
    tap.view.tag = TOP_CHAT_TAG + index;
    [secondView addGestureRecognizer:tap];
    tap = nil;
    
    UILabel *topLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, width -100, 30)];
    topLabel.text = LOCALIZATION(@"chat_group_top");
    topLabel.textColor = [UIColor blackColor];
    topLabel.font = [UIFont systemFontOfSize:15];
    [secondView addSubview:topLabel];
    
    UIView *thirdView = [[UIView alloc]initWithFrame:CGRectMake(0.5, 79, width-1, 35)];
    thirdView.layer.borderWidth = 1;
    thirdView.tag = CACLETOP_CHAT_TAG + index;
    thirdView.layer.borderColor = [[UIColor grayColor] CGColor];
    thirdView.backgroundColor = [UIColor whiteColor];
    UITapGestureRecognizer * cacleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cacleTopAction:)];
    cacleTap.view.tag = CACLETOP_CHAT_TAG + index;
    [thirdView addGestureRecognizer:cacleTap];
    cacleTap = nil;
    
    UILabel *canceltopLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, width - 100, 30)];
    canceltopLabel.text = LOCALIZATION(@"chat_group_operatetitle");
    canceltopLabel.textColor = [UIColor blackColor];
    canceltopLabel.font = [UIFont systemFontOfSize:15];
    [thirdView addSubview:canceltopLabel];
    
   
    [contaiterView addSubview:firstView];
    [contaiterView addSubview:secondView];
    [contaiterView addSubview:thirdView];
    return contaiterView;
}
- (void)topAction:(UITapGestureRecognizer *)sender
{
    UserContact *model = (UserContact *)UserContactArray[sender.view.tag - TOP_CHAT_TAG];
    [userContactDB updateuserContactInfo:nil andkeyValue:model andString:@"1"];
    [popOver dismiss];
    [self getUserADDGroupList];//重新加载数据

}
- (void)cacleTopAction:(UITapGestureRecognizer *)sender
{
    UserContact *model = (UserContact *)UserContactArray[sender.view.tag - CACLETOP_CHAT_TAG];
    [userContactDB updateuserContactInfo:nil andkeyValue:model andString:@"0"];
    [popOver dismiss];
    [self getUserADDGroupList];//重新加载数据
}
//点击其他地方，弹出框消失
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [popOver dismiss];
}

-(void)creatHUD:(NSString *)hud{
    if (!HUD) {
        HUD = [[MBProgressHUD alloc] initWithView:self.view] ;
        [self.view addSubview:HUD];
        HUD.delegate = self;
    }
    HUD.labelText = hud;
}
#pragma mark MBProgressHUDDelegate methods
- (void)hudWasHidden:(MBProgressHUD *)hud {
    // Remove HUD from screen when the HUD was hidded
    if (HUD && HUD.superview) {
        [HUD removeFromSuperview];
        HUD = nil;
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    //self.view = nil;
    // Dispose of any resources that can be recreated.
}

// 给selfTypeDic赋值
- (NSMutableDictionary *)dicWithVType:(VChatType)type andRecvId:(NSNumber *)_recvId{
    newArticleDic = [NSMutableDictionary dictionary];
    // 聊天广场
    if (type == VChatType_VC) {
        [newArticleDic setObject:@"9" forKey:@"typeId"];
        [newArticleDic setObject:@"0" forKey:@"isGroupArticle"];
        [newArticleDic setObject:@"0" forKey:@"recvId"];
    }
    // 个人聊天
    else if (type == VChatType_pChat){
        [newArticleDic setObject:@"10" forKey:@"typeId"];
        [newArticleDic setObject:@"0" forKey:@"isGroupArticle"];
        if (_recvId) {
            [newArticleDic setObject:_recvId forKey:@"recvId"];
        }
    }
    // 群组聊天
    else if (type == VChatType_pGroup){
        [newArticleDic setObject:@"0" forKey:@"typeId"];
        [newArticleDic setObject:@"1" forKey:@"isGroupArticle"];
        if (_recvId) {
            [newArticleDic setObject:_recvId forKey:@"recvId"];
        }
    }
    return newArticleDic;
}
#pragma mark -- noti
- (void)pushNew:(NSNotification *)noti{
    [self addUserContact];
    [self isPushGetData];
    // 开gcd把所在群组加入到聊天列表中
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self writeGroupIntoLocal];
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
        
    });
   
}
- (void)enterForGroud:(NSNotification *)noti{
    [self getUserADDGroupList];
}
- (void)addNewContact:(id)noti{
    
}
//先读取缓存数据
/*
 Notification method handler when app enter in forground
 @param the fired notification object
 */
- (void)appEnterInforground:(NSNotification*)notification{

}
/*
 Notification method handler when app enter in background
 @param the fired notification object
 */
- (void)appEnterInBackground:(NSNotification*)notification{
    
}
- (void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    [tableView setTableHeaderView:view];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PUSH_NEW object:nil];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PUSH_NEW object:nil];
     [[NSNotificationCenter defaultCenter] removeObserver:self name:ENTERFORGROUD object:nil];
    HUD = nil;
    popOver = nil;
    head_bg = nil;
    newArticleDic = nil;
    groupName = nil;
    _tableView = nil;
    UserContactArray = nil;
    groupArray = nil;
    groupToContactArray = nil;
}

@end
