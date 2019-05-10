//
//  RegisterViewController.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/11/20.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import "RegisterViewController.h"
#import "Tools.h"
#import "HttpRequest+User.h"
#import "UserManager.h"

@interface RegisterViewController () <UITextViewDelegate,UITextFieldDelegate>
{
    NSTimer *_timer;
    NSInteger _seconds;
    
    NSString *_uidStr;
    NSString *_codeKey;
}
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UITextField *codeImgTF;
@property (weak, nonatomic) IBOutlet UITextField *smsCodeTF;
@property (weak, nonatomic) IBOutlet UIButton    *codeImgBtn;
@property (weak, nonatomic) IBOutlet UIButton    *getCodeBtn;
@property (weak, nonatomic) IBOutlet UITextView  *protocolTextView;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self configNavigationBarWithNaviTitle:NSLocalizedString_ZT(@"注册") naviFont:20.0 leftBtnTitle:@"back.png" rightBtnTitle:@"" bgColor:MAIN_RGB];
    
    _uidStr = @"";
    _codeKey = UserImgCode_CodeKey;
    [UserManager userImgCodeWithCodeKey:_codeKey codeType:@"1" codeImgBtn:self.codeImgBtn];
    
    //总统网校服务协议
    NSMutableAttributedString *attriStr = [[NSMutableAttributedString alloc] initWithAttributedString:self.protocolTextView.attributedText];
    NSRange range = [[attriStr string] rangeOfString:@"《总统网校服务协议》"];
    [attriStr addAttribute:NSLinkAttributeName value:@"protocol://" range:range];
    [attriStr addAttribute:NSForegroundColorAttributeName value:MAIN_RGB_TEXT range:NSMakeRange(0, 11)];
    self.protocolTextView.attributedText = attriStr;
    self.protocolTextView.delegate = self;
    
    self.phoneTF.delegate = self;
}
#pragma mark - 注册按钮
- (IBAction)registerBtnClicked:(id)sender
{
    [UserManager userRegisterWithVC:self
                              phone:self.phoneTF.text
                           password:[ManagerTools MD5WithStr:self.passwordTF.text]
                            agentId:@"0"
                             status:@"0"
                             remark:@"iOSApp注册"
                         insertName:@"iOSApp"
                            smsCode:self.smsCodeTF.text
                            imgCode:self.codeImgTF.text
                            codeKey:_codeKey];
}

#pragma mark - 图片验证码按钮
- (IBAction)codeImgBtnClicked:(id)sender
{
    [UserManager userImgCodeWithCodeKey:_codeKey codeType:@"1" codeImgBtn:self.codeImgBtn];
}

#pragma mark - 验证手机是否注册
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [UserManager userCheckPhoneIsRegisteredWithVC:self phone:textField.text];
    return YES;
}

#pragma mark - 获取短信验证码
- (IBAction)getCodeBtnClicked:(id)sender
{
    if (self.passwordTF.text.length == 0) {
        [XZCustomWaitingView showAutoHidePromptView:@"请填写信息完整" background:nil showTime:1.0f];
        return;
    }
    [UserManager UserSendSmsCodeWithPhone:self.phoneTF.text imgCode:self.codeImgTF.text codeKey:_codeKey completed:^(id obj)
    {
        //修改按钮状态
        self.getCodeBtn.enabled = NO;
        //开启定时器
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerCountdown) userInfo:nil repeats:YES];
        //开启定时器
        _seconds = 31;
        [_timer setFireDate:[NSDate distantPast]];
        self.getCodeBtn.backgroundColor = MAIN_RGB_TEXT;
        self.getCodeBtn.titleLabel.font = FontOfSize(12.0);
    }];
}

#pragma mark - 倒计时
- (void)timerCountdown
{
    _seconds --;
    [self.getCodeBtn setTitle:[NSString stringWithFormat:@"%ld秒后重新发送",(long)_seconds] forState:UIControlStateNormal];
    if (_seconds == 0)
    {
        [_timer setFireDate:[NSDate distantFuture]];
        [_timer invalidate];
        _timer = nil;
        //改变发送验证码按钮状态
        self.getCodeBtn.enabled = YES;
        self.getCodeBtn.backgroundColor = MAIN_RGB;
        self.getCodeBtn.titleLabel.font = FontOfSize(14.0);
        [self.getCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    }
}

#pragma mark - UITextView代理
- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange
{
    if ([[URL scheme] isEqualToString:@"protocol"])
    {
        NSLog(@"协议方法URL:---%@---",URL);
    }
    return YES;
}

#pragma mark - 导航按钮
- (void)baseNaviButtonClickedWithBtnType:(naviBtnType)btnType
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - dealloc
- (void)dealloc
{
    //销毁定时器
    [_timer invalidate];
    _timer = nil;
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
