//
//  DetailViewController.h
//  DatabaseExample
//
//  Created by apple on 17/2/6.
//  Copyright © 2017年 QSP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StudentModel.h"

typedef NS_ENUM(NSInteger, DetailViewControllerType) {
    DetailViewControllerTypeShow = 0,
    DetailViewControllerTypeEdit = 1
};

@class DetailViewController;
@protocol DetailViewControllerDelegate <NSObject>

@optional
- (void)detailViewControllerAfterAdd:(DetailViewController *)ctr;
- (void)detailViewControllerAfterChange:(DetailViewController *)ctr;
- (void)detailViewControllerAfterDelete:(DetailViewController *)ctr;

@end

@interface DetailViewController : UITableViewController

@property (assign,nonatomic) DetailViewControllerType type;
@property (strong,nonatomic) StudentModel *studentModel;
@property (weak,nonatomic) id<DetailViewControllerDelegate> delegate;

+ (instancetype)detailViewController:(StudentModel *)studentModel andType:(DetailViewControllerType)type;

@end
