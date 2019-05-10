//
//  UpdatePhoneViewController.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/11/27.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import "UpdatePhoneViewController.h"
#import "Tools.h"
#import "HttpRequest+User.h"
#import "UserManager.h"
#import "MeManager.h"

typedef NS_ENUM(NSUInteger, UpdatePhoneStep)
{
    NowPhone = 0, //现在的手机号
    NewPhone = 1, //新手机号
};

@interface UpdatePhoneViewController ()
{
    NSUInteger _step;
    NSTimer *_timer;
    NSInteger _seconds;
    
    NSString *_codeKey;
    NSString *_uidStr;
    NSString *_oldPhoneStr;
}
@property (weak, nonatomic) IBOutlet UILabel *topLabel;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIImageView *firstImgView;
@property (weak, nonatomic) IBOutlet UIImageView *secondImgView;
@property (weak, nonatomic) IBOutlet UITextField *firstTF;
@property (weak, nonatomic) IBOutlet UITextField *secondTF;
@property (weak, nonatomic) IBOutlet UITextField *thirdTF;
@property (weak, nonatomic) IBOutlet UIButton *codeImgBtn;
@property (weak, nonatomic) IBOutlet UIButton *getCodeBtn;
@property (weak, nonatomic) IBOutlet UIButton *bottomBtn;

@end

@implementation UpdatePhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self configNavigationBarWithNaviTitle:@"修改手机号"naviFont:18.0f leftBtnTitle:@"back.png" rightBtnTitle:@"" bgColor:MAIN_RGB];
    
    self.topLabel.text = [NSString stringWithFormat:@"当前的手机号为：%@",[USER_DEFAULTS objectForKey:User_phone]];
    self.firstTF.text = [USER_DEFAULTS objectForKey:User_phone];
    self.firstTF.enabled = NO;
    
    _uidStr = @"";
    _codeKey = UserImgCode_CodeKey;
    [UserManager userImgCodeWithCodeKey:_codeKey codeType:@"99" codeImgBtn:self.codeImgBtn];
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
         //保存临时信息（uid）
         _uidStr = [NSString stringWithFormat:@"%@",obj];
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
        case NowPhone:
        {
            [MeManager meVerifySmsCodeWithPhone:self.firstTF.text imgCode:self.secondTF.text smsCode:self.thirdTF.text completed:^(id obj)
            {
                if (obj != nil && [obj integerValue] == 0)
                {
                    //保存临时信息（老的手机号码）
                    _oldPhoneStr = self.firstTF.text;
                    //修改按钮状态、刷新界面
                    _step = NewPhone;
                    [self changeBgViewStatus];
                }
            }];
        }
            break;
        case NewPhone:
        {
            [MeManager meUpdatePhoneWithVC:self phone:_oldPhoneStr newPhone:self.firstTF.text smsCode:self.thirdTF.text uid:_uidStr imgCode:self.secondTF.text];
        }
            break;
            
        default:
            break;
    }
}
- (void)changeBgViewStatus
{
    //刷新图片验证码
    [UserManager userImgCodeWithCodeKey:_codeKey codeType:@"99" codeImgBtn:self.codeImgBtn];
    //重启定时器
    [_timer setFireDate:[NSDate distantFuture]];
    [_timer invalidate];
    _timer = nil;
    //改变发送验证码按钮状态
    self.getCodeBtn.enabled = YES;
    self.getCodeBtn.backgroundColor = MAIN_RGB;
    self.getCodeBtn.titleLabel.font = FontOfSize(14.0);
    [self.getCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    //改变控件状态
    [self.firstTF resignFirstResponder];
    [self.secondTF resignFirstResponder];
    [self.thirdTF resignFirstResponder];
    self.topLabel.text = @"请填写新手机号信息";
    self.firstTF.text = @"";
    self.firstTF.placeholder = @"请输入新手机号";
    self.firstTF.enabled = YES;
    self.secondTF.text = @"";
    self.secondTF.placeholder = @"图片验证码";
    self.thirdTF.text = @"";
    self.thirdTF.placeholder = @"短信验证码";
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
