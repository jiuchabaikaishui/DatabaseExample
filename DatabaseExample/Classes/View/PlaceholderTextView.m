//
//  PlaceholderTextView.m
//  DatabaseExample
//
//  Created by apple on 17/2/6.
//  Copyright © 2017年 QSP. All rights reserved.
//

#import "PlaceholderTextView.h"

@interface PlaceholderTextView ()

@end

@implementation PlaceholderTextView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setting];
    }
    
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self setting];
    }
    
    return self;
}

- (void)setting
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changedText:) name:UITextViewTextDidChangeNotification object:self];
    
    self.placeholderColor = [UIColor lightGrayColor];
}

- (void)setPlaceholder:(NSString *)placeholder
{
    if (placeholder) {
        _placeholder = placeholder;
        [self setNeedsDisplay];
    }
}
- (void)setFont:(UIFont *)font
{
    [super setFont:font];
    
    [self setNeedsDisplay];
}
- (void)setPlaceholderColor:(UIColor *)placeholderColor
{
    _placeholderColor = placeholderColor;
    [self setNeedsDisplay];
}
- (void)changedText:(NSNotification *)notifiction
{
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    if ([self isBlankString:self.text] && self.placeholder) {
        NSDictionary *attributes = @{NSFontAttributeName:self.font, NSForegroundColorAttributeName:self.placeholderColor};
        CGRect placeholderRect = CGRectMake(5, 8, rect.size.width - 10, rect.size.height - 16);
        [self.placeholder drawInRect:placeholderRect withAttributes:attributes];
    }
}

//判空
- (BOOL)isBlankString:(NSString *)string
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
