//
//  GeventDetailViewController.h
//  GUKE
//
//  Created by gaomeng on 14-10-4.
//  Copyright (c) 2014年 qidi. All rights reserved.
//



//会议详情
#import <UIKit/UIKit.h>
#import "GeventModel.h"
#import "GmettingDetailTableViewCell.h"
#import "SNViewController.h"
@interface GeventDetailViewController : SNViewController

@property(nonatomic,strong)GeventModel *dataModel;


@property(nonatomic,assign)CGFloat webViewHeight;//webview高度

-(void)btnClicked:(UIButton *)sender;
@end
