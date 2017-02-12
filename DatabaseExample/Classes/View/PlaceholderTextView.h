//
//  PlaceholderTextView.h
//  DatabaseExample
//
//  Created by apple on 17/2/6.
//  Copyright © 2017年 QSP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlaceholderTextView : UITextView

@property (copy,nonatomic) NSString *placeholder;
@property (strong,nonatomic) UIColor *placeholderColor;

@end
