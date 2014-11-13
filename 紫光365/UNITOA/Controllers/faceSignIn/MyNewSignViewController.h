//
//  MyNewSignViewController.h
//  UNITOA
//
//  Created by qidi on 14-11-11.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SinIn_NewModel.h"
#import "RefrashProtocol.h"
@interface MyNewSignViewController : UIViewController
{
    SinIn_NewModel *_signModel;
}
@property(nonatomic,strong)SinIn_NewModel *signModel;
@property(nonatomic,assign)id<RefrashDelegate>delegate;
@end
