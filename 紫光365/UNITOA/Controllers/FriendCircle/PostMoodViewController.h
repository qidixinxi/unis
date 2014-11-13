//
//  PostMoodViewController.h
//  UNITOA
//
//  Created by qidi on 14-7-15.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "CircelProtocle.h"
@interface PostMoodViewController : UIViewController<UITextViewDelegate,MBProgressHUDDelegate>
@property(nonatomic,assign)id<FriendCircelDelegate>delegate;
@end
