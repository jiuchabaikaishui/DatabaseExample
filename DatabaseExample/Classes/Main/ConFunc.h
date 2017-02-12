//
//  ConFunc.h
//  MyWeibo
//
//  Created by apple on 16/2/3.
//  Copyright © 2016年 QSP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ConFunc : NSObject

//判空
+ (BOOL)isBlankString:(NSString *)string;

+ (UIImage *)imageFromColor:(UIColor *)color;

+ (UIImage *)imageFromColor:(UIColor *)color andSize:(CGSize)size;

@end
