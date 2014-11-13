//
//  DetailsViewController.h
//  Matters
//
//  Created by ianMac on 14-7-5.
//  Copyright (c) 2014年 ianMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MattersModel.h"

@interface DetailsViewController : UIViewController <UITextFieldDelegate>
{
    UITableView *_DetailsView;
    
    UIView *_PortraitView;
    
    UIView *_ContentView;
    
    UIView *_GradeView;
    
    UIView *_ImageOrVoiceView;
    
    UIView *_FunctionView;
    
    UIView *_inputView;
    
    UIView *_GradeExtendView;
    
    // 键盘弹起之前DetailsView的坐标
    CGPoint DetailsPoint;
    
    MattersModel *model;
    
    // 输入框
    UITextField *_textField;
}

// 重写初始化方法传值
- (instancetype)initWithArray:(NSMutableArray *)array andNum:(int)num;
@end
