//
//  AFNetAPIClient.h
//  WeiTongShi
//
//  Created by qidi on 14-6-2.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import "AFHTTPSessionManager.h"
@interface AFNetAPIClient : AFHTTPSessionManager
+(instancetype)shareClient;
@end
