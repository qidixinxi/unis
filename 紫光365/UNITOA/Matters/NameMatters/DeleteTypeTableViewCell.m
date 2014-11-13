//
//  DeleteTypeTableViewCell.m
//  UNITOA
//
//  Created by ianMac on 14-7-19.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import "DeleteTypeTableViewCell.h"
#import "TypeModel.h"


@implementation DeleteTypeTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubView];
    }
    return self;
}

- (void)initSubView
{
    _content = [[UILabel alloc] initWithFrame:CGRectZero];
    
    [self.contentView addSubview:_content];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _content.frame = CGRectMake(10, 15, 250, 20);
    _content.backgroundColor = [UIColor clearColor];
    _content.textAlignment = NSTextAlignmentLeft;
    _content.font = [UIFont systemFontOfSize:14.0f];
    _content.text = self.typeModel.typeName;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
