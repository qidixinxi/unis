//
//  PutTableViewCell.h
//  Matters
//
//  Created by ianMac on 14-7-5.
//  Copyright (c) 2014年 ianMac. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MattersModel;

@interface PutTableViewCell : UITableViewCell
{
@private
    // 发出的内容
    UILabel *_putContent;
    // 收件姓名
    UILabel *_getName;
    // 状态
    UILabel *_state;
    // 附件
    UIImageView *_imageIcon;
    UILabel *_imageTitile;
    UIImageView *_imageVoiceIcon;
}

@property (nonatomic, strong)MattersModel *mattersModel;
@end
