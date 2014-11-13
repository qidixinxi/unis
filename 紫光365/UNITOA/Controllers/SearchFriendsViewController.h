//
//  searchFriendsViewController.h
//  UNITOA
//
//  Created by qidi on 14-6-26.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum fromType{
    frome_sigin ,
    frome_search
}FROM_TYPE;
@interface SearchFriendsViewController : UIViewController<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,assign)FROM_TYPE fromType;
@end
