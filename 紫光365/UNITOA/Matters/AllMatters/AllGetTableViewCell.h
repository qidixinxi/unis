//
//  AllGetTableViewCell.h
//  Matters
//
//  Created by ianMac on 14-7-5.
//  Copyright (c) 2014年 ianMac. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MattersModel;

@interface AllGetTableViewCell : UITableViewCell
{
@private
    // 发出时间
    UILabel *_putTime;
    // 接收时间
    UILabel *_getTime;
    // 响应时间
    UILabel *_responseTime;
    // 解决时间
    UILabel *_resolutionTime;
    // 执行时间
    UILabel *_executionTime;
    // 来自谁
    UILabel *_fromName;
    // 内容
    UILabel *_content;
    // 装饰按钮
    UILabel *_btn;
}

@property (nonatomic, strong)MattersModel *mattersModel;
@end
