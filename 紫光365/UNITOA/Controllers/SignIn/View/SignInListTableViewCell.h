//
//  SignInListTableViewCell.h
//  UNITOA
//
//  Created by qidi on 14-11-7.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SignIfo.h"
@interface SignInListTableViewCell : UITableViewCell
{
    SignIfo *_postModel;
}
@property(nonatomic,strong)SignIfo *postModel;
@property(nonatomic,strong)UILabel *nameLable;
@property(nonatomic,strong)UILabel *addressLable;
@property(nonatomic,strong)UILabel *timelable;
@property(nonatomic,strong)UIImageView *logoImageView;
+ (CGFloat)cellHeight:(SignIfo *)model;
@end
