//
//  DataBase.m
//  新闻
//
//  Created by gyh on 16/4/25.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "DataBase.h"
#import "FMDB.h"

#import "CollectModel.h"   //新闻收藏model
#import "PhotoCollectModel.h"  //图片收藏model

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
    
    [_queue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"create table if not exists t_photos (id integer primary key autoincrement, title text,image_url text,image_width real,image_height real,time text);"];
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

#pragma mark - 图片数据
+ (void)addPhotosWithTitle:(NSString *)title image_url:(NSString *)image_url image_width:(NSString *)image_width image_height:(NSString *)image_height time:(NSString *)time
{
    [_queue inDatabase:^(FMDatabase *db) {
        // 2.存储数据
        [db executeUpdate:@"insert into t_photos (title,image_url,image_width,image_height,time) values(?,?,?,?,?)",title,image_url,image_width,image_height,time];
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

#pragma mark 显示图片收藏数据
+ (NSMutableArray *)basePhotoDisplay
{
    __block NSMutableArray *dicArray = nil;
    [_queue inDatabase:^(FMDatabase *db) {
        
        dicArray = [NSMutableArray array];
        // 1.查询数据
        FMResultSet *rs = [db executeQuery:@"select * from t_photos"];
        
        // 2.遍历结果集
        while (rs.next) {
            NSString *title = [rs stringForColumn:@"title"];
            NSString *image_url = [rs stringForColumn:@"image_url"];
            CGFloat image_width = [[rs stringForColumn:@"image_width"] floatValue];
            CGFloat image_height = [[rs stringForColumn:@"image_height"] floatValue];
            NSString *time = [rs stringForColumn:@"time"];
            
            PhotoCollectModel *photomodel = [[PhotoCollectModel alloc]init];
            photomodel.title = title;
            photomodel.image_url = image_url;
            photomodel.image_width = image_width;
            photomodel.image_height = image_height;
            photomodel.time = time;
            
            [dicArray addObject:photomodel];
        }
    }];
    return dicArray;
}


//判断新闻数据是否收藏
+ (NSString *)queryWithCollect:(NSString *)docid
{
    __block NSString *str = @"0";
    [_queue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:@"select * from t_news where docid = ?;",docid];
        while (rs.next) {
            NSString *docid = [rs stringForColumn:@"docid"];
            DLog(@"%@",docid);
            str = @"1";
        }
    }];
    return str;
}

//读取图片是否收藏
+ (NSString *)queryWithCollectPhoto:(NSString *)photourl
{
    __block NSString *str = @"0";
    [_queue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:@"select * from t_photos where image_url = ?;",photourl];
        while (rs.next) {
//            NSString *docid = [rs stringForColumn:@"image_url"];
//            DLog(@"%@",docid);
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

#pragma mark -  删除图片单条数据
+ (void)deletetableWithPhoto:(NSString *)photourl
{
    [_queue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"delete from t_photos where image_url = ?;",photourl];
    }];
}

@end
