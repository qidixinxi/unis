//
//  selectDateTimeViewController.h
//  GUKE
//
//  Created by qidi on 14-10-27.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol selectDateTimeViewDelegate <NSObject>

- (void)sendTime:(NSString *)date;

@end
@interface selectDateTimeViewController : UIViewController
@property (nonatomic,strong)id<selectDateTimeViewDelegate>delegate;
@end
