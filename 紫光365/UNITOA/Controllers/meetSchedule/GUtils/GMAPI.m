//
//  GMAPI.m
//  GUKE
//
//  Created by gaomeng on 14-10-5.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import "GMAPI.h"

@implementation GMAPI


+ (MBProgressHUD *)showMBProgressWithText:(NSString *)text addToView:(UIView *)aView
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:aView animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
    view.backgroundColor = [UIColor redColor];
    hud.customView = view;
    hud.labelText = text;
    hud.margin = 15.f;
    hud.yOffset = 0.0f;
    hud.removeFromSuperViewOnHide = YES;
    return hud;
}




+(void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString *height_str= [webView stringByEvaluatingJavaScriptFromString: @"document.body.offsetHeight"];
    int height = [height_str intValue];
    CGRect r = webView.frame;
    r.size.height = height;
    webView.frame = r;
    
}

@end
