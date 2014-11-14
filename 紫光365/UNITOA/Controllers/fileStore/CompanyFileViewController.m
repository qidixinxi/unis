//
//  CompanyFileViewController.m
//  UNITOA
//
//  Created by qidi on 14-11-13.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import "CompanyFileViewController.h"
#import "FileListTableViewCell.h"
@interface CompanyFileViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *_cloudList;
}
@property(nonatomic,strong)NSMutableArray *cloudList;
@property(nonatomic,strong)UITableView  *tableView;
@end
@implementation CompanyFileViewController
@synthesize cloudList = _cloudList;
- (void)viewDidLoad {
    [super viewDidLoad];
   // self.aTitle = LOCALIZATION(@"company_filestore");
    self.cloudList = [[NSMutableArray alloc]init];
    [self creaTable];
    [self getCloudList];
}
- (void)creaTable{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [ZSTool setExtraCellLineHidden:self.tableView];
    [self.view addSubview:self.tableView];
}
- (void)getCloudList{
    [self.cloudList removeAllObjects];
    NSDictionary *parameter = nil;
    if (self.password.length == 0) {
        parameter = @{@"userId":GET_USER_ID,@"sid":GET_S_ID,@"parentId":self.parentId,@"shareType":[NSString stringWithFormat:@"%d",self.share_type],@"showUserId":self.showUserId,@"folderOnly":@"0",@"password":@""};
    }
    else{
        parameter = @{@"userId":GET_USER_ID,@"sid":GET_S_ID,@"parentId":self.parentId,@"shareType":[NSString stringWithFormat:@"%d",self.share_type],@"showUserId":self.showUserId,@"folderOnly":@"0",@"password":self.password};
    }
    [AFRequestService responseData:YOUPAN_LIST_URL andparameters:parameter andResponseData:^(NSData *responseData) {
        NSDictionary *dict = (NSDictionary *)responseData;
        if (CODE_NUM == CODE_SUCCESS) {
            id yuanpanArray = [dict objectForKey:@"yunpanlist"];
            if ([yuanpanArray isKindOfClass:[NSArray class]]) {
               [self.cloudList addObjectsFromArray:[[yunpanModel new] getYunPanList:yuanpanArray]];
            }
        }
        [self.tableView reloadData];
    }];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.cloudList count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellName = @"cell";
    FileListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (cell == nil) {
        //cell = [[[NSBundle mainBundle]loadNibNamed:@"FriendsTableViewCell" owner:self options:nil]lastObject];
        cell = [[FileListTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
    }
     id model = self.cloudList[indexPath.row];
    if ([model isKindOfClass:[yunpanModel class]]) {
        cell.postModel = model;
    }
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(delFolder:)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    cell.logoView.userInteractionEnabled = YES;
    [cell.logoView addGestureRecognizer:tap];
    tap.view.tag = indexPath.row;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    id model = self.cloudList[indexPath.row];
    if ([model isKindOfClass:[yunpanModel class]]) {
        if ([model password].length != 0) {
            
        }
        else{
            CompanyFileViewController *comFile = [[CompanyFileViewController alloc]init];
            comFile.share_type = self.share_type;
            comFile.parentId = [model yunpanId];
            comFile.password = @"";
            comFile.showUserId = self.showUserId;
            comFile.aTitle = [model filename];
            [self.navigationController pushViewController:comFile animated:YES];
        }
    }
}
#pragma mark -------------- 删除文件 -------------------
- (void)delFolder:(UITapGestureRecognizer *)gesture{
    __weak id model = self.cloudList[gesture.view.tag];
    __weak typeof(self)_bself = self;
    if ([model isKindOfClass:[yunpanModel class]]) {
        NSDictionary *parameter = @{@"userId":GET_USER_ID,@"sid":GET_S_ID,@"yunpanId":[model yunpanId]};
        [AFRequestService responseData:YUNPAM_DEL_URL andparameters:parameter andResponseData:^(NSData *responseData) {
            NSDictionary *dict = (NSDictionary *)responseData;
            if (CODE_NUM == CODE_SUCCESS) {
                [_bself.cloudList removeObject:model];
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:gesture.view.tag inSection:0];
                [_bself.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
                [ZSTool presentAlert:@"文件删除成功"];
            }
        }];
    }
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
