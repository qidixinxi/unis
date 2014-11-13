//
//  MySignDetailViewController.h
//  UNITOA
//
//  Created by qidi on 14-11-11.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SinIn_NewModel.h"
@interface MySignDetailViewController : UIViewController
{
    SinIn_NewModel *_signModel;
}
@property(nonatomic,strong)SinIn_NewModel *signModel;
@end
