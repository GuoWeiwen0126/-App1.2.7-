//
//  CashierDeskViewController.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/1/26.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import "CashierDeskViewController.h"
#import "Tools.h"
#import "MyWalletViewController.h"

@interface CashierDeskViewController ()
{
    NSString *_payType;
}
@property (weak, nonatomic) IBOutlet UILabel *actuallyMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *userGoldLabel;
@property (weak, nonatomic) IBOutlet UIButton *payBtn;
@end

@implementation CashierDeskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor whiteColor];
    [self configNavigationBarWithNaviTitle:@"收银台" naviFont:18.0f leftBtnTitle:@"back.png" rightBtnTitle:@"" bgColor:MAIN_RGB];
    [self configView];
}
#pragma mark ========= 支付 =========
- (IBAction)payBtnClicked:(id)sender
{
    //支付方式
    if (_payType.length == 0) {
        [XZCustomWaitingView showAutoHidePromptView:@"请选择支付方式" background:nil showTime:0.8];
        return;
    }
    if ([_payType integerValue] == 1) {  //淘宝购买
        [self goToTaobao];
        return;
    }
    if (![[USER_DEFAULTS objectForKey:Payment] containsString:_payType]) {
        [XZCustomWaitingView showAutoHidePromptView:@"该方式暂不支持\n敬请期待" background:nil showTime:1.0];
        return;
    }
    
    if ([_payType integerValue] == 2) {  //支付宝
        [self aliPaySignatureWithOid:self.oid];
    } else if ([_payType integerValue] == 3) {  //微信支付
        [self wechatPayWithOid:self.oid];
    } else if ([_payType integerValue] == 4) {  //余额支付
        //用户金币不足
        if ([OrderManager decimalNumber:[NSDecimalNumber decimalNumberWithString:IsLocalAccount ? [NSString stringWithFormat:@"%ld",[USER_DEFAULTS integerForKey:User_sum_LocalAccount]/100]:[NSString stringWithFormat:@"%ld",[USER_DEFAULTS integerForKey:User_sum]/100]] CompareWithDecimalNumber:self.actuallyMoney] == -1) {
            [self goToMyWallet];
            return;
        }
        [self sumPayWithOid:self.oid];
    }
}
#pragma mark ========= 支付宝授权 =========
- (void)aliPaySignatureWithOid:(NSString *)oid
{
    [OrderManager orderManagerAliPaySignatureWithOid:oid completed:^(id obj) {
        if (obj != nil) {
            if ([obj integerValue] == 5555) {
                //订单金额为0，运行成功 --- 支付成功，回到主页
                [OrderManager paySuccessBackToMainWithVC:self];
            } else {
                //支付宝支付
                [OrderManager aliPayWithVC:self payOrder:(NSString *)obj completed:^(id obj) {}];
            }
        }
    }];
}
#pragma mark ========= 钱包余额支付 =========
- (void)sumPayWithOid:(NSString *)oid
{
    if (IsLocalAccount) {
        //测试账号（更新本地金币数）
        NSInteger totalGoldNum = [USER_DEFAULTS integerForKey:User_sum_LocalAccount] - [self.actuallyMoney integerValue]*100;
        [USER_DEFAULTS setInteger:totalGoldNum forKey:User_sum_LocalAccount];
        [USER_DEFAULTS synchronize];
        [AppTypeManager updateUserPrivilegeWithAppType:self.appType];
        //支付成功，回到主页
        [XZCustomViewManager showSystemAlertViewWithTitle:@"温馨提示" message:@"支付成功\n开启全新的学习之旅" cancelButtonTitle:@"" otherButtonTitle:@"确定" isTouchbackground:NO withAlertViewType:XZAlertViewTypeSystemAlert handler:^(XZCustomAlertView *alertView, XZAlertViewBtnTag buttonIndex, XZAlertViewType alertViewType) {
            [OrderManager paySuccessBackToMainWithVC:self];
        }];
    } else {
        [OrderManager orderManagerSumPayWithOid:oid completed:^(id obj) {
            if (obj != nil) {
                if ([obj integerValue] == 5555) {  //订单已生效
                    
                } else if ([obj integerValue] == 921) {  //余额不足（统一反回，特别使用）
                    [XZCustomWaitingView hideWaitingMaskView];
                    [self goToMyWallet];
                    return;
                } else {
                    //支付成功，回到主页
                    [XZCustomViewManager showSystemAlertViewWithTitle:@"温馨提示" message:@"支付成功\n开启全新的学习之旅" cancelButtonTitle:@"" otherButtonTitle:@"确定" isTouchbackground:NO withAlertViewType:XZAlertViewTypeSystemAlert handler:^(XZCustomAlertView *alertView, XZAlertViewBtnTag buttonIndex, XZAlertViewType alertViewType) {
                        [OrderManager paySuccessBackToMainWithVC:self];
                    }];
                }
            }
        }];
    }
}
#pragma mark ========= 微信支付 =========
- (void)wechatPayWithOid:(NSString *)oid
{
    
}
- (void)goToMyWallet
{
    [XZCustomViewManager showSystemAlertViewWithTitle:@"温馨提示" message:@"您的金币余额不足，请前往充值。" cancelButtonTitle:@"取消" otherButtonTitle:@"前往充值" isTouchbackground:NO withAlertViewType:XZAlertViewTypeSystemAlert handler:^(XZCustomAlertView *alertView, XZAlertViewBtnTag buttonIndex, XZAlertViewType alertViewType) {
        if (buttonIndex == XZAlertViewBtnTagSure) {
            MyWalletViewController *myWalletVC = [[MyWalletViewController alloc] init];
            [self.navigationController pushViewController:myWalletVC animated:YES];
        }
    }];
}
- (void)goToTaobao
{
    if (![ManagerTools existLocalPlistWithFileName:AppInfoPlist]) {
        [XZCustomWaitingView showAutoHidePromptView:@"跳转淘宝失败" background:nil showTime:0.8];
        return;
    }
    NSDictionary *appInfoDic = [[NSDictionary alloc] initWithContentsOfFile:GetFileFullPath(AppInfoPlist)];
    NSDictionary *tbWordKeyDic = appInfoDic[@"TBWordKey"];
    if ([tbWordKeyDic[@"link"] length] == 0) {
        NSURL *taobaoUrl = [NSURL URLWithString:tbWordKeyDic[@"link"]];
        if ([[UIApplication sharedApplication] canOpenURL:taobaoUrl]) {  //客户端打开
            [[UIApplication sharedApplication] openURL:taobaoUrl];
        } else {  //Safari网页打开
            [[UIApplication sharedApplication] openURL:taobaoUrl];
        }
    } else {
        [XZCustomViewManager showSystemAlertViewWithTitle:@"温馨提示" message:tbWordKeyDic[@"wordKey"] cancelButtonTitle:@"取消" otherButtonTitle:@"复制淘口令" isTouchbackground:NO withAlertViewType:XZAlertViewTypeSystemAlert handler:^(XZCustomAlertView *alertView, XZAlertViewBtnTag buttonIndex, XZAlertViewType alertViewType) {
            if (buttonIndex == XZAlertViewBtnTagSure) {
                UIPasteboard *pasteBoard = [UIPasteboard generalPasteboard];
                pasteBoard.string = tbWordKeyDic[@"wordKey"];
            }
        }];
    }
}
#pragma mark ========= 选择支付方式 =========
- (void)payMethodBtnClicked:(PayMethodButton *)btn
{
    for (id obj in self.view.subviews) {
        if ([obj isKindOfClass:[PayMethodButton class]]) {
            PayMethodButton *payMethodBtn = (PayMethodButton *)obj;
            if (payMethodBtn.tag == btn.tag) {
                payMethodBtn.isSelected = YES;
                _payType = [NSString stringWithFormat:@"%ld",(long)payMethodBtn.tag];
            } else {
                payMethodBtn.isSelected = NO;
            }
        }
    }
    if (btn.tag == 1) {
        self.actuallyMoneyLabel.text = [NSString stringWithFormat:@"¥ %@",self.actuallyMoney];
        [self.payBtn setTitle:@"前往淘宝" forState:UIControlStateNormal];
    }
    if (btn.tag == 2 || btn.tag == 3) {
        self.actuallyMoneyLabel.text = [NSString stringWithFormat:@"¥ %@",self.actuallyMoney];
        [self.payBtn setTitle:@"支付" forState:UIControlStateNormal];
    } else if (btn.tag == 4) {
        self.actuallyMoneyLabel.text = [NSString stringWithFormat:@"%ld 金币",[self.actuallyMoney integerValue] * 100];
        [self.payBtn setTitle:@"支付" forState:UIControlStateNormal];
    }
}
#pragma mark ========= 配置View =========
- (void)configView
{
    self.actuallyMoneyLabel.text = [NSString stringWithFormat:@"¥ %@",self.actuallyMoney];
    self.userGoldLabel.text = [NSString stringWithFormat:@"%ld 金币",IsLocalAccount ? [USER_DEFAULTS integerForKey:User_sum_LocalAccount]:[USER_DEFAULTS integerForKey:User_sum]];
    if ([USER_DEFAULTS boolForKey:AppStatus] == NO) {
        PayMethodButton *payMethodBtn = [[PayMethodButton alloc] initWithFrame:CGRectMake(20, self.userGoldLabel.bottom+20, UI_SCREEN_WIDTH - 20*2, 30)];
        payMethodBtn.payMethod = 4;
        payMethodBtn.tag = 4;
        [payMethodBtn addTarget:self action:@selector(payMethodBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:payMethodBtn];
        return;
    }
    for (int i = 0; i < 4; i ++) {
        PayMethodButton *payMethodBtn = [[PayMethodButton alloc] initWithFrame:CGRectMake(20, self.userGoldLabel.bottom+20 + 40*i, UI_SCREEN_WIDTH - 20*2, 30)];
        payMethodBtn.payMethod = i + 1;
        payMethodBtn.tag = i + 1;
        [payMethodBtn addTarget:self action:@selector(payMethodBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:payMethodBtn];
    }
}

#pragma mark -
#pragma mark - 导航按钮
- (void)baseNaviButtonClickedWithBtnType:(naviBtnType)btnType {
    if (btnType == LeftBtnType) {
        [XZCustomViewManager showSystemAlertViewWithTitle:@"温馨提示" message:@"是否离开收银台？" cancelButtonTitle:@"取消" otherButtonTitle:@"离开" isTouchbackground:NO withAlertViewType:XZAlertViewTypeSystemAlert handler:^(XZCustomAlertView *alertView, XZAlertViewBtnTag buttonIndex, XZAlertViewType alertViewType) {
            if (buttonIndex == XZAlertViewBtnTagSure) {
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
