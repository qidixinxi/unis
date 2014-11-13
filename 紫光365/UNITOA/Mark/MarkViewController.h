//
//  MarkViewController.h
//  UNITOA
//  "打分"
//  Created by ianMac on 14-7-15.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MarkViewController : UIViewController
{
    NSString *_taskId;
}
- (instancetype)initWithtaskId:(NSString *)taskId;

@end
