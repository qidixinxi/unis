//
//  DetailsViewController.m
//  Matters
//
//  Created by ianMac on 14-7-5.
//  Copyright (c) 2014年 ianMac. All rights reserved.
//

#import "DetailsViewController.h"
#import "BlockButton.h"
#import "MarkViewController.h"
#import "SolveReasonViewController.h"
#import "SDWebImageManager.h"
#import "Interface.h"
#import "FriendDetailViewController.h"
#import "TransmitViewController.h"



@interface DetailsViewController ()

// 自定义导航栏
- (void)loadNavigationItem;

// "头像"发送给"头像"的视图
- (void)loadPortraitView;

// 文字内容的视图
- (void)loadContentView;

// "打分详情"的视图
- (void)loadGradeView;

// "图片或声音"的视图
- (void)loadImageOrVoice;

// "解决\转发\退回\归档"的视图
- (void)loadFunctionView;

// "输入框"的视图
- (void)loadInputView;

// "打分详情"的扩展视图
- (void)loadGradeExtendView;

// 判断文件的后缀名是否是声音文件
- (BOOL)judgeFileSuffixVoice;

// 取头像
- (void)getUserIcon:(NSString *)userId andTag:(int)tag;

@end

@implementation DetailsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // 监听键盘事件
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeContentViewPoint:) name:UIKeyboardWillShowNotification object:nil];
    }
    return self;
}

// 重写初始化方法传值
- (instancetype)initWithArray:(NSMutableArray *)array andNum:(int)num
{
    model = [[MattersModel alloc] init];
    model = [array objectAtIndex:num];
    if (self = [super init]) {

    }
    return self;
}

- (void)loadView
{
    UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    view.backgroundColor = [UIColor whiteColor];
    self.view = view;
    
    //取消ios7的导航控制器的特性
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;

        if (((NSArray *)model.attachlist).count){
            _DetailsView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64-64, [UIScreen mainScreen].bounds.size.width, 250+52) style:UITableViewStylePlain];
        }else{
            _DetailsView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64-64, [UIScreen mainScreen].bounds.size.width, 250) style:UITableViewStylePlain];

        }
    }
    
    [_DetailsView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    [self.view addSubview:_DetailsView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadPortraitView];
    [self loadContentView];
    [self loadGradeView];
    if (((NSArray *)model.attachlist).count) {
        [self loadImageOrVoice];
    }
    [self loadFunctionView];
    [self loadInputView];
    [self loadNavigationItem];
}

#pragma mark --Private method--
- (void)loadNavigationItem
{
    // 返回小箭头
    UIButton *left = [UIButton buttonWithType:UIButtonTypeCustom];
    [left setFrame:CGRectMake(0, 0, 48, 20)];
    [left setImage:[UIImage imageNamed:@"top_logo_arrow"] forState:UIControlStateNormal];
    [left addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    // 事项Label
    UILabel *title = [[UILabel alloc] init];
    title.frame = CGRectMake(0, 0, 100, 20);
    title.backgroundColor = [UIColor clearColor];
    title.text = @"事项详情";
    title.font = [UIFont systemFontOfSize:16.0f];
    [title setTextColor:[UIColor whiteColor]];
    
    // "打分"按钮
    BlockButton *btn = [[BlockButton alloc] init];
    btn.frame = CGRectMake(0, 0, 40, 20);
    btn.layer.cornerRadius = 5;
    btn.backgroundColor = [UIColor whiteColor];
    [btn setTitle:@"打分" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    btn.block = ^(BlockButton *btn){
    
        NSLog(@"点击打分按钮");
        MarkViewController *mvc = [[MarkViewController alloc] initWithtaskId:model.taskId];
        [self.navigationController pushViewController:mvc animated:YES];
    };
    
    UIBarButtonItem *negativeSeperator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSeperator.width = -12;
    
    UIBarButtonItem *leftButton1 = [[UIBarButtonItem alloc] initWithCustomView:left];
    UIBarButtonItem *leftButton2 = [[UIBarButtonItem alloc] initWithCustomView:title];
    UIBarButtonItem *rightButton1 = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    NSArray *array = [NSArray arrayWithObjects:negativeSeperator, leftButton1, leftButton2,nil];
    self.navigationItem.leftBarButtonItems = array;
    self.navigationItem.rightBarButtonItem = rightButton1;
}

- (void)loadPortraitView
{
    _PortraitView = [[UIView alloc] init];
    _PortraitView.frame = CGRectMake(0, 0, 320, 65);
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame = CGRectMake(5, 5, 40, 40);
    btn1.tag = 1;
    //[btn1 setBackgroundImage:[UIImage imageNamed:@"0"] forState:UIControlStateNormal];

    [self getUserIcon:model.userId andTag:1];
    [btn1 addTarget:self action:@selector(Click:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *label1 = [[UILabel alloc] init];
    label1.frame = CGRectMake(5, 45, 40, 15);
    label1.textAlignment = NSTextAlignmentCenter;
    label1.font = [UIFont systemFontOfSize:13.0f];
    label1.text = model.name;
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame = CGRectMake(55, 20, 20, 20);
    imageView.image = [UIImage imageNamed:@"taskline"];
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn2.frame = CGRectMake(80, 5, 40, 40);
    btn2.tag = 2;
    //[btn2 setBackgroundImage:[UIImage imageNamed:@"1"] forState:UIControlStateNormal];
    [self getUserIcon:model.recvId andTag:2];
    
    [btn2 addTarget:self action:@selector(Click:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *label2 = [[UILabel alloc] init];
    label2.frame = CGRectMake(80, 45, 40, 15);
    label2.textAlignment = NSTextAlignmentCenter;
    label2.font = [UIFont systemFontOfSize:13.0f];
    label2.text = model.getName;
    
    // 在PortraitView的下方画一条横线
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 65, 320, 0.5)];
    lineView1.backgroundColor = [UIColor colorWithRed:128/255.0 green:128/255.0 blue:128/255.0 alpha:0.8];
    
    [_PortraitView addSubview:btn1];
    [_PortraitView addSubview:btn2];
    [_PortraitView addSubview:imageView];
    [_PortraitView addSubview:label1];
    [_PortraitView addSubview:label2];
    [_PortraitView addSubview:lineView1];
    
    [_DetailsView addSubview:_PortraitView];
}

- (void)loadContentView
{
    _ContentView = [[UIView alloc] init];
    _ContentView.frame = CGRectMake(0, 66, 320, 40);
    
    UILabel *contectLabel1 = [[UILabel alloc] init];
    contectLabel1.frame = CGRectMake(5, 9, 250, 20);
    contectLabel1.textAlignment = NSTextAlignmentLeft;
    contectLabel1.font = [UIFont systemFontOfSize:14.0f];
    contectLabel1.text = model.content;
    
    UILabel *contectLabel2 = [[UILabel alloc] init];
    contectLabel2.frame = CGRectMake(320-70, 9, 65, 20);
    contectLabel2.textAlignment = NSTextAlignmentRight;
    contectLabel2.font = [UIFont systemFontOfSize:14.0f];
    contectLabel2.text = model.state;
    if ([model.state isEqualToString:@"0"]) {
        contectLabel2.text = @"未收,待办";
    }
    if ([model.state isEqualToString:@"1"]) {
        contectLabel2.text = @"待办";
    }
    if ([model.state isEqualToString:@"2"]) {
        contectLabel2.text = @"已收,完成";
    }
    if ([model.state isEqualToString:@"3"]) {
        contectLabel2.text = @"已收,退回";
    }
    
    // 在ContentView的下方画一条横线
    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 40, 320, 0.5)];
    lineView2.backgroundColor = [UIColor colorWithRed:128/255.0 green:128/255.0 blue:128/255.0 alpha:0.8];
    
    [_ContentView addSubview:contectLabel1];
    [_ContentView addSubview:contectLabel2];
    [_ContentView addSubview:lineView2];
    
    [_DetailsView addSubview:_ContentView];
}

- (void)loadGradeView
{
    _GradeView = [[UIView alloc] init];
    _GradeView.frame = CGRectMake(0, 107, 320, 30);
    
    UILabel *gradeLabel = [[UILabel alloc] init];
    gradeLabel.frame = CGRectMake(5, 5, 250, 20);
    gradeLabel.textAlignment = NSTextAlignmentLeft;
    gradeLabel.font = [UIFont systemFontOfSize:14.0f];
    
    NSString *str1 = @"打分详情 ";
    NSString *str2 = nil;
    if ([model.rate isEqualToString:@"0"]) {
        str2 = @" ";
    }
    if ([model.rate isEqualToString:@"1"]) {
        str2 = @"好评,";
    }
    if ([model.rate isEqualToString:@"2"]){
        str2 = @"中评,";
    }
    if ([model.rate isEqualToString:@"3"]) {
        str2 = @"差评,";
    }
    
    NSString *str3 = nil;
    if ([model.responseTime intValue]<1) {
        str3 = @"响应速度快(1分钟以内)";
    }
    if ([model.responseTime intValue]>=1&&[model.responseTime intValue]<=5) {
        str3 = @"响应速度中(5分钟以内)";
    }
    if ([model.responseTime intValue]>5) {
        str3 = @"响应速度慢(5分钟以上)";
    }
    gradeLabel.text = [[str1 stringByAppendingString:str2] stringByAppendingString:str3];
    
    UIButton *extendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    extendBtn.frame = CGRectMake(320-30, 5, 20, 20);
    [extendBtn setBackgroundImage:[UIImage imageNamed:@"task_arrow_down"] forState:UIControlStateNormal];
    [extendBtn setBackgroundImage:[UIImage imageNamed:@"task_arrow_up"] forState:UIControlStateSelected];
    [extendBtn addTarget:self action:@selector(extentClick:) forControlEvents:UIControlEventTouchUpInside];
    extendBtn.selected = NO;

    [_GradeView addSubview:gradeLabel];
    [_GradeView addSubview:extendBtn];
    
    [_DetailsView addSubview:_GradeView];
}

- (void)loadImageOrVoice
{
    _ImageOrVoiceView = [[UIView alloc] init];
    _ImageOrVoiceView.frame = CGRectMake(0, _GradeView.frame.origin.y+_GradeView.frame.size.height, 320, 50);
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame = CGRectMake(5, 10, 30, 30);
    if ([self judgeFileSuffixVoice]) {
        imageView.image = [UIImage imageNamed:@"icon_menu_volume"];
    }else{
        imageView.image = [UIImage imageNamed:@"icon_word"];
    }
    [_ImageOrVoiceView addSubview:imageView];
    
    BlockButton *btn = [[BlockButton alloc]init];
    btn.frame = CGRectMake(40, 15, 320-50, 20);
    btn.backgroundColor = [UIColor whiteColor];
    [btn setTitle:[[[(NSArray *)model.attachlist firstObject]objectForKey:@"fileurl"] lastPathComponent] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.titleEdgeInsets = UIEdgeInsetsMake(5, 0, 5, 55);
    //btn.titleLabel.textAlignment = NSTextAlignmentRight;
    btn.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    btn.block = ^(BlockButton *btn)
    {
        NSLog(@"点击文件(图片或者音频)");
    };
    [_ImageOrVoiceView addSubview:btn];
    
    [_DetailsView addSubview:_ImageOrVoiceView];
}

- (void)loadFunctionView
{
    _FunctionView = [[UIView alloc] init];
    //_FunctionView.frame = CGRectMake(0, 140, 320, 70);
    
    if (((NSArray *)model.attachlist).count) {
        _FunctionView.frame = CGRectMake(0, _ImageOrVoiceView.frame.origin.y+_ImageOrVoiceView.frame.size.height+5, 320, 70);
    }else{
        _FunctionView.frame = CGRectMake(0, _GradeView.frame.origin.y+_GradeView.frame.size.height+3, 320, 70);
    }
    
    UIButton *Functionbtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    Functionbtn1.frame = CGRectMake(15, 5, 40, 40);
    Functionbtn1.tag = 3;
    [Functionbtn1 setShowsTouchWhenHighlighted:YES];
    [Functionbtn1 setBackgroundImage:[UIImage imageNamed:@"taskop_resolve"] forState:UIControlStateNormal];
    [Functionbtn1 addTarget:self action:@selector(Click:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *FunctionLabel1 = [[UILabel alloc] init];
    FunctionLabel1.frame = CGRectMake(15, 47, 40, 20);
    FunctionLabel1.textAlignment = NSTextAlignmentCenter;
    FunctionLabel1.font = [UIFont systemFontOfSize:13.0f];
    FunctionLabel1.text = @"解决";
    
    UIButton *Functionbtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    Functionbtn2.frame = CGRectMake(96, 5, 40, 40);
    Functionbtn2.tag = 4;
    [Functionbtn2 setShowsTouchWhenHighlighted:YES];
    [Functionbtn2 setBackgroundImage:[UIImage imageNamed:@"taskop_forward"] forState:UIControlStateNormal];
    [Functionbtn2 addTarget:self action:@selector(Click:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *FunctionLabel2 = [[UILabel alloc] init];
    FunctionLabel2.frame = CGRectMake(96, 47, 40, 20);
    FunctionLabel2.textAlignment = NSTextAlignmentCenter;
    FunctionLabel2.font = [UIFont systemFontOfSize:13.0f];
    FunctionLabel2.text = @"转发";
    
    UIButton *Functionbtn3 = [UIButton buttonWithType:UIButtonTypeCustom];
    Functionbtn3.frame = CGRectMake(179, 5, 40, 40);
    Functionbtn3.tag = 5;
    [Functionbtn3 setShowsTouchWhenHighlighted:YES];
    [Functionbtn3 setBackgroundImage:[UIImage imageNamed:@"taskop_reject"] forState:UIControlStateNormal];
    [Functionbtn3 addTarget:self action:@selector(Click:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *FunctionLabel3 = [[UILabel alloc] init];
    FunctionLabel3.frame = CGRectMake(179, 47, 40, 20);
    FunctionLabel3.textAlignment = NSTextAlignmentCenter;
    FunctionLabel3.font = [UIFont systemFontOfSize:13.0f];
    FunctionLabel3.text = @"退回";
    
    UIButton *Functionbtn4 = [UIButton buttonWithType:UIButtonTypeCustom];
    Functionbtn4.frame = CGRectMake(320-55, 5, 40, 40);
    Functionbtn4.tag = 6;
    [Functionbtn4 setShowsTouchWhenHighlighted:YES];
    [Functionbtn4 setBackgroundImage:[UIImage imageNamed:@"taskop_archive"] forState:UIControlStateNormal];
    [Functionbtn4 addTarget:self action:@selector(Click:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *FunctionLabel4 = [[UILabel alloc] init];
    FunctionLabel4.frame = CGRectMake(320-55, 47, 40, 20);
    FunctionLabel4.textAlignment = NSTextAlignmentCenter;
    FunctionLabel4.font = [UIFont systemFontOfSize:13.0f];
    FunctionLabel4.text = @"归档";
    
    // 在GradeView的下方画一条横线
    UIView *lineView3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 0.5)];
    lineView3.backgroundColor = [UIColor colorWithRed:128/255.0 green:128/255.0 blue:128/255.0 alpha:0.8];
    
    // 如果事项状态是"已收"状态,则将"解决"和"退回"按钮隐藏,将"转发"和"归档"按钮移到中间
    if (!([model.state isEqualToString:@"0"] || [model.state isEqualToString:@"1"])) {
        
        Functionbtn1.hidden = YES;
        Functionbtn3.hidden = YES;
        FunctionLabel1.hidden = YES;
        FunctionLabel3.hidden = YES;
        
        CGRect myFrame1 = Functionbtn2.frame;
        myFrame1.origin.x = 50.0;
        Functionbtn2.frame = myFrame1;
        
        CGRect myFrame2 = Functionbtn4.frame;
        myFrame2.origin.x = 230.0;
        Functionbtn4.frame = myFrame2;
        
        CGRect myFrame3 = FunctionLabel2.frame;
        myFrame3.origin.x = 50.0;
        FunctionLabel2.frame = myFrame3;
        
        CGRect myFrame4 = FunctionLabel4.frame;
        myFrame4.origin.x = 230.0;
        FunctionLabel4.frame = myFrame4;
    }
    
    [_FunctionView addSubview:lineView3];
    [_FunctionView addSubview:Functionbtn1];
    [_FunctionView addSubview:Functionbtn2];
    [_FunctionView addSubview:Functionbtn3];
    [_FunctionView addSubview:Functionbtn4];
    [_FunctionView addSubview:FunctionLabel1];
    [_FunctionView addSubview:FunctionLabel2];
    [_FunctionView addSubview:FunctionLabel3];
    [_FunctionView addSubview:FunctionLabel4];
    
    [_DetailsView addSubview:_FunctionView];
    
}

- (void)loadInputView
{
    _inputView = [[UIView alloc] init];
    _inputView.frame = CGRectMake(0, _FunctionView.frame.origin.y+_FunctionView.frame.size.height, 320, 40);
    
    _inputView.backgroundColor = [UIColor colorWithRed:128/255.0 green:128/255.0 blue:128/255.0 alpha:0.4];
    
    // "相机"按钮
    UIButton *cameraBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cameraBtn.frame = CGRectMake(3, 5, 30, 30);
    cameraBtn.tag = 7;
    [cameraBtn setBackgroundImage:[UIImage imageNamed:@"taskchat_camera"] forState:UIControlStateNormal];
    [cameraBtn addTarget:self action:@selector(Click:) forControlEvents:UIControlEventTouchUpInside];
    [_inputView addSubview:cameraBtn];
    
    // "图片"按钮
    UIButton *photoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    photoBtn.frame = CGRectMake(3+30+5, 5, 30, 30);
    photoBtn.tag = 8;
    [photoBtn setBackgroundImage:[UIImage imageNamed:@"taskchat_photo"] forState:UIControlStateNormal];
    [photoBtn addTarget:self action:@selector(Click:) forControlEvents:UIControlEventTouchUpInside];
    [_inputView addSubview:photoBtn];
    
    // "声音"按钮
    BlockButton *voiceBtn = [[BlockButton alloc] init];
    voiceBtn.frame = CGRectMake(3+30+5+30+5, 5, 30, 30);
    voiceBtn.tag = 9;
    [voiceBtn setBackgroundImage:[UIImage imageNamed:@"taskchat_voice"] forState:UIControlStateNormal];
    [voiceBtn setBackgroundImage:[UIImage imageNamed:@"taskchat_write"] forState:UIControlStateSelected];
    voiceBtn.selected = NO;
    voiceBtn.block = ^(BlockButton *btn){
    
        if (!btn.selected) {
            btn.selected = YES;
            [_inputView viewWithTag:101].hidden = YES;
            [_inputView viewWithTag:102].hidden = NO;
        }else
        {
            btn.selected = NO;
            [_inputView viewWithTag:101].hidden = NO;
            [_inputView viewWithTag:102].hidden = YES;
        }

        
    };
    [_inputView addSubview:voiceBtn];
    
    // "输入框"视图
    _textField = [[UITextField alloc] init];
    _textField.frame = CGRectMake(3+30+5+30+5+30+5, 5, 282-108, 30);
    _textField.delegate = self;
    _textField.tag = 101;
    _textField.borderStyle = UITextBorderStyleRoundedRect;
    _textField.placeholder = @"请输入内容";
    _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _textField.returnKeyType = UIReturnKeyDone;
    [_inputView addSubview:_textField];
    
    // "发送"按钮
    UIButton *sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sendBtn.frame = CGRectMake(320-30-3, 5, 30, 30);
    sendBtn.tag = 10;
    [sendBtn setBackgroundImage:[UIImage imageNamed:@"taskchat_send"] forState:UIControlStateNormal];
    [sendBtn addTarget:self action:@selector(Click:) forControlEvents:UIControlEventTouchUpInside];
    [_inputView addSubview:sendBtn];
    
    // "录音状态"的视图
    BlockButton *_voiceView = [[BlockButton alloc] init];
    _voiceView.frame = CGRectMake(3+30+5+30+5+30+5, 5, 282-108+35, 30);
    _voiceView.layer.cornerRadius = 5;
    _voiceView.tag = 102;
    _voiceView.backgroundColor = [UIColor whiteColor];
    [_voiceView setTitle:@"按住说话" forState:UIControlStateNormal];
    [_voiceView setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_voiceView setTitleColor:[UIColor greenColor] forState:UIControlStateHighlighted];
    _voiceView.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    _voiceView.block = ^(BlockButton *btn){
    
        NSLog(@"按住说话啦!");
    
    };
    [_inputView addSubview:_voiceView];
    _voiceView.hidden = YES;
    
    [_DetailsView addSubview:_inputView];
}

- (void)loadGradeExtendView
{
    _GradeExtendView = [[UIView alloc] init];
    _GradeExtendView.frame = CGRectMake(0, 30, 320, 100);
    [_GradeView addSubview:_GradeExtendView];
    
    // "发出时间" 标签
    UILabel *label1 = [[UILabel alloc] init];
    label1.frame = CGRectMake(5, 0, 310, 20);
    label1.font = [UIFont systemFontOfSize:13.0f];
    NSString *str1 = @"发出时间:";
    label1.text = [str1 stringByAppendingString:model.putTime];
    [_GradeExtendView addSubview:label1];
    
    // "接收时间" 标签
    UILabel *label2 = [[UILabel alloc] init];
    label2.frame = CGRectMake(5, 20, 310, 20);
    label2.font = [UIFont systemFontOfSize:13.0f];
    NSString *str2 = @"接收时间:";
    label2.text = [str2 stringByAppendingString:model.getTime];
    [_GradeExtendView addSubview:label2];
    
    // "响应时间" 标签
    UILabel *label3 = [[UILabel alloc] init];
    label3.frame = CGRectMake(5, 40, 310, 20);
    label3.backgroundColor = [UIColor colorWithRed:128/255.0 green:128/255.0 blue:128/255.0 alpha:0.4];
    label3.font = [UIFont systemFontOfSize:13.0f];
    NSString *str3 = @"响应时间:";
    label3.text = [str3 stringByAppendingString:model.responseTime];
    [_GradeExtendView addSubview:label3];
    
    // "解决时间" 标签
    UILabel *label4 = [[UILabel alloc] init];
    label4.frame = CGRectMake(5, 60, 310, 20);
    label4.font = [UIFont systemFontOfSize:13.0f];
    NSString *str5 = @"解决时间:";
    label4.text = [str5 stringByAppendingString:model.resolutionTime];
    [_GradeExtendView addSubview:label4];
    
    // "执行时间" 标签
    UILabel *label5 = [[UILabel alloc] init];
    label5.frame = CGRectMake(5, 80, 310, 20);
    label5.backgroundColor = [UIColor colorWithRed:128/255.0 green:128/255.0 blue:128/255.0 alpha:0.4];
    label5.font = [UIFont systemFontOfSize:13.0f];
    NSString *str6 = @"执行时间:";
    label5.text = [str6 stringByAppendingString:model.executionTime];
    [_GradeExtendView addSubview:label5];
}

// 判断文件的后缀名是否是声音文件
- (BOOL)judgeFileSuffixVoice
{
    if ([[[[(NSArray *)model.attachlist firstObject] objectForKey:@"fileurl"] pathExtension]isEqualToString:@"amr"] || [[[[(NSArray *)model.attachlist firstObject] objectForKey:@"fileurl"] pathExtension]isEqualToString:@"wma"] || [[[[(NSArray *)model.attachlist firstObject] objectForKey:@"fileurl"] pathExtension]isEqualToString:@"mp3"]){
        return YES;
    }else{
        return NO;
    }
}

- (void)getUserIcon:(NSString *)userId andTag:(int)tag
{
    __block NSString *imageUrl = nil;
    NSDictionary *parameters = @{@"userId":GET_USER_ID,@"sid":GET_S_ID,@"viewId":userId};
    [AFRequestService responseData:USER_INFO_BYID_URL andparameters:parameters andResponseData:^(id responseData){
        NSDictionary *dict =(NSDictionary *)responseData;
        NSUInteger codeNum = [[dict objectForKey:@"code"] integerValue];
        if (codeNum == CODE_SUCCESS) {
            NSDictionary *userDetail = [dict objectForKey:@"user"];
            imageUrl = [IMAGE_BASE_URL stringByAppendingString:[userDetail valueForKey:@"icon"]];
            NSURL *url1 = [NSURL URLWithString:imageUrl];
            SDWebImageManager *manager1 = [SDWebImageManager sharedManager];
            [manager1 downloadWithURL:url1 options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
                
                if (image) {
                    
                    [(UIButton *)[_PortraitView viewWithTag:tag] setBackgroundImage:image forState:UIControlStateNormal];
                    
                }else{
                    [(UIButton *)[_PortraitView viewWithTag:tag] setBackgroundImage:[UIImage imageNamed:@"user_default_small_64"] forState:UIControlStateNormal];
                }
                
            }];

            
            
        }
        
        else if (codeNum == CODE_ERROE){
            NSString *alertcontext = LOCALIZATION(@"get_data_error");
            NSString *alertText = LOCALIZATION(@"dialog_prompt");
            NSString *alertOk = LOCALIZATION(@"dialog_ok");
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:alertText message:alertcontext delegate:self cancelButtonTitle:alertOk otherButtonTitles:nil];
            [alert show];
        }
        else {
            
        }
        
    } ];

}


// 返回点击事件
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

// 按钮的点击事件
- (void)Click:(UIButton *)btn
{
    if (btn.tag == 1) {
        NSLog(@"点击第1个头像");
        FriendDetailViewController *fvc = [[FriendDetailViewController alloc] init];
        FriendIfo *friendModel = [[FriendIfo alloc] init];
        friendModel.dstUserId = model.userId;
        fvc.friendModel = friendModel;
        [self.navigationController pushViewController:fvc animated:YES];
    }else if(btn.tag == 2){
        NSLog(@"点击第2个头像");
        FriendDetailViewController *fvc = [[FriendDetailViewController alloc] init];
        FriendIfo *friendModel = [[FriendIfo alloc] init];
        friendModel.dstUserId = model.recvId;
        fvc.friendModel = friendModel;
        [self.navigationController pushViewController:fvc animated:YES];
    }else if(btn.tag == 3){
        // NSLog(@"点击\"解决\"按钮");
        SolveReasonViewController *svc = [[SolveReasonViewController alloc] initWithModel:model andAction:0];
        [self.navigationController pushViewController:svc animated:YES];
    }else if(btn.tag == 4){
        NSLog(@"点击\"转发\"按钮");
        
        TransmitViewController *tvc = [[TransmitViewController alloc] initWithModel:model];
        [self.navigationController pushViewController:tvc animated:YES];
        
    }else if(btn.tag == 5){
        // NSLog(@"点击\"退回\"按钮");
        SolveReasonViewController *svc = [[SolveReasonViewController alloc] initWithModel:model andAction:1];
        [self.navigationController pushViewController:svc animated:YES];
    }else if(btn.tag == 6){
        NSLog(@"点击\"归档\"按钮");
    }else if(btn.tag == 7){
        NSLog(@"点击\"照相机\"按钮");
    }else if(btn.tag == 8){
        NSLog(@"点击\"图片\"按钮");
    }else if(btn.tag == 9){
        NSLog(@"点击\"声音和文字切换\"按钮");
    }else if(btn.tag == 10){
        NSLog(@"点击\"发送\"按钮");
    }else{
        NSLog(@"点击\"其他\"按钮");
    }
}

// "打分详情"扩展按钮
- (void)extentClick:(UIButton *)btn
{
    if (!btn.selected) {
        btn.selected = YES;
        _GradeView.frame = CGRectMake(0, 107, 320, 130);
        [self loadGradeExtendView];
        _FunctionView.frame = CGRectMake(0, _FunctionView.frame.origin.y+_GradeExtendView.frame.size.height, 320, 70);
        _inputView.frame = CGRectMake(0, _inputView.frame.origin.y+_GradeExtendView.frame.size.height, 320, 40);
        _DetailsView.frame = CGRectMake(0, 64-64, 320, _DetailsView.frame.size.height+_GradeExtendView.frame.size.height);
        
        _ImageOrVoiceView.frame = CGRectMake(0, _ImageOrVoiceView.frame.origin.y +_GradeExtendView.frame.size.height, 320, 50);
        
    }else{
        btn.selected = NO;
        _GradeView.frame = CGRectMake(0, 107, 320, 30);
        [_GradeExtendView removeFromSuperview];
        
        _FunctionView.frame = CGRectMake(0, _FunctionView.frame.origin.y-_GradeExtendView.frame.size.height, 320, 70);
        _inputView.frame = CGRectMake(0, _inputView.frame.origin.y-_GradeExtendView.frame.size.height, 320, 40);
        _DetailsView.frame = CGRectMake(0, 64-64, 320, _DetailsView.frame.size.height-_GradeExtendView.frame.size.height);
        
        _ImageOrVoiceView.frame = CGRectMake(0, _ImageOrVoiceView.frame.origin.y -_GradeExtendView.frame.size.height, 320, 50);
    }
}

#pragma mark --UItextField delegate--

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    // 动画
    [UIView beginAnimations:nil context:nil];
    // 设置动画的执行时间
    [UIView setAnimationDuration:0.35];
    
    [_textField resignFirstResponder];
    //_DetailsView.frame = CGRectMake(0, 64, 320, 250);
    _DetailsView.center = DetailsPoint;
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
        
        if (value.CGRectValue.size.height!=252) {
            DetailsPoint = _DetailsView.center;
        }

        _DetailsView.center = CGPointMake(_DetailsView.center.x, keyBoardEndY -64 - _DetailsView.bounds.size.height/2.0);
        
    }];
    
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
