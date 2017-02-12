//
//  DatabaseViewController.h
//  DatabaseExample
//
//  Created by apple on 17/2/6.
//  Copyright © 2017年 QSP. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, DatabaseViewControllerType) {
    DatabaseViewControllerTypeSqlite3 = 0,
    DatabaseViewControllerTypeFMDB = 1,
    DatabaseViewControllerTypeFMDBQure = 2
};

@interface DatabaseViewController : UIViewController

@property (assign,nonatomic) DatabaseViewControllerType type;

@end
