//
//  selectDateTimeViewController.m
//  GUKE
//
//  Created by qidi on 14-10-27.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import "selectDateTimeViewController.h"
#import "ZSCustomDatePickerView.h"
@interface selectDateTimeViewController ()<ZSCustomDatePickerViewDelegate>

@end

@implementation selectDateTimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    
    self.view.backgroundColor = GETColor(255, 255, 255);
    ZSCustomDatePickerView *datePicker = [[ZSCustomDatePickerView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    datePicker.delegate = self;
    [self.view addSubview:datePicker];
}
- (void)sendTime:(NSString *)date{
    if (self.delegate && [self.delegate respondsToSelector:@selector(sendTime:)]) {
        [self.delegate sendTime:date];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
