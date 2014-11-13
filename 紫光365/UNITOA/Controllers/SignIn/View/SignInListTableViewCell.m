//
//  SignInListTableViewCell.m
//  UNITOA
//
//  Created by qidi on 14-11-7.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import "SignInListTableViewCell.h"
#import "ZSTool.h"
@implementation SignInListTableViewCell
@synthesize postModel = _postModel;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIImage *logoIco = [UIImage imageNamed:@"naviLocation"];
        CGFloat height = logoIco.size.height;
        CGFloat width = logoIco.size.width;
        self.logoImageView = [[UIImageView alloc]initWithImage:logoIco];
        self.logoImageView.frame = CGRectMake(10, 5, width/3 * 2, height/3 *2);
        [self.contentView addSubview:self.logoImageView];
        
        //CGRectMake(self.logoImageView.frame.origin.x + width, 2, SCREEN_WIDTH - (self.logoImageView.frame.origin.x + width) - 70, 300)
        self.nameLable = [[UILabel alloc]initWithFrame:CGRectZero];
        self.nameLable.numberOfLines = 0;
        self.nameLable.lineBreakMode = NSLineBreakByWordWrapping |NSLineBreakByCharWrapping;
        self.nameLable.textColor = GETColor(83, 83, 83);
        self.nameLable.font = [UIFont systemFontOfSize:15.0];
        [self.contentView addSubview:self.nameLable];
        
        self.timelable = [[UILabel alloc]initWithFrame:CGRectZero];
        //self.timelable.numberOfLines = 0;
        self.timelable.lineBreakMode = NSLineBreakByWordWrapping |NSLineBreakByCharWrapping;
        self.timelable.textColor = GETColor(83, 83, 83);
        self.timelable.font = [UIFont systemFontOfSize:14.0];
        [self.contentView addSubview:self.timelable];
        
        self.addressLable = [[UILabel alloc]initWithFrame:CGRectZero];
        self.addressLable.numberOfLines = 0;
        self.addressLable.lineBreakMode = NSLineBreakByWordWrapping |NSLineBreakByCharWrapping;
        self.addressLable.textColor = GETColor(185, 185, 185);
        self.addressLable.font = [UIFont systemFontOfSize:14.0];
        [self.contentView addSubview:self.addressLable];
    }
    return self;
}
- (void)awakeFromNib {
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}
- (void)setPostModel:(SignIfo *)postModel{
    self.nameLable.text = postModel.name;
    self.timelable.text = [ZSTool handleDate:postModel.createDate];
    self.addressLable.text = postModel.address;
    
    UIImage *logoIco = [UIImage imageNamed:@"naviLocation"];
    CGFloat height = logoIco.size.height;
    CGFloat width = logoIco.size.width;
    self.logoImageView = [[UIImageView alloc]initWithImage:logoIco];
    self.logoImageView.frame = CGRectMake(10, 5, width, height);
    
    CGFloat logoY = self.logoImageView.frame.origin.x + width;
    
    CGRect nameFrame = [SingleInstance getFrame:postModel.name andFontSize:15 andWidth:SCREEN_WIDTH - logoY - 100];
    self.nameLable.frame = CGRectMake(logoY, 2, SCREEN_WIDTH - logoY - 100, nameFrame.size.height);
    
    self.timelable.frame = CGRectMake(SCREEN_WIDTH - 100, 2, 100, 20);
    
    CGRect addressFrame = [SingleInstance getFrame:postModel.address andFontSize:15 andWidth:SCREEN_WIDTH - logoY - 100];
    self.addressLable.frame = CGRectMake(self.nameLable.frame.origin.x, self.nameLable.frame.origin.y + self.nameLable.frame.size.height + 5, self.nameLable.frame.size.width, addressFrame.size.height);
    
}
+ (CGFloat)cellHeight:(SignIfo *)model{
    UIImage *logoIco = [UIImage imageNamed:@"naviLocation"];
    CGFloat width = logoIco.size.width;
     CGFloat logoY = 10 + width;
     CGRect nameFrame = [SingleInstance getFrame:model.name andFontSize:15 andWidth:SCREEN_WIDTH - logoY - 100];
     CGRect addressFrame = [SingleInstance getFrame:model.address andFontSize:15 andWidth:SCREEN_WIDTH - logoY - 100];
    return nameFrame.size.height + addressFrame.size.height + 10;
}
@end
