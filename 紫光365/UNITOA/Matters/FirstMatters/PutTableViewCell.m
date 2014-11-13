//
//  PutTableViewCell.m
//  Matters
//
//  Created by ianMac on 14-7-5.
//  Copyright (c) 2014年 ianMac. All rights reserved.
//

#import "PutTableViewCell.h"
#import "MattersModel.h"

@implementation PutTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubview];
    }
    return self;
}

- (void)initSubview
{
    _putContent = [[UILabel alloc] initWithFrame:CGRectZero];
    _getName = [[UILabel alloc] initWithFrame:CGRectZero];
    _state = [[UILabel alloc] initWithFrame:CGRectZero];
    
    _imageIcon = [[UIImageView alloc] initWithFrame:CGRectZero];
    _imageTitile = [[UILabel alloc] initWithFrame:CGRectZero];
    _imageVoiceIcon = [[UIImageView alloc] initWithFrame:CGRectZero];
    
    [self.contentView addSubview:_putContent];
    [self.contentView addSubview:_getName];
    [self.contentView addSubview:_state];
    [self.contentView addSubview:_imageIcon];
    [self.contentView addSubview:_imageTitile];
    [self.contentView addSubview:_imageVoiceIcon];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _putContent.frame = CGRectMake(10, 15, 190, 20);
    _getName.frame = CGRectMake(195, 15, 60, 20);
    _state.frame = CGRectMake(250, 15, 70, 20);
    
    _imageIcon.frame = CGRectMake(10, 10, 30, 30);
    _imageTitile.frame = CGRectMake(45, 15, 100, 20);
    _imageVoiceIcon.frame = CGRectMake(10, 10, 60, 30);
    
    _putContent.text = self.mattersModel.content;
    _putContent.font = [UIFont systemFontOfSize:14.0f];
    
    _getName.text = self.mattersModel.getName;
    _getName.font = [UIFont systemFontOfSize:14.0f];
    _getName.textAlignment = NSTextAlignmentCenter;
    [_getName setTextColor:[UIColor blueColor]];
    
    _state.text = self.mattersModel.state;
    _state.font = [UIFont systemFontOfSize:14.0f];
    

    _imageIcon.image = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"icon_word" ofType:@"png"]];
    _imageVoiceIcon.image = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"task_voice" ofType:@"png"]];
    _imageTitile.text = [[(NSArray *)self.mattersModel.attachlist firstObject] objectForKey:@"filename"];
    [_imageTitile setLineBreakMode:NSLineBreakByTruncatingMiddle];
    _imageTitile.font = [UIFont systemFontOfSize:13.0f];
    
    // 如果是附件状态,并且附件是图片
    if ([self judgeFileSuffixImage]) {
        NSLog(@"%@是图片",self.mattersModel.taskId);
        _putContent.hidden = YES;
        _imageVoiceIcon.hidden = YES;
        
    }else if ([self judgeFileSuffixVoice]){
        _putContent.hidden = YES;
        _imageIcon.hidden = YES;
        _imageTitile.hidden = YES;
    }else{
        _imageTitile.hidden = YES;
        _imageIcon.hidden = YES;
        _imageVoiceIcon.hidden = YES;
    }
    
    _putContent = nil;
    _getName = nil;
    _state = nil;
    _imageIcon = nil;
    _imageTitile = nil;
    _imageVoiceIcon = nil;
    
}

// 判断文件的后缀名是否是图片文件
- (BOOL)judgeFileSuffixImage
{
    if ([[[[(NSArray *)self.mattersModel.attachlist firstObject] objectForKey:@"fileurl"] pathExtension]isEqualToString:@"jpg"] || [[[[(NSArray *)self.mattersModel.attachlist firstObject] objectForKey:@"fileurl"] pathExtension]isEqualToString:@"JPG"] || [[[[(NSArray *)self.mattersModel.attachlist firstObject] objectForKey:@"fileurl"] pathExtension]isEqualToString:@"png"] || [[[[(NSArray *)self.mattersModel.attachlist firstObject] objectForKey:@"fileurl"] pathExtension]isEqualToString:@"PNG"] || [[[[(NSArray *)self.mattersModel.attachlist firstObject] objectForKey:@"fileurl"] pathExtension]isEqualToString:@"gif"] || [[[[(NSArray *)self.mattersModel.attachlist firstObject] objectForKey:@"fileurl"] pathExtension]isEqualToString:@"GIF"]) {
        return YES;
    }else{
        return NO;
    }
}

// 判断文件的后缀名是否是声音文件
- (BOOL)judgeFileSuffixVoice
{
    if ([[[[(NSArray *)self.mattersModel.attachlist firstObject] objectForKey:@"fileurl"] pathExtension]isEqualToString:@"amr"] || [[[[(NSArray *)self.mattersModel.attachlist firstObject] objectForKey:@"fileurl"] pathExtension]isEqualToString:@"wma"] || [[[[(NSArray *)self.mattersModel.attachlist firstObject] objectForKey:@"fileurl"] pathExtension]isEqualToString:@"mp3"]){
        return YES;
    }else{
        return NO;
    }
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
