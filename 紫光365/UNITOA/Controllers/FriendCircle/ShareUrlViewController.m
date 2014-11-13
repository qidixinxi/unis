//
//  ShareUrlViewController.m
//  UNITOA
//
//  Created by qidi on 14-7-16.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import "ShareUrlViewController.h"
#import "Interface.h"
@interface ShareUrlViewController ()
{
    MBProgressHUD *HUD;
    UIView *head_bg;
    UITextView *moodContent;
    UITableView *_tableView;
    NSMutableArray *frindsArray;
    NSMutableArray *userArray;
    NSInteger index;
    UILabel *placeHolder_shuoming;
    UIImageView *line;
}
@end

@implementation ShareUrlViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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
    [self navigetion];
    [self creatUI];
}

- (void)navigetion
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
    loginLabel.text = LOCALIZATION(@"userarticle_newshare");
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
    [head_bg setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"home_head"]]];
    
    UIButton *right_searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [right_searchBtn setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"search_icon@2x" ofType:@"png"]] forState:UIControlStateNormal];
    
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
    [self.view addSubview:head_bg];
    
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
}
- (void)subMit
{
    // 检测格式是否正确
    NSError *error;
    NSString *regulaStr = @"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regulaStr
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    NSArray *arrayOfAllMatches = [regex matchesInString:moodContent.text options:0 range:NSMakeRange(0, [moodContent.text length])];
    NSString* substringForMatch = nil;
    for (NSTextCheckingResult *match in arrayOfAllMatches)
    {
        substringForMatch = [moodContent.text substringWithRange:match.range];
    }

    if (![substringForMatch isEqualToString:moodContent.text]) {
        NSString *alertcontext = LOCALIZATION(@"userarticle_newshare_error_ format");
        NSString *alertText = LOCALIZATION(@"dialog_prompt");
        NSString *alertOk = LOCALIZATION(@"dialog_ok");
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:alertText message:alertcontext delegate:self cancelButtonTitle:alertOk otherButtonTitles:nil];
        alert.tag = 404;
        [alert show];
    }else if ([moodContent.text isEqualToString:@""] || moodContent.text == nil || [moodContent.text isEqualToString:LOCALIZATION(@"setting_feedback_hint")]) {
        NSString *alertcontext = LOCALIZATION(@"userarticle_newshareurl_empty");
        NSString *alertText = LOCALIZATION(@"dialog_prompt");
        NSString *alertOk = LOCALIZATION(@"dialog_ok");
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:alertText message:alertcontext delegate:self cancelButtonTitle:alertOk otherButtonTitles:nil];
        alert.tag = 403;
        [alert show];
    }else{
        [self creatHUD:LOCALIZATION(@"userarticle_newshare_sending")];
        [HUD show:YES];
        //UserIfo *model = (UserIfo *)[[SingleInstance shareManager].objecAarray firstObject];
        NSDictionary *parameters = @{@"userId":GET_USER_ID,@"sid":GET_S_ID,@"shareUrl":moodContent.text,@"context":moodContent.text,@"isShare":IS_SHARE_CODE};
        [AFRequestService responseData:USER_ARTICEL_NEW andparameters:parameters andResponseData:^(id responseData) {
            NSDictionary * dict = (NSDictionary *)responseData;
            NSUInteger codeNum = [[dict objectForKey:@"code"] integerValue];
            if (codeNum == 0) {
                [HUD hide:YES];
                NSString *alertcontext = LOCALIZATION(@"userarticle_newshare_success");
                NSString *alertText = LOCALIZATION(@"dialog_prompt");
                NSString *alertOk = LOCALIZATION(@"dialog_ok");
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:alertText message:alertcontext delegate:self cancelButtonTitle:alertOk otherButtonTitles:nil];
                alert.tag = 401;
                [alert show];
            }
            else if (codeNum == 1){
                NSString *alertcontext = LOCALIZATION(@"userarticle_newshare_error");
                NSString *alertText = LOCALIZATION(@"dialog_prompt");
                NSString *alertOk = LOCALIZATION(@"dialog_ok");
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:alertText message:alertcontext delegate:self cancelButtonTitle:alertOk otherButtonTitles:nil];
                alert.tag = 402;
                [alert show];
            }
            
        }];
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
    //    if ([@"\n" isEqualToString:text] == YES)
    //    {
    //        [textView resignFirstResponder];
    //        return NO;
    //    }
    
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
- (CGFloat)suggestContentHeight
{
    CGSize sizeText = CGSizeMake(0, 0);
    UIFont *font = [UIFont fontWithName:@"Arial" size:20];
    if (IOS7_LATER) {
        
        NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName,nil];
        sizeText = [moodContent.text boundingRectWithSize:CGSizeMake(320, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    }
    else{
        CGSize size = CGSizeMake(320,1000);
        sizeText = [moodContent.text sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
    }
    return sizeText.height;
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
