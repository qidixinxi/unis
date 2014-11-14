//
//  FileListTableViewCell.m
//  UNITOA
//
//  Created by qidi on 14-11-14.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import "FileListTableViewCell.h"

@implementation FileListTableViewCell
@synthesize postModel = _postModel;
- (void)awakeFromNib {
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
   self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.imgView = [[UIImageView alloc]initWithFrame:CGRectZero];
        self.imgView.backgroundColor = [UIColor clearColor];
        
        self.fileName = [[UILabel alloc]initWithFrame:CGRectZero];
        self.fileName.textColor = GETColor(167, 167, 167);
        self.fileName.backgroundColor = [UIColor clearColor];
        self.fileName.font = [UIFont systemFontOfSize:15];
        self.fileName.textAlignment = NSTextAlignmentLeft;
        
        self.logoView = [[UIImageView alloc]initWithFrame:CGRectZero];
        self.logoView.backgroundColor = [UIColor clearColor];
        
        [self addSubview:self.imgView];
        [self addSubview:self.fileName];
        [self addSubview:self.logoView];
        
    }
    return self;
}
- (void)setPostModel:(yunpanModel *)postModel{
    UIImage *img = nil;
    if (postModel.fileurl.length == 0 || postModel.fileurl == nil || [postModel.fileurl isEqual:[NSNull null]]) {
        img = [UIImage imageNamed:@"folder.png"];
    }
    else{
        if ([postModel.fileurl hasSuffix:@".jpg"]) {
            img = [UIImage imageNamed:@"compress.png"];
        }
        else{
            img = [UIImage imageNamed:@"other.png"];
        }
    }
    self.imgView.frame = CGRectMake(10, (60 - img.size.height)/2, img.size.width, img.size.height);
    self.imgView.image = img;
    self.fileName.frame = CGRectMake(img.size.width + 20, 20, 150, 20);
    
    self.fileName.text = postModel.filename;
    if([postModel.userId isEqualToString:GET_USER_ID]){
    UIImage *imgLogo = [UIImage imageNamed:@"delLogo"];
    self.logoView.image = imgLogo;
    self.logoView.frame = CGRectMake(SCREEN_WIDTH - imgLogo.size.width - 5, 5, imgLogo.size.width, imgLogo.size.height);
    }
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
