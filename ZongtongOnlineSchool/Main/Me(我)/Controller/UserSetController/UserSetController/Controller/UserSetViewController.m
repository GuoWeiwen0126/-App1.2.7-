//
//  UserSetViewController.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/11/27.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import "UserSetViewController.h"
#import "Tools.h"
#import "MeManager.h"
#import "UserSetTableView.h"
#import "UpdatePhoneViewController.h"
//#import "CourseOptionFirstViewController.h"
#import "CourseOptionMainViewController.h"
#import "AreaOptionViewController.h"
#import "ActivationManager.h"

#import "ZFDownloadManager.h"
#define  ZFDownloadManager  [ZFDownloadManager sharedDownloadManager]

typedef NS_ENUM(NSUInteger, UserSetCellIndex)
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

@interface UserSetViewController () <UserSetTableViewDelegate, AreaOptionVCDelegate>
@property (nonatomic, strong) UserSetTableView *tableView;
@end

@implementation UserSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self configUI];
    [self registerNotification];
}
#pragma mark - 配置UI
- (void)configUI
{
    [self configNavigationBarWithNaviTitle:@"设置"naviFont:18.0f leftBtnTitle:@"back.png" rightBtnTitle:@"" bgColor:MAIN_RGB];
    
    self.tableView = [[UserSetTableView alloc] initWithFrame:CGRectMake(0, self.navigationBar.bottom, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - self.navigationBar.height) style:UITableViewStyleGrouped];
    self.tableView .userSetDelegate = self;
    [self.view addSubview:self.tableView ];
}
#pragma mark - 注册通知
- (void)registerNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UpdateUserSetVCCourseName) name:@"UpdateUserSetVCCourseName" object:nil];
}

#pragma mark - 代理方法
#pragma mark - 列表点击代理方法
- (void)userSetTableViewRowsClickedWithIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section*10 + indexPath.row)
    {
        case 0:  //参加考试
        {
//            CourseOptionFirstViewController *courseOptionVC = [[CourseOptionFirstViewController alloc] init];
//            courseOptionVC.isUserCenter = YES;
//            [self.navigationController pushViewController:courseOptionVC animated:YES];
            CourseOptionMainViewController *courseMainVC = [[CourseOptionMainViewController alloc] init];
            courseMainVC.isUserCenter = YES;
            [self.navigationController pushViewController:courseMainVC animated:YES];
        }
            break;
        case 1:  //报考地区
        {
            AreaOptionViewController *areaOptionVC = [[AreaOptionViewController alloc] init];
            areaOptionVC.isExamArea = YES;
            areaOptionVC.areaOptionDelegate = self;
            [self.navigationController pushViewController:areaOptionVC animated:YES];
        }
            break;
        case 10:  //修改手机号
        {
            if (IsLocalAccount) {
                [XZCustomWaitingView showAutoHidePromptView:@"试用账号\n无法修改手机号码" background:nil showTime:1.0];
                return;
            }
            UpdatePhoneViewController *updatePhoneVC = [[UpdatePhoneViewController alloc] init];
            [self.navigationController pushViewController:updatePhoneVC animated:YES];
        }
            break;
        case 20:  //清除缓存
        {
            [XZCustomViewManager showSystemAlertViewWithTitle:@"清除缓存" message:@"将清除所有缓存文件和已缓存的视频，是否清除？" cancelButtonTitle:@"取消" otherButtonTitle:@"立即清除" isTouchbackground:YES withAlertViewType:XZAlertViewTypeSystemAlert handler:^(XZCustomAlertView *alertView, XZAlertViewBtnTag buttonIndex, XZAlertViewType alertViewType) {
                if (buttonIndex == XZAlertViewBtnTagSure) {
                    [XZCustomWaitingView showWaitingMaskView:@"清除缓存" iconName:LoadingImage iconNumber:4];
                    //移除图片缓存
                    [[SDImageCache sharedImageCache] clearDiskOnCompletion:nil];
                    //移除视频缓存
                    [ZFDownloadManager clearAllRquests];
                    [ZFDownloadManager.finishedlist enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        ZFFileModel *fileModel = (ZFFileModel *)obj;
                        [ZFDownloadManager deleteFinishFile:fileModel];
                    }];
                    [XZCustomWaitingView hideWaitingMaskView];
                    [XZCustomWaitingView showAutoHidePromptView:@"清除成功" background:nil showTime:1.0];
                }
            }];
        }
            break;
        case 30:  //关于总统网校
        {
//            [XZCustomViewManager showSystemAlertViewWithTitle:@"关于总统网校" message:[NSString stringWithFormat:@"当前版本\n%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]] cancelButtonTitle:@"" otherButtonTitle:@"确定" isTouchbackground:YES withAlertViewType:XZAlertViewTypeSystemAlert handler:^(XZCustomAlertView *alertView, XZAlertViewBtnTag buttonIndex, XZAlertViewType alertViewType) {
//            }];
            
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"关于总统网校"
                                                                           message:[NSString stringWithFormat:@"当前版本\n%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]]
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                //响应事件
                //得到文本信息
                for(UITextField *text in alert.textFields){
                    NSLog(@"text = %@", text.text);
                    if (text.text.length > 0) {
                        //绑定激活码
                        [ActivationManager activationManagerBindingWithUid:[USER_DEFAULTS objectForKey:User_uid] CDKEY:text.text insertName:[USER_DEFAULTS objectForKey:User_nickName] completed:^(id obj) {
                            if (obj != nil) {
                                //立即使用激活码
                                [ActivationManager activationManagerBasicWithCdkey:text.text completed:^(id obj) {
                                    if (obj != nil) {
                                        NSDictionary *dic = (NSDictionary *)obj;
                                        [ActivationManager activationManagerUseCodeWithUid:[USER_DEFAULTS objectForKey:User_uid] acid:dic[@"acid"] insertName:[USER_DEFAULTS objectForKey:User_nickName] completed:^(id obj) {
                                            if (obj != nil) {
                                                [XZCustomWaitingView showAutoHidePromptView:@"成功" background:nil showTime:1.0];
                                            }
                                        }];
                                    }
                                }];
                            }
                        }];
                    }
                }
            }];
            UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel
                                                                 handler:^(UIAlertAction * action) {
                                                                     //响应事件
                                                                     NSLog(@"action = %@", alert.textFields);
                                                                 }];
            [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
                
            }];
            [alert addAction:okAction];
            [alert addAction:cancelAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
            break;
        case 40:  //退出登录
        {
            [MeManager meLogoutWithVC:self];
        }
            break;
            
        default:
            break;
    }
}
#pragma mark - 地区修改完成代理方法
- (void)areaOptionPopWithProvinceStr:(NSString *)provinceStr cityStr:(NSString *)cityStr
{
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - 通知方法
#pragma mark - 更改科目名称
- (void)UpdateUserSetVCCourseName
{
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - 导航按钮
- (void)baseNaviButtonClickedWithBtnType:(naviBtnType)btnType
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - dealloc
- (void)dealloc
{
    //移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
