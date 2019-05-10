//
//  MeViewController.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/11/21.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import "MeViewController.h"
#import "Tools.h"
#import "MeManager.h"
#import "MeTableView.h"
#import "UserSetViewController.h"
#import "MistakeCollectViewController.h"
#import "QHistoryViewController.h"
#import "QuestionNoteViewController.h"
#import "OpenCourseViewController.h"
#import "FeedbackViewController.h"
#import "OrderViewController.h"
#import "MyWalletViewController.h"
#import "CouponViewController.h"
#import "VideoDownloadViewController.h"
#import "LiveDownloadViewController.h"
#import "ActivationViewController.h"
#import "UserGradeViewController.h"

@interface MeViewController () <MeTableViewDelegate>
@property (nonatomic, strong) MeTableView *meTableView;
@end

@implementation MeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self configNavigationBarWithNaviTitle:IsLocalAccount ? @"我的":[USER_DEFAULTS objectForKey:User_nickName] naviFont:18.0f leftBtnTitle:@"" rightBtnTitle:@"" bgColor:MAIN_RGB];
    
    self.meTableView = [[MeTableView alloc] initWithFrame:CGRectMake(0, self.navigationBar.bottom, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - self.navigationBar.height - TABBAR_HEIGHT) style:UITableViewStyleGrouped];
    self.meTableView.meTableViewDelegate = self;
    [self.view addSubview:self.meTableView];
    
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(MeTableViewHeaderCellPortraitBtnClicked) name:@"MeTableViewHeaderCellPortraitBtnClicked" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(MeTableViewHeaderCellBottomBtnClicked:) name:@"MeTableViewHeaderCellBottomBtnClicked" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UserHeaderCellUpdate) name:@"UserHeaderCellUpdate" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UserNaviTitleUpdate) name:@"UserNaviTitleUpdate" object:nil];
}
#pragma mark - 点击头像方法
- (void)MeTableViewHeaderCellPortraitBtnClicked
{
    if (IsLocalAccount) {
        [XZCustomViewManager showSystemAlertViewWithTitle:@"温馨提示" message:@"您当前为试用账号，无法查看个人信息，请您登录后查看。" cancelButtonTitle:@"" otherButtonTitle:@"确定" isTouchbackground:NO withAlertViewType:XZAlertViewTypeSystemAlert handler:^(XZCustomAlertView *alertView, XZAlertViewBtnTag buttonIndex, XZAlertViewType alertViewType) {}];
    } else {
        [MeManager meUserExtendWithVC:self];
    }
}
#pragma mark - 点击 收藏、错题、历史、笔记
- (void)MeTableViewHeaderCellBottomBtnClicked:(NSNotification *)noti
{
    if (IsLocalAccount) {
        [XZCustomViewManager showSystemAlertViewWithTitle:@"温馨提示" message:@"当前您为试用账号。试用账号无法保存您的做题记录和部分信息，请您登录后查看。" cancelButtonTitle:@"确定" otherButtonTitle:@"" isTouchbackground:NO withAlertViewType:XZAlertViewTypeSystemAlert handler:^(XZCustomAlertView *alertView, XZAlertViewBtnTag buttonIndex, XZAlertViewType alertViewType) {}];
        return;
    }
    switch ([noti.object integerValue]) {
        case 0: case 1:
            {
                MistakeCollectViewController *mistakeCollectVC = [[MistakeCollectViewController alloc] init];
                mistakeCollectVC.mistakeCollectType = [noti.object integerValue] == 0 ? CollectType:MistakeType;
                [self.navigationController pushViewController:mistakeCollectVC animated:YES];
            }
            break;
        case 2:
        {
            QHistoryViewController *qHistoryVC = [[QHistoryViewController alloc] init];
            [self.navigationController pushViewController:qHistoryVC animated:YES];
        }
            break;
        case 3:
        {
            QuestionNoteViewController *qNoteVC = [[QuestionNoteViewController alloc] init];
            [self.navigationController pushViewController:qNoteVC animated:YES];
        }
            break;
            
        default:
            break;
    }
}
#pragma mark - 刷新HeaderCell
- (void)UserHeaderCellUpdate
{
    [self.meTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
}
#pragma mark - 刷新NaviTitle
- (void)UserNaviTitleUpdate
{
    [self.navigationBar refreshTitleButtonFrameWithNaviTitle:[USER_DEFAULTS objectForKey:User_nickName]];
}

#pragma mark - 列表点击代理方法
- (void)meTableViewRowsClickedWithIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section*10 + indexPath.row)
    {
        case 10:  //已开通课程
        {
            if (IsLocalAccount) {
                [XZCustomWaitingView showAutoHidePromptView:@"试用账号无法查看已开通课程" background:nil showTime:1.0];
                return;
            }
//            [XZCustomWaitingView showAutoHidePromptView:@"暂时无法查看" background:nil showTime:0.8];
            OpenCourseViewController *openCourseVC = [[OpenCourseViewController alloc] init];
            [self.navigationController pushViewController:openCourseVC animated:YES];
        }
            break;
        case 11:  //积分获取
        {
            UserGradeViewController *userGradeVC = [[UserGradeViewController alloc] init];
            [self.navigationController pushViewController:userGradeVC animated:YES];
        }
            break;
        case 12:  //问题反馈
        {
            if (IsLocalAccount) {
                [XZCustomWaitingView showAutoHidePromptView:@"暂无反馈" background:nil showTime:1.0];
                return;
            }
            FeedbackViewController *feedbackVC = [[FeedbackViewController alloc] init];
            [self.navigationController pushViewController:feedbackVC animated:YES];
        }
            break;
        case 13:  //课程下载管理
        {
            VideoDownloadViewController *videoDownloadVC = [[VideoDownloadViewController alloc] init];
            [self.navigationController pushViewController:videoDownloadVC animated:YES];
        }
            break;
        case 14:  //直播下载管理
        {
            LiveDownloadViewController *liveDownloadVC = [[LiveDownloadViewController alloc] init];
            [self.navigationController pushViewController:liveDownloadVC animated:YES];
        }
            break;
        case 15:  //能力评估
        {
            [XZCustomWaitingView showAutoHidePromptView:@"即将上线\n敬请期待" background:nil showTime:0.8];
        }
            break;
        case 16:  //学习规划
        {
            [XZCustomWaitingView showAutoHidePromptView:@"即将上线\n敬请期待" background:nil showTime:0.8];
        }
            break;
        case 20:  //通知
        {
            [XZCustomWaitingView showAutoHidePromptView:@"即将上线\n敬请期待" background:nil showTime:0.8];
        }
            break;
        case 21:  //订单
        {
            if (IsLocalAccount) {
//                [XZCustomWaitingView showAutoHidePromptView:@"暂无订单" background:nil showTime:1.0];
                [XZCustomViewManager showSystemAlertViewWithTitle:@"温馨提示" message:@"当前您为试用账号。无法查看订单，请您登录后查看。" cancelButtonTitle:@"确定" otherButtonTitle:@"" isTouchbackground:NO withAlertViewType:XZAlertViewTypeSystemAlert handler:^(XZCustomAlertView *alertView, XZAlertViewBtnTag buttonIndex, XZAlertViewType alertViewType) {}];
                return;
            }
            OrderViewController *orderVC = [[OrderViewController alloc] init];
            [self.navigationController pushViewController:orderVC animated:YES];
        }
            break;
        case 22:  //钱包
        {
            MyWalletViewController *myWalletVC = [[MyWalletViewController alloc] init];
            [self.navigationController pushViewController:myWalletVC animated:YES];
        }
            break;
        case 23:  //优惠券
        {
            if (IsLocalAccount) {
                [XZCustomWaitingView showAutoHidePromptView:@"暂无优惠券" background:nil showTime:1.0];
                return;
            }
            CouponViewController *couponVC = [[CouponViewController alloc] init];
            [self.navigationController pushViewController:couponVC animated:YES];
        }
            break;
        case 24:  //激活码
        {
            if (IsLocalAccount) {
                [XZCustomWaitingView showAutoHidePromptView:@"暂无激活码" background:nil showTime:1.0];
                return;
            }
            ActivationViewController *activationVC = [[ActivationViewController alloc] init];
            [self.navigationController pushViewController:activationVC animated:YES];
        }
            break;
        case 30:  //联系客服
        {
            if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:[NSString stringWithFormat:@"mqq://im/chat?chat_type=wpa&uin=%@&version=1&src_type=web",[ManagerTools deleteSpaceAndNewLineWithString:[USER_DEFAULTS objectForKey:ServiceQQ]]]]]) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"mqq://im/chat?chat_type=wpa&uin=%@&version=1&src_type=web",[ManagerTools deleteSpaceAndNewLineWithString:[USER_DEFAULTS objectForKey:ServiceQQ]]]]];
            } else {
                [XZCustomWaitingView showAutoHidePromptView:@"打开失败" background:nil showTime:1.2];
            }
        }
            break;
        case 31:  //设置
        {
            UserSetViewController *userSetVC = [[UserSetViewController alloc] init];
            [self.navigationController pushViewController:userSetVC animated:YES];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark -
#pragma mark - 导航按钮
- (void)baseNaviButtonClickedWithBtnType:(naviBtnType)btnType
{
    if (btnType == RightBtnType)
    {
        NSLog(@"签到");
    }
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
