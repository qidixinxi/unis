//
//  RBCustomDatePickerView.h
//  RBCustomDateTimePicker
//  e-mail:rbyyy924805@163.com
//  Created by renbing on 3/17/14.
//  Copyright (c) 2014 renbing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MXSCycleScrollView.h"

@protocol ZSCustomDatePickerViewDelegate <NSObject>

- (void)sendTime:(NSString *)date;

@end
@interface ZSCustomDatePickerView : UIView <MXSCycleScrollViewDatasource,MXSCycleScrollViewDelegate>

@property (nonatomic,strong)id<ZSCustomDatePickerViewDelegate>delegate;
@end
