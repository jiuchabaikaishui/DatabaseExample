//
//  DatabaseViewController.m
//  DatabaseExample
//
//  Created by apple on 17/2/6.
//  Copyright © 2017年 QSP. All rights reserved.
//

#import "DatabaseViewController.h"
#import "StudentModel.h"
#import "DetailViewController.h"
#import "SqliteStudentFunction.h"
#import "StudentCell.h"

@interface DatabaseViewController ()<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, DetailViewControllerDelegate>

@property (strong,nonatomic) NSMutableArray *studentsArr;
@property (weak,nonatomic) UITableView *tableView;
@property (strong,nonatomic) StudentModel *currentStudentModel;

@end

@implementation DatabaseViewController

#pragma mark - 属性方法
- (NSMutableArray *)studentsArr
{
    if (_studentsArr == nil) {
        _studentsArr = [NSMutableArray arrayWithCapacity:1];
        
        [SqliteStudentFunction getAllStudents:^(NSArray *students, NSString *msg) {
            [_studentsArr addObjectsFromArray:[self groupedByLetter:students]];
            
            DebugLog(@"%@", msg);
        }];
    }
    
    return _studentsArr;
}

//本地化下按首字母分组排序的神器——UILocalizedIndexedCollation
- (NSArray *)groupedByLetter:(NSArray *)sourceArr
{
    UILocalizedIndexedCollation *collation = [UILocalizedIndexedCollation currentCollation];
    
    //按照索引创建对应的数组
    NSMutableArray *sectionsArr = [NSMutableArray arrayWithCapacity:collation.sectionTitles.count];
    for (int index = 0; index < collation.sectionTitles.count; index++) {
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:1];
        [sectionsArr addObject:arr];
    }
    
    for (StudentModel *studentModel in sourceArr) {
        NSInteger section = [collation sectionForObject:studentModel collationStringSelector:@selector(name)];
        [sectionsArr[section] addObject:studentModel];
    }
    
    NSMutableArray *resultArr = [NSMutableArray arrayWithCapacity:1];
    for (NSArray *arr in sectionsArr) {
        [resultArr addObject:[NSMutableArray arrayWithArray:[collation sortedArrayFromArray:arr collationStringSelector:@selector(name)]]];
    }
    
    DebugLog(@"%@", resultArr);
    return resultArr;
}
#pragma mark - 控制器周期
- (void)dealloc
{
    [Notification_Default_Center removeObserver:self];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self settingUi];
    
    [Notification_Default_Center addObserver:self selector:@selector(addStudent:) name:AddStudentNotifiction object:nil];
    [Notification_Default_Center addObserver:self selector:@selector(deleteStudent:) name:DeleteStudentNotifiction object:nil];
    [Notification_Default_Center addObserver:self selector:@selector(changeStudent:) name:ChangeStudentNotifiction object:nil];
}

- (void)addStudent:(NSNotification *)sender
{
    StudentModel *studentModel = sender.userInfo[@"student"];
    if (studentModel) {
        UILocalizedIndexedCollation *collation = [UILocalizedIndexedCollation currentCollation];
        NSInteger section = [collation sectionForObject:studentModel collationStringSelector:@selector(name)];
        NSMutableArray *singleSection = self.studentsArr[section];
        [singleSection addObject:studentModel];
        NSArray *tempSection = [collation sortedArrayFromArray:singleSection collationStringSelector:@selector(name)];
        singleSection = [NSMutableArray arrayWithArray:tempSection];
        NSInteger row = [singleSection indexOfObject:studentModel];
        [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:row inSection:section]] withRowAnimation:UITableViewRowAnimationNone];
    }
}
- (void)deleteStudent:(NSNotification *)sender
{
    StudentModel *studentModel = sender.userInfo[@"student"];
    if (studentModel) {
        NSUInteger index = [self.studentsArr indexOfObject:studentModel];
        [self.studentsArr removeObject:studentModel];
        [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    }
}
- (void)changeStudent:(NSNotification *)sender
{
    StudentModel *studentModel = sender.userInfo[@"student"];
    if (studentModel) {
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[self.studentsArr indexOfObject:studentModel] inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    }
}

#pragma mark - 自定义方法
- (void)settingUi
{
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithTitle:@"添加" style:UIBarButtonItemStylePlain target:self action:@selector(addAction:)];
    UIBarButtonItem *deleteItem = [[UIBarButtonItem alloc] initWithTitle:@"删除" style:UIBarButtonItemStylePlain target:self action:@selector(deleteAction:)];
    self.navigationItem.rightBarButtonItems = @[addItem, deleteItem];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:MainScreen_Bounds style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, MainScreen_Width - 16, 44)];
    searchBar.placeholder = @"搜索";
    searchBar.delegate = self;
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreen_Width, 44)];
    [headerView addSubview:searchBar];
    tableView.tableHeaderView = searchBar;
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    tableView.sectionIndexColor = [UIColor blackColor];
    tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
}
- (void)addAction:(UIBarButtonItem *)sender
{
    DetailViewController *nextCtr = [DetailViewController detailViewController:nil andType:DetailViewControllerTypeEdit];
    nextCtr.delegate = self;
    nextCtr.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:nextCtr animated:YES];
}
- (void)deleteAction:(UIBarButtonItem *)sender
{
    if ([sender.title isEqualToString:@"删除"]) {
        self.tableView.editing = YES;
        [sender setTitle:@"取消"];
    }
    else
    {
        self.tableView.editing = NO;
        [sender setTitle:@"删除"];
    }
}
- (void)updateAction:(UIButton *)sender
{
    StudentModel *studentModel = self.studentsArr[sender.tag];
    
    DetailViewController *nextCtr = [DetailViewController detailViewController:studentModel andType:DetailViewControllerTypeEdit];
    nextCtr.delegate = self;
    nextCtr.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:nextCtr animated:YES];
}
#pragma mark - <UITableViewDelegate, UITableViewDataSource>代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *arr = self.studentsArr[section];
    return arr.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.studentsArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"CellIdentifier";
    StudentCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[StudentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(0, 0, 50, 30);
        [button setTitle:@"更新" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(updateAction:) forControlEvents:UIControlEventTouchUpInside];
        cell.accessoryView = button;
    }
    
    StudentModel *studentModel = self.studentsArr[indexPath.section][indexPath.row];
    cell.imageView.image = studentModel.photo ? studentModel.photo : [ConFunc imageFromColor:Color_Random andSize:CGSizeMake(100, 100)];
    cell.textLabel.text = [NSString stringWithFormat:@"%@，学号：%@，年龄：%d", studentModel.name, studentModel.studentNumber, studentModel.age];
    cell.accessoryView.tag = indexPath.row;
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    StudentModel *studentModel = self.studentsArr[indexPath.section][indexPath.row];
    
    DetailViewController *nextCtr = [DetailViewController detailViewController:studentModel andType:DetailViewControllerTypeShow];
    nextCtr.delegate = self;
    nextCtr.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:nextCtr animated:YES];
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if ([self.studentsArr[section] count] > 0) {
        return [UILocalizedIndexedCollation currentCollation].sectionTitles[section];
    }
    
    return nil;
}
- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    NSMutableArray *resultArr = [NSMutableArray arrayWithCapacity:1];
    for (NSArray *arr in self.studentsArr) {
        if (arr.count > 0) {
            NSInteger index = [self.studentsArr indexOfObject:arr];
            [resultArr addObject:[UILocalizedIndexedCollation currentCollation].sectionTitles[index]];
        }
    }
    
    return resultArr;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.studentsArr removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

#pragma mark - <UISearchBarDelegate>代理方法
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.view endEditing:YES];
}

#pragma mark - <DetailViewControllerDelegate>代理方法
- (void)detailViewControllerAfterAdd:(DetailViewController *)ctr
{
    [Notification_Default_Center postNotificationName:AddStudentNotifiction object:nil userInfo:@{@"student": ctr.studentModel}];
}
- (void)detailViewControllerAfterDelete:(DetailViewController *)ctr
{
    [Notification_Default_Center postNotificationName:DeleteStudentNotifiction object:nil userInfo:@{@"student": ctr.studentModel}];
}
- (void)detailViewControllerAfterChange:(DetailViewController *)ctr
{
    [Notification_Default_Center postNotificationName:ChangeStudentNotifiction object:nil userInfo:@{@"student": ctr.studentModel}];
}

@end