//
//  yunpanModel.h
//  UNITOA
//
//  Created by qidi on 14-11-14.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface yunpanModel : NSObject
{
    NSString *_createDate;
    NSString *_deleteFlag;
    NSString *_fileType;
    NSString *_filename;
    NSString *_filesize;
    NSString *_fileurl;
    NSString *_parentId;
    NSString *_password;
    NSString *_permission;
    NSString *_previewurl;
    NSString *_shareType;
    NSString *_userId;
    NSString *_userlist;
    NSString *_yunpanId;
}
@property(nonatomic,strong)NSString *createDate;
@property(nonatomic,strong)NSString *deleteFlag;
@property(nonatomic,strong)NSString *fileType;
@property(nonatomic,strong)NSString *filename;
@property(nonatomic,strong)NSString *filesize;
@property(nonatomic,strong)NSString *fileurl;
@property(nonatomic,strong)NSString *parentId;
@property(nonatomic,strong)NSString *password;
@property(nonatomic,strong)NSString *permission;
@property(nonatomic,strong)NSString *previewurl;
@property(nonatomic,strong)NSString *shareType;
@property(nonatomic,strong)NSString *userId;
@property(nonatomic,strong)NSString *userlist;
@property(nonatomic,strong)NSString *yunpanId;
- (NSArray *)getYunPanList:(NSArray *)yunpanArray;
@end
