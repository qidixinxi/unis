//
//  AllMattersViewController.h
//  Matters
//
//  Created by ianMac on 14-7-5.
//  Copyright (c) 2014年 ianMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AllMattersViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    // 创建一个全局的TableView
    UITableView *_tableView;
    
    // 数据源
    NSMutableArray *_MattersDataArray;
    
    // 网络加载提示控件(小圈圈)
    UIActivityIndicatorView *_aiv;
    
    // 用户的Id
    NSString *userIdStr;
    
    // 判断视图选择器
    BOOL _isGet;
}

// 初始化方法
- (instancetype)initWithUserId:(NSString *)userId;

@end
