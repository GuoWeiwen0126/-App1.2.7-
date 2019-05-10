//
//  LoginViewViewController.m
//  TalkfunSDKDemo
//
//  Created by 孙兆能 on 16/5/16.
//  Copyright © 2016年 talk-fun. All rights reserved.
//

#import "LoginViewViewController.h"
#import "LiveLoginViewController.h"
#import "PlaybackLoginViewController.h"
#import "TalkfunApplyViewController.h"
//#import "NetworkDetector.h"
#import "UTLHelpper.h"
//#import "UIView+Toast.h"

@interface LoginViewViewController ()

//@property (nonatomic,strong) NetworkDetector    * networkDetector;

@property (weak, nonatomic ) IBOutlet UIButton           *liveBtn;
@property (weak, nonatomic ) IBOutlet UIButton           *playbackBtn;
@property (weak, nonatomic ) IBOutlet UIImageView        *logoImageView;
@property (weak, nonatomic) IBOutlet UIImageView *mostProfectionalView;
@property (weak, nonatomic ) IBOutlet NSLayoutConstraint *logoLiveBtnhorSpace;
@property (weak, nonatomic ) IBOutlet NSLayoutConstraint *playbackBtnTopToLiveBtn;
@property (weak, nonatomic ) IBOutlet NSLayoutConstraint *playbackBtnLeadingToLiveBtn;
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;
@property (weak, nonatomic ) IBOutlet UIButton           *applyBtn;
@property (weak, nonatomic ) IBOutlet NSLayoutConstraint *logoTopToSuperView;
@property (weak, nonatomic ) IBOutlet NSLayoutConstraint *logoBottomToLiveBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *playbackButtonBottomSpace;


@end

@implementation LoginViewViewController

//- (NetworkDetector *)networkDetector
//{
//    if (!_networkDetector) {
//        __weak typeof(self) weakSelf = self;
//        _networkDetector = [[NetworkDetector alloc] init];
//        _networkDetector.networkChangeBlock = ^(NetworkStatus networkStatus){
//
//            if (networkStatus == 0) {
//                [weakSelf.view toast:@"没有网络" position:ToastPosition];
////                [weakSelf.view makeToast:@"没有网络" duration:5 position:CSToastPositionCenter];
//            }
//        };
//    }
//    return _networkDetector;
//}
//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
//        APPLICATION.statusBarHidden = YES;
//    }
//    return self;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.playbackButtonBottomSpace.constant = HeightRatio*-93;
    [self networkcheck];
    
    [self buttonHide:YES];
    [UIView animateWithDuration:1 animations:^{
        self.mostProfectionalView.alpha = 0.0;
    } completion:^(BOOL finished) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.mostProfectionalView.hidden = YES;
            [self buttonHide:NO];
        });
    }];
    
    self.versionLabel.text = GetVersionText();
    NSAttributedString * attStr = [[NSAttributedString alloc] initWithString:self.applyBtn.titleLabel.text attributes:@{NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle)}];
    [self.applyBtn setAttributedTitle:attStr forState:UIControlStateNormal];
    
    NSString * version = [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"];
    self.versionLabel.text = [NSString stringWithFormat:@"©Talkfun Live V%@",version];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"";
    self.navigationItem.backBarButtonItem = backItem;
}

- (void)buttonHide:(BOOL)hide{
    self.liveBtn.hidden = hide;
    self.playbackBtn.hidden = hide;
}

//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    NSArray * arr = [DEVICEMODEL componentsSeparatedByString:@"iPad"];
//    if (arr.count != 1) {
//        self.logoLiveBtnhorSpace.constant         = - self.logoImageView.center.x + 20;
//        self.playbackBtnTopToLiveBtn.constant     = -self.liveBtn.frame.size.height;
//        self.playbackBtnLeadingToLiveBtn.constant = 30;
//    }
//    else if (ScreenSize.height < 500)
//    {
//        self.logoTopToSuperView.constant = 10;
//        self.logoBottomToLiveBtn.constant = -5;
//    }
//}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
//    NSArray * arr = [DEVICEMODEL componentsSeparatedByString:@"iPad"];
//    if (arr.count != 1) {
//        self.logoLiveBtnhorSpace.constant         = - (self.logoImageView.frame.size.width / 2) + 20;
//        self.playbackBtnTopToLiveBtn.constant     = -self.liveBtn.frame.size.height;
//        self.playbackBtnLeadingToLiveBtn.constant = 30;
//    }
//    else if (ScreenSize.height < 500)
//    {
//        self.logoTopToSuperView.constant = 10;
//        self.logoBottomToLiveBtn.constant = -5;
//    }
}

//MARK:按钮点击事件
//MARK:直播按钮
- (IBAction)liveButtonClicked:(UIButton *)sender {
    
    LiveLoginViewController * liveVC = [[LiveLoginViewController alloc] init];
    [self.navigationController pushViewController:liveVC animated:YES];
    
}
//MARK:点播按钮
- (IBAction)playbackButtonClicked:(UIButton *)sender {
    
    PlaybackLoginViewController * playbackVC = [[PlaybackLoginViewController alloc] init];
    [self.navigationController pushViewController:playbackVC animated:YES];
    
}
//MARK:申请试用按钮
- (IBAction)applyForTrialButtonClicked:(UIButton *)sender {
    
//    ApplyForTrialViewController * applyVC = [[ApplyForTrialViewController alloc] init];
    TalkfunApplyViewController * applyVC = [[TalkfunApplyViewController alloc] init];
//    applyVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//    CATransition* transition = [CATransition animation];
    
//    transition.type = kCATransitionFade;//可更改为其他方式
//    transition.subtype = kCATransitionFromTop;//可更改为其他方式
//    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    [self.navigationController pushViewController:applyVC animated:YES];
    
}

#pragma mark - 检查网络
-(void)networkcheck{
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(judgeNetwork:) name:kReachabilityChangedNotification object:nil];
//    [self.networkDetector networkcheck];
//    [self.hostReach startNotifier];
}

-(void)judgeNetwork:(NSNotification *)note{
    if ([UTLHelpper NetWorkIsOK]) {
        //NSLog(@"------->有网络");
    }
    else{
        //NSLog(@"UTHelper ---->无网络");
        
//        [self.view makeToast:@"启用蜂窝移动数据或无线局域网来访问数据" duration:4 position:CSToastPositionTop];
    }
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
