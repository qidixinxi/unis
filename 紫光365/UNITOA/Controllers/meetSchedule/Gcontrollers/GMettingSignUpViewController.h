//
//  GMettingSignUpViewController.h
//  GUKE
//
//  Created by gaomeng on 14-10-4.
//  Copyright (c) 2014年 qidi. All rights reserved.
//



//会议报名
#import <UIKit/UIKit.h>
#import "GeventModel.h"
#import "MBProgressHUD.h"
#import "GMAPI.h"
#import "SNViewController.h"

@interface GMettingSignUpViewController : SNViewController<UITableViewDataSource,UITableViewDelegate,MBProgressHUDDelegate,UIAlertViewDelegate,UITextFieldDelegate>
@property(nonatomic,strong)NSMutableArray *contentLabelArray;

@property(nonatomic,strong)GeventModel *dataModel;

@end
