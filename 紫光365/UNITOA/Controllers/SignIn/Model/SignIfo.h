//
//  SignIfo.h
//  UNITOA
//
//  Created by qidi on 14-11-7.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SignIfo : NSObject
{
    NSString *_address;
    NSString *_createDate;
    NSString *_latitude;
    NSString *_name;
    NSString *_signId;
    NSString *_userId;
}
@property(nonatomic,strong)NSString *address;
@property(nonatomic,strong)NSString *createDate;
@property(nonatomic,strong)NSString *latitude;
@property(nonatomic,strong)NSString *longitude;
@property(nonatomic,strong)NSString *name;
@property(nonatomic,strong)NSString *signId;
@property(nonatomic,strong)NSString *userId;
@end
