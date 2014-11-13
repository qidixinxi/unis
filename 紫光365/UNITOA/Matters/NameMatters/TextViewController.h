//
//  TextViewController.h
//  UNITOA
//  文本事项
//  Created by ianMac on 14-7-17.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UserIfo;


@interface TextViewController : UIViewController<UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>
{
    // 视图选择器
    UISegmentedControl *_seg;
    
    // "选择常用事项"的视图
    UIView *_selectView;
    
    // "添加常用事项"的视图
    UIView *_addView;
    
    // "删除常用事项"的视图
    UIView *_deleteView;
    
    // "正常" "加急" "静音"的视图
    UIView *_extentView;
    
    // "发送给"的视图
    UIView *_sendToView;
    
    // "对方阅读后是否立即删除"的视图
    UIView *_isImmediatelyDeleteView;
    
    // 要发送的内容的视图
    UITableView *_contentView;
    
    // 输入内容的视图
    UIView *_inputView;
    
    // 输入的内容
    UITextField *_textField;
    
    // 键盘弹起之前_selectView的坐标
    CGPoint _selectViewPoint;
    
    // "添加常用事项"中输入框的视图
    UIView *_addInputView;
    
    // 键盘弹起之前_addViewPoint的坐标
    CGPoint _addViewPoint;
    
    // 数据源
    NSMutableArray *_dataArray;
    
    // 网络加载提示控件(小圈圈)
    UIActivityIndicatorView *_aiv;
    
    // 定义一个用户信息Model
    UserIfo *_model;
    
    //
    UITableView *_deleteTabelView;
    
    // 事项的紧急程度
    NSString *_emergency;
    
    // 是否阅读后立即删除
    NSString *_deleteAfterRead;
    
    // 延期提醒的日期
    NSString *_remindTime;
}
// 用于记录当前所选中的行
@property (nonatomic, strong) NSIndexPath *selectedPath;
// 创建属性(用于存放删除的对象)
@property (nonatomic, strong) NSMutableArray *deleteArray;

// 自定义初始化方法
- (instancetype)initWithModel:(UserIfo *)userModel;
@end
