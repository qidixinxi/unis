//
//  GMAPI.h
//  GUKE
//
//  Created by gaomeng on 14-10-5.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MBProgressHUD.h"

@interface GMAPI : NSObject

+ (MBProgressHUD *)showMBProgressWithText:(NSString *)text addToView:(UIView *)aView;

+(void)webViewDidFinishLoad:(UIWebView *)webView;

@end
