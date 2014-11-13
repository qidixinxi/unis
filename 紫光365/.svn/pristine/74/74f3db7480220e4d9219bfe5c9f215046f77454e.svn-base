//
//  GetTableViewCell.m
//  Matters
//
//  Created by ianMac on 14-7-5.
//  Copyright (c) 2014年 ianMac. All rights reserved.
//

#import "GetTableViewCell.h"
#import "MattersModel.h"
#import "SolveReasonViewController.h"
#import "MattersViewController.h"

@implementation GetTableViewCell

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
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _contentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _imageIcon = [[UIImageView alloc] initWithFrame:CGRectZero];
    _imageTitile = [[UILabel alloc] initWithFrame:CGRectZero];
    _imageVoiceIcon = [[UIImageView alloc] initWithFrame:CGRectZero];
    _btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    _btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    _stateLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    
    [self.contentView addSubview:_nameLabel];
    [self.contentView addSubview:_contentLabel];
    [self.contentView addSubview:_imageIcon];
    [self.contentView addSubview:_imageTitile];
    [self.contentView addSubview:_imageVoiceIcon];
    [self.contentView addSubview:_btn1];
    [self.contentView addSubview:_btn2];
    [self.contentView addSubview:_stateLabel];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _nameLabel.frame = CGRectMake(10, 15, 60, 20);
    _contentLabel.frame = CGRectMake(60, 15, 150, 20);
    
    _imageIcon.frame = CGRectMake(60, 10, 30, 30);
    _imageTitile.frame = CGRectMake(95, 15, 100, 20);
    _imageVoiceIcon.frame = CGRectMake(60, 10, 60, 30);

    _nameLabel.font = [UIFont systemFontOfSize:14.0f];
    _nameLabel.textColor = [UIColor blueColor];
    _nameLabel.text = self.mattersModel.name;
    _contentLabel.font = [UIFont systemFontOfSize:14.0f];
    _contentLabel.text = self.mattersModel.content;
    
    _imageIcon.image = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"icon_word" ofType:@"png"]];
    _imageVoiceIcon.image = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"task_voice" ofType:@"png"]];
    _imageTitile.text = [[(NSArray *)self.mattersModel.attachlist firstObject] objectForKey:@"filename"];
    [_imageTitile setLineBreakMode:NSLineBreakByTruncatingMiddle];
    _imageTitile.font = [UIFont systemFontOfSize:13.0f];
    
    _stateLabel.frame = CGRectMake(210, 10, 110, 30);
    _stateLabel.font = [UIFont systemFontOfSize:14.0f];
    _stateLabel.text = self.mattersModel.state;
    _stateLabel.textAlignment = NSTextAlignmentCenter;
    if ([self.mattersModel.state isEqualToString:@"1"]||[self.mattersModel.state isEqualToString:@"0"]) {
        _stateLabel.hidden = YES;
    }
    
    _btn1.frame = CGRectMake(210, 10, 50, 30);
    _btn1.backgroundColor = [UIColor colorWithRed:128/255.0 green:128/255.0 blue:128/255.0 alpha:0.3];
    _btn1.layer.cornerRadius = 5;
    _btn1.tag = 1;
    [_btn1 setTitle:LOCALIZATION(@"button_resolve") forState:UIControlStateNormal];
    [_btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _btn1.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [_btn1 addTarget:self action:@selector(Click:) forControlEvents:UIControlEventTouchUpInside];
    
    _btn2.frame = CGRectMake(265, 10, 50, 30);
    _btn2.backgroundColor = [UIColor colorWithRed:128/255.0 green:128/255.0 blue:128/255.0 alpha:0.3];
    _btn2.layer.cornerRadius = 5;
    _btn2.tag = 2;
    [_btn2 setTitle:LOCALIZATION(@"button_reject") forState:UIControlStateNormal];
    [_btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _btn2.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [_btn2 addTarget:self action:@selector(Click:) forControlEvents:UIControlEventTouchUpInside];
    
    // 在model的state状态不为1时候,将按钮隐藏
    if (!([self.mattersModel.state isEqualToString:@"1"]||[self.mattersModel.state isEqualToString:@"0"])) {
        _btn1.hidden = YES;
        _btn2.hidden = YES;
    }
    NSLog(@"-----%@这里测试:%@",self.mattersModel.content,self.mattersModel.state);
    // 如果是附件状态,并且附件是图片
    if ([self judgeFileSuffixImage]) {
        //NSLog(@"%@是图片",self.mattersModel.taskId);
        _contentLabel.hidden = YES;
        _imageVoiceIcon.hidden = YES;
        
    }else if ([self judgeFileSuffixVoice]){
        _contentLabel.hidden = YES;
        _imageIcon.hidden = YES;
        _imageTitile.hidden = YES;
    }else{
        _imageTitile.hidden = YES;
        _imageIcon.hidden = YES;
        _imageVoiceIcon.hidden = YES;
    }
    
    _nameLabel = nil;
    _contentLabel = nil;
    _imageIcon = nil;
    _imageTitile = nil;
    _imageVoiceIcon = nil;
    _btn1 = nil;
    _btn2 = nil;
    _stateLabel = nil;
}

- (void)Click:(UIButton *)btn
{
    if (btn.tag == 1) {
        //NSLog(@"点击\"解决\"");
        SolveReasonViewController *svc = [[SolveReasonViewController alloc] initWithModel:self.mattersModel andAction:0];
        [((MattersViewController *)self.nextResponder.nextResponder.nextResponder.nextResponder).navigationController pushViewController:svc animated:YES];

    }else{
        //NSLog(@"点击\"退回\"");
        SolveReasonViewController *svc = [[SolveReasonViewController alloc] initWithModel:self.mattersModel andAction:1];
        [((MattersViewController *)self.nextResponder.nextResponder.nextResponder.nextResponder).navigationController pushViewController:svc animated:YES];
    }
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
