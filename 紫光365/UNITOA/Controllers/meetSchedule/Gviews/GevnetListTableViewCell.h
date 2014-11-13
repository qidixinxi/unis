//
//  GevnetListTableViewCell.h
//  GUKE
//
//  Created by gaomeng on 14-10-5.
//  Copyright (c) 2014年 qidi. All rights reserved.
//


//活动列表自定义cell
#import <UIKit/UIKit.h>
#import "GeventModel.h"

@interface GevnetListTableViewCell : UITableViewCell


-(void)loadCustomViewWithIndexPath:(NSIndexPath*)indexPath:model:(GeventModel*)theModel;



@end
