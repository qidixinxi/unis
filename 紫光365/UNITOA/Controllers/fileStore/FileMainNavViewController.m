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
}
@end

@implementation FileMainNavViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.aTitle = LOCALIZATION(@"filestore");
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
