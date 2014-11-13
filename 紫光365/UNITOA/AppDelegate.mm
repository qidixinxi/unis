
//  AppDelegate.m
//  UNITOA
//
//  Created by qidi on 14-6-25.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import "AppDelegate.h"
#import "UserLoginViewController.h"
#import "UserContactViewController.h"
#import "FriendListViewController.h"
#import "FirendCircleHomeTableViewController.h"
#import "SqliteFieldAndTable.h"
#import "MyUncaughtExceptionHandler.h"
#import "UncaughtExceptionHandler.h"
#import <AudioToolbox/AudioToolbox.h>
#import "UserCenter.h"
#import "Interface.h"
#import "CheckNetWork.h"
#import "addNewContact.h"
#import "getAppInfo.h"
#import "MattersViewController.h"

BMKMapManager *_mapManager;
@implementation AppDelegate

// 注册远程推送通知
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    // 存储远程推送通知的tocken值
    [[NSUserDefaults standardUserDefaults] setValue:deviceToken forKey:DEVICETOKEN];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self setUpBaiduManager];
    [self getMyLocation];
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firstStart"]){
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstStart"];
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"ison0"];
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:@"ison1"];
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"ison2"];
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"ison3"];
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"ison4"];
    }else{
        NSLog(@"不是第一次启动");
    }
    //self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window = [[WindowCustom alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"navi_bg"] forBarMetrics:UIBarMetricsDefault];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    /* 数据库的版本升级，当前版本是2*/
    [getAppInfo getDataBaseVersion:7];
    
    /* 获取版本信息，检查是否有更新*/
    [getAppInfo getAppVersion];
    /* 多语言的切换*/
    NSUserDefaults *lanUser = [NSUserDefaults standardUserDefaults];
    NSString *lan = [lanUser objectForKey:@"LAN"];
    if (NULL == lan) {
        lan = @"zh";
    }
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:lan ofType:@"plist"];
    NSDictionary *dictionary = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    if(NULL != dictionary){
        [lanUser setObject:dictionary forKey:@"language"];
    }

    // 聊天页面
   
    /*
     页面跳转的部分 如果是点击推送消息启动的程序，则跳到指定的页面
     如果不是点击推送启动的程序，则正常启动程序
     */
    if (launchOptions != nil && ![launchOptions isEqual:[NSNull null]]) {
        [[NSUserDefaults standardUserDefaults] setValue:launchOptions forKey:LANUCH];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self showControlView:Root_contact];
        
    }
    else{
     //自动登入的判断
    if (IS_AUTOLOG && GET_USER_ID != nil && GET_S_ID !=nil) {
        [self showControlView:Root_home];
    }
    else{
        [self showControlView:Root_login];
    }
    }
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    //注册远程推送通知
    [self startRegisterNotification];
    
   
    
    // 监测网络
    CheckNetWork *check = [[CheckNetWork alloc] init];
    [check checkNetworkChange];
    [check networkTips];
    
    // 异常的捕获
    [MyUncaughtExceptionHandler setDefaultHandler];
    //[self installUncaughtExceptionHandler];
    return YES;
}
// 注册远程推送通知
- (void)startRegisterNotification{
    if (IOS8_LATER) {
        UIUserNotificationSettings *notificationSetting = [UIUserNotificationSettings settingsForTypes: UIRemoteNotificationTypeBadge |UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:notificationSetting];
    }
    else{
        //注册远程推送通知
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
         UIRemoteNotificationTypeBadge |
         UIRemoteNotificationTypeAlert |
         UIRemoteNotificationTypeSound];
    }
    if (IOS8_LATER) {
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
}
// 接受（到）远程推送通知（挂起）
-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    NSDictionary *dic = [userInfo objectForKey:@"info"];
    NSString *typeId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"typeId"]];
    // 发送人的id
    NSString *dataId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"dataId"]];
    // 接受人的id
    NSString *recvId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"recvId"]];
    // 私人聊天
    [[SingleInstance shareManager] setRecvId:recvId];
    [[SingleInstance shareManager] setSendId:dataId];
    [[SingleInstance shareManager] setIsPush:YES];
    [[NSUserDefaults standardUserDefaults] setObject:dataId forKey:@"sendId"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if ([typeId
         isEqualToString:PUSH_PCHAT]) {
        [[NSUserDefaults standardUserDefaults] setObject:dataId forKey:@"dataId"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        if ([recvId isEqualToString:GET_USER_ID]) {
                [addNewContact addUserContact:dataId];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:kPushNewPChat object:nil userInfo:nil];
    }
    // 全部的消息推送
    if ([typeId isEqualToString:PUSH_PCHAT] || [typeId isEqualToString:PUSH_GPCHAT] || [typeId isEqualToString:PUSH_GCHAT]){
        if ([typeId isEqualToString:PUSH_PCHAT]){
            NSString *recvId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"dataId"]];
            // 私人聊天
            [[SingleInstance shareManager] setRecvId:recvId];
        }
        if (([typeId isEqualToString:PUSH_GPCHAT] || [typeId isEqualToString:PUSH_GCHAT])&& [[[NSUserDefaults standardUserDefaults] objectForKey:@"ison0"] boolValue] == NO) {
            return;
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"redLabel" object:nil userInfo:dic];
        [[NSNotificationCenter defaultCenter] postNotificationName:PUSH_NEW object:nil userInfo:dic];
    }
    // 聊天广场
    if ([typeId isEqualToString:PUSH_GCHAT] ) {
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"ison0"] boolValue]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kPushNewGChat object:nil userInfo:nil];
        }
    }
    // 群聊
    if ([typeId isEqualToString:PUSH_GPCHAT] ) {
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"ison0"]boolValue]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kPushNewGPChat object:nil userInfo:nil];
        }
        
    }
    
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [self playVoice];
                dispatch_sync(dispatch_get_main_queue(), ^{
                    
                });
            });
    
    
}
// 设置声音的播放和震动
- (void)playVoice{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"newdatatoast" ofType:@"wav"];
    //组装并播放音效
    SystemSoundID soundID;
    NSURL *filePath = [NSURL fileURLWithPath:path isDirectory:NO];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)filePath, &soundID);
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"ison1"]boolValue]) {
        AudioServicesPlaySystemSound(soundID);
    }
    else{
    AudioServicesDisposeSystemSoundID(soundID);
    }
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"ison2"]boolValue]) {
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    }
    else{
        AudioServicesDisposeSystemSoundID(kSystemSoundID_Vibrate);
    }
}
// 控制视图的跳转
- (void)showControlView:(ROOTVC_TYPE)type
{
    [self rememberLujing];
    // 跳转到登入页面
    if (type == Root_login){
        UserLoginViewController *vc = [[UserLoginViewController alloc] init];
        UINavigationController *nv = [[UINavigationController alloc] initWithRootViewController:vc];
        self.window.rootViewController = nv;
        
    }else if (type == Root_home){
        // 把tocken写到服务器
        if ([[NSUserDefaults standardUserDefaults] objectForKey:DEVICETOKEN] != nil && ![[[NSUserDefaults standardUserDefaults] objectForKey:DEVICETOKEN] isEqual:[NSNull null]]) {
            NSDictionary *params = @{@"userId": GET_USER_ID,@"sid":GET_S_ID,@"deviceToken":[[NSUserDefaults standardUserDefaults] objectForKey:DEVICETOKEN]};
            [AFRequestService responseData:UPLOAD_TOCKEN_URL andparameters:params  andResponseData:^(NSData *responseData) {
                NSDictionary *dict = (NSDictionary *)responseData;
                NSUInteger codeNum = [[dict objectForKey:@"code"] integerValue];
                if (codeNum == CODE_SUCCESS) {
                    return ;
                }
                else if (codeNum == CODE_ERROE){
                    SqliteFieldAndTable *sqliteAndtable = [[SqliteFieldAndTable alloc]init];
                    AppDelegate __weak *_Self = self;
                    [sqliteAndtable repeatLogin:^(BOOL flag) {
                        if (flag) {
                            [_Self showControlView:Root_home];
                            
                        }
                        else{
                            [_Self showControlView:Root_login];
                        }
                    }];
                }
            }];
        }
        // 后台执行加载数据
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            SqliteFieldAndTable *sqliteAndtable = [[SqliteFieldAndTable alloc]init];
            [sqliteAndtable getAllInfo];
            sqliteAndtable = nil;
            dispatch_sync(dispatch_get_main_queue(), ^{
                
            });
        });
        
        FriendListViewController *vc = [[FriendListViewController alloc] init];
        UINavigationController *nv = [[UINavigationController alloc] initWithRootViewController:vc];
        self.window.rootViewController = nv;
    }
    // 跳转到连天页面
    else if (type == Root_contact){
         UserContactViewController *userContact = [[UserContactViewController alloc]init];
        UINavigationController *nvc = [[UINavigationController alloc]initWithRootViewController:userContact];
        //标记是否是推送过去的
        userContact.index = 1;
        self.window.rootViewController = nvc;
    }
    // 跳转到朋友页面
    else if(type == Root_friend){
        FriendListViewController *vc = [[FriendListViewController alloc] init];
        UINavigationController *nv = [[UINavigationController alloc] initWithRootViewController:vc];
        self.window.rootViewController = nv;
    }
    else if (type == Root_Matter){
        MattersViewController *vc = [[MattersViewController alloc] init];
        UINavigationController *nv = [[UINavigationController alloc] initWithRootViewController:vc];
        self.window.rootViewController = nv;
    }
}

// 初始化滚动路径
- (void)rememberLujing{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithFloat:0] forKey:@"offset_Y"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithFloat:0] forKey:@"Contact_Y"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}
#pragma mark ----------启动BaiduMapManager--------------------
- (void)setUpBaiduManager{
    
    _mapManager = [[BMKMapManager alloc]init];
    BOOL ret = [_mapManager start:@"NAywxWuW5iZaBSP4QH2Dao2n" generalDelegate:self];
    if (!ret) {
        NSLog(@"管理器启动失败");
    }
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
        [[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"navi_bg@2x" ofType:@"png"]] forBarMetrics:UIBarMetricsDefault];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
        [[NSNotificationCenter defaultCenter] postNotificationName:ENTERFORGROUD object:nil userInfo:nil];
        
}
- (void)getMyLocation{
    if (IOS8_LATER) {
        //由于IOS8中定位的授权机制改变 需要进行手动授权
        CLLocationManager *_locationManager = [[CLLocationManager alloc] init];
        //获取授权认证
        [_locationManager requestAlwaysAuthorization];
        [_locationManager requestWhenInUseAuthorization];
    }
    _locationServer = [[BMKLocationService alloc]init];
    _locationServer.delegate = self;
    [_locationServer startUserLocationService];
}
//  开始启动定位
- (void)willStartLocatingUser{
    
}
// 在停止定位后调用测方法
- (void)didStopLocatingUser{
    
}
// 用户方向更新后调用的方法
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation{
    
//    if (userLocation.location.coordinate.latitude == 0.0 || userLocation.location.coordinate.longitude == 0.0) {
//        [_locationServer stopUserLocationService];
//        //[_locationServer startUserLocationService];
//    }
//    else{
//        [_locationServer stopUserLocationService];
//        
//    }
    
}
// 用户位置更新后调用的方法
- (void)didUpdateUserLocation:(BMKUserLocation *)userLocation{
    if (userLocation.location.coordinate.latitude == 0.0 || userLocation.location.coordinate.longitude == 0.0) {
        [_locationServer stopUserLocationService];
        [_locationServer startUserLocationService];
    }
    else{
        [_locationServer stopUserLocationService];
        [SingleInstance shareManager].latitude = [NSString stringWithFormat:@"%.7f",userLocation.location.coordinate.latitude];
        [SingleInstance shareManager].longitude = [NSString stringWithFormat:@"%.7f",userLocation.location.coordinate.longitude];
    }
    
    
}
- (void)applicationDidBecomeActive:(UIApplication *)application
{
    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
