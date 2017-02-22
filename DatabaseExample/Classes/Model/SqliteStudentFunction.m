//
//  SqliteStudentFunction.m
//  DatabaseExample
//
//  Created by apple on 17/2/9.
//  Copyright © 2017年 QSP. All rights reserved.
//

#import "SqliteStudentFunction.h"
#import "SqliteDBAccess.h"
#import <sqlite3.h>

//数据库路径
#define SqlitePathStr           [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"DatabaseExample.sqlite"]
//学生表名
#define StudentTableName        @"t_student"

@implementation SqliteStudentFunction

static sqlite3 *database;

/**
 *  在手动调用类里的任何方法前自动调用一次
 */
+ (void)initialize
{
    [SqliteDBAccess openDBPath:SqlitePathStr succesefulBlock:^(sqlite3 *db) {
        DebugLog(@"数据库打开成功！");
        [SqliteDBAccess executeSql:[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (identifier integer PRIMARY KEY AUTOINCREMENT, name text NOT NULL, studentNumber text NOT NULL UNIQUE, photo blob, age integer NOT NULL, address text, describe text);", StudentTableName] toDatabase:db succesefulBlock:^{
            database = db;
            DebugLog(@"学生表创建成功!");
        } andFailureBlock:^(NSString *msg) {
            DebugLog(@"学生表创建失败，%@", msg);
        }];
    } andFailureBlock:^(NSString *msg) {
        DebugLog(@"数据库打开失败，%@", msg);
    }];
}

/**
 *  获取所有学生
 *
 *  @param callBack 回调
 */
+ (void)getAllStudents:(void (^)(NSArray *students, NSString *msg))callBack
{
    [SqliteDBAccess prepareSql:[NSString stringWithFormat:@"SELECT * FROM %@;", StudentTableName] fromDatabase:database succesefulBlock:^(sqlite3_stmt *stmt) {
        if (callBack) {
            callBack([self getStudentsFromStatement:stmt], @"学生获取成功！");
        }
        
        //在遍历完结果集后，调用sqlite3_finalize以释放和预编译的语句相关的资源。
        sqlite3_finalize(stmt);
    } andFailureBlock:^(NSString *msg) {
        if (callBack) {
            callBack(nil, [NSString stringWithFormat:@"学生获取失败，%@", msg]);
        }
    }];
}

/**
 *  按条件搜索学生
 *
 *  @param condition 条件
 *  @param callBack  搜索回调
 */
+ (void)searchStudents:(NSString *)condition andCallBack:(void (^)(NSArray *students, NSString *msg))callBack
{//
    
    int age = [condition intValue];
    NSString *selectStr;
    if (age != 0 || [condition isEqualToString:@"0"]) {
        selectStr = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE name LIKE ? or studentNumber LIKE ? or age LIKE ?;", StudentTableName];
    }
    else
    {
        selectStr = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE name LIKE ? or studentNumber LIKE ?;", StudentTableName];
    }
    [SqliteDBAccess prepareSql:selectStr fromDatabase:database succesefulBlock:^(sqlite3_stmt *stmt) {
        sqlite3_bind_text(stmt, 1, [NSString stringWithFormat:@"%%%@%%", condition].UTF8String, -1, NULL);
        sqlite3_bind_text(stmt, 2, [NSString stringWithFormat:@"%%%@%%", condition].UTF8String, -1, NULL);
        if (age != 0 || [condition isEqualToString:@"0"]) {
            sqlite3_bind_int(stmt, 3, age);
        }
        
        if (callBack) {
            callBack([self getStudentsFromStatement:stmt], @"搜索成功！");
        }
        
        //在遍历完结果集后，调用sqlite3_finalize以释放和预编译的语句相关的资源。
        sqlite3_finalize(stmt);
    } andFailureBlock:^(NSString *msg) {
        if (callBack) {
            callBack(nil, msg);
        }
    }];
}

/**
 *  添加学生
 *
 *  @param studentModel 学生模型
 *  @param succese      添加成功回调
 *  @param failure      添加失败回调
 */
+ (void)addStudent:(StudentModel *)studentModel succesefulBlock:(void (^)(StudentModel *studentModel))succese andFailureBlock:(void (^)(NSString *msg))failure
{
    //未添加事务的代码
    {
//        //先插入学生数据
//        [SqliteDBAccess prepareSql:[NSString stringWithFormat:@"INSERT INTO %@ (name, studentNumber, photo, age, address, describe) VALUES(?, ?, ?, ?, ?, ?);", StudentTableName] fromDatabase:database succesefulBlock:^(sqlite3_stmt *stmt) {
//            NSData *data = UIImagePNGRepresentation(studentModel.photo);
//            sqlite3_bind_text(stmt, 1, studentModel.name.UTF8String, -1, NULL);
//            sqlite3_bind_text(stmt, 2, studentModel.studentNumber.UTF8String, -1, NULL);
//            sqlite3_bind_blob(stmt, 3, [data bytes], (int)[data length], NULL);
//            sqlite3_bind_int(stmt, 4, studentModel.age);
//            sqlite3_bind_text(stmt, 5, studentModel.address.UTF8String, -1, NULL);
//            sqlite3_bind_text(stmt, 6, studentModel.describe.UTF8String, -1, NULL);
//            if (sqlite3_step(stmt) == SQLITE_DONE) {
//                //插入成功后，查出此条数据
//                [SqliteDBAccess prepareSql:[NSString stringWithFormat:@"SELECT * FROM %@ WHERE studentNumber = ?;", StudentTableName] fromDatabase:database succesefulBlock:^(sqlite3_stmt *stmt) {
//                    sqlite3_bind_text(stmt, 1, studentModel.studentNumber.UTF8String, -1, NULL);
//                    StudentModel *model = [[self getStudentsFromStatement:stmt] firstObject];
//                    studentModel.identifier = model.identifier;
//                    
//                    if (succese) {
//                        succese(studentModel);
//                    }
//                    
//                    //在遍历完结果集后，调用sqlite3_finalize以释放和预编译的语句相关的资源。
//                    sqlite3_finalize(stmt);
//                } andFailureBlock:^(NSString *msg) {
//                    if (failure) {
//                        failure(msg);
//                    }
//                }];
//            }
//            else
//            {
//                if (failure) {
//                    failure([NSString stringWithFormat:@"添加学生失败，%@", [NSString stringWithUTF8String:sqlite3_errmsg(database)]]);
//                }
//            }
//            
//            //在遍历完结果集后，调用sqlite3_finalize以释放和预编译的语句相关的资源。
//            sqlite3_finalize(stmt);
//        } andFailureBlock:^(NSString *msg) {
//            if (failure) {
//                failure([NSString stringWithFormat:@"添加学生失败，%@", msg]);
//            }
//        }];
    }
    
    //添加事务的代码
    {
        //开启事务
        [SqliteDBAccess executeSql:@"BEGIN" toDatabase:database succesefulBlock:^{
            DebugLog(@"事务启动成功！");
            
            [SqliteDBAccess prepareSql:[NSString stringWithFormat:@"INSERT INTO %@ (name, studentNumber, photo, age, address, describe) VALUES(?, ?, ?, ?, ?, ?);", StudentTableName] fromDatabase:database succesefulBlock:^(sqlite3_stmt *stmt) {
                NSData *data = UIImagePNGRepresentation(studentModel.photo);
                sqlite3_bind_text(stmt, 1, studentModel.name.UTF8String, -1, NULL);
                sqlite3_bind_text(stmt, 2, studentModel.studentNumber.UTF8String, -1, NULL);
                sqlite3_bind_blob(stmt, 3, [data bytes], (int)[data length], NULL);
                sqlite3_bind_int(stmt, 4, studentModel.age);
                sqlite3_bind_text(stmt, 5, studentModel.address.UTF8String, -1, NULL);
                sqlite3_bind_text(stmt, 6, studentModel.describe.UTF8String, -1, NULL);
                if (sqlite3_step(stmt) == SQLITE_DONE) {
                    [SqliteDBAccess prepareSql:[NSString stringWithFormat:@"SELECT * FROM %@ WHERE studentNumber = ?;", StudentTableName] fromDatabase:database succesefulBlock:^(sqlite3_stmt *stmt) {
                        sqlite3_bind_text(stmt, 1, studentModel.studentNumber.UTF8String, -1, NULL);
                        StudentModel *model = [[self getStudentsFromStatement:stmt] firstObject];
                        if (studentModel) {
                            studentModel.identifier = model.identifier;
                            if (succese) {
                                succese(studentModel);
                            }
                            
                            //提交事务
                            [SqliteDBAccess executeSql:@"COMMIT" toDatabase:database succesefulBlock:^{
                                DebugLog(@"提交事务成功！");
                            } andFailureBlock:^(NSString *msg) {
                                DebugLog(@"提交事务失败：%@", msg);
                            }];
                        }
                        else
                        {
                            //回滚事务
                            [SqliteDBAccess executeSql:@"ROLLBACK" toDatabase:database succesefulBlock:^{
                                DebugLog(@"回滚成功！");
                            } andFailureBlock:^(NSString *msg) {
                                DebugLog(@"回滚失败：%@", msg);
                            }];
                        }
                        
                        //在遍历完结果集后，调用sqlite3_finalize以释放和预编译的语句相关的资源。
                        sqlite3_finalize(stmt);
                    } andFailureBlock:^(NSString *msg) {
                        if (failure) {
                            failure(msg);
                            
                            //回滚事务
                            [SqliteDBAccess executeSql:@"ROLLBACK" toDatabase:database succesefulBlock:^{
                                DebugLog(@"回滚成功！");
                            } andFailureBlock:^(NSString *msg) {
                                DebugLog(@"回滚失败：%@", msg);
                            }];
                        }
                    }];
                }
                else
                {
                    if (failure) {
                        failure([NSString stringWithFormat:@"添加学生失败，%@", [NSString stringWithUTF8String:sqlite3_errmsg(database)]]);
                    }
                }
                
                //在遍历完结果集后，调用sqlite3_finalize以释放和预编译的语句相关的资源。
                sqlite3_finalize(stmt);
            } andFailureBlock:^(NSString *msg) {
                if (failure) {
                    failure([NSString stringWithFormat:@"添加学生失败，%@", msg]);
                }
                
                //回滚事务
                [SqliteDBAccess executeSql:@"ROLLBACK" toDatabase:database succesefulBlock:^{
                    DebugLog(@"回滚成功！");
                } andFailureBlock:^(NSString *msg) {
                    DebugLog(@"回滚失败：%@", msg);
                }];
            }];
        } andFailureBlock:^(NSString *msg) {
            DebugLog(@"事务启动失败：%@", msg);
        }];
    }
}

/**
 *  更新学生
 *
 *  @param studentModel 学生模型
 *  @param succese      更新成功回调
 *  @param failure      更新失败回调
 */
+ (void)updateStudent:(StudentModel *)studentModel  succesefulBlock:(void (^)(StudentModel *studentModel))succese andFailureBlock:(void (^)(NSString *msg))failure
{
    [SqliteDBAccess prepareSql:[NSString stringWithFormat:@"UPDATE %@ SET name = ?, studentNumber = ?, photo = ?, age = ?, address = ?, describe = ? WHERE identifier = ?;", StudentTableName] fromDatabase:database succesefulBlock:^(sqlite3_stmt *stmt) {
        NSData *data = UIImagePNGRepresentation(studentModel.photo);
        sqlite3_bind_text(stmt, 1, studentModel.name.UTF8String, -1, NULL);
        sqlite3_bind_text(stmt, 2, studentModel.studentNumber.UTF8String, -1, NULL);
        sqlite3_bind_blob(stmt, 3, [data bytes], (int)[data length], NULL);
        sqlite3_bind_int(stmt, 4, studentModel.age);
        sqlite3_bind_text(stmt, 5, studentModel.address.UTF8String, -1, NULL);
        sqlite3_bind_text(stmt, 6, studentModel.describe.UTF8String, -1, NULL);
        sqlite3_bind_int(stmt, 7, studentModel.identifier);
        //执行完成
        if (sqlite3_step(stmt) == SQLITE_DONE) {
            if (succese) {
                succese(studentModel);
            }
        }
        else
        {
            if (failure) {
                failure([NSString stringWithFormat:@"更新学生失败，%@", [NSString stringWithUTF8String:sqlite3_errmsg(database)]]);
            }
        }
        
        //在遍历完结果集后，调用sqlite3_finalize以释放和预编译的语句相关的资源。
        sqlite3_finalize(stmt);
    } andFailureBlock:^(NSString *msg) {
        if (failure) {
            failure([NSString stringWithFormat:@"更新学生失败，%@", msg]);
        }
    }];
}

/**
 *  删除学生
 *
 *  @param studentModel 学生模型
 *  @param succese      删除成功回调
 *  @param failure      删除失败回调
 */
+ (void)deleteStudent:(StudentModel *)studentModel  succesefulBlock:(void (^)(StudentModel *studentModel))succese andFailureBlock:(void (^)(NSString *msg))failure
{
    [SqliteDBAccess executeSql:[NSString stringWithFormat:@"DELETE FROM %@ WHERE identifier = %i;", StudentTableName, studentModel.identifier] toDatabase:database succesefulBlock:^{
        if (succese) {
            succese(studentModel);
        }
    } andFailureBlock:^(NSString *msg) {
        if (failure) {
            failure(msg);
        }
    }];
}

/**
 *  从sqlite3_stmt中获取学生数据
 *
 *  @param stmt sqlite3_stmt结果集
 *
 *  @return 学生数组
 */
+ (NSArray *)getStudentsFromStatement:(sqlite3_stmt *)stmt
{
    NSMutableArray *students = [NSMutableArray arrayWithCapacity:1];
    StudentModel *studentModel;
    while (sqlite3_step(stmt) == SQLITE_ROW) {
        studentModel = [[StudentModel alloc] init];
        studentModel.identifier = sqlite3_column_int(stmt, 0);
        char *name = (char *)sqlite3_column_text(stmt, 1);
        char *studentNumber = (char *)sqlite3_column_text(stmt, 2);
        void *photo = (void *)sqlite3_column_blob(stmt, 3);
        studentModel.name = name ? [NSString stringWithUTF8String:name] : nil;
        studentModel.studentNumber = studentNumber ? [NSString stringWithUTF8String:studentNumber] : nil;
        studentModel.photo = photo ? [UIImage imageWithData:[NSData dataWithBytes:photo length:sqlite3_column_bytes(stmt, 3)]] : nil;
        studentModel.age = sqlite3_column_int(stmt, 4);
        char *address = (char *)sqlite3_column_text(stmt, 5);
        char *describe = (char *)sqlite3_column_text(stmt, 6);
        studentModel.address = address ? [NSString stringWithUTF8String:address] : nil;
        studentModel.describe = describe ? [NSString stringWithUTF8String:describe] : nil;
        
        [students addObject:studentModel];
    }
    
    return students;
}

@end
