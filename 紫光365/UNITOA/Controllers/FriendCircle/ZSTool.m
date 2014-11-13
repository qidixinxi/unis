//
//  ZSTool.m
//  UNITOA
//
//  Created by qidi on 14-10-21.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import "ZSTool.h"
#import "SingleInstance.h"
#import "Interface.h"
@implementation ZSTool
+(NSString *)dateFromString:(NSString *)dateString{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    [dateFormatter setDateFormat:@"MM-dd"];
    NSString *destDateString = [dateFormatter stringFromDate:destDate];
    return destDateString;
}

// 时间处理函数
+ (NSString *)handleDate:(NSString *)createDate
{
    NSString *subDate = [[createDate componentsSeparatedByString:@" "] firstObject];
    NSString *houre = [[createDate componentsSeparatedByString:@" "] lastObject];
    NSString *subhoure = [NSString stringWithFormat:@"%@:%@",[[houre componentsSeparatedByString:@":"]objectAtIndex:0],[[houre componentsSeparatedByString:@":"]objectAtIndex:1]];
    NSArray *mouthAndDay = [subDate componentsSeparatedByString:@"-"];
    NSString *mouth = mouthAndDay[1];
    NSString *day = mouthAndDay[2];
    if ([mouth hasPrefix:@"0"]) {
        mouth = [mouth substringWithRange:NSMakeRange(1, 1)];
    }
    if ([day hasPrefix:@"0"] ) {
        day = [day substringWithRange:NSMakeRange(1, 1)];
    }
    
    return [NSString stringWithFormat:@"%@月%@日%@",mouth,day,subhoure];
}

+ (void)showMBProgressWithText:(NSString *)text addToView:(UIView *)aView
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:aView animated:YES];
    hud.mode = MBProgressHUDModeDeterminate;
    hud.labelText = text;
    hud.margin = 15.f;
    hud.yOffset = 150.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:1.5];
}

+ (MBProgressHUD *)returnMBProgressWithText:(NSString *)text addToView:(UIView *)aView
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:aView animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = text;
    hud.margin = 15.f;
    hud.yOffset = 150.f;
    hud.removeFromSuperViewOnHide = YES;
    return hud;
}

+(NSURL *)returnUrl:(NSString *)url
{
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGE_BASE_URL,url]];
}


+(CGSize)returnStringHeightWith:(NSString *)string WithWidth:(float)theWidht WithFont:(int)aFont
{
    CGSize rectSize;
    if (IOS7_LATER) {
        CGRect rectr = [string boundingRectWithSize:CGSizeMake(theWidht, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:aFont]} context:nil];
        rectSize = rectr.size;
    }
    else{
        rectSize = [SingleInstance customFontHeight:string andFontSize:theWidht andLineWidth:aFont];
    }
    
    return rectSize;
}


// 判断文件的后缀名是否是声音文件
+(BOOL)judgeFileSuffixVoice:(NSString *)string
{
    if ([[string pathExtension]isEqualToString:@"amr"] || [[string pathExtension]isEqualToString:@"wma"] || [[string pathExtension]isEqualToString:@"mp3"]){
        return YES;
    }else{
        return NO;
    }
}

// 判断文件的后缀名是否是图片文件
+(BOOL)judgeFileSuffixImage:(NSString *)string
{
    if ([[string pathExtension]isEqualToString:@"jpg"] || [[string pathExtension]isEqualToString:@"JPG"] || [[string pathExtension]isEqualToString:@"png"] || [[string pathExtension]isEqualToString:@"PNG"] || [[string pathExtension]isEqualToString:@"gif"] || [[string pathExtension]isEqualToString:@"GIF"]) {
        return YES;
    }else{
        return NO;
    }
}

+ (void)presentAlert:(NSString *)alertContent
{
    UIAlertView*alert = [[UIAlertView alloc]initWithTitle:alertContent message:nil delegate:nil
                                        cancelButtonTitle:nil otherButtonTitles:nil];
    [alert show];
    
    UIActivityIndicatorView*activeView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    activeView.center = CGPointMake(alert.bounds.size.width/2.0f, alert.bounds.size.height-40.0f);
    
    [alert dismissWithClickedButtonIndex:0 animated:YES];
    
    [activeView startAnimating];
    
    [alert addSubview:activeView];
}
#pragma mark -------- setExtraCellLineHidden -----------
+ (void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    [tableView setTableHeaderView:view];
    view = nil;
}
@end
