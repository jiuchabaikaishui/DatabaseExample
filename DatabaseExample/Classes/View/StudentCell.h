//
//  StudentCell.h
//  DatabaseExample
//
//  Created by apple on 17/2/10.
//  Copyright © 2017年 QSP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StudentModel.h"

@class StudentCell;

@protocol StudentCellDelegate <NSObject>

- (void)studentCellAfterUpdate:(StudentCell *)cell;

@end

@interface StudentCell : UITableViewCell

@property (strong,nonatomic) StudentModel *studentModel;

+ (instancetype)studentCell:(UITableView *)tableView andStudentModel:(StudentModel *)studentModel;

@end
