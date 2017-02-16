//
//  SqliteStudentFunction.h
//  DatabaseExample
//
//  Created by apple on 17/2/9.
//  Copyright © 2017年 QSP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StudentModel.h"

@interface SqliteStudentFunction : NSObject

/**
 *  获取所有学生
 *
 *  @param callBack 回调
 */
+ (void)getAllStudents:(void (^)(NSArray *students, NSString *msg))callBack;

/**
 *  添加学生
 *
 *  @param studentModel 学生模型
 *  @param succese      添加成功回调
 *  @param failure      添加失败回调
 */
+ (void)addStudent:(StudentModel *)studentModel succesefulBlock:(void (^)(StudentModel *studentModel))succese andFailureBlock:(void (^)(NSString *msg))failure;

/**
 *  更新学生
 *
 *  @param studentModel 学生模型
 *  @param succese      更新成功回调
 *  @param failure      更新失败回调
 */
+ (void)updateStudent:(StudentModel *)studentModel  succesefulBlock:(void (^)(StudentModel *studentModel))succese andFailureBlock:(void (^)(NSString *msg))failure;

/**
 *  按条件搜索学生
 *
 *  @param condition 条件
 *  @param callBack  搜索回调
 */
+ (void)searchStudents:(NSString *)condition andCallBack:(void (^)(NSArray *students, NSString *msg))callBack;

/**
 *  删除学生
 *
 *  @param studentModel 学生模型
 *  @param succese      删除成功回调
 *  @param failure      删除失败回调
 */
+ (void)deleteStudent:(StudentModel *)studentModel  succesefulBlock:(void (^)(StudentModel *studentModel))succese andFailureBlock:(void (^)(NSString *msg))failure;

@end
