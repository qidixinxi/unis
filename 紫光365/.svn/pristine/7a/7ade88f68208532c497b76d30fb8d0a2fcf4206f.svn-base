//
//  SolveReasonViewController.h
//  Matters
//
//  Created by ianMac on 14-7-8.
//  Copyright (c) 2014年 ianMac. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BlockButton;
@class MattersModel;

@interface SolveReasonViewController : UIViewController <UITextViewDelegate, UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
    UITableView *_SolveReasonView;
    
    UIView *_titleView;
    
    UIView *_fileView;
    
    UITextView *_AddContentView;
    
    BlockButton *_ConfirmBtn;
    
    // 键盘弹起之前DetailsView的坐标
    CGPoint SolvePoint;
    
    MattersModel *_mattersModel;
    
    // 接收actionNum的值
    int _actionNum;
}

// 重写初始化方法传值 (actionNum:0解决  actionNum:1退回)
- (instancetype)initWithModel:(MattersModel *)model andAction:(int)actionNum;
@end
