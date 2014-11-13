//
//  customPopViewController.h
//  GUKE
//
//  Created by qidi on 14-10-10.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TSPopoverTouchesDelegate.h"

enum {
    QIPopoverArrowDirectionTop = 0,
    QIPopoverArrowDirectionRight,
    QIPopoverArrowDirectionBottom,
    QIPopoverArrowDirectionLeft
};
typedef NSUInteger TSPopoverArrowDirection;

enum {
    QIPopoverArrowPositionVertical = 0,
    QIPopoverArrowPositionHorizontal
};
typedef NSUInteger TSPopoverArrowPosition;

@class customPopoverView;
@interface customPopViewController : UIViewController<TSPopoverTouchesDelegate>
{
    customPopoverView * popoverView;
    TSPopoverArrowDirection arrowDirection;
    CGRect screenRect;
    int titleLabelheight;
}

@property (strong, nonatomic) UIViewController *contentViewController;
@property (strong, nonatomic) UIView *contentView;
@property (strong, nonatomic) NSString *titleText;
@property (strong, nonatomic) UIColor *titleColor;
@property (strong, nonatomic) UIFont *titleFont;
@property (strong, nonatomic) UIColor *popoverBaseColor;
@property (nonatomic) int cornerRadius;
@property (nonatomic, readwrite) TSPopoverArrowPosition arrowPosition;
@property (nonatomic) BOOL popoverGradient;

- (id)initWithContentViewController:(UIViewController*)viewController;
- (id)initWithView:(UIView*)view;
- (void) showPopoverWithTouch:(UIEvent*)senderEvent;
- (void) showPopoverWithCell:(UITableViewCell*)senderCell;
- (void) showPopoverWithRect:(CGRect)senderRect;
- (void) view:(UIView*)view touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event;
- (void) dismissPopoverAnimatd:(BOOL)animated;
@end
