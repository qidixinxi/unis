//
//  SendPostsImageScrollView.m
//  FBCircle
//
//  Created by soulnear on 14-8-6.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import "SendPostsImageScrollView.h"

@implementation SendPostsImageScrollView
@synthesize data_array = _data_array;
@synthesize imageView_array = _imageView_array;




- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        _imageView_array = [NSMutableArray array];
    }
    return self;
}


//208  274
-(void)loadAllViewsWith:(NSMutableArray *)array WithBlock:(SendPostsImageScrollViewBlock)theBlock
{
    [_imageView_array removeAllObjects];
    self.data_array = array;
    
    sendImage_block = theBlock;
    
    for (UIView * view in self.subviews) {
        [view removeFromSuperview];
    }
    
    for (int i = 0;i <= self.data_array.count;i++)
    {
        if (i == self.data_array.count && self.data_array.count <= 9) {
            UIButton *addImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
            addImageButton.frame = CGRectMake(5+100*i,5,90,90);
            addImageButton.tag =  self.data_array.count;
            [addImageButton setBackgroundImage:[UIImage imageNamed:@"addImage"] forState:UIControlStateNormal];
            [addImageButton addTarget:self action:@selector(addMoreImage:) forControlEvents:UIControlEventTouchUpInside];
             [self addSubview:addImageButton];
            if (i == 9) {
                addImageButton.hidden = YES;
            }
        }
        else{
        UIImage * image = [self.data_array objectAtIndex:i];
        
        CGRect rect = CGRectMake(5+100*i,5,90,90);
        
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:rect];
        
        imageView.image = image;
        
        imageView.tag = 100 + i;
        
        imageView.userInteractionEnabled = YES;
        
        imageView.contentMode = UIViewContentModeScaleToFill;
        
        [self addSubview:imageView];
        
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(preViewTap:)];
        
        [imageView addGestureRecognizer:tap];
        
        
        
        
        UIButton * close_button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        close_button.frame = CGRectMake(75,-5,25,25);
        
        close_button.tag = 1000 + i;
        
        [close_button addTarget:self action:@selector(deleteImageTap:) forControlEvents:UIControlEventTouchUpInside];
        
        [close_button setImage:[UIImage imageNamed:@"Send_Image_close.png"] forState:UIControlStateNormal];
        
        [imageView addSubview:close_button];
        
        [_imageView_array addObject:imageView];
       
    }
}
    if (self.data_array.count < 9){
    self.contentSize = CGSizeMake(5+100*(self.data_array.count + 1),0);
    }
    else{
        self.contentSize = CGSizeMake(5+100*self.data_array.count,0);
    }
}


-(void)deleteImageTap:(UIButton *)sender
{
    
    if (sendImage_block)
    {
        sendImage_block(sender.tag-1000,0);
    }
    
    
    NSMutableArray * temp_array = [NSMutableArray arrayWithArray:_imageView_array];
    
     UIButton * addImageButton = (UIButton *)[self viewWithTag:temp_array.count];
    for (int i = 0;i < temp_array.count;i++)
    {
        UIImageView * imageView = (UIImageView *)[self viewWithTag:i+100];
        
        UIButton * button = (UIButton *)[imageView viewWithTag:1000+i];
       
        
        if (i == sender.tag - 1000)
        {
            [_imageView_array removeObjectAtIndex:sender.tag-1000];
            
            [imageView removeFromSuperview];
        }
       
        if (sender.tag-1000 < i)
        {
            imageView.tag = 100+i-1;
            
            button.tag = 1000 + i -1;
            
            CGRect frame = imageView.frame;
            
            frame.origin.x = 5+100*(i-1);
            
//            // button的位置
//            addImageButton.tag = _imageView_array.count;
//            CGRect buttonFrame = addImageButton.frame;
//            
//            buttonFrame.origin.x = 5+100*(temp_array.count-1);
            
            [UIView animateWithDuration:0.3 animations:^{
                imageView.frame = frame;
                //addImageButton.frame = buttonFrame;
            } completion:^(BOOL finished) {
                
            }];
            
             }
        // button的位置
        addImageButton.tag = _imageView_array.count;
        CGRect buttonFrame = addImageButton.frame;
        
        buttonFrame.origin.x = 5+100*(temp_array.count-1);
        
        [UIView animateWithDuration:0.3 animations:^{
            addImageButton.frame = buttonFrame;
        } completion:^(BOOL finished) {
            
        }];
        }
    if (self.imageView_array.count < 9) {
        addImageButton.hidden = NO;
        self.contentSize = CGSizeMake(5+100*(self.imageView_array.count +1),0);
    }
    else{
        addImageButton.hidden = YES;
    self.contentSize = CGSizeMake(5+100*(self.imageView_array.count),0);
    }
    
    
}
- (void)addMoreImage:(UIButton *)sender{
    if (self.sendImageDelegate && [self.sendImageDelegate respondsToSelector:@selector(addMoreImage)]) {
        [self.sendImageDelegate addMoreImage];
    }
}



#pragma mark - 跳到预览界面


-(void)preViewTap:(UITapGestureRecognizer *)sender
{
//    if (sendImage_block) {
//        sendImage_block(sender.view.tag-100,1);
//    }
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end












