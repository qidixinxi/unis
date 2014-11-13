//
//  ShareImageViewController.m
//  UNITOA
//
//  Created by qidi on 14-7-16.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import "ShareImageViewController.h"
#import "Interface.h"
#import "imgUploadModel.h"
#import "MBButtonMenuViewController.h"
#import "ELCImagePickerController.h"
#import "UIImage+UIImageScale.h"
@interface ShareImageViewController ()<MBButtonMenuViewControllerDelegate,ELCImagePickerControllerDelegate,SendPostsImageScrollViewDelegate,UIImagePickerControllerDelegate>
{
    MBProgressHUD *HUD;
    UIView *head_bg;
    UITextView *moodContent;
    UITableView *_tableView;
    NSMutableArray *frindsArray;
    NSMutableArray *userArray;
    UILabel *placeHolder_shuoming;
    UIImageView *line;
    UIImageView *imgView;
     UIImagePickerController *shareImagePicker;// 分享图片的Picker
}
@property (nonatomic, strong) MBButtonMenuViewController *menu2;// UIActionSheet2
@end

@implementation ShareImageViewController
@synthesize data_array = _data_array;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    if (IOS7_LATER) {
        [[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"guke_title_bg@2x" ofType:@"png"]] forBarMetrics:UIBarMetricsDefault];
        
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    }
    else{
        [[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"guke_title_bg@2x" ofType:@"png"]] forBarMetrics:UIBarMetricsDefault];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
        
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    if (IOS7_LATER) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"navi_bg"] forBarMetrics:UIBarMetricsDefault];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];

    [self navigation];
    [self creatUI];
    // Do any additional setup after loading the view.
}

- (void)navigation
{
    UIView *bgNavi = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 190, 44)];
    bgNavi.backgroundColor = [UIColor clearColor];
    bgNavi.userInteractionEnabled = YES;
    
    UIImage *image = [UIImage imageNamed:@"return_unis_logo"];
    UIImageView *logoView = [[UIImageView alloc]initWithImage:image];
    logoView.backgroundColor = [UIColor clearColor];
    logoView.frame = CGRectMake(0, (44 - image.size.height)/2, image.size.width, image.size.height);
    logoView.contentMode = UIViewContentModeScaleAspectFit;
    logoView.userInteractionEnabled = YES;
    
    
    UILabel *loginLabel = [[UILabel alloc]initWithFrame:CGRectMake(image.size.width + 5, 7, 160, 30)];
    loginLabel.text = LOCALIZATION(@"userarticle_newfile");
    loginLabel.textColor = [UIColor whiteColor];
    loginLabel.backgroundColor = [UIColor clearColor];
    loginLabel.font = [UIFont systemFontOfSize:16];
    [bgNavi addSubview:logoView];
    [bgNavi addSubview:loginLabel];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [logoView addGestureRecognizer:tap];
    tap = nil;
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:bgNavi];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIButton * rightItem = [UIButton buttonWithType:UIButtonTypeCustom];
    rightItem.frame = CGRectMake(281, 30, 59, 30);
    rightItem.tag =202;
    rightItem.titleLabel.textAlignment = NSTextAlignmentCenter;
    NSString *subMit = LOCALIZATION(@"button_send");
    rightItem.titleLabel.font = [UIFont systemFontOfSize:12.5f];
    [rightItem setTitle:subMit forState:UIControlStateNormal];
    [rightItem setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [rightItem setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"submit_bg_ico@2x" ofType:@"png"]] forState:UIControlStateNormal];
    
    [rightItem addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem* item2 = [[UIBarButtonItem alloc]initWithCustomView:rightItem];
    self.navigationItem.rightBarButtonItem = item2;
}
- (void)creatUI
{
    head_bg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, viewSize.width, 40)];
    [head_bg setBackgroundColor:[UIColor colorWithPatternImage:[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"home_head@2x" ofType:@"png"]]]];
    
    
    UIButton *right_searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [right_searchBtn setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"search_icon@2x" ofType:@"png"]]forState:UIControlStateNormal];
    
    right_searchBtn.frame = CGRectMake(0, 0, 25, 25);
    [right_searchBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    right_searchBtn.tag = 301;
    
    moodContent = [[UITextView alloc]init];
    moodContent.backgroundColor = [UIColor clearColor];
    moodContent.textColor = [UIColor grayColor];
    moodContent.keyboardType = UIKeyboardTypeDefault;
    moodContent.font = [UIFont systemFontOfSize:16];
    moodContent.returnKeyType = UIReturnKeyDefault;
    [moodContent becomeFirstResponder];
    moodContent.frame = CGRectMake(10,10,SCREEN_WIDTH-20,100);
    moodContent.autocapitalizationType = UITextAutocapitalizationTypeNone;
    moodContent.delegate = self;
    // 画边框
    moodContent.layer.borderColor = GETColor(192, 190, 190).CGColor;
    moodContent.layer.borderWidth =1.0;
    moodContent.layer.cornerRadius =5.0;
    
    placeHolder_shuoming = [[UILabel alloc] initWithFrame:CGRectMake(5,5,200,20)];
    placeHolder_shuoming.text = LOCALIZATION(@"userarticle_newtext_hint");
    placeHolder_shuoming.font = [UIFont systemFontOfSize:16];
    placeHolder_shuoming.textAlignment = NSTextAlignmentLeft;
    placeHolder_shuoming.textColor = [UIColor grayColor];
    placeHolder_shuoming.backgroundColor = [UIColor clearColor];
    [moodContent addSubview:placeHolder_shuoming];


    [head_bg addSubview:moodContent];
//    [head_bg addSubview:imgView];
    [self.view addSubview:head_bg];
    
    
    
    imageScrollView = [[SendPostsImageScrollView alloc] initWithFrame:CGRectMake(5,moodContent.frame.size.height + moodContent.frame.origin.y + 10,SCREEN_WIDTH - 10,100)];
    imageScrollView.layer.borderColor = GETColor(192, 190, 190).CGColor;
    imageScrollView.layer.borderWidth = 1.0;
    imageScrollView.sendImageDelegate = self;
    imageScrollView.showsHorizontalScrollIndicator = NO;
    imageScrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:imageScrollView];
    
    __weak typeof(self)bself = self;
    [imageScrollView loadAllViewsWith:_data_array WithBlock:^(int index, int preViewPage) {
        [bself.data_array removeObjectAtIndex:index];
    }];
    
}
- (void)addMoreImage{
    [moodContent resignFirstResponder];
    [self setShareImage];
   
}
- (void)tapAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)btnClick:(UIButton *)sender{
    [moodContent resignFirstResponder];
    [self subMit];
}
// 点击收起键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [moodContent resignFirstResponder];
    [moodContent resignFirstResponder];
}
- (void)subMit
{
    if ([moodContent.text isEqualToString:@""] || moodContent.text == nil || [moodContent.text isKindOfClass:[NSNull class]]) {
        NSString *alertcontext = LOCALIZATION(@"userarticle_newtext_empty");
        NSString *alertText = LOCALIZATION(@"dialog_prompt");
        NSString *alertOk = LOCALIZATION(@"dialog_ok");
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:alertText message:alertcontext delegate:self cancelButtonTitle:alertOk otherButtonTitles:nil];
        alert.tag = 403;
        [alert show];
    }else{
        NSMutableArray * array = [NSMutableArray array];
        
        for (UIImage * image in _data_array)
        {
            NSData * imgData = UIImageJPEGRepresentation(image, 0.3);
            
            imgUploadModel * model = [[imgUploadModel alloc] init];
            model.imageName = [UUID createUUID];
            model.imageData = imgData;
            [array addObject:model];
        }
        if([array count] == 0){
            NSString *alertcontext = @"请选择图片";
            NSString *alertText = LOCALIZATION(@"dialog_prompt");
            NSString *alertOk = LOCALIZATION(@"dialog_ok");
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:alertText message:alertcontext delegate:self cancelButtonTitle:alertOk otherButtonTitles:nil];
            [alert show];
            return;
        }
        [self creatHUD:LOCALIZATION(@"userarticle_newfile_sending")];
        [HUD show:YES];
        NSDictionary *parameters = @{@"userId":GET_USER_ID,@"sid":GET_S_ID,@"context":moodContent.text,@"isShare":ISNOT_SHARE_CODE};
        [AFRequestService responseDataWithImage:USER_ARTICEL_NEW andparameters:parameters andDataArray:array andfieldType:@"photo" andfileName:@"photo.jpg" andResponseData:^(NSData *responseData) {
            NSDictionary * dict = (NSDictionary *)responseData;
            NSUInteger codeNum = [[dict objectForKey:@"code"] integerValue];
            
            if (codeNum == 0) {
                [HUD hide:YES];
                NSString *alertcontext = LOCALIZATION(@"userarticle_newfile_success");
                NSString *alertText = LOCALIZATION(@"dialog_prompt");
                NSString *alertOk = LOCALIZATION(@"dialog_ok");
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:alertText message:alertcontext delegate:self cancelButtonTitle:alertOk otherButtonTitles:nil];
                alert.tag = 401;
                [alert show];
            }
            else if (codeNum == 1)
            {
                NSString *alertcontext = LOCALIZATION(@"userarticle_newfile_error");
                NSString *alertText = LOCALIZATION(@"dialog_prompt");
                NSString *alertOk = LOCALIZATION(@"dialog_ok");
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:alertText message:alertcontext delegate:self cancelButtonTitle:alertOk otherButtonTitles:nil];
                alert.tag = 402;
                [alert show];
            }
         
        }];        
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (alertView.tag == 401) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(refreshData)]) {
            [self.delegate refreshData];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    else{
        return;
    }
}
#pragma mark ========= UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    
    return YES;
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    //碰到换行，键盘消失
    if ([@"\n" isEqualToString:text] == YES)
    {
        [textView resignFirstResponder];
        return NO;
    }
    
    if (textView.text.length > 0)
    {
        placeHolder_shuoming.text = @"";
        placeHolder_shuoming.hidden = YES;
    }else
    {
        placeHolder_shuoming.hidden = NO;
        placeHolder_shuoming.text = LOCALIZATION(@"userarticle_newtext_hint");
    }
    return YES;
}
// 文字输入结束
- (void)textViewDidEndEditing:(UITextView *)textView{
    
}
// 开始输入文字
- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length > 0)
    {
        placeHolder_shuoming.text = @"";
        placeHolder_shuoming.hidden = YES;
    }else
    {
        placeHolder_shuoming.hidden = NO;
        placeHolder_shuoming.text = LOCALIZATION(@"userarticle_newtext_hint");
    }
    
}

// 获取图片
- (void)setShareImage
{
    if (![self menu2]) {
        
        NSArray *titles = @[LOCALIZATION(@"button_takePhoto"),
                            LOCALIZATION(@"button_selectPhoto"),
                            LOCALIZATION(@"button_cancel")];
        _menu2 = [[MBButtonMenuViewController alloc] initWithButtonTitles:titles];
        _menu2.backgroundColor = [UIColor blackColor];
        [_menu2 setDelegate:self];
        [_menu2 setCancelButtonIndex:[[_menu2 buttonTitles]count]-1];
    }
    
    [[self menu2] showInView:[self view]];
}
#pragma mark - MBButtonMenuViewControllerDelegate
- (void)buttonMenuViewController:(MBButtonMenuViewController *)buttonMenu buttonTappedAtIndex:(NSUInteger)index
{
    [buttonMenu hide];
    UIImagePickerControllerSourceType soursceType;
    if (index == 0) {
        BOOL isCamera = [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
        if (!isCamera) {
            return;
        }
        soursceType = UIImagePickerControllerSourceTypeCamera;
    }
    else if (index == 1){
        soursceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    else if (index == 2){
        return;
    }

    if (index == 0) {
        shareImagePicker = [[UIImagePickerController alloc]init];
        shareImagePicker.sourceType = soursceType;
        shareImagePicker.delegate = self;
        //bgImagePicker.allowsEditing = YES;
        [[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"navi_bg1" ofType:@"png"]] forBarMetrics:UIBarMetricsDefault];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
        [self presentViewController:shareImagePicker animated:YES completion:nil];
    }
    else{
        [self chooseMorePhoto];
    }


}

#pragma mark - 多图选择
-(void)chooseMorePhoto
{
    ELCImagePickerController *elcPicker = [[ELCImagePickerController alloc] init];
    
    elcPicker.maximumImagesCount = 100; //Set the maximum number of images to select to 100
    elcPicker.maximumImagesCount = 9 - [self.data_array count];
    elcPicker.imagePickerDelegate = self;
    
    [[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"navi_bg1" ofType:@"png"]] forBarMetrics:UIBarMetricsDefault];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    [self presentViewController:elcPicker animated:YES completion:nil];
}

#pragma mark ELCImagePickerControllerDelegate Methods

- (void)elcImagePickerController:(ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info
{
   // NSMutableArray * img_array = [NSMutableArray array];
    
    for (NSDictionary * dic in info)
    {
        UIImage *img = [dic objectForKey:UIImagePickerControllerOriginalImage];
        UIImage *imgScale = img;
        NSData *imgData = UIImageJPEGRepresentation(img, 0.3);
        if (img.size.width>800) {
            imgScale = [img scaleToSize:CGSizeMake(800, img.size.height*(800.0/img.size.width))];
            imgData = UIImageJPEGRepresentation(imgScale, 0.3);
        }
        
        [self.data_array addObject:imgScale];
    }
    
    
    [self dismissViewControllerAnimated:YES completion:^{
        __weak typeof(self)bself = self;
        [imageScrollView loadAllViewsWith:self.data_array WithBlock:^(int index, int preViewPage) {
            [bself.data_array removeObjectAtIndex:index];
        }];
    }];
}

- (void)elcImagePickerControllerDidCancel:(ELCImagePickerController *)picker
{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *img = [info objectForKey:UIImagePickerControllerOriginalImage];
    UIImage *imgScale = img;
    NSData *imgData = UIImageJPEGRepresentation(img, 0.3);
    if (img.size.width>800) {
        imgScale = [img scaleToSize:CGSizeMake(800, img.size.height*(800.0/img.size.width))];
        imgData = UIImageJPEGRepresentation(imgScale, 0.3);
    }
    if([picker isEqual:shareImagePicker]){
        NSMutableArray * img_array = [NSMutableArray array];
        [img_array addObject:imgScale];
        [self dismissViewControllerAnimated:YES completion:^{
            [self.data_array addObjectsFromArray:img_array];
            __weak typeof(self)bself = self;
            [imageScrollView loadAllViewsWith:self.data_array WithBlock:^(int index, int preViewPage) {
                [bself.data_array removeObjectAtIndex:index];
            }];

        }];
        
    }
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)creatHUD:(NSString *)hud{
    if (!HUD) {
        HUD = [[MBProgressHUD alloc] initWithView:self.view] ;
        [self.view addSubview:HUD];
        HUD.delegate = self;
    }
    HUD.labelText = hud;
}
#pragma mark MBProgressHUDDelegate methods
- (void)hudWasHidden:(MBProgressHUD *)hud {
    // Remove HUD from screen when the HUD was hidded
    if (HUD && HUD.superview) {
        [HUD removeFromSuperview];
        HUD = nil;
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    if(self.isViewLoaded && !self.view.window){
        HUD = nil;
        head_bg = nil;
        moodContent = nil;
        _tableView = nil;
        frindsArray = nil;
        userArray = nil;
        line = nil;
        self.view = nil;
    }
}

-(void)dealloc{
    HUD = nil;
    head_bg = nil;
    moodContent = nil;
    _tableView = nil;
    frindsArray = nil;
    userArray = nil;
    line = nil;
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
