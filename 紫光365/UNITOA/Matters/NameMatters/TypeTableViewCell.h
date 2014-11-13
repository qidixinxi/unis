//
//  TypeTableViewCell.h
//  UNITOA
//
//  Created by ianMac on 14-7-18.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TypeModel;

@interface TypeTableViewCell : UITableViewCell
{
@private
    UILabel *_content;
    UILabel *_btn;
}

@property (nonatomic, strong) TypeModel *typeModel;
@end
