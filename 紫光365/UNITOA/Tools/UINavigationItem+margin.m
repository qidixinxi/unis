//
//  UINavigationItem+margin.m
//  UNITOA
//
//  Created by ianMac on 14-7-22.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import "UINavigationItem+margin.h"

@implementation UINavigationItem (margin)


#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1
- (void)setLeftBarButtonItem:(UIBarButtonItem *)_leftBarButtonItem
{
    if (IOS7_LATER)
    {
        UIBarButtonItem *negativeSeperator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        negativeSeperator.width = -7;
        
        if (_leftBarButtonItem){
            [self setLeftBarButtonItems:@[negativeSeperator, _leftBarButtonItem]];
        }
        else{
            
            [self setLeftBarButtonItems:@[negativeSeperator]];
            
        }
    }
    else{
        [self setLeftBarButtonItem:_leftBarButtonItem animated:NO];
    }
}

- (void)setRightBarButtonItem:(UIBarButtonItem *)_rightBarButtonItem
{
    if (IOS7_LATER)
    {
        UIBarButtonItem *negativeSeperator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        negativeSeperator.width = -7;
        
        if (_rightBarButtonItem){
            [self setRightBarButtonItems:@[negativeSeperator, _rightBarButtonItem]];
        }else{
            [self setRightBarButtonItems:@[negativeSeperator]];
        }
    }else{
        [self setRightBarButtonItem:_rightBarButtonItem animated:NO];
    }
}
#endif

@end
