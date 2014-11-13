//
//  DeleteTypeTableViewCell.h
//  UNITOA
//
//  Created by ianMac on 14-7-19.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TypeModel;

@interface DeleteTypeTableViewCell : UITableViewCell
{
@private
    UILabel *_content;
}

@property (nonatomic, strong) TypeModel *typeModel;
@end
