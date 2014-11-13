//
//  FriendCircleHomeTableViewCell.h
//  UNITOA
//
//  Created by qidi on 14-8-6.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RTLabel.h"
#import "FriendContentView.h"
#import "CommentView.h"
#import "CommentTableView.h"
#import "ZSCircleImageView.h"
@class FriendCircleHomeTableViewCell;
@protocol FriendCircleHomeTableViewCellDelegate <NSObject>
//删除说说的代理方法
-(void)deleteBlogWithCell:(FriendCircleHomeTableViewCell *)cell;
//删除评论的代理方法
- (void)deleteOwnComment:(id)commentid andCell:(id)cell andHomeCell:(FriendCircleHomeTableViewCell *)homeCell;

@end


typedef void(^CommentViewBlock)(NSString *);
@class UserArticleList;
@interface FriendCircleHomeTableViewCell : UITableViewCell<RTLabelDelegate,CommentTableViewDelegate>
@property(nonatomic, strong)UserArticleList *post;
@property(nonatomic, assign)NSInteger index;
@property(nonatomic, assign)UIImage *shareImage;
@property(nonatomic, strong)UIImageView *userIcon;
@property(nonatomic, strong)UILabel *userName;
@property(nonatomic, strong)UILabel *content;
@property(nonatomic, strong)UIImageView *shareImg;
@property(nonatomic, strong)UILabel *reportTime;
@property(nonatomic, strong)UIButton *favorite;
@property(nonatomic, strong)UIButton *comment;
@property(nonatomic, strong)UILabel *urlLabel;
@property (nonatomic, strong)RTLabel *contact;
@property (nonatomic, strong)FriendContentView *ContentView;
@property(nonatomic, strong)CommentView *goodView;
@property(nonatomic, strong)CommentTableView *commentView;
@property(nonatomic, copy)CommentViewBlock sendUserId;
@property(nonatomic,strong)ZSCircleImageView * PictureViews;
@property(nonatomic,strong)UIImageView * single_imageView;
@property(nonatomic,strong)UIButton * delete_button;
@property(nonatomic,weak)id<FriendCircleHomeTableViewCellDelegate>delegate;
+ (CGFloat)heightForCellWithPost:(UserArticleList *)post;
@end
