//
//  FaceSignListViewController.h
//  UNITOA
//
//  Created by qidi on 14-11-10.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBarSDK.h"
@interface FaceSignListViewController : UIViewController<UINavigationControllerDelegate,UIImagePickerControllerDelegate,ZBarReaderDelegate>
{
    int num;
    BOOL upOrdown;
    NSTimer * timer;
    
}
@property (nonatomic, strong) UIImageView * line;

@end
