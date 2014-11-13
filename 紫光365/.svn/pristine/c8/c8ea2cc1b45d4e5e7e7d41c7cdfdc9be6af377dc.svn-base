//
//  TypeTableViewCell.m
//  UNITOA
//
//  Created by ianMac on 14-7-18.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import "TypeTableViewCell.h"
#import "BlockButton.h"
#import "TypeModel.h"


@implementation TypeTableViewCell

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
    _btn = [[UILabel alloc] initWithFrame:CGRectZero];
    
    [self.contentView addSubview:_content];
    [self.contentView addSubview:_btn];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    _content.frame = CGRectMake(10, 15, 250, 20);
    _content.backgroundColor = [UIColor clearColor];
    _content.textAlignment = NSTextAlignmentLeft;
    _content.font = [UIFont systemFontOfSize:14.0f];
    _content.text = self.typeModel.typeName;
    
    _btn.frame = CGRectMake(260, 10, 50, 30);
    _btn.layer.borderWidth  = 1.0f;
    _btn.layer.borderColor  = [UIColor darkGrayColor].CGColor;
    _btn.layer.backgroundColor = [UIColor colorWithRed:128/255.0 green:128/255.0 blue:128/255.0 alpha:0.3].CGColor;
    _btn.layer.cornerRadius = 5.0f;
    _btn.text = @"发送";
    _btn.textColor = [UIColor blackColor];
    _btn.font = [UIFont systemFontOfSize:14.0f];
    _btn.textAlignment = NSTextAlignmentCenter;
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
