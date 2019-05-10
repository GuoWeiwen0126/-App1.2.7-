//
//  ForgetPWViewController.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/11/20.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import "ForgetPWViewController.h"
#import "Tools.h"
#import "HttpRequest+User.h"

#import "UserManager.h"

typedef NS_ENUM(NSUInteger, ForgotPWStep)
{
    SendSmsCode = 0,  //获取验证码
    SetPassword  = 1, //设置密码
};

@interface ForgetPWViewController ()
{
    NSUInteger _step;
    NSTimer *_timer;
    NSInteger _seconds;
    
    NSString *_codeKey;
    NSString *_phoneStr;
    NSString *_smsCodeStr;
}
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgViewHeight;
@property (weak, nonatomic) IBOutlet UIImageView *firstImgView;
@property (weak, nonatomic) IBOutlet UIImageView *secondImgView;
@property (weak, nonatomic) IBOutlet UITextField *firstTF;
@property (weak, nonatomic) IBOutlet UITextField *secondTF;
@property (weak, nonatomic) IBOutlet UITextField *thirdTF;
@property (weak, nonatomic) IBOutlet UIButton *codeImgBtn;
@property (weak, nonatomic) IBOutlet UIButton *getCodeBtn;
@property (weak, nonatomic) IBOutlet UIButton *bottomBtn;

@end

@implementation ForgetPWViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self configNavigationBarWithNaviTitle:@"找回密码" naviFont:18.0 leftBtnTitle:@"back.png" rightBtnTitle:@"" bgColor:MAIN_RGB];
    
    _codeKey = UserImgCode_CodeKey;
    [UserManager userImgCodeWithCodeKey:_codeKey codeType:@"99" codeImgBtn:self.codeImgBtn];
    
    _step = SendSmsCode;
}

#pragma mark - 图片验证码按钮
- (IBAction)codeImgBtnClicked:(id)sender
{
    [UserManager userImgCodeWithCodeKey:_codeKey codeType:@"99" codeImgBtn:self.codeImgBtn];
}

#pragma mark - 获取验证码
- (IBAction)getCodeBtnClicked:(id)sender
{
    //发送短信验证码
    [UserManager UserSendSmsCodeWithPhone:self.firstTF.text imgCode:self.secondTF.text codeKey:_codeKey completed:^(id obj)
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

#pragma mark - 底部按钮点击方法
- (IBAction)bottomBtnClicked:(id)sender
{
    switch (_step)
    {
        case SendSmsCode:
        {
            if (![ManagerTools checkTelNumber:self.firstTF.text])
            {
                [XZCustomWaitingView showAutoHidePromptView:@"请填写正确的手机号" background:nil showTime:1.0f];
                return;
            }
            else if (self.secondTF.text.length == 0 || self.thirdTF.text.length == 0)
            {
                [XZCustomWaitingView showAutoHidePromptView:@"请填写信息完整" background:nil showTime:1.0f];
                return;
            }
            //保存临时信息（phone、smsCode）
            _phoneStr = self.firstTF.text;
            _smsCodeStr = self.thirdTF.text;
            //修改按钮状态、刷新界面
            _step = SetPassword;
            [self changeBgViewStatus];
        }
            break;
        case SetPassword:
        {
            //验证手机号是否注册
            [HttpRequest UserGetPhoneIsRegisterWithPhone:_phoneStr completed:^(id data)
             {
                 NSDictionary *dic = [HttpRequest jsonDataToDicOrArrayWithData:data];
                 if (StatusIsEqualToZero(dic))
                 {
                     if ([dic[@"Data"] isEqualToString:@"YES"])
                     {
                         //手机获取会员信息
                         [UserManager userUserInfoWithPhone:_phoneStr completed:^(id obj) {
                             if (obj != nil) {
                                 NSDictionary *dic = (NSDictionary *)obj;
                                 //密码重置
                                 [UserManager UserResetPasswordWithUid:dic[@"uid"] phone:_phoneStr smsCode:_smsCodeStr newPassword:self.firstTF.text confirmPassword:self.secondTF.text completed:^
                                  {
                                      [self.navigationController popViewControllerAnimated:YES];
                                  }];
                             }
                         }];
                     }
                 }
                 else {ShowErrMsgWithDic(dic)}
             }];
        }
            break;
            
        default:
            break;
    }
}
- (void)changeBgViewStatus
{
    self.bgViewHeight.constant = 120.0f;
    self.codeImgBtn.hidden = YES;
    self.firstImgView.image = [UIImage imageNamed:@"mima.png"];
    self.secondImgView.image = [UIImage imageNamed:@"zaicishuru.png"];
    self.firstTF.text = @"";
    self.firstTF.placeholder = @"请输入新密码";
    self.secondTF.text = @"";
    self.secondTF.placeholder = @"再次输入新密码";
    self.secondTF.secureTextEntry = NO;
    [self.bottomBtn setTitle:@"完成修改" forState:UIControlStateNormal];
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
