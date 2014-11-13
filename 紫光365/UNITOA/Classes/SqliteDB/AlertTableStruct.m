//
//  AlertTableStruct.m
//  UNITOA
//
//  Created by qidi on 14-9-1.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import "AlertTableStruct.h"
#define DATABASE_FOLDER  @"database_folder"
#define DATABASE_NAME    @"thunis.db"
#define ENGLISH_CLIENT @"vchatclient.db"
@implementation AlertTableStruct
// 穿件数据库文件夹
+(NSString *)dataBaseFoler{
    NSError *error;
    NSString *folderPath = [DOCUMENTPATH stringByAppendingPathComponent:DATABASE_FOLDER];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:folderPath]){
        BOOL res = [fileManager createDirectoryAtPath:folderPath withIntermediateDirectories:YES attributes:nil error:&error];
        NSAssert(res, @"创建目录失败 ");
    }
    return folderPath;
}
// 获取数据库的路径
+(NSString *)querAndCreatDatabasePath:(NSString *)dataBaseName{
    return [[self dataBaseFoler] stringByAppendingPathComponent:dataBaseName];
}
+ (void)creatTableStruct:(NSInteger)versionNum
{
    if (versionNum == 7) {
        // 获取数据库的路径
        FMDatabaseQueue *dataBaseQueue = [[FMDatabaseQueue alloc]initWithPath:[AlertTableStruct querAndCreatDatabasePath:ENGLISH_CLIENT]];
        [dataBaseQueue inDatabase:^(FMDatabase *db) {
            NSString *shareSource = [NSString stringWithFormat:@"ALTER TABLE %@ ADD shareSource varchar",TABLE_HD];
            BOOL res1 = [db executeUpdate:shareSource];
            if (res1) {
                
            }
            else{
                
            }
            NSString *shareId = [NSString stringWithFormat:@"ALTER TABLE %@ ADD shareId varchar",TABLE_HD];
            BOOL res2 = [db executeUpdate:shareId];
            if (res2) {
                
            }
            else{
                
            }
        }];
        
    }
}
@end
