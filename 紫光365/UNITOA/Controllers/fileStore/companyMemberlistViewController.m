//
//  companyMemberlistViewController.m
//  UNITOA
//
//  Created by qidi on 14-11-13.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import "companyMemberlistViewController.h"
#import "pinyin.h"
#import "ChineseString.h"
#import "FriendIfo.h"
#import "FriendsTableViewCell.h"
#import "FriendsTableViewCellOne.h"
#import "FriendDetailViewController.h"
#import "TSPopoverController.h"
#import "TSActionSheet.h"
#import "SearchFriendsViewController.h"
#import "SetUpViewController.h"
#import "UserContactViewController.h"
#import "QiDiPopoverView.h"
#import "GroupListViewController.h"
#import "MattersViewController.h"
#import "SqliteFieldAndTable.h"
#import "UserLoginViewController.h"
#import "CompanyFileViewController.h"
@interface companyMemberlistViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    MBProgressHUD *HUD;
    QiDiPopoverView *popOver;
    UIView *head_bg;
    UITableView *_tableView;
    NSMutableArray *frindsArray;
    NSMutableArray *userArray;
    UITextField *groupName;
    NSString *_friendNewCount;
}

@end

@implementation companyMemberlistViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        frindsArray = [[NSMutableArray alloc]init];
        userArray = [[NSMutableArray alloc]init];
        _sortedArrForArrays = [[NSMutableArray alloc]init];
        _sectionHeadsKeys = [[NSMutableArray alloc] init];
        _friendNewCount = [NSString stringWithFormat:@"%d",0];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.aTitle = LOCALIZATION(@"company_filestore");
    if (IOS7_LATER) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    [self creatTable];
    [self getCompanyMemeberList];
}
- (void)creatTable
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    if (IOS7_LATER) {
        [_tableView setSeparatorInset:UIEdgeInsetsMake(0,10,0,10)];
    }
    _tableView.sectionIndexColor = [UIColor blackColor];
    [ZSTool setExtraCellLineHidden:_tableView];
    UIView *linebg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0)];
    [self.view addSubview:linebg];
    [self.view addSubview:_tableView];
    linebg = nil;
}
//获取用户群组及联系人列表
- (void)getCompanyMemeberList
{
    [frindsArray removeAllObjects];
    [userArray removeAllObjects];
    [_sortedArrForArrays removeAllObjects];
    [_sectionHeadsKeys removeAllObjects];
    //NSDictionary *parameters = @{@"userId":GET_USER_ID,@"sid":GET_S_ID,@"pageSize":[NSString stringWithFormat:@"%d",INT_MAX],@"page":[NSString stringWithFormat:@"%d",1]};
   // NSDictionary *parameters = @{@"userId":GET_USER_ID,@"sid":GET_S_ID,@"keyword":@" ",@"pageSize":[NSString stringWithFormat:@"%d",INT_MAX],@"page":[NSString stringWithFormat:@"%d",1]};
     NSDictionary *parameters = @{@"userId":GET_USER_ID,@"sid":GET_S_ID};
    [AFRequestService responseData:USER_LIST_URL andparameters:parameters andResponseData:^(id responseData){
        NSDictionary *dict =(NSDictionary *)responseData;
        if ([self bindData:dict]) {
            [_tableView reloadData];
        }
    } ];//andCathtype:[GET_USER_ID integerValue] andID:FREIENDLIST_CATCH_ID andtypeName:nil];// 好友列表的唯一标识
}
- (BOOL)bindData:(NSDictionary *)dict
{
    NSUInteger codeNum = [[dict objectForKey:@"code"] integerValue];
    if (codeNum == CODE_SUCCESS) {
        NSArray *contactlists = [dict objectForKey:@"userlist"];
        for (int i = 0; i <[contactlists count]; ++i) {
            NSDictionary *contactlist = (NSDictionary *)contactlists[i];
            FriendIfo *model = [[FriendIfo alloc]init];
            model.dstUserId = [contactlist valueForKey:@"userId"];
           // model.dstUser = [contactlist valueForKey:@"dstUser"];
            model.dstUserName = [contactlist objectForKey:@"firstname"];
            model.friendId = [contactlist objectForKey:@"userId"];
            model.status = [contactlist objectForKey:@"status"];
            model.userId = [contactlist objectForKey:@"userId"];
            model.icon = [contactlist objectForKey:@"icon"];
            [frindsArray addObject:model];
            
        }
        
        [HUD hide:YES];
        self.sortedArrForArrays = [self getChineseStringArr:frindsArray];
    }
    else if (codeNum == CODE_ERROE){
          __weak typeof(self)_bself = self;
        SqliteFieldAndTable *sqliteAndtable = [[SqliteFieldAndTable alloc]init];
        [sqliteAndtable repeatLogin:^(BOOL flag) {
            if (!flag) {

                UserLoginViewController *login = [[UserLoginViewController alloc]init];
                [_bself.navigationController pushViewController:login animated:YES];
                login = nil;
            }
        }];
        return NO;
    }
    else{
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"登入失败" message:@"用户名重复，请联系管理员" delegate:self cancelButtonTitle:LOCALIZATION(@"dialog_ok") otherButtonTitles:nil];
        [alert show];
        return NO;
    }
    return YES;
}
#pragma mark ====== TableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

        return  [[self.sortedArrForArrays objectAtIndex:section] count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.sortedArrForArrays count];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    tableView.sectionIndexColor = GETColor(106, 106, 106);
    if (IOS7_LATER) {
        tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    }
    return self.sectionHeadsKeys;
}
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return index;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    view.backgroundColor = GETColor(245, 245, 245);
    UILabel *titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(10, 2.5, 30, 15)];
    titleLabel.textColor = GETColor(106, 106, 106);
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont systemFontOfSize:14.0f];
    titleLabel.text= [_sectionHeadsKeys objectAtIndex:section];
    
    [view addSubview:titleLabel];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellName = @"cell";
        FriendsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"FriendsTableViewCell" owner:self options:nil]lastObject];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSArray *arr = [self.sortedArrForArrays objectAtIndex:indexPath.section];
        if ([arr count] > indexPath.row) {
            ChineseString *str = (ChineseString *) [arr objectAtIndex:indexPath.row];
            cell.nameLable.text = str.friendModel.dstUserName;
            if([NSString stringWithFormat:@"%@",str.friendModel.icon].length>0){
                str.friendModel.icon = @" ";
            }
            [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGE_BASE_URL,str.friendModel.icon]] placeholderImage:[UIImage imageNamed:@"portrait_ico"]];
        }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
        return 55;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *arr = [self.sortedArrForArrays objectAtIndex:indexPath.section];
    ChineseString *str = (ChineseString *) [arr objectAtIndex:indexPath.row];
    CompanyFileViewController *companyVC = [CompanyFileViewController new];
    companyVC.share_type = COMPANY_FILE;
    companyVC.showUserId = str.friendModel.friendId;
    companyVC.parentId = @"0";
    companyVC.aTitle = LOCALIZATION(@"company_filestore"); 
    [self.navigationController pushViewController:companyVC animated:YES];
}
// 按首字母对名字进行分组排序
- (NSMutableArray *)getChineseStringArr:(NSMutableArray *)arrToSort {
    NSMutableArray *chineseStringsArray = [NSMutableArray array];
    for(int i = 0; i < [arrToSort count]; i++) {
        FriendIfo *model = (FriendIfo *)arrToSort[i];
        ChineseString *chineseString=[[ChineseString alloc]init];
        chineseString.string=model.dstUserName;
        chineseString.friendModel = model;
        if(chineseString.string==nil){
            chineseString.string=@"";
        }
        
        if(![chineseString.string isEqualToString:@""]){
            //join the pinYin
            NSString *pinYinResult = [NSString string];
            for(int j = 0;j < chineseString.string.length; j++) {
                NSString *singlePinyinLetter = [[NSString stringWithFormat:@"%c",
                                                 pinyinFirstLetter([chineseString.string characterAtIndex:j])]uppercaseString];
                
                pinYinResult = [pinYinResult stringByAppendingString:singlePinyinLetter];
            }
            chineseString.pinYin = pinYinResult;
        } else {
            chineseString.pinYin = @"";
        }
        [chineseStringsArray addObject:chineseString];
        chineseString = nil;
    }
    
    //sort the ChineseStringArr by pinYin
    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"pinYin" ascending:YES]];
    [chineseStringsArray sortUsingDescriptors:sortDescriptors];
    
    
    NSMutableArray *arrayForArrays = [NSMutableArray array];
    BOOL checkValueAtIndex= NO;  //flag to check
    NSMutableArray *TempArrForGrouping = nil;
    
    for(int index = 0; index < [chineseStringsArray count]; index++)
    {
        ChineseString *chineseStr = (ChineseString *)[chineseStringsArray objectAtIndex:index];
        NSMutableString *strchar= [NSMutableString stringWithString:chineseStr.pinYin];
        NSString *sr= [strchar substringToIndex:1];
        //sr containing here the first character of each string
        if(![_sectionHeadsKeys containsObject:[sr uppercaseString]])//here I'm checking whether the character already in the selection header keys or not
        {
            [_sectionHeadsKeys addObject:[sr uppercaseString]];
            TempArrForGrouping = [[NSMutableArray alloc] initWithObjects:nil];
            checkValueAtIndex = NO;
        }
        if([_sectionHeadsKeys containsObject:[sr uppercaseString]])
        {
            [TempArrForGrouping addObject:[chineseStringsArray objectAtIndex:index]];
            if(checkValueAtIndex == NO)
            {
                [arrayForArrays addObject:TempArrForGrouping];
                checkValueAtIndex = YES;
            }
        }
    }
    return arrayForArrays;
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
