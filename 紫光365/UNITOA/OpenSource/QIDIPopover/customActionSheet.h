//
//  customActionSheet.h
//  GUKE
//
//  Created by qidi on 14-10-10.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class customPopViewController;
@interface customActionSheet : UIView
{
    customPopViewController *popoverController ;
    NSMutableArray *buttonsMutableArray;
}

@property (strong, nonatomic) UIColor *titleColor;
@property (strong, nonatomic) UIFont *titleFont;
@property (strong, nonatomic) UIColor *popoverBaseColor;
@property (nonatomic) int cornerRadius;
@property (nonatomic) BOOL popoverGradient;
@property (nonatomic) BOOL buttonGradient;
@property (nonatomic) BOOL titleShadow;
@property (strong, nonatomic) UIColor *titleShadowColor;
@property (nonatomic) CGSize titleShadowOffset;

- (id)initWithTitle:(NSString *)title;
- (void)cancelButtonWithTitle:(NSString *) title icon:(NSString *)iconURL block:(void (^)()) block;
- (void)destructiveButtonWithTitle:(NSString *) title icon:(NSString *)iconURL block:(void (^)()) block;
- (void)addButtonWithTitle:(NSString *) title icon:(NSString *)iconURL block:(void (^)()) block;
- (void)addButtonWithTitle:(NSString *)title
                      icon:(NSString *)iconURL
                     color:(UIColor*)color
                titleColor:(UIColor*)titleColor
               borderWidth:(NSUInteger)borderWidth
               borderColor:(UIColor*)borderColor
                     block:(void (^)())block;
- (void) showWithTouch:(UIEvent*)senderEvent;
- (void) showWithRect:(CGRect)senderRect;
- (void) showWithCell:(UITableViewCell*)senderCell;
@end
