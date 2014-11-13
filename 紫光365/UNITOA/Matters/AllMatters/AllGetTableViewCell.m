//
//  AllGetTableViewCell.m
//  Matters
//
//  Created by ianMac on 14-7-5.
//  Copyright (c) 2014年 ianMac. All rights reserved.
//

#import "AllGetTableViewCell.h"
#import "MattersModel.h"

@implementation AllGetTableViewCell

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
    _putTime = [[UILabel alloc] initWithFrame:CGRectZero];
    _getTime = [[UILabel alloc] initWithFrame:CGRectZero];
    _responseTime = [[UILabel alloc] initWithFrame:CGRectZero];
    _resolutionTime = [[UILabel alloc] initWithFrame:CGRectZero];
    _executionTime = [[UILabel alloc] initWithFrame:CGRectZero];
    _content = [[UILabel alloc] initWithFrame:CGRectZero];
    _btn = [[UILabel alloc] initWithFrame:CGRectZero];
    
    [self.contentView addSubview:_putTime];
    [self.contentView addSubview:_getTime];
    [self.contentView addSubview:_resolutionTime];
    [self.contentView addSubview:_responseTime];
    [self.contentView addSubview:_executionTime];
    [self.contentView addSubview:_content];
    [self.contentView addSubview:_btn];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _putTime.frame = CGRectMake(10, 10, 250, 15);
    _getTime.frame = CGRectMake(10, 30, 250, 15);
    _responseTime.frame = CGRectMake(10, 50, 250, 15);
    _resolutionTime.frame = CGRectMake(10, 70, 250, 15);
    _executionTime.frame = CGRectMake(10, 90, 250, 15);
    _content.frame = CGRectMake(10, 110, 260, 25);
    
    NSString *sendStr = @"发出时间:";
    _putTime.text = [sendStr stringByAppendingString:self.mattersModel.putTime];
    _putTime.font = [UIFont systemFontOfSize:12.0f];
    NSString *getStr = @"接收时间:";
    _getTime.text = [getStr stringByAppendingString:self.mattersModel.getTime];
    _getTime.font = [UIFont systemFontOfSize:12.0f];
    NSString *responseStr = @"响应时间:";
    _responseTime.text = [responseStr stringByAppendingString:self.mattersModel.responseTime];
    _responseTime.font = [UIFont systemFontOfSize:12.0f];
    NSString *resolutionStr = @"解决时间:";
    _resolutionTime.text = [resolutionStr stringByAppendingString:self.mattersModel.resolutionTime];
    _resolutionTime.font = [UIFont systemFontOfSize:12.0f];
    NSString *executionStr = @"执行时间:";
    _executionTime.text = [executionStr stringByAppendingString:self.mattersModel.executionTime];
    _executionTime.font = [UIFont systemFontOfSize:12.0f];
    _executionTime.textColor = [UIColor blueColor];
    
    NSString *contentStr1 = @"来自";
    NSString *contentStr2 = [contentStr1 stringByAppendingString:self.mattersModel.name];
    NSString *contentStr3 = [contentStr2 stringByAppendingString:@" : "];
    _content.text = [contentStr3 stringByAppendingString:self.mattersModel.content];
    _content.font = [UIFont boldSystemFontOfSize:14.0f];
    
    _btn.frame = CGRectMake(270, 110, 45, 27);
    _btn.layer.borderWidth  = 1.0f;
    _btn.layer.borderColor  = [UIColor darkGrayColor].CGColor;
    _btn.layer.backgroundColor = [UIColor colorWithRed:128/255.0 green:128/255.0 blue:128/255.0 alpha:0.3].CGColor;
    _btn.layer.cornerRadius = 5.0f;
    _btn.text = LOCALIZATION(@"button_view");
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
