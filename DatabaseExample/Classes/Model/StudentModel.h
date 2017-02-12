//
//  StudentModel.h
//  DatabaseExample
//
//  Created by apple on 17/2/6.
//  Copyright © 2017年 QSP. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StudentModel : NSObject

@property (assign, nonatomic) int identifier;
@property (strong, nonatomic) UIImage *photo;
@property (copy,nonatomic) NSString *studentNumber;
@property (copy, nonatomic) NSString *name;
@property (assign, nonatomic) int age;
@property (copy, nonatomic) NSString *address;
@property (copy,nonatomic) NSString *describe;

@end
