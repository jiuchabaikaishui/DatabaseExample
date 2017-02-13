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
@property (weak,nonatomic) UIButton *updateButton;

@end

@implementation StudentCell

- (void)setStudentModel:(StudentModel *)studentModel
{
    if (studentModel) {
        _studentModel = studentModel;
        self.photoImageView.image = studentModel.photo;
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
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.layer.cornerRadius = 5;
    imageView.layer.masksToBounds = YES;
    imageView.layer.borderWidth = 0.5;
    imageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
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
    [button setTitle:@"更新" forState:UIControlStateNormal];
    button.titleLabel.textColor = darkColor;
    [button setBackgroundImage:[ConFunc imageFromColor:Color_Random andSize:CGSizeMake(100, 100)] forState:UIControlStateNormal];
    [button setBackgroundImage:[ConFunc imageFromColor:Color_Random andSize:CGSizeMake(100, 100)] forState:UIControlStateSelected];
    button.layer.cornerRadius = 5;
    button.layer.masksToBounds = YES;
    button.layer.borderWidth = 0.5;
    button.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [button addTarget:self action:@selector(updateAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:button];
    self.updateButton = button;
}

- (void)updateAction:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(studentCellAfterUpdate:)]) {
        [self.delegate studentCellAfterUpdate:self];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat X = SPACING;
    CGFloat Y = SPACING;
    CGFloat W = 60;
    CGFloat H = W;
    self.photoImageView.frame = CGRectMake(X, Y, W, H);
    
    X = self.photoImageView.frameRight + SPACING;
    W = self.frameWidth - X - H - 4*SPACING;
    H = 20;
    self.nameLabel.frame = CGRectMake(X, Y, W, H);
    
    Y = self.nameLabel.frameBottom;
    self.numberLabel.frame = CGRectMake(X, Y, W, H);
    
    Y = self.numberLabel.frameBottom;
    self.ageLabel.frame = CGRectMake(X, Y, W, H);
    
    X = self.nameLabel.frameRight + SPACING;
    Y = SPACING;
    W = 60;
    H = W;
    self.updateButton.frame = CGRectMake(X, Y, W, H);
    
    self.backgroundView.frame = CGRectMake(0, self.backgroundView.frame.origin.y, self.backgroundView.frame.size.width, self.backgroundView.frame.size.height);
}

@end
