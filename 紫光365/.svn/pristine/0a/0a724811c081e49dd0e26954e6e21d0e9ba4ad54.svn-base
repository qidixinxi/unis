//
//  ZSCircleImageView.m
//  UNITOA
//
//  Created by qidi on 14-10-21.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import "ZSCircleImageView.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "UserArticleListAttachListModel.h"
#import "UIImageView+WebCache.h"
#import "ZSTool.h"
@implementation ZSCircleImageView
@synthesize isReply = _isReply;
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        self.clipsToBounds = YES;
    }
    return self;
}

-(void)setthebloc:(FBCirclePicturesViewsBlocs)thechuanbloc{
    
    _mybloc=thechuanbloc;
}


-(void)doTap:(UITapGestureRecognizer *)sender
{
    
    _mybloc(sender.view.tag);
    
    
}

#pragma mark-zkingChangge
-(void)setimageArr:(NSArray *)imgarr withSize:(int)size isjuzhong:(BOOL)juzhong
{
    NSArray * array = [[NSArray alloc] init];
    
    array = imgarr;
    
    int row = 0;
    
    int number = 0;
    
    
    int iii = 9;
    
    if (array.count < 9)
    {
        iii = array.count;
    }
    
    
    for (int i = 0;i < array.count;i++)
    {
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake((size+3)*number,(size + 3)*row,size,size)];
        
        if (juzhong)
        {
            if (array.count == 1)
            {
                imageView.frame = CGRectMake(self.frame.size.width/2-size/2,(size + 3)*row,size,size);
            }else if(array.count == 2)
            {
                imageView.frame = CGRectMake((self.frame.size.width-size*2-4)/2 + (size+3)*number,(size + 3)*row,size,size);
            }
        }
        
        imageView.tag = i+1;
        imageView.userInteractionEnabled = YES;
        imageView.clipsToBounds = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.backgroundColor = [UIColor grayColor];
        
        id object = [array objectAtIndex:i];
        
        NSString * image_url = @"";
        
        if ([object isKindOfClass:[UserArticleListAttachListModel class]])
        {
            image_url = ((UserArticleListAttachListModel*)object).fileurl;
        }else
        {
            image_url = [array objectAtIndex:i];
        }
        
        //        UserArticleListAttachListModel * model = [array objectAtIndex:i];
        [imageView sd_setImageWithURL:[ZSTool returnUrl:image_url] placeholderImage:nil];
        
        [self addSubview:imageView];
        
        number++;
        
        if (i%3 >= 2)
        {
            row++;
            number = 0;
        }
        
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doTap:)];
        [imageView addGestureRecognizer:tap];
    }    
}


@end
