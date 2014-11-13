//
//  FileMainNavViewController.m
//  UNITOA
//
//  Created by qidi on 14-11-12.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import "FileMainNavViewController.h"

@interface FileMainNavViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView  *_tableView;
    NSArray *_NAVArray;
}
@property(nonatomic,strong)UITableView  *tableView;
@property(nonatomic,strong)NSArray  *NAVArray;
@end
@implementation FileMainNavViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    if (IOS7_LATER) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    self.aTitle = LOCALIZATION(@"filestore");
    self.NAVArray = @[LOCALIZATION(@"company_filestore"),LOCALIZATION(@"private_filestore"),LOCALIZATION(@"locao_filestore")];
}
- (void)creaTable{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [ZSTool setExtraCellLineHidden:self.tableView];
    [self.view addSubview:self.tableView];
}
#pragma mark -------------UITableViewDelegate----------------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.NAVArray count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 30;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellName = @"Fcell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
    }
    cell.textLabel.text = self.NAVArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}- (void)didReceiveMemoryWarning {
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
