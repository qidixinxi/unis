//
//  TextViewController.m
//  UNITOA
//
//  Created by ianMac on 14-7-17.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import "TextViewController.h"
#import "BlockButton.h"
#import "Interface.h"
#import "TypeModel.h"
#import "TypeTableViewCell.h"
#import "DeleteTypeTableViewCell.h"


@interface TextViewController ()

// 自定义导航栏
- (void)loadNavigationItem;

// 分段选择器
- (void)loadUISegmentedControl;

// "正常" "加急" "静音"的视图
- (void)loadExtentView;

// "发送给"视图
- (void)loadSendToView;

// "对方阅读后是否立即删除"的视图
- (void)loadIsImmediatelyDeleteView;

// 发送内容的视图
- (void)loadContentView;

// 输入内容的视图
- (void)loadInputView;

// "添加常用事项"中输入框的视图
- (void)loadAddInputView;

// 请求"常用事项"的数据
- (void)requestData;

// 请求"删除事项"的数据
- (void)requestdeleteData;

// 数据加载遮罩
- (void)loadShadeView;

// 去掉tabelview多余的分割线
- (void)setExtraCellLineHidden:(UITableView *)tableView;

// "将要删除的事项"的视图
- (void)loadDeletaTableView;

// "时间选择器"的视图
- (void)loadDatePicker;


@end

@implementation TextViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // 监听键盘事件
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeContentViewPoint:) name:UIKeyboardWillShowNotification object:nil];
        [self loadShadeView];
        [self requestData];
    }
    return self;
}

// 自定义初始化方法
- (instancetype)initWithModel:(UserIfo *)userModel
{
    _model = userModel;
    if (self = [super init]) {
        
    }
    return self;
}

- (void)loadView
{
    UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    view.backgroundColor = [UIColor whiteColor];
    self.view = view;
    
    // "选择常用事项"的视图
    _selectView = [[UIView alloc] init];
    _selectView.frame = CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height-64);
    _selectView.backgroundColor = [UIColor whiteColor];
    _selectView.hidden = NO;
    [self.view addSubview:_selectView];
    
    // "添加常用事项"的视图
    _addView = [[UIView alloc] init];
    _addView.frame = CGRectMake(0, 50, 320, 160);
    _addView.backgroundColor = [UIColor whiteColor];
    _addView.hidden = YES;
    [self.view addSubview:_addView];
    
    // "删除常用事项"的视图
    _deleteView = [[UIView alloc] init];
    _deleteView.frame = CGRectMake(0, 55, 320, [UIScreen mainScreen].bounds.size.height-64-55);
    _deleteView.backgroundColor = [UIColor blackColor];
    _deleteView.hidden = YES;
    [self.view addSubview:_deleteView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadNavigationItem];
    [self loadUISegmentedControl];
    [self loadExtentView];
    [self loadSendToView];
    [self loadIsImmediatelyDeleteView];
    [self loadContentView];
    [self loadInputView];
    [self loadAddInputView];
    [self setExtraCellLineHidden:_contentView];
    [self loadDeletaTableView];
    [self setExtraCellLineHidden:_deleteTabelView];
    [self loadDatePicker];
}

#pragma mark --private method--
- (void)loadNavigationItem
{
    // 返回小箭头
    UIButton *left = [UIButton buttonWithType:UIButtonTypeCustom];
    [left setFrame:CGRectMake(0, 0, 48, 20)];
    [left setImage:[UIImage imageNamed:@"top_logo_arrow"] forState:UIControlStateNormal];
    [left addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    // 事项Label
    UILabel *title = [[UILabel alloc] init];
    title.frame = CGRectMake(0, 0, 70, 20);
    title.backgroundColor = [UIColor clearColor];
    title.text = @"文本事项";
    title.textAlignment = NSTextAlignmentCenter;
    title.font = [UIFont systemFontOfSize:16.0f];
    [title setTextColor:[UIColor whiteColor]];
    
    UIBarButtonItem *negativeSeperator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSeperator.width = -12;
    
    UIBarButtonItem *leftButton1 = [[UIBarButtonItem alloc] initWithCustomView:left];
    UIBarButtonItem *leftButton2 = [[UIBarButtonItem alloc] initWithCustomView:title];
    
    NSArray *array = [NSArray arrayWithObjects:negativeSeperator, leftButton1, leftButton2,nil];
    self.navigationItem.leftBarButtonItems = array;
}

- (void)loadUISegmentedControl
{
    NSArray *array = [[NSArray alloc] initWithObjects:@"选择常用事项", @"添加常用事项", @"删除常用事项", nil];
    _seg = [[UISegmentedControl alloc] initWithItems:array];
    _seg.frame = CGRectMake(10, 5, 300, 40);
    _seg.selectedSegmentIndex = 0;
    [_seg setTintColor:[UIColor colorWithRed:128/255.0 green:128/255.0 blue:128/255.0 alpha:0.4]];
    
    UIFont *font = [UIFont boldSystemFontOfSize:14.0f];
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:font
                                                           forKey:NSFontAttributeName];
    [_seg setTitleTextAttributes:attributes
                        forState:UIControlStateNormal];
    
    UIColor *blackColor = [UIColor blackColor];
    NSDictionary *colorAttr = [NSDictionary dictionaryWithObject:blackColor forKey:NSForegroundColorAttributeName];
    [_seg setTitleTextAttributes:colorAttr forState:UIControlStateNormal];
    // 添加事件
    [_seg addTarget:self action:@selector(segValueChange:) forControlEvents:UIControlEventValueChanged];
    
    [self.view addSubview:_seg];
    
    // 在UISegmentedControl的下方画一条横线
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 49.5, 320, 0.5)];
    lineView.backgroundColor = [UIColor colorWithRed:128/255.0 green:128/255.0 blue:128/255.0 alpha:0.8];
    lineView.tag = 1002;
    [self.view addSubview:lineView];

}

- (void)loadExtentView
{
    _extentView = [[UIView alloc] init];
    _extentView.frame = CGRectMake(0, 50, 320, 85);
    _extentView.backgroundColor = [UIColor whiteColor];
    [_selectView addSubview:_extentView];
    
    // "正常"按钮
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame = CGRectMake(10, 10, 50, 50);
    btn1.tag = 1;
    btn1.selected = YES;
    [btn1 setBackgroundImage:[UIImage imageNamed:@"task_normal"] forState:UIControlStateNormal];
    [btn1 setBackgroundImage:[UIImage imageNamed:@"task_normal_select"] forState:UIControlStateSelected];
    [btn1 addTarget:self action:@selector(Click:) forControlEvents:UIControlEventTouchUpInside];
    [_extentView addSubview:btn1];
    
    // "正常"文字标签
    UILabel *label1 = [[UILabel alloc] init];
    label1.frame = CGRectMake(10, 63, 50, 15);
    label1.text = @"正常";
    label1.textColor = [UIColor blackColor];
    label1.textAlignment = NSTextAlignmentCenter;
    label1.font = [UIFont systemFontOfSize:13.5f];
    [_extentView addSubview:label1];
    
    // "加急"按钮
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn2.frame = CGRectMake(10+60, 10, 50, 50);
    btn2.tag = 2;
    btn2.selected = NO;
    [btn2 setBackgroundImage:[UIImage imageNamed:@"task_emergency"] forState:UIControlStateNormal];
    [btn2 setBackgroundImage:[UIImage imageNamed:@"task_emergency_select"] forState:UIControlStateSelected];
    [btn2 addTarget:self action:@selector(Click:) forControlEvents:UIControlEventTouchUpInside];
    [_extentView addSubview:btn2];
    
    // "加急"文字标签
    UILabel *label2 = [[UILabel alloc] init];
    label2.frame = CGRectMake(10+60, 63, 50, 15);
    label2.text = @"加急";
    label2.textColor = [UIColor blackColor];
    label2.textAlignment = NSTextAlignmentCenter;
    label2.font = [UIFont systemFontOfSize:13.5f];
    [_extentView addSubview:label2];
    
    // "静音"按钮
    UIButton *btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn3.frame = CGRectMake(10+60+60, 10, 50, 50);
    btn3.tag = 3;
    btn3.selected = NO;
    [btn3 setBackgroundImage:[UIImage imageNamed:@"task_silence"] forState:UIControlStateNormal];
    [btn3 setBackgroundImage:[UIImage imageNamed:@"task_silence_select"] forState:UIControlStateSelected];
    [btn3 addTarget:self action:@selector(Click:) forControlEvents:UIControlEventTouchUpInside];
    [_extentView addSubview:btn3];
    
    // "静音"文字标签
    UILabel *label3 = [[UILabel alloc] init];
    label3.frame = CGRectMake(10+60+60, 63, 50, 15);
    label3.text = @"静音";
    label3.textColor = [UIColor blackColor];
    label3.textAlignment = NSTextAlignmentCenter;
    label3.font = [UIFont systemFontOfSize:13.5f];
    [_extentView addSubview:label3];
    
    // 在ExtentView的下方画一条横线
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 84.5, 320, 0.5)];
    lineView.backgroundColor = [UIColor colorWithRed:128/255.0 green:128/255.0 blue:128/255.0 alpha:0.8];
    [_extentView addSubview:lineView];
    
}

- (void)loadSendToView
{
    _sendToView = [[UIView alloc] init];
    _sendToView.frame = CGRectMake(0, 135, 320, 40);
    _sendToView.backgroundColor = [UIColor whiteColor];
    [_selectView addSubview:_sendToView];
    
    // "发送给"标签
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(5, 12, 100, 15);
    NSString *str = @"发送给: ";
    label.text = [str stringByAppendingString:_model.firstname];
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [UIFont systemFontOfSize:14.0f];
    [_sendToView addSubview:label];
    
    // 在SendToView的下方画一条横线
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 39.5, 320, 0.5)];
    lineView.backgroundColor = [UIColor colorWithRed:128/255.0 green:128/255.0 blue:128/255.0 alpha:0.8];
    [_sendToView addSubview:lineView];
}

- (void)loadIsImmediatelyDeleteView
{
    _isImmediatelyDeleteView = [[UIView alloc] init];
    _isImmediatelyDeleteView.frame = CGRectMake(0, 175, 320, 45);
    _isImmediatelyDeleteView.backgroundColor = [UIColor whiteColor];
    [_selectView addSubview:_isImmediatelyDeleteView];
    
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(5, 15, 200, 15);
    label.text = @"对方阅读后立即自动删除";
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [UIFont systemFontOfSize:14.0f];
    [_isImmediatelyDeleteView addSubview:label];
    
    UISwitch *mySwitch = [[UISwitch alloc] init];
    mySwitch.frame = CGRectMake(260, 7, 0, 0);
    [mySwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    [_isImmediatelyDeleteView addSubview:mySwitch];
    
    // 在isImmediatelyDeleteView的下方画一条横线
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 44.5, 320, 0.5)];
    lineView.backgroundColor = [UIColor colorWithRed:128/255.0 green:128/255.0 blue:128/255.0 alpha:0.8];
    [_isImmediatelyDeleteView addSubview:lineView];
    
}

- (void)loadContentView
{
    _contentView = [[UITableView alloc] init];
    _contentView.frame = CGRectMake(0, 220, 320, 152);
    _contentView.backgroundColor = [UIColor whiteColor];
    _contentView.delegate = self;
    _contentView.dataSource = self;
    // 解决IOS7下tableview分割线左边短了一点
    if ([_contentView respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [_contentView setSeparatorInset:UIEdgeInsetsZero];
        
    }
    if ([UIScreen mainScreen].bounds.size.height>480) {
        _contentView.frame = CGRectMake(0, 220, 320, 234);
    }
    [_selectView addSubview:_contentView];
}

- (void)loadInputView
{
    _inputView = [[UIView alloc] init];
    _inputView.frame = CGRectMake(0, 372, 320, 60);
    _inputView.backgroundColor = [UIColor colorWithRed:128/255.0 green:128/255.0 blue:128/255.0 alpha:0.3];
    [_selectView addSubview:_inputView];
    if ([UIScreen mainScreen].bounds.size.height>480) {
        _inputView.frame = CGRectMake(0, 454, 320, 50);
    }

    //
    BlockButton *clockBtn = [[BlockButton alloc] init];
    clockBtn.frame = CGRectMake(5, 5, 35, 35);
    [clockBtn setBackgroundImage:[UIImage imageNamed:@"task_remind"] forState:UIControlStateNormal];
    [_inputView addSubview:clockBtn];
    
    clockBtn.block = ^(BlockButton *btn){
    
        NSLog(@"点击闹钟的按钮");
        if (((UIDatePicker *)[self.view viewWithTag:1004]).hidden) {
            ((UIDatePicker *)[self.view viewWithTag:1004]).hidden = NO;
        }else{
            ((UIDatePicker *)[self.view viewWithTag:1004]).hidden = YES;
        }
        
    };
    
    //
    _textField = [[UITextField alloc] init];
    _textField.frame = CGRectMake(45, 5, 230, 35);
    _textField.backgroundColor = [UIColor grayColor];
    _textField.layer.cornerRadius = 5;
    _textField.delegate = self;
    _textField.placeholder = @"输入新事项";
    [_inputView addSubview:_textField];
    
    //
    BlockButton *sendBtn = [[BlockButton alloc] init];
    sendBtn.frame = CGRectMake(280, 5, 35, 35);
    [sendBtn setBackgroundImage:[UIImage imageNamed:@"taskchat_send"] forState:UIControlStateNormal];
    [_inputView addSubview:sendBtn];
    
    sendBtn.block = ^(BlockButton *btn){
        
        NSDictionary *parameters = @{@"userId":GET_USER_ID,@"sid":GET_S_ID,@"recvId":_model.userId,@"recvId":_model.userId,@"recvType":@"6",@"context":_textField.text,@"emergency":_emergency,@"deleteAfterRead":_deleteAfterRead,@"remindTime":_remindTime};
        //NSLog(@"时间为:%@",_remindTime);
        
        [AFRequestService responseData:@"tasknew.php" andparameters:parameters andResponseData:^(id responseData){
            NSDictionary *dict =(NSDictionary *)responseData;
            NSString *list = [dict objectForKey:@"code"];
            if ([list intValue] == 0) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"发送成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                // 显示
                [alert show];
            }else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"发送失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                // 显示
                [alert show];
            }
            
        }];

        
    };
    
}

- (void)loadAddInputView
{
    UITextView *_textView = [[UITextView alloc] init];
    _textView.frame = CGRectMake(10, 10, 300, 110);
    _textView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.8];
    _textView.font = [UIFont systemFontOfSize:14.0f];
    
    // 画边框
    _textView.layer.borderColor = [UIColor grayColor].CGColor;
    _textView.layer.borderWidth = 1.0;
    _textView.layer.cornerRadius = 5.0;
    [_addView addSubview:_textView];
    
    // 自定义键盘上方的View
    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 38)];
    customView.backgroundColor = [UIColor lightGrayColor];
    _textView.inputAccessoryView = customView;
    
    // 自定义键盘上方的View的收键盘的按钮
    BlockButton *closeKeyboardBtn = [[BlockButton alloc] init];
    closeKeyboardBtn.frame = CGRectMake(320-35, 3, 30, 30);
    [closeKeyboardBtn setBackgroundImage:[UIImage imageNamed:@"ic_pulltorefresh_arrow"] forState:UIControlStateNormal];
    closeKeyboardBtn.block = ^(BlockButton *btn){
        // 动画
        [UIView beginAnimations:nil context:nil];
        // 设置动画的执行时间
        [UIView setAnimationDuration:0.35];
        
        [_textView resignFirstResponder];
        _selectView.frame = CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height-64);
        _addView.frame = CGRectMake(0, 50, 320, 160);
        _seg.frame = CGRectMake(10, 5, 300, 40);
        ((UIView *)[self.view viewWithTag:1002]).frame = CGRectMake(0, 49.5, 320, 0.5);
        // 尾部
        [UIView commitAnimations];
    };
    [customView addSubview:closeKeyboardBtn];
    
    // 按钮
    BlockButton *btn = [[BlockButton alloc] init];
    btn.frame = CGRectMake(10, 130, 300, 30);
    btn.backgroundColor = [UIColor greenColor];
    btn.layer.cornerRadius = 5;
    btn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [btn setTitle:@"添加新事项" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_addView addSubview:btn];
    btn.block = ^(BlockButton *btn){
    

        NSDictionary *parameters = @{@"userId":GET_USER_ID,@"sid":GET_S_ID,@"typeName":_textView.text};
        [AFRequestService responseData:@"tasktypeadd.php" andparameters:parameters andResponseData:^(id responseData){
            NSDictionary *dict =(NSDictionary *)responseData;
            NSString *list = [dict objectForKey:@"code"];
            if ([list intValue] == 0) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"添加事项成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                // 显示
                [alert show];
                _textView.text = @"";
            }else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"添加事项失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                // 显示
                [alert show];
            }

        }];
    
    };

}

- (void)requestData
{
    [_aiv startAnimating];
    _emergency = @"0";
    _deleteAfterRead = @"0";
    
    //获得系统时间
    NSDate *senddate = [NSDate date];
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYY-MM-dd-HH-mm-ss"];
    _remindTime = [dateformatter stringFromDate:senddate];
    
    _dataArray = [[NSMutableArray alloc] init];
    NSDictionary *parameters = @{@"userId":GET_USER_ID,@"sid":GET_S_ID};
    
    [AFRequestService responseData:@"tasktypelist.php" andparameters:parameters andResponseData:^(id responseData){
        NSDictionary *dict =(NSDictionary *)responseData;
        NSArray *list = [dict objectForKey:@"tasktypelist"];
        for (NSDictionary *matterList in list) {
            NSLog(@"测试:%@",matterList);
            TypeModel *model = [[TypeModel alloc] init];
            model.typeId = [matterList objectForKey:@"typeId"];
            model.typeName = [matterList objectForKey:@"typeName"];
            model.userId = [matterList objectForKey:@"userId"];
            [_dataArray addObject:model];

        }
        [_contentView reloadData];
        [_aiv stopAnimating];
    }];

}

- (void)requestdeleteData
{
    [_aiv startAnimating];
    _dataArray = [[NSMutableArray alloc] init];
    NSDictionary *parameters = @{@"userId":GET_USER_ID,@"sid":GET_S_ID};
    
    [AFRequestService responseData:@"tasktypelist.php" andparameters:parameters andResponseData:^(id responseData){
        NSDictionary *dict =(NSDictionary *)responseData;
        NSArray *list = [dict objectForKey:@"tasktypelist"];
        for (NSDictionary *matterList in list) {
            NSLog(@"测试:%@",matterList);
            TypeModel *model = [[TypeModel alloc] init];
            model.typeId = [matterList objectForKey:@"typeId"];
            model.typeName = [matterList objectForKey:@"typeName"];
            model.userId = [matterList objectForKey:@"userId"];
            [_dataArray addObject:model];
            
        }
        [_deleteTabelView reloadData];
        [_aiv stopAnimating];
    }];
    
}

- (void)loadShadeView
{
    // 网络加载提示(小圈圈)
    _aiv = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _aiv.center = self.view.center;
    [self.view addSubview:_aiv];
}

- (void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    [tableView setTableHeaderView:view];
}

- (void)loadDeletaTableView
{
     _deleteTabelView = [[UITableView alloc] init];
     _deleteTabelView.delegate = self;
     _deleteTabelView.dataSource = self;
     _deleteTabelView.frame = CGRectMake(0, 0, 320,480-64-55-40-5);
    // 解决IOS7下tableview分割线左边短了一点
    if ([_deleteTabelView respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [_deleteTabelView setSeparatorInset:UIEdgeInsetsZero];
        
    }
    [_deleteView addSubview:_deleteTabelView];
    
    self.selectedPath = [NSIndexPath indexPathForRow:-1 inSection:0];
    
    // "删除事项"按钮
    BlockButton *btn = [[BlockButton alloc] init];
    btn.frame = CGRectMake(10, 480-64-55-35, 300, 30);
    btn.backgroundColor = [UIColor greenColor];
    btn.layer.cornerRadius = 5;
    [btn setTitle:@"删除事项" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.block = ^(BlockButton *btn){
    
        NSLog(@"点击删除事项");
        if ([self.deleteArray count]) {
            NSString *str3 = ((TypeModel *)[_deleteArray firstObject]).typeId;
            for (int i = 0; i<_deleteArray.count-1; i++) {
                
                TypeModel *typeModel = (TypeModel *)[_deleteArray objectAtIndex:i];
                
                NSString *str = typeModel.typeId;
                if (_deleteArray.count>1) {
                    NSString *str2 = [str stringByAppendingString:@","];
                    str3 = [str2 stringByAppendingString:((TypeModel *)[_deleteArray objectAtIndex:i+1]).typeId];
                }
            }
            //NSLog(@"看看数据吧%@",str3);
            
                NSDictionary *parameters = @{@"userId":GET_USER_ID,@"sid":GET_S_ID,@"typeIds":str3};
                
                [AFRequestService responseData:@"tasktypedel.php" andparameters:parameters andResponseData:^(id responseData){
                    NSDictionary *dict =(NSDictionary *)responseData;
                    NSString *list = [dict objectForKey:@"code"];
                    if ([list intValue] == 0) {
                        [self requestdeleteData];
                    }else{
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"删除事项失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                        // 显示
                        [alert show];
                    }

                }];

                
            
        }
        
    };
    [_deleteView addSubview:btn];
    
    if ([UIScreen mainScreen].bounds.size.height>480) {
        _deleteTabelView.frame = CGRectMake(0, 0, 320,480-64-55-40-5+(568-480));
        btn.frame = CGRectMake(10, 480-64-55-35+(568-480), 300, 30);
    }
    
}

- (void)loadDatePicker
{
    // 时间选择控件
    UIDatePicker *oneDatePicker = [[UIDatePicker alloc] init];
    oneDatePicker.frame = CGRectMake(0, 50, 320, 150);
    oneDatePicker.backgroundColor = [UIColor grayColor];
    oneDatePicker.date = [NSDate date]; // 设置初始时间
    // [oneDatePicker setDate:[NSDate dateWithTimeIntervalSinceNow:48 * 20 * 18] animated:YES]; // 设置时间，有动画效果
    oneDatePicker.timeZone = [NSTimeZone timeZoneWithName:@"GTM+8"]; // 设置时区，中国在东八区
    oneDatePicker.minimumDate = [NSDate dateWithTimeIntervalSinceNow:72 * 60 * 60 * -1]; // 设置最小时间
    oneDatePicker.maximumDate = [NSDate dateWithTimeIntervalSinceNow:72 * 60 * 60]; // 设置最大时间
    oneDatePicker.tag = 1004;
    
    oneDatePicker.datePickerMode = UIDatePickerModeDateAndTime; // 设置样式
    // 以下为全部样式
    // typedef NS_ENUM(NSInteger, UIDatePickerMode) {
    //    UIDatePickerModeTime,           // 只显示时间
    //    UIDatePickerModeDate,           // 只显示日期
    //    UIDatePickerModeDateAndTime,    // 显示日期和时间
    //    UIDatePickerModeCountDownTimer  // 只显示小时和分钟 倒计时定时器
    // };
    
    
    [oneDatePicker addTarget:self action:@selector(oneDatePickerValueChanged:) forControlEvents:UIControlEventValueChanged]; // 添加监听器
    
    [self.view addSubview:oneDatePicker]; // 添加到View上
    oneDatePicker.hidden = YES;
}

// 返回点击事件
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

// "正常" "加急" "静音"的按钮事件
- (void)Click:(UIButton *)btn
{
    if (btn.tag == 1) {
        NSLog(@"点击正常按钮");
        if (!btn.selected) {
            btn.selected = YES;
            ((UIButton *)[_extentView viewWithTag:2]).selected = NO;
            ((UIButton *)[_extentView viewWithTag:3]).selected = NO;
            _emergency = @"0";
        }
    }else if (btn.tag == 2){
        NSLog(@"点击加急按钮");
        if (!btn.selected) {
            btn.selected = YES;
            ((UIButton *)[_extentView viewWithTag:1]).selected = NO;
            ((UIButton *)[_extentView viewWithTag:3]).selected = NO;
            _emergency = @"1";
        }
    }else{
        NSLog(@"点击静音按钮");
        if (!btn.selected) {
            btn.selected = YES;
            ((UIButton *)[_extentView viewWithTag:1]).selected = NO;
            ((UIButton *)[_extentView viewWithTag:2]).selected = NO;
            _emergency = @"2";
        }
    }
}

// 分段控制器事件
- (void)segValueChange:(UISegmentedControl *)seg
{
    //根据选中的的分段的下标，拿到分段的标题
    NSString * string = [seg titleForSegmentAtIndex:seg.selectedSegmentIndex];
    //显示一下即可
    NSLog(@"当前选中为:%@",string);
    if (seg.selectedSegmentIndex == 0) {
        _selectView.hidden = NO;
        _addView.hidden = YES;
        _deleteView.hidden = YES;
        [self requestData];
    }else if (seg.selectedSegmentIndex == 1){
        _selectView.hidden = YES;
        _addView.hidden = NO;
        _deleteView.hidden = YES;
    }else{
        _selectView.hidden = YES;
        _addView.hidden = YES;
        _deleteView.hidden = NO;
        _deleteArray = [[NSMutableArray alloc] init];
        [_deleteTabelView setEditing:YES animated:YES];
        [self requestdeleteData];
    }
    
}

// UISwitch的事件
-(void)switchAction:(id)sender
{
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isButtonOn = [switchButton isOn];
    if (isButtonOn) {
        _deleteAfterRead = @"1";
        //NSLog(@"测试一下哈!%@",_deleteAfterRead);
    }else {
        _deleteAfterRead = @"0";
        //NSLog(@"测试一下哈!%@",_deleteAfterRead);
    }
}

- (void)oneDatePickerValueChanged:(UIDatePicker *) sender {
    
    NSDate *select = [sender date]; // 获取被选中的时间
    NSDateFormatter *selectDateFormatter = [[NSDateFormatter alloc] init];
    selectDateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss"; // 设置时间和日期的格式
    _remindTime = [selectDateFormatter stringFromDate:select]; // 把date类型转为设置好格式的string类型

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:_remindTime delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    // 显示
    [alert show];
}

#pragma mark --UIAlertView delegate--
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        ((UIDatePicker *)[self.view viewWithTag:1004]).hidden = YES;
    }
}

#pragma mark --UItextField delegate--

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    // 动画
    [UIView beginAnimations:nil context:nil];
    // 设置动画的执行时间
    [UIView setAnimationDuration:0.35];
    
    [textField resignFirstResponder];

    _seg.frame = CGRectMake(10, 5, 300, 40);
    ((UIView *)[self.view viewWithTag:1002]).frame = CGRectMake(0, 49.5, 320, 0.5);
    _selectView.frame = CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height-64);
    _addView.frame = CGRectMake(0, 50, 320, 160);
    
    // 尾部
    [UIView commitAnimations];

    return YES;
}

// 根据键盘状态，调整_DetailsView的位置
- (void) changeContentViewPoint:(NSNotification *)notification{
    NSDictionary *userInfo = [notification userInfo];
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGFloat keyBoardEndY = value.CGRectValue.origin.y;  // 得到键盘弹出后的键盘视图所在y坐标
    
    NSNumber *duration = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // 添加移动动画，使视图跟随键盘移动
    [UIView animateWithDuration:duration.doubleValue animations:^{
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationCurve:[curve intValue]];
        
        _seg.frame = CGRectMake(10, 5-252, 300, 40);
        ((UIView *)[self.view viewWithTag:1002]).frame = CGRectMake(0, 49.5-252, 320, 0.5);
        _selectView.center = CGPointMake(_selectView.center.x, keyBoardEndY - 64 -_selectView.bounds.size.height/2.0);
        if ([UIScreen mainScreen].bounds.size.height!=568) {
            _addView.center = CGPointMake(_addView.center.x, keyBoardEndY - 64 -_addView.bounds.size.height/2.0);
        }else{
            _addView.center = CGPointMake(_addView.center.x, 80);
        }
    }];
    
}

#pragma mark --tableView delegate--
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!_selectView.hidden) {
        //static NSString *str = @"getCell";
        NSString *str = [NSString stringWithFormat:@"getCell%d%d", [indexPath section], [indexPath row]];//以indexPath来唯一确定cell
        TypeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
        if (cell == nil) {
            cell = [[TypeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
        }
        cell.typeModel = [_dataArray objectAtIndex:indexPath.row];
        return cell;
    }else{
        NSString *str = [NSString stringWithFormat:@"deleteCell%d%d", [indexPath section], [indexPath row]];//以indexPath来唯一确定cell
        DeleteTypeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
        if (cell == nil) {
            cell = [[DeleteTypeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
        }
        cell.typeModel = [_dataArray objectAtIndex:indexPath.row];
        return cell;
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!_selectView.hidden) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        NSLog(@"选中了第 %d个 分段中的第 %d 行",indexPath.section,indexPath.row);
        
        NSDictionary *parameters = @{@"userId":GET_USER_ID,@"sid":GET_S_ID,@"recvId":_model.userId,@"recvId":_model.userId,@"recvType":@"6",@"context":((TypeModel *)_dataArray[indexPath.row]).typeName,@"emergency":_emergency,@"deleteAfterRead":_deleteAfterRead};
        //NSLog(@"userId为%@  sid为%@",model.userId,model.sid);
        
        [AFRequestService responseData:@"tasknew.php" andparameters:parameters andResponseData:^(id responseData){
            NSDictionary *dict =(NSDictionary *)responseData;
            NSString *list = [dict objectForKey:@"code"];
            if ([list intValue] == 0) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"发送成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                // 显示
                [alert show];
            }else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"发送失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                // 显示
                [alert show];
            }
            
        }];

        
    }else{
        NSLog(@"被选中");
        //把这一行的数据拿出来存到 _deleArray数组中
        TypeModel *model = [_dataArray objectAtIndex:indexPath.row];
        [_deleteArray addObject:model];
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //同事满足 增加  删除两种状态
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}

//反选的效果
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"反选的效果");
    //
    TypeModel * model = [_dataArray objectAtIndex:indexPath.row];
    //判断(暂定)
    if([_deleteArray containsObject:model])
    {
        [_deleteArray removeObject:model];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
