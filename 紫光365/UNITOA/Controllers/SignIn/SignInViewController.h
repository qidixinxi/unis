//
//  SignInViewController.h
//  UNITOA
//
//  Created by qidi on 14-11-5.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMapKit.h"
#import "RefrashProtocol.h"
@interface SignInViewController : UIViewController<BMKMapViewDelegate,BMKLocationServiceDelegate>{
     BMKMapView* _mapView;
     BMKLocationService* _locService;
}
@property(nonatomic,assign)id<RefrashDelegate>delegate;
@end
