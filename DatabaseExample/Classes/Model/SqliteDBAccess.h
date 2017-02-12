//
//  SqliteDBAccess.h
//  DatabaseExample
//
//  Created by apple on 17/2/8.
//  Copyright © 2017年 QSP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface SqliteDBAccess : NSObject

/**
 *  打开数据库
 *
 *  @param path    数据库路径
 *  @param success 打开成功的回调
 *  @param falure  打开失败的回调
 */
+ (void)openDBPath:(NSString *)path succesefulBlock:(void (^)(sqlite3 *db))success andFailureBlock:(void (^)(NSString *msg))failure;

/**
 *  关闭数据库
 *
 *  @param database 数据库链接
 *  @param succese  成功的回调
 *  @param failure  失败的回调
 */
+ (void)closeDB:(sqlite3 *)database succesefulBlock:(void (^)())succese andFailureBlock:(void (^)(NSString *msg))failure;

/**
 *  执行SQL语句（不适应查询语句和blob(NSData)二进制数据类型的操作）
 *
 *  @param sqStr    SQL语句
 *  @param database 数据库链接
 *  @param succese  成功的回调
 *  @param failure  失败的回调
 */
+ (void)executeSql:(NSString *)sqStr toDatabase:(sqlite3 *)database succesefulBlock:(void (^)())succese andFailureBlock:(void (^)(NSString *msg))failure;

/**
 *  准备需要sqlite3_stmt结果集的SQL语句
 *
 *  @param sqStr    SQL语句
 *  @param database 数据库连接
 *  @param succese  成功的回调
 *  @param failure  失败的回调
 */
+ (void)prepareSql:(NSString *)sqStr fromDatabase:(sqlite3 *)database succesefulBlock:(void (^)(sqlite3_stmt *stmt))succese andFailureBlock:(void (^)(NSString *msg))failure;

@end
