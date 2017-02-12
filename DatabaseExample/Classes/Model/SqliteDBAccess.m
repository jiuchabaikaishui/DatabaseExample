//
//  SqliteDBAccess.m
//  DatabaseExample
//
//  Created by apple on 17/2/8.
//  Copyright © 2017年 QSP. All rights reserved.
//

#import "SqliteDBAccess.h"

@implementation SqliteDBAccess

/**
 *  打开数据库
 *
 *  @param path    数据库路径
 *  @param success 打开成功的回调
 *  @param falure  打开失败的回调
 */
+ (void)openDBPath:(NSString *)path succesefulBlock:(void (^)(sqlite3 *db))success andFailureBlock:(void (^)(NSString *msg))failure
{
    sqlite3 *database = NULL;
    int result = sqlite3_open(path.UTF8String, &database);
    if (result == SQLITE_OK) {
        if (success) {
            success(database);
        }
    }
    else
    {
        if (failure) {
            const char *msg = sqlite3_errmsg(database);
            failure([NSString stringWithUTF8String:msg]);
        }
        
        if (database) {
            [self closeDB:database succesefulBlock:nil andFailureBlock:nil];
        }
    }
}

/**
 *  关闭数据库
 *
 *  @param database 数据库链接
 *  @param succese  成功的回调
 *  @param failure  失败的回调
 */
+ (void)closeDB:(sqlite3 *)database succesefulBlock:(void (^)())succese andFailureBlock:(void (^)(NSString *msg))failure
{
    int result = sqlite3_close(database);
    if (result == SQLITE_OK) {
        if (succese) {
            succese();
        }
    }
    else
    {
        if (failure) {
            failure([NSString stringWithUTF8String:sqlite3_errmsg(database)]);
        }
    }
}

/**
 *  执行SQL语句（不适应查询语句和blob(NSData)二进制数据类型的操作）
 *
 *  @param sqStr    SQL语句
 *  @param database 数据库链接
 *  @param succese  成功的回调
 *  @param failure  失败的回调
 */
+ (void)executeSql:(NSString *)sqStr toDatabase:(sqlite3 *)database succesefulBlock:(void (^)())succese andFailureBlock:(void (^)(NSString *msg))failure
{
    DebugLog(@"%@", sqStr);
    char *msg = NULL;
    int result = sqlite3_exec(database, sqStr.UTF8String, NULL, NULL, &msg);
    if (result == SQLITE_OK) {
        if (succese) {
            succese();
        }
    }
    else
    {
        if (failure) {
            failure([NSString stringWithUTF8String:msg]);
        }
    }
}

/**
 *  准备需要sqlite3_stmt结果集的SQL语句
 *
 *  @param sqStr    SQL语句
 *  @param database 数据库连接
 *  @param succese  成功的回调
 *  @param failure  失败的回调
 */
+ (void)prepareSql:(NSString *)sqStr fromDatabase:(sqlite3 *)database succesefulBlock:(void (^)(sqlite3_stmt *stmt))succese andFailureBlock:(void (^)(NSString *msg))failure
{
    DebugLog(@"%@", sqStr);
    sqlite3_stmt *stmt = NULL;
    int result = sqlite3_prepare_v2(database, sqStr.UTF8String, -1, &stmt, NULL);
    if (result == SQLITE_OK) {
        if (succese) {
            succese(stmt);
        }
    }
    else
    {
        if (failure) {
            failure(@"SQL语句是非法的。");
        }
    }
}

@end
