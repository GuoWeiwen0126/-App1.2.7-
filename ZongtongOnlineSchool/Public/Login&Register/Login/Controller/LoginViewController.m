//
//  LoginViewController.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/11/14.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import "LoginViewController.h"
#import "Tools.h"
#import "UserManager.h"
#import "RegisterViewController.h"
#import "ForgetPWViewController.h"
#import "CourseAreaViewController.h"
#import "CourseOptionFirstViewController.h"

@interface LoginViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
@property (weak, nonatomic) IBOutlet UIButton *tryOutBtn;
@property (weak, nonatomic) IBOutlet UIButton *rememberPWBtn;
@property (weak, nonatomic) IBOutlet UIButton *forgetPWBtn;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self configNavigationBarWithNaviTitle:NSLocalizedString_ZT(@"登录") naviFont:20.0 leftBtnTitle:@"" rightBtnTitle:@"" bgColor:MAIN_RGB];
    self.phoneTF.delegate = self;
    self.passwordTF.delegate = self;
    if ([USER_DEFAULTS boolForKey:User_RememberPassword] && IsLocalAccount == NO) {
        self.phoneTF.text = [USER_DEFAULTS objectForKey:User_phone];
        self.passwordTF.text = [USER_DEFAULTS objectForKey:User_Password];
        self.rememberPWBtn.selected = YES;
    }
    if (AfterReview) {
        self.tryOutBtn.hidden = YES;
    }
}

#pragma mark - 登录按钮点击方法
- (IBAction)loginBtnClicked:(id)sender
{
    [UserManager userLoginWithVC:self phone:self.phoneTF.text password:self.passwordTF.text isVerify:NO];
}
#pragma mark - 试用按钮点击方法
- (IBAction)tryOutBtnClicked:(id)sender
{
    [UserManager userLoginWithVC:self phone:@"16603732323" password:@"123456" isVerify:NO];
}
#pragma mark - 注册按钮点击方法
- (IBAction)registerBtnClicked:(id)sender
{
    RegisterViewController *registerVC = [[RegisterViewController alloc] init];
    [self.navigationController pushViewController:registerVC animated:YES];
}
#pragma mark - 记住密码按钮点击方法
- (IBAction)rememberPWBtnClicked:(id)sender
{
    self.rememberPWBtn.selected = !self.rememberPWBtn.selected;
    [USER_DEFAULTS setBool:self.rememberPWBtn.selected forKey:User_RememberPassword];
    [USER_DEFAULTS synchronize];
}
#pragma mark - 忘记密码按钮点击方法
- (IBAction)forgetPWBtnClicked:(id)sender
{
    ForgetPWViewController *forgetPWVC = [[ForgetPWViewController alloc] init];
    [self.navigationController pushViewController:forgetPWVC animated:YES];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    NSLog(@"---%@---",textField.text);
    if (self.phoneTF.text.length > 0 && self.passwordTF.text.length > 0)
    {
        self.loginBtn.backgroundColor = MAIN_RGB;
        [self.loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    else
    {
        self.loginBtn.backgroundColor = [UIColor whiteColor];
        [self.loginBtn setTitleColor:MAIN_RGB_TEXT forState:UIControlStateNormal];
    }
    
    return YES;
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
