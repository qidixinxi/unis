//
//  SuggestionViewController.m
//  UNITOA
//
//  Created by qidi on 14-6-27.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import "SuggestionViewController.h"
#import "Interface.h"
@interface SuggestionViewController ()
{
    UIView *head_bg;
    UITextView *suggestContent;
    UITableView *_tableView;
    NSMutableArray *frindsArray;
    NSMutableArray *userArray;
    NSInteger index;
    UIImageView *line;
}
@end

@implementation SuggestionViewController

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
    [self navigetion];
    [self creatUI];
    // Do any additional setup after loading the view.
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
    loginLabel.text = LOCALIZATION(@"setting_feedback");
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
    NSString *subMit = LOCALIZATION(@"button_submit");
    [rightItem setTitle:subMit forState:UIControlStateNormal];
    rightItem.titleLabel.font = [UIFont systemFontOfSize:12.5f];
    [rightItem setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [rightItem setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"submit_bg_ico@2x" ofType:@"png"]] forState:UIControlStateNormal];
    
    [rightItem addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem* item2 = [[UIBarButtonItem alloc]initWithCustomView:rightItem];
    self.navigationItem.rightBarButtonItem = item2;
}
- (void)creatUI
{
    if (currentDev || currentDev1) {
        head_bg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, viewSize.width, 40)];
        
    }
    else{
        head_bg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, viewSize.width, 40)];
    }
    [head_bg setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"home_head"]]];
    
    UIButton *right_searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [right_searchBtn setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"search_icon@2x" ofType:@"png"]] forState:UIControlStateNormal];
    
    right_searchBtn.frame = CGRectMake(0, 0, 25, 25);
    [right_searchBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    right_searchBtn.tag = 301;
    
    suggestContent = [[UITextView alloc]init];
    suggestContent.text = LOCALIZATION(@"setting_feedback_hint");
    suggestContent.backgroundColor = [UIColor clearColor];
    suggestContent.textColor = [UIColor grayColor];
    suggestContent.font = [UIFont systemFontOfSize:16];
    suggestContent.returnKeyType = UIReturnKeySearch;
    suggestContent.frame = CGRectMake(10, 5, viewSize.width-20, [self suggestContentHeight]+5);
    suggestContent.autocapitalizationType = UITextAutocapitalizationTypeNone;
    suggestContent.delegate = self;
    
    line = [[UIImageView alloc]initWithImage:[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"searchbglinered@2x" ofType:@"png"]]];
    
    line.frame = CGRectMake(5, suggestContent.frame.size.height+suggestContent.frame.origin.y+5, viewSize.width-10, 4);
    [head_bg addSubview:line];
    [head_bg addSubview:suggestContent];
    [self.view addSubview:head_bg];
    
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    
    return YES;
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    suggestContent.text = @"";
    suggestContent.textColor = [UIColor blackColor];
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    if ([textView.text isEqualToString:@""] || textView.text == nil) {
        suggestContent.text = LOCALIZATION(@"setting_feedback_hint");
    }
    
}
- (void)textViewDidChange:(UITextView *)textView
{
    suggestContent.frame = CGRectMake(10, 5, viewSize.width-20, [self suggestContentHeight]);
    line.frame = CGRectMake(5, suggestContent.frame.size.height+suggestContent.frame.origin.y+5, viewSize.width-10, 4);
}
- (CGFloat)suggestContentHeight
{
    CGSize sizeText = CGSizeMake(0, 0);
    UIFont *font = [UIFont fontWithName:@"Arial" size:20];
    if (currentDev || currentDev1) {
        
        NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName,nil];
        sizeText = [suggestContent.text boundingRectWithSize:CGSizeMake(320, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    }
    else{
        CGSize size = CGSizeMake(320,1000);
        sizeText = [suggestContent.text sizeWithFont:font constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
    }
    return sizeText.height;
}
- (void)tapAction
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)btnClick:(UIButton *)sender{
    [self subMit];
}
- (void)subMit
{
    NSDictionary *parameters = @{@"userId":GET_USER_ID,@"sid":GET_S_ID,@"content":suggestContent};
    [AFRequestService responseData:FEEDBACK_URL andparameters:parameters andResponseData:^(id responseData) {
        NSDictionary * dict = (NSDictionary *)responseData;
        NSUInteger codeNum = [[dict objectForKey:@"code"] integerValue];
        if (codeNum == 0) {
            NSString *alertcontext = LOCALIZATION(@"setting_feedback_success");
            NSString *alertText = LOCALIZATION(@"dialog_prompt");
            NSString *alertOk = LOCALIZATION(@"dialog_ok");
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:alertText message:alertcontext delegate:self cancelButtonTitle:alertOk otherButtonTitles:nil];
            alert.tag = 401;
            [alert show];
        }
        else if (codeNum == 1){
            NSString *alertcontext = LOCALIZATION(@"setting_feedback_error");
            NSString *alertText = LOCALIZATION(@"dialog_prompt");
            NSString *alertOk = LOCALIZATION(@"dialog_ok");
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:alertText message:alertcontext delegate:self cancelButtonTitle:alertOk otherButtonTitles:nil];
            alert.tag = 402;
            [alert show];
        }
        
    }];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (alertView.tag == 401) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    else{
        
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    if(self.isViewLoaded && !self.view.window){

        head_bg = nil;
        suggestContent = nil;
        _tableView = nil;
        frindsArray = nil;
        userArray = nil;
        line = nil;
        self.view = nil;
        
    }
    // Dispose of any resources that can be recreated.
}
-(void)dealloc{
    head_bg = nil;
    suggestContent = nil;
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
