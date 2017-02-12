//
//  StudentCell.m
//  DatabaseExample
//
//  Created by apple on 17/2/10.
//  Copyright © 2017年 QSP. All rights reserved.
//

#import "StudentCell.h"

#define Large_Font              [UIFont systemFontOfSize:16]
#define nomal_Font              [UIFont systemFontOfSize:14]

@interface StudentCell ()

@property (weak, nonatomic) UIImageView *photoImageView;
@property (weak, nonatomic) UILabel *nameLabel;
@property (weak, nonatomic) UILabel *numberLabel;
@property (weak, nonatomic) UILabel *ageLabel;
@property (weak, nonatomic) UIButton *updateButton;

@end

@implementation StudentCell

- (void)setStudentModel:(StudentModel *)studentModel
{
    if (studentModel) {
        _studentModel = studentModel;
        self.imageView.image = studentModel.photo;
        self.nameLabel.text = [NSString stringWithFormat:@"姓名：%@", studentModel.name];
        self.numberLabel.text = [NSString stringWithFormat:@"学号：%@", studentModel.studentNumber];
        self.ageLabel.text = [NSString stringWithFormat:@"年龄：%i", studentModel.age];
    }
}

+ (instancetype)studentCell:(UITableView *)tableView andStudentModel:(StudentModel *)studentModel
{
    static NSString *identifier = @"StudentCell";
    StudentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.studentModel = studentModel;
    
    return cell;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self settingUi];
    }
    
    return self;
}

- (void)settingUi
{
//    self.imageView.backgroundColor = Color_Random;
//    self.textLabel.backgroundColor = Color_Random;
//    self.imageView.layer.cornerRadius = 3;
//    self.imageView.layer.masksToBounds = YES;
//    self.imageView.layer.borderWidth = 0.5;
//    self.imageView.layer.borderColor = [UIColor grayColor].CGColor;
    
//    CGFloat X = SPACING;
//    CGFloat Y = SPACING;
//    CGFloat W = 100;
//    CGFloat H = W;
//    CGRect rect = CGRectMake(X, Y, W, H);
    UIImageView *imageView = [[UIImageView alloc] init];
    [self.contentView addSubview:imageView];
    self.photoImageView = imageView;
    
    UIColor *darkColor = [UIColor blackColor];
    UIColor *lightColor = [UIColor darkGrayColor];
    UILabel *label = [[UILabel alloc] init];
    label.font = Large_Font;
    label.textColor = darkColor;
    [self.contentView addSubview:label];
    self.nameLabel = label;
    
    label = [[UILabel alloc] init];
    label.font = nomal_Font;
    label.textColor = lightColor;
    [self.contentView addSubview:label];
    self.numberLabel = label;
    
    label = [[UILabel alloc] init];
    label.font = nomal_Font;
    label.textColor = lightColor;
    [self.contentView addSubview:label];
    self.ageLabel = label;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [];
}

//- (void)layoutSubviews
//{
//    [super layoutSubviews];
//    
//    CGFloat X = SPACING;
//    CGFloat Y = 7;
//    CGFloat W = 30;
//    CGFloat H = W;
//    self.imageView.frame = CGRectMake(X, Y, W, H);
//    
//    X = self.imageView.frameRight + SPACING;
//    Y = 0;
//    W = self.frameWidth - X;
//    H = 44;
//    self.textLabel.frame = CGRectMake(X, Y, W, H);
//}

@end
