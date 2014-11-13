//
//  SinIn_NewModel.h
//  UNITOA
//
//  Created by qidi on 14-11-10.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SinIn_NewModel : UIViewController
{
    NSString *_barcode;
    NSString *_createDate;
    NSString *_expireDate;
    NSString *_reason;
    NSString *_signinId;
    NSString *_userId;
    NSString *_userCount;
    NSString *_latitude;
    NSString *_longitude;
    NSString *_address;
    NSString *_username;
     NSString *_logId;
}
@property(nonatomic, strong) NSString *barcode;
@property(nonatomic, strong) NSString *createDate;
@property(nonatomic, strong) NSString *expireDate;
@property(nonatomic, strong) NSString *reason;
@property(nonatomic, strong) NSString *signinId;
@property(nonatomic, strong) NSString *userId;
@property(nonatomic, strong) NSString *userCount;
@property(nonatomic, strong) NSString *signinDate;
@property(nonatomic, strong) NSString *latitude;
@property(nonatomic, strong) NSString *longitude;
@property(nonatomic, strong) NSString *address;
@property(nonatomic, strong) NSString *username;
@property(nonatomic, strong) NSString *logId;
@end
