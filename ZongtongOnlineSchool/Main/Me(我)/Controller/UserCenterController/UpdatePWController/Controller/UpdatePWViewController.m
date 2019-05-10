//
//  UpdatePWViewController.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/11/23.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import "UpdatePWViewController.h"
#import "Tools.h"
#import "MeManager.h"
#import "UpdatePWTableView.h"

@interface UpdatePWViewController ()

@property (nonatomic, strong) UpdatePWTableView *tableView;

@end

@implementation UpdatePWViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self configNavigationBarWithNaviTitle:@"修改密码"naviFont:18.0f leftBtnTitle:@"back.png" rightBtnTitle:@"保存" bgColor:MAIN_RGB];
    
    self.tableView = [[UpdatePWTableView alloc] initWithFrame:CGRectMake(0, self.navigationBar.bottom, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - self.navigationBar.height) style:UITableViewStylePlain];
    self.tableView.bounces = NO;
    [self.view addSubview:self.tableView];
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
        if ([MeManager checkUpdatePasswordInfoWithOldPW:self.tableView.cell_oldPW.textField.text newPW:self.tableView.cell_newPW.textField.text confirmPW:self.tableView.cell_confirmPW.textField.text] == NO)
        {
            return;
        }
//        NSLog(@"---%@---%@---%@---",self.tableView.cell_oldPW.textField.text,self.tableView.cell_newPW.textField.text,self.tableView.cell_confirmPW.textField.text);
        [MeManager meUpdatePasswordWithVC:self password:self.tableView.cell_oldPW.textField.text newPassword:self.tableView.cell_confirmPW.textField.text];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
