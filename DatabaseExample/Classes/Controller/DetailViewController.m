//
//  DetailViewController.m
//  DatabaseExample
//
//  Created by apple on 17/2/6.
//  Copyright © 2017年 QSP. All rights reserved.
//

#import "DetailViewController.h"
#import "PlaceholderTextView.h"
#import "SqliteStudentFunction.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>

@interface DetailViewController ()<UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *idTextField;
@property (weak, nonatomic) IBOutlet UIImageView *phopoImageView;
@property (weak, nonatomic) IBOutlet UITextField *ageTextField;
@property (weak, nonatomic) IBOutlet PlaceholderTextView *addressTextView;
@property (weak, nonatomic) IBOutlet PlaceholderTextView *describeTextView;

@property (weak,nonatomic) UIBarButtonItem *editItem;
@property (weak,nonatomic) UIBarButtonItem *saveItem;
@property (weak,nonatomic) UIBarButtonItem *deleteItem;

@end

@implementation DetailViewController

- (void)setStudentModel:(StudentModel *)studentModel
{
    if (studentModel) {
        if (self.nameTextField && self.idTextField && self.phopoImageView && self.ageTextField && self.addressTextView && self.describeTextView) {
            [self changeStudentModel:studentModel];
        }
        
        _studentModel = studentModel;
    }
}
- (void)changeStudentModel:(StudentModel *)studentModel
{
    if (studentModel) {
        self.nameTextField.text = studentModel.name;
        self.idTextField.text = [NSString stringWithFormat:@"%@", studentModel.studentNumber];
        self.phopoImageView.image = studentModel.photo;
        self.ageTextField.text = [NSString stringWithFormat:@"%d", studentModel.age];
        self.addressTextView.text = studentModel.address;
        self.describeTextView.text = studentModel.describe;
    }
}
- (void)setType:(DetailViewControllerType)type
{
    _type = type;
    
    if (self.nameTextField && self.idTextField && self.ageTextField && self.addressTextView && self.describeTextView) {
        [self changeType:type];
    }
}

- (void)changeType:(DetailViewControllerType)type
{
    if (type == DetailViewControllerTypeShow) {
        self.nameTextField.userInteractionEnabled = NO;
        self.idTextField.userInteractionEnabled = NO;
        self.ageTextField.userInteractionEnabled = NO;
        self.addressTextView.userInteractionEnabled = NO;
        self.describeTextView.userInteractionEnabled = NO;
        
        if (self.studentModel) {
            UIBarButtonItem *editItem = self.editItem;
            if (editItem) {
                [editItem setTitle:@"编辑"];
            }
            else
            {
                editItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(editAction:)];
                self.editItem = editItem;
            }
            
            UIBarButtonItem *deleteItem = self.deleteItem;
            if (!deleteItem) {
                deleteItem = [[UIBarButtonItem alloc] initWithTitle:@"删除" style:UIBarButtonItemStylePlain target:self action:@selector(deleteAction:)];
                self.deleteItem = deleteItem;
            }
            
            self.navigationItem.rightBarButtonItems = @[editItem, deleteItem];
        }
    }
    else if (type == DetailViewControllerTypeEdit)
    {
        self.nameTextField.userInteractionEnabled = YES;
        self.idTextField.userInteractionEnabled = YES;
        self.ageTextField.userInteractionEnabled = YES;
        self.addressTextView.userInteractionEnabled = YES;
        self.describeTextView.userInteractionEnabled = YES;
        
        if (self.studentModel) {
            UIBarButtonItem *cancelItem = self.editItem;
            if (cancelItem) {
                [cancelItem setTitle:@"取消"];
            }
            else
            {
                cancelItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(editAction:)];
                self.editItem = cancelItem;
            }
            
            UIBarButtonItem *saveItem = self.saveItem ? self.saveItem : [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveAction:)];
            self.saveItem = saveItem;
            
            UIBarButtonItem *deleteItem = self.deleteItem;
            if (!deleteItem) {
                deleteItem = [[UIBarButtonItem alloc] initWithTitle:@"删除" style:UIBarButtonItemStylePlain target:self action:@selector(deleteAction:)];
                self.deleteItem = deleteItem;
            }
            
            self.navigationItem.rightBarButtonItems = @[cancelItem, saveItem, deleteItem];
        }
        else
        {
            UIBarButtonItem *saveItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveAction:)];
            
            self.navigationItem.rightBarButtonItems = @[saveItem];
        }
    }
}

- (void)editAction:(UIBarButtonItem *)sender
{
    if (self.type == DetailViewControllerTypeShow) {
        [self.navigationItem.rightBarButtonItem setTitle:@"取消"];
        self.type = DetailViewControllerTypeEdit;
        if ([self.idTextField canBecomeFirstResponder]) {
            [self.nameTextField becomeFirstResponder];
        }
    }
    else if (self.type == DetailViewControllerTypeEdit)
    {
        [self.navigationItem.rightBarButtonItem setTitle:@"编辑"];
        self.type = DetailViewControllerTypeShow;
        self.studentModel = self.studentModel;
    }
}
- (void)saveAction:(UIBarButtonItem *)sender
{
    StudentModel *studentModel = self.studentModel ? self.studentModel : [[StudentModel alloc] init];
    studentModel.name = self.nameTextField.text;
    studentModel.photo = self.phopoImageView.image;
    studentModel.studentNumber = self.idTextField.text;
    studentModel.age = [self.ageTextField.text intValue];
    studentModel.address = self.addressTextView.text;
    studentModel.describe = self.describeTextView.text;
    
    __weak typeof(self) weakSelf = self;
    if (self.studentModel) {
        [SqliteStudentFunction updateStudent:studentModel succesefulBlock:^(StudentModel *studentModel) {
            if ([weakSelf.delegate respondsToSelector:@selector(detailViewControllerAfterChange:)]) {
                [weakSelf.delegate detailViewControllerAfterChange:weakSelf];
            }
            
            [weakSelf.navigationController popViewControllerAnimated:YES];
        } andFailureBlock:^(NSString *msg) {
            MainAlertMsg(msg)
        }];
    }
    else
    {
        [SqliteStudentFunction addStudent:studentModel succesefulBlock:^(StudentModel *studentModel) {
            weakSelf.studentModel = studentModel;
            if ([weakSelf.delegate respondsToSelector:@selector(detailViewControllerAfterAdd:)]) {
                [weakSelf.delegate detailViewControllerAfterAdd:weakSelf];
            }
            
            [weakSelf.navigationController popViewControllerAnimated:YES];
        } andFailureBlock:^(NSString *msg) {
            MainAlertMsg(msg)
        }];
    }
}
- (void)deleteAction:(UIBarButtonItem *)sender
{
    [SqliteStudentFunction deleteStudent:self.studentModel succesefulBlock:^(StudentModel *studentModel) {
        if ([self.delegate respondsToSelector:@selector(detailViewControllerAfterDelete:)]) {
            [self.delegate detailViewControllerAfterDelete:self];
        }
        
        [self.navigationController popViewControllerAnimated:YES];
    } andFailureBlock:^(NSString *msg) {
        MainAlertMsg(msg)
    }];
}

+ (instancetype)detailViewController:(StudentModel *)studentModel andType:(DetailViewControllerType)type
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    DetailViewController *ctr = [storyboard instantiateViewControllerWithIdentifier:@"DetailViewController"];
    ctr.studentModel = studentModel;
    ctr.type = type;
    return ctr;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = self.studentModel ? self.studentModel.name : @"添加学生";
    [self changeType:self.type];
    if (self.studentModel) {
        [self changeStudentModel:self.studentModel];
    }
    if (self.type == DetailViewControllerTypeEdit && [self.idTextField canBecomeFirstResponder]) {
        [self.nameTextField becomeFirstResponder];
    }
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    self.phopoImageView.layer.cornerRadius = 5;
    self.phopoImageView.layer.masksToBounds = YES;
    self.phopoImageView.layer.borderWidth = 0.5;
    self.phopoImageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    self.addressTextView.layer.cornerRadius = 5;
    self.addressTextView.layer.masksToBounds = YES;
    self.addressTextView.layer.borderWidth = 0.5;
    self.addressTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    self.describeTextView.layer.cornerRadius = 5;
    self.describeTextView.layer.masksToBounds = YES;
    self.describeTextView.layer.borderWidth = 0.5;
    self.describeTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
}

#pragma mark - <UITableViewDataSource, UITableViewDelegate>代理方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.type == DetailViewControllerTypeEdit) {
        switch (indexPath.row) {
            case 0:
            {
                if (self.nameTextField.canBecomeFirstResponder) {
                    [self.nameTextField becomeFirstResponder];
                }
            }
                break;
            case 1:
            {
                if (self.idTextField.canBecomeFirstResponder) {
                    [self.idTextField becomeFirstResponder];
                }
            }
                break;
            case 2:
            {
                [self.view endEditing:YES];
                UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"图片来源" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相机", @"相册", nil];
                [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
            }
                break;
            case 3:
            {
                if (self.ageTextField.canBecomeFirstResponder) {
                    [self.ageTextField becomeFirstResponder];
                }
            }
                break;
            case 4:
            {
                if (self.addressTextView.canBecomeFirstResponder) {
                    [self.addressTextView becomeFirstResponder];
                }
            }
                break;
            case 5:
            {
                if (self.describeTextView.canBecomeFirstResponder) {
                    [self.describeTextView becomeFirstResponder];
                }
            }
                break;
                
            default:
                break;
        }
    }
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

#pragma mark <UIActionSheetDelegate>代理方法
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
        {
            ALAuthorizationStatus authStatus = [ALAssetsLibrary authorizationStatus];
            if (authStatus == ALAuthorizationStatusRestricted || authStatus == ALAuthorizationStatusDenied)
            {
                MainAlertMsg(@"请授权掌医医护端使用相机服务: 设置 > 隐私 > 相机");
                return;
            }
            
            //资源类型为照相机
            UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
            //判断是否有相机
            if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
            {
                UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                picker.delegate = self;
                //设置拍照后的图片可被编辑
                picker.allowsEditing = YES;
                //资源类型为照相机
                picker.sourceType = sourceType;
                
                [self presentViewController:picker animated:YES completion:nil];
            }else
            {
                MainAlertMsg(@"该设备无摄像头");
            }
        }
            break;
        case 1:
        {
            AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
            if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied)
            {
                MainAlertMsg(@"请授权掌医医护端使用相机服务: 设置 > 隐私 > 照片");
                return;
            }
            
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            //资源类型为图片库
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            picker.delegate = self;
            //设置选择后的图片可被编辑
            picker.allowsEditing = YES;

            [self presentViewController:picker animated:YES completion:nil];
        }
            
        default:
            break;
    }
}

#pragma mark - <UIImagePickerControllerDelegate>代理方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *image = [info valueForKey:UIImagePickerControllerEditedImage];
    self.phopoImageView.image = image;
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
