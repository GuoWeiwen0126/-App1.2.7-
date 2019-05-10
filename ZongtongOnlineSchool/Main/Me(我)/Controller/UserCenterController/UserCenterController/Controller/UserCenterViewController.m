//
//  UserCenterViewController.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/11/22.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import "UserCenterViewController.h"
#import "Tools.h"
#import "MeManager.h"
#import "UploadPortraitManager.h"
#import "UserCenterTableView.h"
#import "UpdatePWViewController.h"
#import "UpdateAddressViewController.h"

typedef NS_ENUM(NSUInteger, UserCenterCellIndex)
{
    UserPortrait  = 0,
    UserNickName  = 1,
    UserSex       = 2,
    UserGrade     = 10,
    UserVIPGrade  = 11,
    UserPassword  = 20,
    UserAddress   = 30,
    UserProtocol  = 40,
};

@interface UserCenterViewController () <UserCenterTableViewCellDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (nonatomic, strong) UserCenterTableView *tableView;

@end

@implementation UserCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self configNavigationBarWithNaviTitle:@"个人资料"naviFont:18.0f leftBtnTitle:@"back.png" rightBtnTitle:@"" bgColor:MAIN_RGB];
    
    self.tableView = [[UserCenterTableView alloc] initWithFrame:CGRectMake(0, self.navigationBar.bottom, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - self.navigationBar.height) style:UITableViewStyleGrouped];
    self.tableView.userCenterDelegate = self;
    [self.view addSubview:self.tableView];
    
    //注册通知
    [self registerNotification];
}
#pragma mark - 列表点击代理方法
- (void)userCenterTableViewCellDidSelectWithIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section*10 + indexPath.row)
    {
        case UserPortrait:
        {
            [self updatePortrait];
        }
            break;
        case UserNickName:
        {
            [MeManager meUpdateNickName];
        }
            break;
//        case UserSex:
//        {
//            
//        }
//            break;
        case UserGrade:
        {
            
        }
            break;
        case UserVIPGrade:
        {
            
        }
            break;
        case UserPassword:
        {
            UpdatePWViewController *updatePWVC = [[UpdatePWViewController alloc] init];
            [self.navigationController pushViewController:updatePWVC animated:YES];
        }
            break;
        case UserAddress:
        {
            UpdateAddressViewController *updateAddressVC = [[UpdateAddressViewController alloc] init];
            [self.navigationController pushViewController:updateAddressVC animated:YES];
        }
            break;
//        case UserProtocol:
//        {
//            
//        }
//            break;
            
        default:
            break;
    }
}

#pragma mark - 修改头像
- (void)updatePortrait
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.allowsEditing = YES;
    picker.delegate = self;
    [XZCustomViewManager showCustomActionSheetWithTitle:@"设置头像照片" cancelButtonTitle:@"取消" otherButtonTitles:@[@"拍照", @"从本地选择"] handle:^(XZCustomActionSheetView *actionSheetView, NSInteger index) {
         if (index == 1) {
             picker.sourceType = UIImagePickerControllerSourceTypeCamera;
             [self presentViewController:picker animated:YES completion:nil];
         } else if (index == 2) {
             picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
             [self presentViewController:picker animated:YES completion:nil];
         }
     }];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    //定义一个newPhoto，用来存放我们选择的图片。
    UIImage *newPhoto = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    [UploadPortraitManager uploadPortraitWithImageData:UIImagePNGRepresentation(newPhoto)];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 注册通知
- (void)registerNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UpdateUserPortrait) name:@"UpdateUserPortrait" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UpdateNickName) name:@"UpdateNickName" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UpdateSexType:) name:@"UpdateSexType" object:nil];
}
#pragma mark - 通知方法
- (void)UpdateUserPortrait
{
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
}
- (void)UpdateNickName
{
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
}
- (void)UpdateSexType:(NSNotification *)noti
{
    [MeManager meUpdateSexTypeWithNewSexType:noti.object];
}

#pragma mark - 导航按钮
- (void)baseNaviButtonClickedWithBtnType:(naviBtnType)btnType
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
