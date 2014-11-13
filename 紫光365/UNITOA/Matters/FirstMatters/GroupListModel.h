//
//  GroupListModel.h
//  UNITOA
//
//  Created by ianMac on 14-7-11.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GroupListModel : NSObject

@property (nonatomic, copy) NSString *addTime;
@property (nonatomic, copy) NSString *createDate;
@property (nonatomic, copy) NSString *creator;
@property (nonatomic, copy) NSString *creatorName;
@property (nonatomic, copy) NSString *denytalk;
@property (nonatomic, copy) NSString *groupId;
@property (nonatomic, copy) NSString *groupName;
@property (nonatomic, copy) NSString *groupType;
@property (nonatomic, copy) NSString *isCreator;
@property (nonatomic, copy) NSString *latestMsg;
@property (nonatomic, copy) NSString *latestMsgTime;
@property (nonatomic, copy) NSString *latestMsgUser;
@property (nonatomic, copy) NSString *membermemo;
@property (nonatomic, copy) NSString *memo;

@end
