//
//  TransmitViewController.m
//  UNITOA
//  转发任务
//  Created by ianMac on 14-7-21.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import "TransmitViewController.h"
#import "BlockButton.h"
#import "MattersModel.h"
#import "Interface.h"


@interface TransmitViewController ()

// 自定义导航栏
- (void)loadNavigationItem;

// "事项"的视图
- (void)loadTitleView;

// "转发"的视图
- (void)loadTransmitView;

// "附件"的视图
- (void)loadFileView;

// "添加内容"的视图
- (void)loadAddContentView;

// "确定转发"按钮
- (void)loadConfirmBtn;

@end

@implementation TransmitViewController

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
- (instancetype)initWithModel:(MattersModel *)model
{
    //_mattersModel = [[MattersModel alloc] init];
    if (self = [super init]) {
        _mattersModel = model;
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
        _SolveReasonView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64-64, [UIScreen mainScreen].bounds.size.width, 230+40) style:UITableViewStylePlain];
    }
    [_SolveReasonView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:_SolveReasonView];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadTitleView];
    [self loadTransmitView];
    [self loadFileView];
    [self loadAddContentView];
    [self loadConfirmBtn];
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
    
    title.text = @"转发任务";

    title.font = [UIFont systemFontOfSize:16.0f];
    [title setTextColor:[UIColor whiteColor]];
    
    UIBarButtonItem *negativeSeperator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSeperator.width = -12;
    
    UIBarButtonItem *leftButton1 = [[UIBarButtonItem alloc] initWithCustomView:left];
    UIBarButtonItem *leftButton2 = [[UIBarButtonItem alloc] initWithCustomView:title];
    
    NSArray *array = [NSArray arrayWithObjects:negativeSeperator, leftButton1, leftButton2,nil];
    self.navigationItem.leftBarButtonItems = array;
    
}

- (void)loadTitleView
{
    _titleView = [[UIView alloc] init];
    _titleView.frame = CGRectMake(0, 0, 320, 40);
    
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(5, 0, 310, 40);
    NSString *str1 = @"事项:  ";
    NSString *str2 = [str1 stringByAppendingString:_mattersModel.name];
    NSString *str3 = [str2 stringByAppendingString:@"   "];
    label.text = [str3 stringByAppendingString:_mattersModel
                  .content];
    label.font = [UIFont systemFontOfSize:14.0f];
    
    [_titleView addSubview:label];
    
    [_SolveReasonView addSubview:_titleView];
}

// "转发"的视图
- (void)loadTransmitView
{
    _transmitView = [[UIView alloc] init];
    _transmitView.frame = CGRectMake(0, 40, 320, 40);
    _transmitView.backgroundColor = [UIColor clearColor];
    [_SolveReasonView addSubview:_transmitView];
    
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(5, 0, 60, 40);
    label.text = @"转发给:  ";
    label.font = [UIFont systemFontOfSize:14.0f];
    
    [_transmitView addSubview:label];
    
    BlockButton *btn = [[BlockButton alloc] init];
    btn.frame = CGRectMake(55, 5, 60, 30);
    [btn setTitle:@"点击选择接收人" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    btn.layer.cornerRadius = 5;
    btn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    btn.block = ^(BlockButton *btn){
    
        NSLog(@"点击了转发按钮");
        
    };
    [_transmitView addSubview:btn];
}

- (void)loadFileView
{
    _fileView = [[UIView alloc] init];
    _fileView.frame = CGRectMake(0, 40+40, 320, 40);
    
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(5, 0, 200, 40);
    label.text = @"附 件: （图片、语音、文件)";
    label.font = [UIFont systemFontOfSize: 14.0f];
    [_fileView addSubview:label];
    
    BlockButton *btn = [[BlockButton alloc] init];
    btn.frame = CGRectMake(200, 5, 30, 30);
    [btn setBackgroundImage:[UIImage imageNamed:@"task_attach"] forState:UIControlStateNormal];
    btn.block = ^(BlockButton *btn){
        
        NSLog(@"上传文件");
        [self setICON];
    };
    
    [_fileView addSubview:btn];
    
    // 在FileView的上方画一条横线
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 0.5)];
    lineView1.backgroundColor = [UIColor colorWithRed:128/255.0 green:128/255.0 blue:128/255.0 alpha:0.8];
    [_fileView addSubview:lineView1];
    
    [_SolveReasonView addSubview:_fileView];
}

- (void)loadAddContentView
{
    _AddContentView = [[UITextView alloc] init];
    _AddContentView.frame = CGRectMake(5, 85+40, 310, 100);
    _AddContentView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.8];
    _AddContentView.font = [UIFont systemFontOfSize:14.0f];
    
    // 画边框
    _AddContentView.layer.borderColor = [UIColor grayColor].CGColor;
    _AddContentView.layer.borderWidth =1.0;
    _AddContentView.layer.cornerRadius =5.0;
    
    [_SolveReasonView addSubview:_AddContentView];
    
    // 自定义键盘上方的View
    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 38)];
    customView.backgroundColor = [UIColor lightGrayColor];
    _AddContentView.inputAccessoryView = customView;
    
    // 自定义键盘上方的View的收键盘的按钮
    BlockButton *closeKeyboardBtn = [[BlockButton alloc] init];
    closeKeyboardBtn.frame = CGRectMake(320-35, 3, 30, 30);
    [closeKeyboardBtn setBackgroundImage:[UIImage imageNamed:@"ic_pulltorefresh_arrow"] forState:UIControlStateNormal];
    closeKeyboardBtn.block = ^(BlockButton *btn){
        // 动画
        [UIView beginAnimations:nil context:nil];
        // 设置动画的执行时间
        [UIView setAnimationDuration:0.35];
        
        [_AddContentView resignFirstResponder];
        //_DetailsView.frame = CGRectMake(0, 64, 320, 250);
        
        _SolveReasonView.center = SolvePoint;
        // 尾部
        [UIView commitAnimations];
    };
    [customView addSubview:closeKeyboardBtn];
}

- (void)loadConfirmBtn
{
    _ConfirmBtn = [[BlockButton alloc] init];
    _ConfirmBtn.frame = CGRectMake(5, 190+40, 310, 30);
    _ConfirmBtn.backgroundColor = [UIColor greenColor];
    _ConfirmBtn.layer.cornerRadius = 5.0;
    _ConfirmBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15.0f];
    
    [_ConfirmBtn setTitle:@"确定转发" forState:UIControlStateNormal];
 
    [_ConfirmBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    __block MattersModel *matter = [[MattersModel alloc] init];
    matter = _mattersModel;
    __block UITextView *blockTextView = [[UITextView alloc] init];
    blockTextView = _AddContentView;
    _ConfirmBtn.block = ^(BlockButton *btn){
        
        NSLog(@"点击转发按钮");
        
        
        NSDictionary *parameters = @{@"userId":GET_USER_ID,@"sid":GET_S_ID};
        
        //NSLog(@"时间为:%@",_remindTime);
        
        [AFRequestService responseData:@"taskreply.php" andparameters:parameters andResponseData:^(id responseData){
            NSDictionary *dict =(NSDictionary *)responseData;
            NSString *list = [dict objectForKey:@"code"];
            if ([list intValue] == 0) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"转发成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                // 显示
                [alert show];
            }else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"转发失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                // 显示
                [alert show];
            }
            
        }];
        
    };
    [_SolveReasonView addSubview:_ConfirmBtn];
}
// 返回点击事件
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)setICON
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:
                                  LOCALIZATION(@"dialog_cancel")  destructiveButtonTitle:LOCALIZATION(@"button_takePhoto") otherButtonTitles:LOCALIZATION(@"button_selectPhoto"), nil];
    [actionSheet showInView:self.view];
}
#pragma mark ======UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    UIImagePickerControllerSourceType soursceType;
    if (buttonIndex == 0) {
        BOOL isCamera = [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
        if (!isCamera) {
            return;
        }
        soursceType = UIImagePickerControllerSourceTypeCamera;
    }
    else if (buttonIndex == 1){
        soursceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    else if (buttonIndex == 2){
        return;
    }
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
    imagePicker.sourceType = soursceType;
    imagePicker.delegate = self;
    [self presentViewController:imagePicker animated:YES completion:^{
        
    }];
}

#pragma mark ====== UIImagePickerController Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *img = [info objectForKey:UIImagePickerControllerOriginalImage];
    NSData *imgData = UIImageJPEGRepresentation(img, 0.5);
    NSDictionary *parameters = @{@"userId": GET_USER_ID,@"sid": GET_S_ID};
    [AFRequestService responseDataWithImage:CHANG_ICON_URL andparameters:parameters andImageData:imgData  andfieldType:@"attach1" andfileName:@"attach1.jpg" andResponseData:^(NSData *responseData) {
        NSDictionary *dict = (NSDictionary *)responseData;
        NSInteger codeNum = [[dict objectForKey:@"code"] intValue];
        if (codeNum == 0) {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:LOCALIZATION(@"dialog_prompt") message:LOCALIZATION(@"setting_changeicon_success") delegate:self cancelButtonTitle:LOCALIZATION(@"dialog_ok") otherButtonTitles:nil];
            [alert show];
            [self.presentedViewController dismissViewControllerAnimated:YES completion:^{
                
            }];
        }
        else if (codeNum == 1){
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:LOCALIZATION(@"dialog_prompt") message:LOCALIZATION(@"setting_changeicon_error") delegate:self cancelButtonTitle:LOCALIZATION(@"dialog_ok") otherButtonTitles:nil];
            [alert show];
            [self.presentedViewController dismissViewControllerAnimated:YES completion:^{
                
            }];
        }
        else {
            return;
            
        }
        
    }];
    
    
}


#pragma mark --UItextField delegate--

// 根据键盘状态，调整_tableView的位置
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
        
        SolvePoint = _SolveReasonView.center;
        
        _SolveReasonView.center = CGPointMake(_SolveReasonView.center.x, keyBoardEndY- 64 - _SolveReasonView.bounds.size.height/2.0);
        
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
