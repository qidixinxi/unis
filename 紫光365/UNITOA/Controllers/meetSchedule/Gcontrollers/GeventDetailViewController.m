        //
//  GeventDetailViewController.m
//  GUKE
//
//  Created by gaomeng on 14-10-4.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import "GeventDetailViewController.h"
#import "GMettingSignUpViewController.h"
#import "UILabel+GautoMatchedText.h"

#import "MBProgressHUD.h"


//#import "PartnerConfig.h"
//#import "DataSigner.h"
//#import "AlixPayResult.h"
//#import "DataVerifier.h"
//#import "AlixPayOrder.h"




//#import "AlixLibService.h"


//#import "AlixLibService.h"

@interface GeventDetailViewController ()<UITableViewDataSource,UITableViewDelegate,UIWebViewDelegate,UIAlertViewDelegate>
{
    GmettingDetailTableViewCell *_tmpCell;
    MBProgressHUD *_hud;
    UIWebView *_webView;
    UITableView *_tableView;
}
@end

@implementation GeventDetailViewController



-(void)dealloc{
    
    NSLog(@"%s",__FUNCTION__);
    _webView.delegate = nil;
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"GMJOINSUCCESS" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"GMESCSUCCESS" object:nil];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    if (IOS7_LATER) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    NSLog(@"%@",self.dataModel.eventTitle);
    self.aTitle = @"会议日程";
    
    NSLog(@"%s",__FUNCTION__);
    
    [self prepareNetData];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(prepareNetData1) name:@"GMJOINSUCCESS" object:nil];
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(prepareNetData2) name:@"GMESCSUCCESS" object:nil];
    
    
    
}


//报名成功后的通知方法
-(void)prepareNetData1{
    
    
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _hud.labelText = @"正在加载";
    
    NSString *eventIdStr = self.dataModel.eventId;
    
    
    NSDictionary *parameters = @{@"userId":GET_U_ID,@"sid":GET_S_ID,@"eventId":eventIdStr};
    
    [AFRequestService responseData:CALENDAR_EVENT andparameters:parameters andResponseData:^(id responseData) {
        
        NSDictionary * dict = (NSDictionary *)responseData;
        NSString * code = [dict objectForKey:@"code"];
        NSDictionary *eventDic = [dict objectForKey:@"event"];
        if ([code intValue]==0)//说明请求数据成功
        {
            
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            NSLog(@"loadSuccess");
            
            NSLog(@"查看活动  %@",dict);
            
            NSString *isbaoming = @"1";
            
            self.dataModel = [[GeventModel alloc]initWithDic:eventDic];
            self.dataModel.userExists = isbaoming;
            self.dataModel.userlist = [dict objectForKey:@"userlist"];
            if (!_webView) {
                _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, 275, 0)];
            }
            [_webView loadHTMLString:self.dataModel.context baseURL:nil];
            _webView.delegate = self;
            _webView.hidden = YES;
            [self.view addSubview:_webView];
        }else{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            UIAlertView *al = [[UIAlertView alloc]initWithTitle:@"提示" message:@"加载失败，请重新加载" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [al show];
            NSLog(@"%d",[code intValue]);
        }
    }];
}

//取消报名成功后的通知方法
-(void)prepareNetData2{
    
    
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _hud.labelText = @"正在加载";
    
    NSString *eventIdStr = self.dataModel.eventId;
    
    
    NSDictionary *parameters = @{@"userId":GET_U_ID,@"sid":GET_S_ID,@"eventId":eventIdStr};
    
    [AFRequestService responseData:CALENDAR_EVENT andparameters:parameters andResponseData:^(id responseData) {
        
        NSDictionary * dict = (NSDictionary *)responseData;
        NSString * code = [dict objectForKey:@"code"];
        NSDictionary *eventDic = [dict objectForKey:@"event"];
        if ([code intValue]==0)//说明请求数据成功
        {
            
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            NSLog(@"loadSuccess");
            
            NSLog(@"查看活动  %@",dict);
            
            NSString *isbaoming = @"0";
            
            self.dataModel = [[GeventModel alloc]initWithDic:eventDic];
            self.dataModel.userExists = isbaoming;
            self.dataModel.userlist = [dict objectForKey:@"userlist"];
            
            
            if (!_webView) {
                _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, 275, 0)];
            }
            [_webView loadHTMLString:self.dataModel.context baseURL:nil];
            _webView.delegate = self;
            _webView.hidden = YES;
            [self.view addSubview:_webView];
            [self.view addSubview:_webView];
            
        }else{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            UIAlertView *al = [[UIAlertView alloc]initWithTitle:@"提示" message:@"加载失败，请重新加载" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [al show];
            NSLog(@"%d",[code intValue]);
        }
    }];
}





-(void)prepareNetData{
    
    
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _hud.labelText = @"正在加载";
    
    NSString *eventIdStr = self.dataModel.eventId;
    
    
    NSDictionary *parameters = @{@"userId":GET_U_ID,@"sid":GET_S_ID,@"eventId":eventIdStr};

    [AFRequestService responseData:CALENDAR_EVENT andparameters:parameters andResponseData:^(id responseData) {
        
        NSDictionary * dict = (NSDictionary *)responseData;
        NSString * code = [dict objectForKey:@"code"];
        NSDictionary *eventDic = [dict objectForKey:@"event"];
        if ([code intValue]==0)//说明请求数据成功
        {
            
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            NSLog(@"loadSuccess");
            
            NSLog(@"查看活动  %@",dict);
            
            NSString *isbaoming = self.dataModel.userExists;
            
            self.dataModel = [[GeventModel alloc]initWithDic:eventDic];
            self.dataModel.userExists = isbaoming;
            self.dataModel.userlist = [dict objectForKey:@"userlist"];
            
            if (!_webView) {
                _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, 275, 0)];
            }
            [_webView loadHTMLString:self.dataModel.context baseURL:nil];
            _webView.delegate = self;
            _webView.hidden = YES;
            [self.view addSubview:_webView];
            
//            UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, 320, iPhone5?568-64:568-64-64) style:UITableViewStylePlain];
//            tableView.delegate = self;
//            tableView.dataSource = self;
//            [self.view addSubview:tableView];
            
            
        }else{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            UIAlertView *al = [[UIAlertView alloc]initWithTitle:@"提示" message:@"加载失败，请重新加载" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [al show];
            NSLog(@"%d",[code intValue]);
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = 0;
    
    if (_tmpCell)
    {
        
        height = [_tmpCell loadCustomViewWithIndexPath:indexPath dataModel:self.dataModel];
        NSLog(@"height1 =====  %f",height);
    }else{
        _tmpCell = [[GmettingDetailTableViewCell alloc]init];
        _tmpCell.delegate = self;
       height =  [_tmpCell loadCustomViewWithIndexPath:indexPath dataModel:self.dataModel];
        
    }
    
    return height;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"identifier";
    GmettingDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[GmettingDetailTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.delegate = self;
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    [cell loadCustomViewWithIndexPath:indexPath dataModel:self.dataModel];
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}


-(void)btnClicked:(UIButton *)sender{
    if (sender.tag == 10) {//报名
        
        NSLog(@"我要报名");
        
        GMettingSignUpViewController *gg = [[GMettingSignUpViewController alloc]init];
        gg.dataModel = self.dataModel;
        [self.navigationController pushViewController:gg animated:YES];
        
        
        
    }else if (sender.tag == 11){//取消报名
        NSLog(@"取消报名");
        
        _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        _hud.labelText = @"正在取消";
        
        [self eventquitNetWork];
        
        
        
    }else if (sender.tag == 12){
        
        
        
    }
    
}







#pragma mark -  取消报名
-(void)eventquitNetWork{
    
    
    NSString *eventIdStr = self.dataModel.eventId;
    
    NSDictionary *parameters = @{@"userId":GET_U_ID,@"sid":GET_S_ID,@"eventId":eventIdStr};
    
    [AFRequestService responseData:CALENDAR_EVENTQUIT andparameters:parameters andResponseData:^(id responseData) {
        
        NSDictionary * dict = (NSDictionary *)responseData;
        NSString * code = [dict objectForKey:@"code"];
        if ([code intValue]==0)//说明请求数据成功
        {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            
            [[NSNotificationCenter defaultCenter]postNotificationName:@"GMESCSUCCESS" object:nil];
            
            UIAlertView *al = [[UIAlertView alloc]initWithTitle:@"提示" message:@"取消成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [al show];
            
            
        }else{
            UIAlertView *al = [[UIAlertView alloc]initWithTitle:@"提示" message:@"取消失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [al show];
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
        }
    }];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
    NSString *height_str= [webView stringByEvaluatingJavaScriptFromString: @"document.body.offsetHeight"];
    int height = [height_str intValue];
    webView.frame = CGRectMake(0,0,290,height);
    NSLog(@"height: %@", [webView stringByEvaluatingJavaScriptFromString: @"document.body.offsetHeight"]);
    
    self.webViewHeight = [[webView stringByEvaluatingJavaScriptFromString: @"document.body.offsetHeight"]intValue] +10;
    
    
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    
}



-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 101) {
        if (buttonIndex == 0) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }
}





@end
