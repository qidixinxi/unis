//
//  GmettingDetailTableViewCell.h
//  GUKE
//
//  Created by gaomeng on 14-10-5.
//  Copyright (c) 2014年 qidi. All rights reserved.
//


//活动详情自定义cell
#import <UIKit/UIKit.h>
#import "GeventModel.h"
@class GeventDetailViewController;

@interface GmettingDetailTableViewCell : UITableViewCell


@property(nonatomic,assign)GeventDetailViewController *delegate;


-(CGFloat)loadCustomViewWithIndexPath:(NSIndexPath*)indexPath dataModel:(GeventModel*)theModel;




@end
