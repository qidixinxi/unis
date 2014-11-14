//
//  CompanyFileViewController.h
//  UNITOA
//
//  Created by qidi on 14-11-13.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SNViewController.h"

typedef enum shareType{
    PRIVATE_FILE = 0,
    COMPANY_FILE = 1,
}SHARE_TYPE;
@interface CompanyFileViewController : SNViewController
@property(nonatomic,assign)SHARE_TYPE share_type;
@property(nonatomic,strong)NSString *showUserId;
@property(nonatomic,strong)NSString *parentId;
@property(nonatomic,strong)NSString *password;
@end
