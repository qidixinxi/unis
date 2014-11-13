//
//  customPopoverView.m
//  GUKE
//
//  Created by qidi on 14-10-10.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import "customPopoverView.h"
#define MARGIN 0
#define ARROW_SIZE 0
@implementation customPopoverView

@synthesize cornerRadius = _cornerRadius;
@synthesize arrowPoint = _arrowPoint;
@synthesize arrowDirection = _arrowDirection;
@synthesize arrowPosition = _arrowPosition;
@synthesize baseColor = _baseColor;
@synthesize isGradient = _isGradient;

- (id)init
{
    self = [super init];
    if(self){
        self.backgroundColor = GETColor(244, 244, 244);
        self.baseColor = [UIColor clearColor];
        self.layer.borderColor =[GETColor(200, 199, 199) CGColor];
        self.layer.borderWidth = 1;
        self.isGradient = YES;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    UIImage *backgroundImage = self.backgroundImage;
    [backgroundImage drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) blendMode:kCGBlendModeNormal alpha:1];
    
}

-(UIImage*)backgroundImage
{
    //// Color
    CGFloat myRed=0,myGreen=0,myBlue=0,myWhite=0,alpha=1;
    UIColor *gradientBaseColor = self.baseColor;
    UIColor* gradientTopColor;
    UIColor* gradientMiddleColor;
    UIColor* gradientBottomColor;
    
    BOOL s = [gradientBaseColor getRed:&myRed green:&myGreen blue:&myBlue alpha:&alpha ];
    if(!s) {
        [gradientBaseColor getWhite:&myWhite alpha:&alpha];
    }
    
    if(myRed < 0) myRed = 0;
    if(myGreen < 0) myGreen = 0;
    if(myBlue < 0) myBlue = 0;
    if(myWhite < 0) myWhite = 0;
    
    if(myWhite > 0.0f){
        gradientTopColor = [UIColor colorWithWhite:myWhite+0.35f alpha:0.7];
        gradientMiddleColor = [UIColor colorWithWhite:myWhite+0.13f alpha:0.7];
        gradientBottomColor = [UIColor colorWithWhite:myWhite alpha:0.7];
    } else {
        gradientTopColor = [UIColor colorWithRed:244 green:244 blue:244 alpha: 0];
        gradientMiddleColor = [UIColor colorWithRed:244 green:244 blue:244 alpha: 0];
        gradientBottomColor = [UIColor colorWithRed:244 green:244 blue:244 alpha: 0];
    }
    
    UIColor *arrowColor = gradientBottomColor;
    if(self.arrowDirection == QIPopoverArrowDirectionTop && self.isGradient){
        arrowColor = gradientTopColor;
    }
    
    //size
    float bgSizeWidth = self.frame.size.width;
    float bgSizeHeight = self.frame.size.height;
    float bgRectSizeWidth = 0;
    float bgRectSizeHeight = 0;
    float bgRectPositionX = 0;
    float bgRectPositionY = 0;
    float arrowHead = 0;
    float arrowBase = ARROW_SIZE+1;
    float arrowFirst =0;
    float arrowLast = 0;
    
    //CGPoint senderLocationInViewPoint = [self convertPoint:self.arrowPoint fromView:[[UIApplication sharedApplication] keyWindow]];
    UIWindow *appWindow = [[UIApplication sharedApplication] keyWindow];
    CGPoint senderLocationInViewPoint = [self convertPoint:self.arrowPoint fromView:appWindow.rootViewController.view];
    
    if(self.arrowPosition == QIPopoverArrowPositionVertical){
        bgRectSizeWidth = bgSizeWidth;
        bgRectSizeHeight = bgSizeHeight - ARROW_SIZE;
        
        if(self.arrowDirection == QIPopoverArrowDirectionTop){
            bgRectPositionY = ARROW_SIZE;
        }
        
        if(self.arrowDirection == QIPopoverArrowDirectionBottom){
            arrowHead = bgRectSizeHeight + ARROW_SIZE;
            arrowBase = bgRectSizeHeight - 1;
        }
    }else if(self.arrowPosition == QIPopoverArrowPositionHorizontal){
        bgRectSizeWidth = bgSizeWidth - ARROW_SIZE;
        bgRectSizeHeight = bgSizeHeight;
        
        if(self.arrowDirection == QIPopoverArrowDirectionLeft){
            bgRectPositionX = ARROW_SIZE;
        }
        
        if(self.arrowDirection == QIPopoverArrowDirectionRight){
            arrowHead = bgRectSizeWidth + ARROW_SIZE;
            arrowBase = bgRectSizeWidth - 1;
        }
    }
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(bgSizeWidth, bgSizeHeight), NO, 0);
    
    //// General Declarations
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    
    
    //// Gradient Declarations
    NSArray* bgGradientColors = [NSArray arrayWithObjects:
                                 (id)gradientBottomColor.CGColor,
                                 (id)gradientBottomColor.CGColor,
                                 (id)gradientMiddleColor.CGColor,
                                 (id)gradientTopColor.CGColor, nil];
    CGFloat bgGradientLocations[] = {0,0.4, 0.5, 1};
    CGGradientRef bgGradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)bgGradientColors, bgGradientLocations);
    
    
    //// Rounded Rectangle Drawing
    UIBezierPath* roundedRectanglePath = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(bgRectPositionX, bgRectPositionY, bgRectSizeWidth, bgRectSizeHeight) cornerRadius: self.cornerRadius+MARGIN];
    
    
    //// Polygon Drawing
    UIBezierPath* bezierPath = [UIBezierPath bezierPath];
    if(self.arrowPosition == QIPopoverArrowPositionVertical){
        arrowFirst = senderLocationInViewPoint.x-ARROW_SIZE/2;
        arrowLast = senderLocationInViewPoint.x+ARROW_SIZE/2;
        if(arrowFirst < bgRectPositionX + (self.cornerRadius+MARGIN)){
            arrowFirst = bgRectPositionX + (self.cornerRadius+MARGIN);
            arrowLast = arrowFirst + ARROW_SIZE;
        }
        if(arrowLast > (bgRectPositionX + bgRectSizeWidth) - (self.cornerRadius+MARGIN)){
            arrowLast = (bgRectPositionX + bgRectSizeWidth) - (self.cornerRadius+MARGIN);
            arrowFirst = arrowLast -  ARROW_SIZE;
        }
        [bezierPath moveToPoint: CGPointMake(arrowFirst, arrowBase)];
        [bezierPath addLineToPoint: CGPointMake(senderLocationInViewPoint.x, arrowHead)];
        [bezierPath addLineToPoint: CGPointMake(arrowLast, arrowBase)];
    }else if(self.arrowPosition == QIPopoverArrowPositionHorizontal){
        arrowFirst = senderLocationInViewPoint.y-ARROW_SIZE/2;
        arrowLast = senderLocationInViewPoint.y+ARROW_SIZE/2;
        
        if(arrowFirst < bgRectPositionY + (self.cornerRadius+MARGIN)){
            arrowFirst = bgRectPositionY + (self.cornerRadius+MARGIN);
            arrowLast = arrowFirst + ARROW_SIZE;
        }
        
        if(arrowLast > (bgRectPositionY + bgRectSizeHeight) - (self.cornerRadius+MARGIN)){
            arrowLast = (bgRectPositionY + bgRectSizeHeight) - (self.cornerRadius+MARGIN);
            arrowFirst = arrowLast - ARROW_SIZE;
        }
        
        [bezierPath moveToPoint: CGPointMake(arrowBase, arrowFirst)];
        [bezierPath addLineToPoint: CGPointMake(arrowHead, senderLocationInViewPoint.y)];
        [bezierPath addLineToPoint: CGPointMake(arrowBase, arrowLast)];
    }
    
    CGContextSaveGState(context);
    [arrowColor setFill];
    [bezierPath fill];
    [roundedRectanglePath appendPath:bezierPath];
    
    [roundedRectanglePath addClip];
    
    [gradientBottomColor setFill];
    [roundedRectanglePath fill];
    if(self.arrowDirection == QIPopoverArrowDirectionTop){
        [arrowColor setFill];
        [bezierPath fill];
    }
    if(self.isGradient){
        CGContextDrawLinearGradient(context, bgGradient, CGPointMake(0, bgRectPositionY+20), CGPointMake(0, bgRectPositionY), 0);
    }
    
    CGContextRestoreGState(context);
    
    //// Cleanup
    CGGradientRelease(bgGradient);
    CGColorSpaceRelease(colorSpace);
    
    UIImage *output = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    return output;
}

@end
