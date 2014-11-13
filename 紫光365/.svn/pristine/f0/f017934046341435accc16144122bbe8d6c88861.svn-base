//
//  NameMatterViewController.h
//  UNITOA
//
//  Created by ianMac on 14-7-14.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
@class UserIfo;
@interface NameMatterViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate>
{
    UIView *_FaviconAndNameView;
    
    UISegmentedControl *_seg;
    
    UITableView *_tableView;
    
    // 数据源
    NSMutableArray *_MattersDataArray;
    
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
    
    //
    UserIfo *userInfoModel;

}

// 重写初始化方法传值
- (instancetype)initWithUserModel:(UserIfo *)userModel;
@end
