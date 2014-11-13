//
//  AppDelegate.h
//  UNITOA
//
//  Created by qidi on 14-6-25.
//  Copyright (c) 2014年 qidi. All rights reserved.
// 页面的跳转
typedef enum{
	Root_login = 0,
	Root_home,
    Root_contact,
    Root_friend,
    Root_Matter
} ROOTVC_TYPE;
#import <UIKit/UIKit.h>
#import "WindowCustom.h"
#import <AVFoundation/AVFoundation.h>
#import "BMapKit.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate,BMKGeneralDelegate,BMKLocationServiceDelegate>{
    AVAudioPlayer *avAudioPlayer;   //播放器player
    BMKLocationService *_locationServer;
}
@property (strong, nonatomic) WindowCustom *window;

- (void)showControlView:(ROOTVC_TYPE)type;
@end
