//
//  TransmitViewController.h
//  UNITOA
//  转发任务
//  Created by ianMac on 14-7-21.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BlockButton;
@class MattersModel;

@interface TransmitViewController : UIViewController<UITextViewDelegate, UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
    UITableView *_SolveReasonView;
    
    UIView *_titleView;
    
    UIView *_transmitView;
    
    UIView *_fileView;
    
    UITextView *_AddContentView;
    
    BlockButton *_ConfirmBtn;
    
    // 键盘弹起之前DetailsView的坐标
    CGPoint SolvePoint;
    
    MattersModel *_mattersModel;

}
- (instancetype)initWithModel:(MattersModel *)model;
@end
