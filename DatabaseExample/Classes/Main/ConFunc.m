//
//  ConFunc.m
//  MyWeibo
//
//  Created by apple on 16/2/3.
//  Copyright © 2016年 QSP. All rights reserved.
//

#import "ConFunc.h"

@implementation ConFunc

//判空
+ (BOOL)isBlankString:(NSString *)string
{
    if (string == nil || string == NULL)
        return YES;
    
    if ([string isKindOfClass:[NSNull class]])
        return YES;
    
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0)
        return YES;
    
    return NO;
}

+ (UIImage *)imageFromColor:(UIColor *)color
{
    CGSize size = CGSizeMake(CGFLOAT_MIN + 1, CGFLOAT_MIN + 1);
    
    return [self imageFromColor:color andSize:size];
}

+ (UIImage *)imageFromColor:(UIColor *)color andSize:(CGSize)size
{
    //CGRect rect = CGRectMake(0, 0, CGFLOAT_MIN + 1, CGFLOAT_MIN + 1);
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, (CGRect){{0, 0}, size});
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}

@end
