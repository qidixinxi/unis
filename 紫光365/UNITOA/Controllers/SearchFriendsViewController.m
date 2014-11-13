//
//  searchFriendsViewController.m
//  UNITOA
//
//  Created by qidi on 14-6-26.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import "SearchFriendsViewController.h"
#import "Interface.h"
#import "FriendIfo.h"
#import "UserLoginViewController.h"
#import "SqliteFieldAndTable.h"
#import "FriendsTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "FriendDetailViewController.h"
#import "SignListViewController.h"
#define SEARCH_RIGHT_BTN_TAG 301
@interface SearchFriendsViewController ()
{
    UIView *head_bg;
    UITextField *searchField;
    UITableView *_tableView;
    NSMutableArray *frindsArray;
    NSMutableArray *userArray;
}
@end

@implementation SearchFriendsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    userArray = [[NSMutableArray alloc]init];
    self.view.backgroundColor = [UIColor whiteColor];
    UIView *bgNavi = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 130, 44)];
    bgNavi.backgroundColor = [UIColor clearColor];
    bgNavi.userInteractionEnabled = YES;
    
    UIImage *image = [UIImage imageNamed:@"return_unis_logo"];
    UIImageView *logoView = [[UIImageView alloc]initWithImage:image];
    
    
    logoView.backgroundColor = [UIColor clearColor];
    logoView.frame = CGRectMake(0, (44 - image.size.height)/2, image.size.width, image.size.height);
    logoView.contentMode = UIViewContentModeScaleAspectFit;
    logoView.userInteractionEnabled = YES;
    
    
    UILabel *loginLabel = [[UILabel alloc]initWithFrame:CGRectMake(image.size.width + 5, 7, 160, 30)];
    loginLabel.text = LOCALIZATION(@"friend_search");
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
    [self creatUI];
    [self creatTable];
    
    [self setExtraCellLineHidden:_tableView];
}
- (void)creatUI
{
    if (currentDev || currentDev1) {
        head_bg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, viewSize.width, 40)];
        
    }
    else{
        head_bg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, viewSize.width, 40)];
    }
    [head_bg setBackgroundColor:[UIColor colorWithPatternImage:[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"home_head@2x" ofType:@"png"]]]];
    
    UIButton *right_searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [right_searchBtn setBackgroundImage:[UIImage imageNamed:@"search_ico"] forState:UIControlStateNormal];
    
    right_searchBtn.frame = CGRectMake(0, 0, 25, 25);
    [right_searchBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    right_searchBtn.tag = SEARCH_RIGHT_BTN_TAG;
    
    searchField = [[UITextField alloc]initWithFrame:CGRectMake(10, 5, viewSize.width-20, 30)];
    searchField.backgroundColor = [UIColor clearColor];
    searchField.returnKeyType = UIReturnKeySearch;
    searchField.placeholder = @"Name/E-mail/Phone";
    searchField.rightView = right_searchBtn;
    searchField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    searchField.rightViewMode = UITextFieldViewModeAlways;
    searchField.delegate = self;
    [searchField becomeFirstResponder];
    
    UIImageView *line = [[UIImageView alloc]initWithImage:[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"searchbglinered@2x" ofType:@"png"]]];
    
    line.frame = CGRectMake(5, 35, viewSize.width-10, 4);
    [head_bg addSubview:line];
    [head_bg addSubview:searchField];
    [self.view addSubview:head_bg];
    
}
- (void)btnClick:(UIButton *)sender
{
    [userArray removeAllObjects];
    [searchField resignFirstResponder];
    [self requestUserData];
}
- (void)creatTable
{
    if (currentDev || currentDev1) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,head_bg.frame.size.height+head_bg.frame.origin.y ,viewSize.width, viewSize.height - head_bg.frame.size.height-head_bg.frame.origin.y-64) style:UITableViewStylePlain];
        
    }
    else{
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,head_bg.frame.size.height+head_bg.frame.origin.y ,viewSize.width, viewSize.height - head_bg.frame.size.height-head_bg.frame.origin.y-44) style:UITableViewStylePlain];
        
    }
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // 解决IOS7下tableview分割线左边短了一点
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [_tableView setSeparatorInset:UIEdgeInsetsZero];
        
    }
    [self.view addSubview:_tableView];
}
- (void)tapAction
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)requestUserData
{
    [userArray removeAllObjects];
     NSDictionary *parameters = @{@"userId":GET_USER_ID,@"sid":GET_S_ID,@"keyword":searchField.text,@"pageSize":[NSString stringWithFormat:@"%d",INT_MAX],@"page":[NSString stringWithFormat:@"%d",1]};
    [AFRequestService responseData:USER_SEARCH_URL andparameters:parameters andResponseData:^(NSData *responseData) {
        NSDictionary *dict =(NSDictionary *)responseData;
        NSUInteger codeNum = [[dict objectForKey:@"code"] integerValue];
        if (codeNum == CODE_SUCCESS) {
            NSArray *userLists = [dict objectForKey:@"userlist"];
            if([userLists count] == 0){
                [self presentAlert];
            }
            for (int i = 0; i < [userLists count]; ++i) {
                FriendIfo *friendModel = [[FriendIfo alloc]init];
                NSDictionary * userlist = (NSDictionary *)userLists[i];
                friendModel.dstUserId = [userlist objectForKey:@"userId"];
                friendModel.dstUserName = [userlist objectForKey:@"firstname"];
                friendModel.dstUser = [userlist objectForKey:@"username"];
                friendModel.icon = [userlist objectForKey:@"icon"];
                if (![friendModel.dstUserId isEqualToString:GET_USER_ID]) {
                    [userArray addObject:friendModel];
                    friendModel = nil;
                }
            }
            _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
            [_tableView reloadData];
        }
        else if (codeNum == CODE_ERROE){
            SqliteFieldAndTable *sqliteAndtable = [[SqliteFieldAndTable alloc]init];
            SearchFriendsViewController __weak *_Self = self;
            [sqliteAndtable repeatLogin:^(BOOL flag) {
                if (flag) {
                    [_Self requestUserData];
                }
                else{
                    UserLoginViewController *login = [[UserLoginViewController alloc]init];
                    [_Self.navigationController pushViewController:login animated:YES];
                    login = nil;
                }
                
            }];
        }
        else {
            return ;
        }
        
    }];
    
}
-(void)presentAlert
{
    UIAlertView*alert = [[UIAlertView alloc]initWithTitle:@"未搜索到相应成员"
                         
                                                  message:nil
                         
                         
                         
                                                 delegate:nil
                         
                         
                         
                                        cancelButtonTitle:nil
                         
                         
                         
                                        otherButtonTitles:nil];
    
    [alert show];
    
    UIActivityIndicatorView*activeView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    activeView.center = CGPointMake(alert.bounds.size.width/2.0f, alert.bounds.size.height-40.0f);
    
    [alert dismissWithClickedButtonIndex:0 animated:YES];
    
    [activeView startAnimating];
    
    [alert addSubview:activeView];
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self requestUserData];
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return YES;
    
}
#pragma mark ====== UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [userArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellName = @"cell";
    FriendsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"FriendsTableViewCell" owner:self options:nil]lastObject];
    }
    FriendIfo *model = (FriendIfo *)userArray[indexPath.row];
    cell.nameLable.text = model.dstUserName;
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGE_BASE_URL,model.icon]] placeholderImage:[UIImage imageNamed:@"portrait_ico"]];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.fromType == frome_search) {
        FriendDetailViewController *friendDetail = [[FriendDetailViewController alloc]init];
        friendDetail.friendModel = (FriendIfo *)userArray[indexPath.row];
        [self.navigationController pushViewController:friendDetail animated:YES];
    }
    else if(self.fromType == frome_sigin) {
        SignListViewController *signList = [[SignListViewController alloc]init];
        signList.friendID = ((FriendIfo *)userArray[indexPath.row]).dstUserId;
        [self.navigationController pushViewController:signList animated:YES];
        
    }
    
}

- (void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    [tableView setTableHeaderView:view];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    if(self.isViewLoaded && !self.view.window){
        head_bg = nil;
        searchField = nil;
        _tableView = nil;
        frindsArray = nil;
        userArray = nil;
        self.view = nil;
    }
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    head_bg = nil;
    searchField = nil;
    _tableView = nil;
    frindsArray = nil;
    userArray = nil;
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
