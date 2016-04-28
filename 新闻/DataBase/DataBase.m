//
//  DataBase.m
//  新闻
//
//  Created by gyh on 16/4/25.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "DataBase.h"
#import "FMDB.h"

#import "CollectModel.h"

@implementation DataBase

static FMDatabaseQueue *_queue;


#pragma mark - 初始化，创建表
+(void)initialize
{
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject]stringByAppendingPathComponent:@"News.sqlite"];
    
    //创建队列
    _queue = [FMDatabaseQueue databaseQueueWithPath:path];
    //创表
    [_queue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"create table if not exists t_news (id integer primary key autoincrement, title text,docid text,time text);"];
    }];
}


#pragma mark 存数据
+ (void)addNews:(NSString *)title docid:(NSString *)docid time:(NSString *)time
{
    [_queue inDatabase:^(FMDatabase *db) {
        // 2.存储数据
        [db executeUpdate:@"insert into t_news (title,docid,time) values(?,?,?)",title,docid,time];
    }];
}


#pragma mark 显示数据
+ (NSMutableArray *)display
{
    __block NSMutableArray *dicArray = nil;
    [_queue inDatabase:^(FMDatabase *db) {
        
        dicArray = [NSMutableArray array];
        // 1.查询数据
        FMResultSet *rs = [db executeQuery:@"select * from t_news"];
        
        // 2.遍历结果集
        while (rs.next) {
            NSString *title = [rs stringForColumn:@"title"];
            NSString *docid = [rs stringForColumn:@"docid"];
            NSString *time = [rs stringForColumn:@"time"];
            
            CollectModel *collectmodel = [[CollectModel alloc]init];
            collectmodel.title = title;
            collectmodel.docid = docid;
            collectmodel.time = time;
            
            [dicArray addObject:collectmodel];
        }
    }];
    return dicArray;
}


+ (NSString *)queryWithCollect:(NSString *)docid
{
    __block NSString *str = @"0";
    [_queue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:@"select * from t_news where docid = ?;",docid];
        while (rs.next) {
            NSString *docid = [rs stringForColumn:@"docid"];
            NSLog(@"%@",docid);
            str = @"1";
        }
    }];
    return str;
}


#pragma mark -  删除表
+ (void)deletetable
{
    [_queue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"delete from t_news"];
    }];
}

#pragma mark -  删除单条数据
+ (void)deletetable:(NSString *)docid
{
    [_queue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"delete from t_news where docid = ?;",docid];
    }];
}

@end
