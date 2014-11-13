//
//  GroupMemberListViewController.h
//  UNITOA
//
//  Created by qidi on 14-7-9.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GroupList.h"
#import "RefrashProtocol.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"

typedef enum _fromType{
    Frome_GroupList = 0,
    Frome_Chhat
}FROME_TYPE;
@interface GroupMemberListViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate,MBProgressHUDDelegate,UITextFieldDelegate,RefrashDelegate>
@property (nonatomic, strong)GroupList *groupModel;
@property (nonatomic, strong)NSMutableArray *groupMemberList;
@property (nonatomic, assign)id<RefrashDelegate>delegate;
@property (nonatomic, assign)FROME_TYPE fromeType;
@property (nonatomic, retain) UICollectionView *collectionView;//使用UICollectionView进行布局
@end
