//
//  yunpanModel.m
//  UNITOA
//
//  Created by qidi on 14-11-14.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import "yunpanModel.h"

@implementation yunpanModel
- (void)dealloc
{
     self.createDate = nil;
     self.deleteFlag = nil;
     self.fileType = nil;
     self.filename = nil;
     self.filesize = nil;
     self.fileurl = nil;
     self.parentId = nil;
     self.password = nil;
     self.permission = nil;
     self.previewurl = nil;
     self.shareType = nil;
     self.userId = nil;
     self.userlist = nil;
     self.yunpanId = nil;
}
- (NSArray *)getYunPanList:(NSArray *)yunpanArray{
    NSMutableArray *yunpanList = [NSMutableArray new];
    for (int i = 0; i<[yunpanArray count]; i++) {
        id list = yunpanArray[i];
        if ([list isKindOfClass:[NSDictionary class]]) {
            yunpanModel *model = [yunpanModel new];
            model.createDate = [list objectForKey:@"createDate"];
            model.deleteFlag = [list objectForKey:@"deleteFlag"];
            model.fileType = [list objectForKey:@"fileType"];
            model.filename = [list objectForKey:@"filename"];
            model.filesize = [list objectForKey:@"filesize"];
            model.fileurl = [list objectForKey:@"fileurl"];
            model.parentId = [list objectForKey:@"parentId"];
            model.password = [list objectForKey:@"password"];
            model.permission = [list objectForKey:@"permission"];
            model.previewurl = [list objectForKey:@"previewurl"];
            model.shareType = [list objectForKey:@"shareType"];
            model.userId = [list objectForKey:@"userId"];
            model.userlist = [list objectForKey:@"userlist"];
            model.yunpanId = [list objectForKey:@"yunpanId"];
            [yunpanList addObject:model];
            model = nil;
        }
    }
    return [yunpanList copy];
}
@end
