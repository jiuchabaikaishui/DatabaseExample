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

@interface DatabaseViewController ()<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, DetailViewControllerDelegate, StudentCellDelegate>

@property (strong,nonatomic) NSMutableArray *studentsArr;
@property (strong,nonatomic) NSMutableArray *searchStudentsArr;
@property (weak,nonatomic) UITableView *tableView;
@property (weak,nonatomic) UISearchBar *searchBar;
@property (strong,nonatomic) UISearchDisplayController *searchDisplayCtr;

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
- (NSMutableArray *)searchStudentsArr
{
    if (_searchStudentsArr == nil) {
        _searchStudentsArr = [NSMutableArray arrayWithCapacity:1];
    }
    
    return _searchStudentsArr;
}

/**
 *  按首字母分组
 *
 *  @param sourceArr 目标数组
 *
 *  @return 分好组的数组
 */
- (NSArray *)groupedByLetter:(NSArray *)sourceArr
{
    UILocalizedIndexedCollation *collation = [UILocalizedIndexedCollation currentCollation];
    
    //按照索引创建对应的数组
    NSMutableArray *sectionsArr = [NSMutableArray arrayWithCapacity:collation.sectionTitles.count];
    for (int index = 0; index < collation.sectionTitles.count; index++) {
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:1];
        [sectionsArr addObject:arr];
    }
    
    //设置StudentModel模型的组号，并装进对应数组中
    for (StudentModel *studentModel in sourceArr) {
        NSInteger section = [collation sectionForObject:studentModel collationStringSelector:@selector(name)];
        studentModel.section = section;
        [sectionsArr[section] addObject:studentModel];
    }
    
    //对每组数据进行按名称首字母排序
    NSMutableArray *resultArr = [NSMutableArray arrayWithCapacity:1];
    for (NSArray *arr in sectionsArr) {
        [resultArr addObject:[NSMutableArray arrayWithArray:[collation sortedArrayFromArray:arr collationStringSelector:@selector(name)]]];
    }
    
    return resultArr;
}

#pragma mark - 控制器周期
- (void)dealloc
{
    //移除通知
    [Notification_Default_Center removeObserver:self];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //设置UI
    [self settingUi];
    
    //注册通知
    [Notification_Default_Center addObserver:self selector:@selector(addStudent:) name:AddStudentNotifiction object:nil];
    [Notification_Default_Center addObserver:self selector:@selector(deleteStudent:) name:DeleteStudentNotifiction object:nil];
    [Notification_Default_Center addObserver:self selector:@selector(changeStudent:) name:ChangeStudentNotifiction object:nil];
}

- (void)addStudent:(NSNotification *)sender
{
    StudentModel *studentModel = sender.userInfo[@"student"];
    if (studentModel) {
        //为StudentModel模型设置section
        UILocalizedIndexedCollation *collation = [UILocalizedIndexedCollation currentCollation];
        NSInteger section = [collation sectionForObject:studentModel collationStringSelector:@selector(name)];
        studentModel.section = section;
        
        //添加数据
        NSMutableArray *singleSection = self.studentsArr[section];
        [singleSection addObject:studentModel];
        NSArray *tempSection = [collation sortedArrayFromArray:singleSection collationStringSelector:@selector(name)];
        singleSection = [NSMutableArray arrayWithArray:tempSection];
        NSInteger row = [singleSection indexOfObject:studentModel];
        
        //插入cell
        [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:row inSection:section]] withRowAnimation:UITableViewRowAnimationNone];
        
        //刷新索引
        [self.tableView reloadSectionIndexTitles];
        
        //如果是搜索的
        if (self.searchDisplayCtr.active) {
            [self.searchDisplayCtr.searchResultsTableView reloadData];
        }
    }
}
- (void)deleteStudent:(NSNotification *)sender
{
    StudentModel *studentModel = sender.userInfo[@"student"];
    if (studentModel) {
        //移除数据
        NSUInteger index = [self.studentsArr[studentModel.section] indexOfObject:studentModel];
        [self.studentsArr[studentModel.section] removeObject:studentModel];
        
        //删除cell
        [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:studentModel.section]] withRowAnimation:UITableViewRowAnimationNone];
        
        //刷新索引
        [self.tableView reloadSectionIndexTitles];
        
        //如果是搜索的
        if (self.searchDisplayCtr.active) {
            [self.searchDisplayCtr.searchResultsTableView reloadData];
        }
    }
}
- (void)changeStudent:(NSNotification *)sender
{
    StudentModel *studentModel = sender.userInfo[@"student"];
    if (studentModel) {
        //移除原数据
        NSUInteger index = [self.studentsArr[studentModel.section] indexOfObject:studentModel];
        [self.studentsArr[studentModel.section] removeObject:studentModel];
        //删除cell
        [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:studentModel.section]] withRowAnimation:UITableViewRowAnimationNone];
        
        //添加新数据
        UILocalizedIndexedCollation *collation = [UILocalizedIndexedCollation currentCollation];
        NSInteger section = [collation sectionForObject:studentModel collationStringSelector:@selector(name)];
        studentModel.section = section;
        [self.studentsArr[section] addObject:studentModel];
        
        //插入cell
        [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[self.studentsArr[section] indexOfObject:studentModel] inSection:section]] withRowAnimation:UITableViewRowAnimationNone];
        
        //刷新索引
        [self.tableView reloadSectionIndexTitles];
        
        //如果是搜索的
        if (self.searchDisplayCtr.active) {
            [self.searchDisplayCtr.searchResultsTableView reloadData];
        }
    }
}

#pragma mark - 自定义方法
- (void)settingUi
{
    //设置导航栏右边的UIBarButtonItem
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithTitle:@"添加" style:UIBarButtonItemStylePlain target:self action:@selector(addAction:)];
    UIBarButtonItem *deleteItem = [[UIBarButtonItem alloc] initWithTitle:@"删除" style:UIBarButtonItemStylePlain target:self action:@selector(deleteAction:)];
    self.navigationItem.rightBarButtonItems = @[addItem, deleteItem];
    
    //设置搜索框和UITableView
    UITableView *tableView = [[UITableView alloc] initWithFrame:MainScreen_Bounds style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, MainScreen_Width - 16, 44)];
    self.searchBar = searchBar;
    searchBar.placeholder = @"搜索";
    searchBar.delegate = self;
    UISearchDisplayController *displayController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
    displayController.searchResultsDataSource = self;
    displayController.searchResultsDelegate = self;
    self.searchDisplayCtr = displayController;
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

#pragma mark - <UITableViewDelegate, UITableViewDataSource>代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.tableView) {
        NSArray *arr = self.studentsArr[section];
        return arr.count;
    }
    
    [SqliteStudentFunction searchStudents:self.searchBar.text ? self.searchBar.text : @"" andCallBack:^(NSArray *students, NSString *msg) {
        [self.searchStudentsArr removeAllObjects];
        [self.searchStudentsArr addObjectsFromArray:students];
    }];
    return self.searchStudentsArr.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == self.tableView) {
        return self.studentsArr.count;
    }
    
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    StudentModel *studentModel = tableView == self.tableView ? self.studentsArr[indexPath.section][indexPath.row] : self.searchStudentsArr[indexPath.row];
    StudentCell *cell = [StudentCell studentCell:tableView andStudentModel:studentModel];
    cell.delegate = self;
    
    return cell;
}
- (void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIBarButtonItem *deleteItem = [self.navigationItem.rightBarButtonItems lastObject];
    [deleteItem setTitle:@"取消"];
}
- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIBarButtonItem *deleteItem = [self.navigationItem.rightBarButtonItems lastObject];
    [deleteItem setTitle:@"取消"];
    return YES;
}
- (void)tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIBarButtonItem *deleteItem = [self.navigationItem.rightBarButtonItems lastObject];
    [deleteItem setTitle:@"删除"];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 76;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    StudentModel *studentModel;
    if (tableView == self.tableView) {
        studentModel = self.studentsArr[indexPath.section][indexPath.row];
    }
    else
    {
        studentModel = self.searchStudentsArr[indexPath.row];
    }
    
    DetailViewController *nextCtr = [DetailViewController detailViewController:studentModel andType:DetailViewControllerTypeShow];
    nextCtr.delegate = self;
    nextCtr.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:nextCtr animated:YES];
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (tableView == self.tableView && [self.studentsArr[section] count] > 0) {
        return [UILocalizedIndexedCollation currentCollation].sectionTitles[section];
    }
    
    return nil;
}
- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (tableView == self.tableView) {
        NSMutableArray *resultArr = [NSMutableArray arrayWithCapacity:1];
        for (NSArray *arr in self.studentsArr) {
            if (arr.count > 0) {
                NSInteger index = [self.studentsArr indexOfObject:arr];
                [resultArr addObject:[UILocalizedIndexedCollation currentCollation].sectionTitles[index]];
            }
        }
        [resultArr insertObject:UITableViewIndexSearch atIndex:0];
        
        return resultArr;
    }
    else
    {
        return nil;
    }
}
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    NSInteger result = -1;
    if (tableView == self.tableView) {
        if (index == 0) {
            [tableView scrollRectToVisible:tableView.tableHeaderView.frame animated:NO];
        }
        else
        {
            result = [[UILocalizedIndexedCollation currentCollation].sectionTitles indexOfObject:title];
        }
    }
    
    return result;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tableView) {
        return YES;
    }
    
    return NO;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        StudentModel *studentModel = self.studentsArr[indexPath.section][indexPath.row];
        [SqliteStudentFunction deleteStudent:studentModel succesefulBlock:^(StudentModel *studentModel) {
            [Notification_Default_Center postNotificationName:DeleteStudentNotifiction object:nil userInfo:@{@"student": self.studentsArr[indexPath.section][indexPath.row]}];
        } andFailureBlock:^(NSString *msg) {
            MainAlertMsg(msg);
        }];
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

#pragma mark - <StudentCellDelegate>代理方法
- (void)studentCellAfterUpdate:(StudentCell *)cell
{
    DetailViewController *nextCtr = [DetailViewController detailViewController:cell.studentModel andType:DetailViewControllerTypeEdit];
    nextCtr.delegate = self;
    nextCtr.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:nextCtr animated:YES];
}

@end
