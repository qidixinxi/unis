//
//  MattersViewController.h
//  Matters
//
//  Created by ianMac on 14-7-4.
//  Copyright (c) 2014年 ianMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MattersViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>
{
    // 创建一个全局的TableView
    UITableView *_tableView;
    
    // 数据源
    NSMutableArray *_MattersDataArray;
    
    // 视图选择器
    UISegmentedControl *_seg;
    
    // 滚动视图
    UIScrollView *_scrollView;
    
    // 判断视图选择器
    BOOL _isGet;
    
    // 事项数量的标签
    UILabel *label1;
    
    // "未收"事项数量
    int uncollected_num;
    
    // "待办"事项数量
    int backLog_num;
    
    // "退回"事项数量
    int reject_num;
    
    // 网络加载提示控件(小圈圈)
    UIActivityIndicatorView *_aiv;
    
    // 用户ScrollView的数组
    NSMutableArray *_scrollViewArray;
    
    // 群组ScrollView的数组
    NSMutableArray *_scrollGroupArray;
    
}
@end
