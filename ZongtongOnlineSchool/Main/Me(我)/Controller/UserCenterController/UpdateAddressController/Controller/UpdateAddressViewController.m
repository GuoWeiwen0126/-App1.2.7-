//
//  UpdateAddressViewController.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/11/23.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import "UpdateAddressViewController.h"
#import "Tools.h"
#import "MeManager.h"
#import "UpdateAddressTableView.h"
#import "AreaOptionViewController.h"

@interface UpdateAddressViewController () <UpdateAddressDelegate, AreaOptionVCDelegate>

@property (nonatomic, strong) UpdateAddressTableView *tableView;

@end

@implementation UpdateAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self configNavigationBarWithNaviTitle:@"邮寄信息"naviFont:18.0f leftBtnTitle:@"back.png" rightBtnTitle:@"保存" bgColor:MAIN_RGB];
    
    self.tableView = [[UpdateAddressTableView alloc] initWithFrame:CGRectMake(0, self.navigationBar.bottom, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - self.navigationBar.height) style:UITableViewStyleGrouped];
    self.tableView.updateAddressDelegate = self;
    [self.view addSubview:self.tableView];
}

#pragma mark - 修改地区代理方法
- (void)updateAddressChangeArea
{
    AreaOptionViewController *areaVC = [[AreaOptionViewController alloc] init];
    areaVC.areaOptionDelegate = self;
    [self.navigationController pushViewController:areaVC animated:YES];
}
#pragma mark - 地区修改完成代理方法
- (void)areaOptionPopWithProvinceStr:(NSString *)provinceStr cityStr:(NSString *)cityStr
{
    self.tableView.provinceStr = provinceStr;
    self.tableView.cityStr = cityStr;
    self.tableView.areaStr = [NSString stringWithFormat:@"%@ %@",provinceStr,cityStr];
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:1]] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - 导航按钮
- (void)baseNaviButtonClickedWithBtnType:(naviBtnType)btnType
{
    if (btnType == LeftBtnType)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        //保存邮寄信息
        [MeManager meUpdateAddressWithUid:[USER_DEFAULTS objectForKey:User_uid] name:self.tableView.nameStr province:self.tableView.provinceStr city:self.tableView.cityStr address:self.tableView.addressStr completed:^(id obj) {
            if (obj != nil) {
                [USER_DEFAULTS setObject:self.tableView.provinceStr forKey:User_Address_Province];
                [USER_DEFAULTS setObject:self.tableView.cityStr     forKey:User_Address_City];
                [USER_DEFAULTS setObject:self.tableView.addressStr  forKey:User_Address_Address];
                [XZCustomWaitingView showAutoHidePromptView:@"保存成功" background:nil showTime:1.0];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
    }
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
