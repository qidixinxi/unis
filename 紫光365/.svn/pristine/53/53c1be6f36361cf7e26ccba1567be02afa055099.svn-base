//
//  customActionSheet.m
//  GUKE
//
//  Created by qidi on 14-10-10.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import "customActionSheet.h"
#import "customPopViewController.h"
#import "UIBarButtonItem+WEPopover.h"

#define CORNER_RADIUS 0
#define BORDER 10
#define TITLE_SHADOW_OFFSET   CGSizeMake(0, -1)
#define BUTTON_HEIGHT 30
@implementation customActionSheet
@synthesize cornerRadius = _cornerRadius;
@synthesize titleColor = _titleColor;
@synthesize titleFont = _titleFont;
@synthesize popoverBaseColor = _popoverBaseColor;
@synthesize popoverGradient = _popoverGradient;
@synthesize buttonGradient = _buttonGradient;
@synthesize titleShadow = _titleShadow;
@synthesize titleShadowColor = _titleShadowColor;
@synthesize titleShadowOffset = _titleShadowOffset;
- (id)initWithTitle:(NSString *)title
{
    if ((self = [super init]))
    {
        self.frame = CGRectMake(0,0, 100, 300);
        buttonsMutableArray = [[NSMutableArray alloc] init];
        self.cornerRadius = CORNER_RADIUS;
        self.buttonGradient = YES;
        self.titleShadow = YES;
        self.titleColor = [UIColor whiteColor];
        //self.titleShadowOffset = TITLE_SHADOW_OFFSET;
        self.titleShadowColor = [UIColor clearColor];
        
        popoverController = [[customPopViewController alloc] init];
        popoverController.titleText = title;
        popoverController.titleFont = [UIFont boldSystemFontOfSize:14];
        popoverController.popoverBaseColor = [UIColor clearColor];
        popoverController.popoverGradient = YES;
    }
    return self;
}
- (id)init
{
    if ((self = [super init]))
    {
        self.frame = CGRectMake(0,0, 120, 300);
        buttonsMutableArray = [[NSMutableArray alloc] init];
        self.cornerRadius = CORNER_RADIUS;
        self.buttonGradient = YES;
        self.titleShadow = YES;
        self.titleColor = [UIColor whiteColor];
        self.titleShadowColor = [UIColor clearColor];
        
        popoverController = [[customPopViewController alloc] init];
        popoverController.titleFont = [UIFont boldSystemFontOfSize:14];
        popoverController.popoverBaseColor = [UIColor redColor];
        popoverController.popoverGradient = YES;
    }
    return self;
}
- (void)addButtonWithTitle:(NSString *)title
                      icon:(NSString *)iconURL
                     color:(UIColor*)color
                titleColor:(UIColor*)titleColor
               borderWidth:(NSUInteger)borderWidth
               borderColor:(UIColor*)borderColor
                     block:(void (^)())block
{
    [buttonsMutableArray addObject:[NSArray arrayWithObjects:
                                    block ? [block copy] : [NSNull null],
                                    title,
                                    color,
                                    titleColor,
                                    [NSNumber numberWithInteger:borderWidth],
                                    borderColor,
                                    iconURL,
                                    nil]];
}

- (void)addButtonWithTitle:(NSString *)title icon:(NSString *)iconURL block:(void (^)())block
{
    [self addButtonWithTitle:title
                        icon:(NSString *)iconURL
                       color:[UIColor clearColor]
                  titleColor:[UIColor lightGrayColor]
                 borderWidth:0
                 borderColor:[UIColor clearColor]
                       block:block];
}

- (void)destructiveButtonWithTitle:(NSString *)title icon:(NSString *)iconURL block:(void (^)())block
{
    [self addButtonWithTitle:title
                        icon:(NSString *)iconURL
                       color:[UIColor redColor]
                  titleColor:[UIColor lightGrayColor]
                 borderWidth:0
                 borderColor:[UIColor clearColor]
                       block:block];
}

- (void)cancelButtonWithTitle:(NSString *)title icon:(NSString *)iconURL block:(void (^)())block
{
    [self addButtonWithTitle:title
                        icon:(NSString *)iconURL
                       color:[UIColor clearColor]
                  titleColor:[UIColor lightGrayColor]
                 borderWidth:0
                 borderColor:[UIColor blackColor]
                       block:block];
}




//- (void)showFromBarButtonItem:(UIBarButtonItem *)item animated:(BOOL)animated
- (void) showWithTouch:(UIEvent*)senderEvent
{
    [self buildButtons];
    [popoverController showPopoverWithTouch:senderEvent];
}

- (void) showWithCell:(UITableViewCell*)senderCell
{
    [self buildButtons];
    [popoverController showPopoverWithCell:senderCell];
}

- (void) showWithRect:(CGRect)senderRect
{
    [self buildButtons];
    [popoverController showPopoverWithRect:senderRect];
    
}

- (void) buildButtons
{
    NSUInteger i = 1;
    NSUInteger buttonHeight = BUTTON_HEIGHT;
    NSUInteger buttonY = 5;
    for (NSArray *button in buttonsMutableArray)
    {
        NSString *title = [button objectAtIndex:1];
        UIColor *titleColor = [button objectAtIndex:3];
        NSString *iconUrl = [button objectAtIndex:6];
        UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, buttonY, self.bounds.size.width, buttonHeight)];
        bgView.layer.borderWidth  = 0;
        
        UIImage *image = [UIImage imageNamed:iconUrl];
        UIImageView *imgView = [[UIImageView alloc]initWithImage:image];
        imgView.frame = CGRectMake(3, 8, image.size.width * 1.2, image.size.height * 1.2);
        [bgView addSubview:imgView];
        if(!(i == [buttonsMutableArray count])){
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(-20, imgView.frame.size.height + imgView.frame.origin.y + 10, self.bounds.size.width + 40, 1)];
        line.layer.borderWidth = 1;
        line.layer.borderColor = [GETColor(200, 199, 199) CGColor];
        [bgView addSubview:line];
        }
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(23, 6, bgView.bounds.size.width-20, 20);
        button.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        button.titleLabel.textAlignment = NSTextAlignmentLeft;
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        button.backgroundColor = [UIColor clearColor];
        button.tag = i++;
        
        [button setTitleColor:titleColor forState:UIControlStateNormal];
        [button setTitle:title forState:UIControlStateNormal];
        button.accessibilityLabel = title;
        
        if(self.titleShadow){
            [button setTitleShadowColor:self.titleShadowColor forState:UIControlStateNormal];
            button.titleLabel.shadowOffset = self.titleShadowOffset;
        }
        
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:button];
        
        [self addSubview:bgView];
        bgView = nil;
        buttonY += buttonHeight + BORDER;
        
    }
    CGRect frame = self.frame;
    frame.size.height = buttonY;
    self.frame = frame;
    
    popoverController.contentView = self;
    popoverController.cornerRadius = self.cornerRadius;
    popoverController.popoverBaseColor = self.popoverBaseColor;
    popoverController.popoverGradient = self.popoverGradient;
    popoverController.titleColor = self.titleColor;
}


- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated
{
    if (buttonIndex >= 0 && buttonIndex < [buttonsMutableArray count])
    {
        id obj = [[buttonsMutableArray objectAtIndex: buttonIndex] objectAtIndex:0];
        if (![obj isEqual:[NSNull null]])
        {
            ((void (^)())obj)();
        }
    }
    
    if (animated)
    {
        [popoverController dismissPopoverAnimatd:YES];
        [self removeFromSuperview];
    }
    else
    {
        [popoverController dismissPopoverAnimatd:NO];
        [self removeFromSuperview];
    }
}

#pragma mark - Action

- (void)buttonClicked:(id)sender
{
    /* Run the button's block */
    NSInteger buttonIndex = [sender tag] - 1;
    [self dismissWithClickedButtonIndex:buttonIndex animated:YES];
}

@end
