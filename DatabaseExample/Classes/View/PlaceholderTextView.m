//
//  PlaceholderTextView.m
//  DatabaseExample
//
//  Created by apple on 17/2/6.
//  Copyright © 2017年 QSP. All rights reserved.
//

#import "PlaceholderTextView.h"

@implementation PlaceholderTextView

- (void)setting
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(beginEditing:) name:UITextViewTextDidBeginEditingNotification object:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endEditing:) name:UITextViewTextDidEndEditingNotification object:self];
    
    self.placeholderColor = [UIColor lightGrayColor];
}

//- (void) beginEditing:(NSNotification*) notification {
//    if ([self.realText isEqualToString:self.placeholder]) {
//        super.text = nil;
//        self.textColor = self.realTextColor;
//    }
//}
//
//- (void) endEditing:(NSNotification*) notification {
//    if ([self.realText isEqualToString:@""] || self.realText == nil) {
//        super.text = self.placeholder;
//        self.textColor = [UIColor lightGrayColor];
//    }
//}
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

@end
