//
//  FileListTableViewCell.h
//  UNITOA
//
//  Created by qidi on 14-11-14.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "yunpanModel.h"
@interface FileListTableViewCell : UITableViewCell
@property(nonatomic,strong)yunpanModel *postModel;
@property(nonatomic,strong)UIImageView *imgView;
@property(nonatomic,strong)UILabel *fileName;
@property(nonatomic,strong)UIImageView *logoView;
@end
