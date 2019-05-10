//
//  TalkfunNewLoginViewController.m
//  TalkfunSDKDemo
//
//  Created by Sunzn on 2017/4/18.
//  Copyright © 2017年 Talkfun. All rights reserved.
//

#import "TalkfunNewLoginViewController.h"
#import "TalkfunButton.h"
#import "TalkfunMoreBtn.h"
#import "AppDelegate.h"
#import "TalkfunWindow.h"
#import "TalkfunApplyViewController.h"
#import "TalkfunInputNameViewController.h"
#import "TalkfunScanViewController.h"
#import "DownloadListController.h"
#import "LiveLoginViewController.h"
#import "TalkfunViewController.h"
#import "TalkfunPlaybackViewController.h"
#import "TalkfunAboutViewController.h"
#import "UIImageView+WebCache.h"
//#import "TalkfunXiaoBanViewController.h"//小班
#define NewIDsStr @"newIDs"
#define RememberID @"rememberID"
#define LogoUrl @"LogoUrl"
#define ConstraintValue 80
#define KIsiPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
@interface TalkfunNewLoginViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIButton *scanBtn;
@property (weak, nonatomic) IBOutlet TalkfunMoreBtn *moreBtn;
@property (weak, nonatomic) IBOutlet UIImageView *logoImage;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tfContainerHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tfContainerWidth;
@property (weak, nonatomic) IBOutlet UIView *idUnderLineView;
@property (weak, nonatomic) IBOutlet UITextField *idTF;
@property (weak, nonatomic) IBOutlet UIView *secretUnderLineView;
@property (weak, nonatomic) IBOutlet UITextField *secretTF;
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UIView *nameUnderLineView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *idTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameTopConstraint;
@property (weak, nonatomic) IBOutlet UIButton *rememberBtn;
@property (weak, nonatomic) IBOutlet UIButton *getInBtn;
@property (weak, nonatomic) IBOutlet UIImageView *selectTipsImage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *moreContainerViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *moreContainerViewWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *settingBtnTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *offlineBtnTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *helpBtnTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *aboutBtnTop;
@property (nonatomic,strong) TalkfunButton * selectModeBtn;
@property (nonatomic,strong) TalkfunButton * secretBtn;
@property (nonatomic,strong) TalkfunButton * nameBtn;
@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) NSMutableArray * idsArray;
@property (weak, nonatomic) IBOutlet UIView *moreContainerView;
@property (weak, nonatomic) IBOutlet UILabel *secretFaultTips;
@property (weak, nonatomic) IBOutlet UIView *modeSelectView;
@property (weak, nonatomic) IBOutlet TalkfunMoreBtn *liveBtn;
@property (weak, nonatomic) IBOutlet TalkfunMoreBtn *playbackBtn;
@property (weak, nonatomic) IBOutlet UILabel *courseTitle;
@property (weak, nonatomic) IBOutlet UIImageView *navLeftImage;
@property (weak, nonatomic) IBOutlet UILabel *navLeftLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tfContainerViewTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rememberBtnHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *getInBtnTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *logoTop;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *top_2;

//保存直播间登陆的数据
@property(nonatomic,strong)NSMutableDictionary *liveLandingData;

//保存点播间登陆的数据
@property(nonatomic,strong)NSMutableDictionary *playbackLandingData;

//切换前保存
@property (strong, nonatomic)NSString* currentLive;

//切换前保存
@property (strong, nonatomic)NSString* currentPlayback;
@end

@implementation TalkfunNewLoginViewController
- (NSMutableDictionary *)liveLandingData
{
    if(!_liveLandingData){
        _liveLandingData = [NSMutableDictionary dictionary];
    } return _liveLandingData;
}
- (NSMutableDictionary *)playbackLandingData
{
    if(!_playbackLandingData){
        _playbackLandingData = [NSMutableDictionary dictionary];
    } return _playbackLandingData;
}
- (void)viewDidLoad {
    [super viewDidLoad];

    
    if (IsIPAD) {
        self.logoTop.constant = CGRectGetHeight(self.view.frame)/2-64;
        self.tfContainerWidth.constant = 320;
    }
    
    [self configTF];
    [self configModeContainerView];
    [self configMoreContainerView];
    [self configGetInBtn];
    
    self.secretFaultTips.alpha = 0.0;
    //    self.isScanIn = NO;
    self.courseTitle.hidden = YES;
    
    [self.idsArray removeAllObjects];
    [self.idsArray addObjectsFromArray:[self getNSUserDefaultWithKey:NewIDsStr]];
    NSString * IDStr = [self getNSUserDefaultWithKey:RememberID];
    if (IDStr && ![IDStr isKindOfClass:[NSNull class]]&&!self.isPlayback) {
        self.idTF.text = IDStr;
        self.selectTipsImage.image = [UIImage imageNamed:@"select"];
        self.rememberBtn.selected = YES;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideMoreView:) name:@"HideMoreView" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:)
                                                name:UITextFieldTextDidChangeNotification object:self.idTF];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    TalkfunWindow * window = (TalkfunWindow *)appDelegate.window;
    window.viewFrame = self.moreContainerView.frame;
    
    if (!IsIPAD){
        //        view height : 300.000000  : 55.500000 : 98.000000 : 70.000000
//        NSLog(@"view height : %lf  : %lf : %lf : %lf",CGRectGetHeight(self.view.frame)/2.0,self.containerView.frame.size.height/2.0,CGRectGetHeight(self.logoImage.frame),self.tfContainerViewTop.constant);
        self.logoTop.constant = CGRectGetHeight(self.view.frame)/2.0-self.containerView.frame.size.height/2.0-CGRectGetHeight(self.logoImage.frame)-self.tfContainerViewTop.constant-44-20;
        self.tfContainerWidth.constant = 216*CGRectGetHeight(self.view.frame)/568;
    }
    [self isScanIn:self.isScanIn];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    
    if (self.isPlayback) {
        [self.nameBtn setTitle:@"点播ID" forState:UIControlStateNormal];
        self.nameTF.text = self.liveid;
        self.nameTF.keyboardType = UIKeyboardTypeDecimalPad;
        
//         [self.getInBtn  setTitle:@"进入回放" forState:UIControlStateNormal];
        
    }else{
        [self.nameBtn setTitle:@"昵称" forState:UIControlStateNormal];
        if(self.liveid.length>1){
              self.idTF.text = self.liveid;
        }
       
//         [self.getInBtn  setTitle:@"进入直播" forState:UIControlStateNormal];
    }
    
    [self logoImageSet];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    //    [self historyList:YES];
    self.view.userInteractionEnabled = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self selectLiveBtn:self.liveBtn.selected];
}

- (void)logoImageSet{
    id obj = [UserDefault objectForKey:LogoUrl];
    if (obj) {
        NSString * logoUrl = obj[@"logo"];
        [self.logoImage sd_setImageWithURL:[NSURL URLWithString:logoUrl] placeholderImage:nil options:0];
    }else{
        self.logoImage.image = [UIImage imageNamed:@"欢拓云播"];
    }
}

- (void)hideMoreView:(NSNotification *)notification{
    self.moreContainerView.hidden = YES;
}



- (void)configTF{
    self.containerView.clipsToBounds = YES;
    //    self.tfContainerHeight.constant = 111;
    
    TalkfunButton * selectModeBtn = [TalkfunButton buttonWithType:UIButtonTypeCustom];
    selectModeBtn.frame = CGRectMake(0, 0, 60, 30);
    selectModeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [selectModeBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [selectModeBtn setTitle:@"直播ID" forState:UIControlStateNormal];
    [selectModeBtn addTarget:self action:@selector(selectModeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [selectModeBtn setImage:[UIImage imageNamed:@"downward"] forState:UIControlStateNormal];
    self.selectModeBtn = selectModeBtn;
    self.idTF.leftView = selectModeBtn;
    self.idTF.delegate = self;
    self.idTF.leftViewMode = UITextFieldViewModeAlways;
    self.idTF.textAlignment = NSTextAlignmentRight;
    //    self.idTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    TalkfunButton * secretBtn = [TalkfunButton buttonWithType:UIButtonTypeCustom];
    secretBtn.frame = CGRectMake(0, 0, 60, 30);
    secretBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [secretBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [secretBtn setTitle:@"密码" forState:UIControlStateNormal];
    self.secretBtn = secretBtn;
    self.secretTF.leftView = secretBtn;
    self.secretTF.delegate = self;
    self.secretTF.leftViewMode = UITextFieldViewModeAlways;
    self.secretTF.textAlignment = NSTextAlignmentRight;
    self.secretTF.secureTextEntry = YES;
    if(!self.isPlayback){
        self.secretTF.placeholder = @"若是公开课,无需密码";
    }else{
        
        
        
    }
    
    
    if([self.temporary isEqualToString:@"1"]){
        self.secretTF.hidden = YES;
        
        self.secretUnderLineView.hidden = YES;
    }
    self.secretTF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    //    self.secretTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    TalkfunButton * nameBtn = [TalkfunButton buttonWithType:UIButtonTypeCustom];
    nameBtn.frame = CGRectMake(0, 0, 60, 30);
    nameBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [nameBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    //    if (self.isPlayback) {
    //        [nameBtn setTitle:@"点播ID" forState:UIControlStateNormal];
    //        self.nameTF.text = self.liveid;
    //        self.nameTF.keyboardType = UIKeyboardTypeDecimalPad;
    //
    //    }else{
    //      [nameBtn setTitle:@"昵称" forState:UIControlStateNormal];
    //    }
    
    self.nameBtn = nameBtn;
    self.nameTF.leftView = nameBtn;
    self.nameTF.delegate = self;
    self.nameTF.leftViewMode = UITextFieldViewModeAlways;
    self.nameTF.textAlignment = NSTextAlignmentRight;
    //    self.nameTF.secureTextEntry = YES;
    //    self.nameTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    if (self.isScanIn&&(self.roomid||self.liveid)) {
        self.idTF.text = self.roomid?self.roomid:self.liveid;
    }
}

- (void)configModeContainerView{
    self.modeSelectView.backgroundColor = [UIColor whiteColor];
    self.modeSelectView.layer.cornerRadius = 4;
    self.modeSelectView.layer.shadowColor = [UIColor grayColor].CGColor;
    self.modeSelectView.layer.shadowOpacity = 0.5;
    self.modeSelectView.layer.shadowOffset = CGSizeMake(0, 2);
    
    
    self.liveBtn.layer.cornerRadius = 4;
    self.playbackBtn.layer.cornerRadius = 4;
    self.modeSelectView.hidden = YES;
    [self selectLiveBtn:YES];
    
}

- (void)selectLiveBtn:(BOOL)liveBtn{
    
    self.liveBtn.selected = liveBtn;
    self.playbackBtn.selected = !liveBtn;
    self.liveBtn.backgroundColor = liveBtn?GRAYCOLOR:[UIColor clearColor];
    self.playbackBtn.backgroundColor = liveBtn?[UIColor clearColor]:GRAYCOLOR;
    [self.selectModeBtn setTitle:liveBtn?self.liveBtn.titleLabel.text:self.playbackBtn.titleLabel.text forState:UIControlStateNormal];
    [self selectModeBtnSelected:NO];
    
    
    self.nameBtn.hidden = !liveBtn;
    self.nameTF.hidden =  !liveBtn;
    
    self.nameUnderLineView.hidden =  !liveBtn;
}

- (void)configMoreContainerView{
    self.moreContainerView.clipsToBounds = NO;
    self.moreContainerView.backgroundColor = [UIColor whiteColor];
    self.moreContainerView.layer.cornerRadius = 4;
    self.moreContainerView.layer.shadowOffset = CGSizeMake(0, 0);
    self.moreContainerView.layer.shadowColor = [UIColor blackColor].CGColor;
    //    self.moreContainerView.layer.shadowRadius = 0.5;
    self.moreContainerView.layer.shadowOpacity = 0.5;
    self.moreContainerView.hidden = YES;
    self.moreContainerViewHeight.constant = 100;
    
    self.settingBtnTop.constant = -150;
    self.helpBtnTop.constant = -150;
    self.offlineBtnTop.constant = 0;
    self.aboutBtnTop.constant = 50;
    
    if (KIsiPhoneX) {
        self.top_2.constant = 15;
    }
    
    //    self.moreContainerView.clipsToBounds = YES;
}

- (void)configGetInBtn{
    self.getInBtn.layer.shadowOffset = CGSizeMake(0, 5);
    self.getInBtn.layer.shadowColor = [UIColor grayColor].CGColor;
    self.getInBtn.layer.shadowOpacity = 0.5;
}

- (void)selectModeBtnSelected:(BOOL)selected{
    self.modeSelectView.alpha = selected?1.:0.;
    self.modeSelectView.hidden = !selected;
    [self.selectModeBtn setImage:[UIImage imageNamed:selected?@"upward":@"downward"] forState:UIControlStateNormal];
}

- (void)isScanIn:(BOOL)isScanIn{
    self.nameTopConstraint.constant = isScanIn?0:ConstraintValue;
    self.idTopConstraint.constant = isScanIn?ConstraintValue:0;
    self.tfContainerHeight.constant = isScanIn?81:111;
    self.tfContainerViewTop.constant = isScanIn?70:20;
    self.courseTitle.hidden = !isScanIn;
    self.navLeftImage.image = [UIImage imageNamed:isScanIn?@"back":@"扫码"];
    self.navLeftLabel.text = isScanIn?@"扫一扫":@"扫码登录";
    self.rememberBtnHeight.constant = isScanIn?0:34;
    self.rememberBtn.hidden = isScanIn;
    self.selectTipsImage.hidden = self.rememberBtn.hidden;
    self.getInBtnTop.constant = isScanIn?0:20;
}

#pragma mark - 按钮点击事件
- (IBAction)scanBtnClicked:(UIButton *)sender {
    if (self.isScanIn) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        TalkfunScanViewController * scanVC = [TalkfunScanViewController new];
        [self.navigationController pushViewController:scanVC animated:YES];
    }
    NSLog(@"___%s___",__func__);
}
- (IBAction)liveBtnClicked:(TalkfunMoreBtn *)sender {
    
    //登陆成功才保存
    if (self.idTF.text.length>0) {
        //直播间是登陆成功了的,  保存当前直播间,稍等回来自动加载密码
        if ( self.playbackLandingData[self.idTF.text]) {
            
            self.currentPlayback = self.idTF.text;
            
        }
    }
    
    [self.getInBtn  setTitle:@"进入直播" forState:UIControlStateNormal];
    [self.nameBtn setTitle:@"昵称" forState:UIControlStateNormal];
    self.nameTF.keyboardType = UIKeyboardTypeDefault;
    self.liveBtn.selected =YES;
    self.isPlayback = NO;
    self.secretTF.text = @"";
    self.nameTF.text = @"";
    
    
    if ( self.currentLive.length>0) {
        //读取刚刚 保存切换前的数据出来 填写
        if ( self.liveLandingData[self.currentLive]) {
            
            NSMutableDictionary *params =        self.liveLandingData[self.currentLive];
            
            self.idTF.text = params[@"id"];
            self.secretTF.text =  params[@"password"];
            self.nameTF.text = params[@"nickname"];
        }else{
             self.idTF.text = self.currentLive;
        }
    }else{
    self.idTF.text = self.currentLive;
    if (!self.liveBtn.selected||self.isPlayback==YES) {
       
        self.secretTF.text = nil;
        self.nameTF.text = nil;
    }
        
    }
    [self selectLiveBtn:YES];
}
- (IBAction)playbackBtnClicked:(TalkfunMoreBtn *)sender {
    
    if (self.idTF.text.length>0) {
        //直播间是登陆成功了的,  保存当前直播间,稍等回来自动加载密码
        if ( self.liveLandingData[self.idTF.text]) {
            
            self.currentLive = self.idTF.text;
            
        }
    }
       if ( self.currentPlayback.length>0) {
           //读取刚刚 保存切换前的数据出来 填写
           if ( self.playbackLandingData[self.currentPlayback]) {
               
       NSMutableDictionary *params =        self.playbackLandingData[self.currentPlayback];
               
               self.idTF.text = params[@"id"];
               self.secretTF.text =  params[@"password"];
           }else{
                self.idTF.text = self.currentPlayback;
           }
       }else{
            self.idTF.text = self.currentPlayback;
           if (self.liveBtn.selected||self.isPlayback==YES) {
               
              
               self.secretTF.text = nil;
               self.nameTF.text = nil;
           }
       }
   
    [self.getInBtn  setTitle:@"进入回放" forState:UIControlStateNormal];
    [self selectLiveBtn:NO];
}
- (IBAction)moreBtnClicked:(TalkfunMoreBtn *)sender {
    [self selectLiveBtn:self.liveBtn.selected];
    self.moreContainerView.hidden = NO;
    NSLog(@"___%s___",__func__);
}
- (void)selectModeBtnClicked:(UIButton *)btn{
    [self historyList:YES];
    if (self.modeSelectView.hidden) {
        [self selectModeBtnSelected:YES];
    }else{
        [self selectModeBtnSelected:NO];
    }
    NSLog(@"___%s___",__func__);
}
- (IBAction)rememberBtnClicked:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        self.selectTipsImage.image = [UIImage imageNamed:@"select"];
    }
    else
    {
        self.selectTipsImage.image = [UIImage imageNamed:@"unselect"];
    }
    NSLog(@"___%s___",__func__);
}
// 控制器的view完全消失的时候调用
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
     if([self.temporary isEqualToString:@"1"]){
        self.isScanIn = NO;
        self.temporary = @"0";
        
        self.secretUnderLineView.hidden = NO;
        self.secretTF.hidden = NO;
        self.secretTF.text = nil;
        self.nameTF.text = nil;
        self.idTF.text  = nil;
    }

}

- (IBAction)getInBtnClicked:(UIButton *)sender {
    
//    self.nameTF.text = @"手机学员";
//    self.secretTF.text = @"123456";

    

//    
//    dispatch_async(dispatch_get_main_queue(), ^{
//
//        TalkfunXiaoBanViewController *push = [[UIStoryboard storyboardWithName:@"TalkfunXiaoBanViewController" bundle:nil] instantiateViewControllerWithIdentifier:@"123"];
//
    
        
   
//    });
//
//    return;
    if (!self.isPlayback) {
        if (TEXTFIELDHASNOVALUE(self.idTF)) {
            [self.view toast:@"请输入ID" position:ToastPosition];
            return;
        }else if (self.liveBtn.selected && TEXTFIELDHASNOVALUE(self.nameTF)){
            [self.view toast:@"请输入昵称" position:ToastPosition];
            return;
        }
    }else{
        //换为点播状态
        self.liveBtn.selected =NO;
    }
    self.liveid = @"";
    NSMutableDictionary * params = [NSMutableDictionary new];
    params[@"id"] = self.idTF.text;
    params[@"type"] = self.liveBtn.selected?@(4):@(5);
    if (self.liveBtn.selected) {
        params[@"nickname"] = self.nameTF.text;
    }
    if (!TEXTFIELDHASNOVALUE(self.secretTF)) {
        params[@"password"] = self.secretTF.text;
    }
    WeakSelf
    __block TalkfunViewController * myVC = nil;
    __block TalkfunPlaybackViewController * playbackVC = nil;
    [self.view startAnimation];
    
    [self.view endEditing:YES];
    
    //防止快速重复点击 进入
    self.view.userInteractionEnabled = NO;
    //只要昵称 的请求
    if([self.temporary isEqualToString:@"1"]){
        
        NSMutableDictionary  *tempParameter= [NSMutableDictionary dictionary];
        [tempParameter setObject:self.nameTF.text forKey:@"nickname"];//名字
        [tempParameter setObject:self.liveid forKey:@"roomid"];//房间id
        [tempParameter setObject:self.role forKey:@"role"];//用户身份
        [tempParameter setObject:self.temporary forKey:@"temporary"];//是否临时登录链接
        [tempParameter setObject:self.et forKey:@"et"];//过期时间
        [tempParameter setObject:self.sign forKey:@"sign"];
        
        [TalkfunLoginRequest   tempLoginRequestForScanIn:tempParameter callback:^(id result) {
            if ([result isKindOfClass:[NSDictionary class]] &&[result[@"code"] intValue] == 0) {
                [UserDefault synchronize];
                myVC = [[TalkfunViewController alloc] init];
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                [dict setObject:@"0" forKey:@"code"];
                
                NSMutableDictionary *data = [NSMutableDictionary dictionary];
                [data setObject:weakSelf.title1 forKey:@"title"];
                [data  setObject:weakSelf.logo forKey:@"logo"];
                
                [data  setObject:result[@"data"][@"access_token"] forKey:@"access_token"];
                [dict setObject:data forKey:@"data"];
                myVC.res = dict;
                dispatch_async(dispatch_get_main_queue(), ^{
                   
                   
//                    weakSelf.isScanIn = NO;
//                     weakSelf.temporary = @"0";
//
//                     weakSelf.secretUnderLineView.hidden = NO;
//                     weakSelf.secretTF.hidden = NO;
//                    weakSelf.secretTF.text = nil;
//                    weakSelf.nameTF.text = nil;
//                    weakSelf.idTF.text  = nil;
                    
                    [weakSelf presentViewController:myVC animated:YES completion:nil];
                    
                });
                
                
                
                
            }else
            {    dispatch_async(dispatch_get_main_queue(), ^{
                if ([result isKindOfClass:[NSDictionary class]]) {
                    [weakSelf.view toast:result[@"msg"] position:ToastPosition];
                }else{
                    NSError * error = result;
                    [weakSelf.view toast:error.userInfo[NSLocalizedDescriptionKey] position:ToastPosition];
                }
            });
                weakSelf.view.userInteractionEnabled = YES;
            }
            [weakSelf.view stopAnimation];
            
        }];
        
        
        
    }else{
       
        
        //不是扫码的登陆
        [TalkfunLoginRequest requestForNewLogin:params callback:^(id result) {
            if ([result isKindOfClass:[NSDictionary class]] &&[result[@"code"] intValue] == 0) {
                
                //直播字典保存
                if (weakSelf.liveBtn.selected) {
                    NSMutableDictionary *copyParams = [NSMutableDictionary dictionaryWithDictionary:params];
                    [weakSelf.liveLandingData  setObject:copyParams forKey:params[@"id"]];

                }else{
                    
                    //观看
                    NSMutableDictionary *copyParams = [NSMutableDictionary dictionaryWithDictionary:params];
                    [weakSelf.playbackLandingData  setObject:copyParams forKey:params[@"id"]];

                }
                
                
                //            存储数据
                if (!weakSelf.isScanIn) {
                    if (weakSelf.idTF.text.length != 0) {
                        [weakSelf saveValue:NewIDsStr Value:self.idTF.text];
                    }
                    if (weakSelf.rememberBtn.selected) {
                        [UserDefault setObject:weakSelf.idTF.text forKey:RememberID];
                    }else{
                        [UserDefault removeObjectForKey:RememberID];
                    }
                }
                if (result[@"data"][@"logo"]) {
                    [UserDefault setObject:result[@"data"] forKey:LogoUrl];
                }
                [UserDefault synchronize];
                
                if (weakSelf.liveBtn.selected) {
                    myVC = [[TalkfunViewController alloc] init];
                    myVC.res = result;
                    if (result[@"data"][@"access_token"]) {
                        
//                   push.token =     result[@"data"][@"access_token"];
                        dispatch_async(dispatch_get_main_queue(), ^{
                               [weakSelf presentViewController:myVC animated:YES completion:nil];
                        });
                        
                    }
                }else{
                    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:result];
                    parameters[TalkfunPlaybackID] = weakSelf.idTF.text;
                    playbackVC = [[TalkfunPlaybackViewController alloc] init];
                    playbackVC.playbackID = weakSelf.idTF.text;
                    playbackVC.res = parameters;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        weakSelf.temporary = @"0";
                        weakSelf.isScanIn = NO;
                        
                        
                            [weakSelf presentViewController:playbackVC animated:YES completion:nil];
                    
                    });
                    
                }
                
                
            }
            else
            {  dispatch_async(dispatch_get_main_queue(), ^{
                if ([result isKindOfClass:[NSDictionary class]]) {
                    [weakSelf.view toast:result[@"msg"] position:ToastPosition];
                }else{
                    
                    NSError * error = result;
                    [weakSelf.view toast:error.userInfo[NSLocalizedDescriptionKey] position:ToastPosition];
                    
                }
            });
                weakSelf.view.userInteractionEnabled = YES;
                
                if (weakSelf.liveBtn.selected) {
                    
                    weakSelf.currentLive =  weakSelf.idTF.text;
                    if (self.currentLive) {
                         [weakSelf.liveLandingData removeObjectForKey:weakSelf.currentLive];
                    }
                   
                    weakSelf.secretTF.text = nil;
                    weakSelf.nameTF.text = nil;
                }else{
                    //观看
                    weakSelf.currentPlayback =  weakSelf.idTF.text;
                    if (weakSelf.currentPlayback) {
                         [weakSelf.playbackLandingData removeObjectForKey:weakSelf.currentPlayback];
                    }
                    
                    //                weakSelf.idTF.text = nil;
                    weakSelf.secretTF.text = nil;
                    weakSelf.nameTF.text = nil;
                }
            }
            [weakSelf.view stopAnimation];
            
            

        }];
    }
    
    
    
    
    NSLog(@"___%s___",__func__);
    
}
- (IBAction)oldVersionBtn:(UIButton *)sender {
    LiveLoginViewController * liveVC = [[LiveLoginViewController alloc] init];
    [self.navigationController pushViewController:liveVC animated:YES];
    NSLog(@"___%s___",__func__);
}
- (IBAction)applyBtn:(UIButton *)sender {
    TalkfunApplyViewController * applyVC = [[TalkfunApplyViewController alloc] init];
    [self.navigationController pushViewController:applyVC animated:YES];
    NSLog(@"___%s___",__func__);
}
- (IBAction)downloadListBtnClicked:(TalkfunMoreBtn *)sender {
    DownloadListController * dv = [[DownloadListController alloc] init];
    
    [self.navigationController pushViewController:dv animated:YES];
    //    [self presentViewController:dv animated:YES completion:nil];
}
- (IBAction)aboutBtnClicked:(TalkfunMoreBtn *)sender {
    TalkfunAboutViewController * aboutVC = [TalkfunAboutViewController new];
    [self.navigationController pushViewController:aboutVC animated:YES];
}

#pragma mark - textfield delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField == self.idTF) {
        [self.selectModeBtn setTitleColor:BLUECOLOR forState:UIControlStateNormal];
        self.idUnderLineView.backgroundColor = BLUECOLOR;
        if (textField.text.length==0) {
            [self historyList:NO];
        }
    }else if (textField == self.secretTF){
        [self.secretBtn setTitleColor:BLUECOLOR forState:UIControlStateNormal];
        self.secretUnderLineView.backgroundColor = BLUECOLOR;
        self.secretFaultTips.alpha = 0.0;
    }else if (textField == self.nameTF){
        [self.nameBtn setTitleColor:BLUECOLOR forState:UIControlStateNormal];
        self.nameUnderLineView.backgroundColor = BLUECOLOR;
    }
    
    if (!self.isPlayback) {
        [self selectLiveBtn:self.liveBtn.selected];
    }
    
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    if (textField == self.idTF) {
        [self.selectModeBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        self.idUnderLineView.backgroundColor = GRAYCOLOR;
    }else if (textField == self.secretTF){
        [self.secretBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        self.secretUnderLineView.backgroundColor = GRAYCOLOR;
    }else if (textField == self.nameTF){
        [self.nameBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        self.nameUnderLineView.backgroundColor = GRAYCOLOR;
    }
    return YES;
}

- (void)textFiledEditChanged:(NSNotification *)notification
{
    UITextField * tf = notification.object;
    NSString * text = tf.text;
    NSArray * IDArray = [self getNSUserDefaultWithKey:NewIDsStr];
    [self.idsArray removeAllObjects];
    if (text.length != 0) {
        for (int i = 0; i < IDArray.count; i ++) {
            NSString * t = IDArray[i];
            if ([t hasPrefix:text] && ![t isEqualToString:text]) {
                [self.idsArray addObject:t];
            }
        }
    }
    else
    {
        [self.idsArray addObjectsFromArray:IDArray];
    }
    
    //    [self.tableView reloadData];
    [UIView animateWithDuration:0.3 animations:^{
        //        [self.tableView setFrame:CGRectMake(CGRectGetMinX(self.tableView.frame), CGRectGetMinY(self.containerView.frame) + CGRectGetMaxY(self.idTF.frame), CGRectGetWidth(self.tableView.frame), self.tableView.contentSize.height)];
        [self reloadData];
    }];
}

#pragma mark 当点击键盘的返回键（右下角）时，执行该方法。
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if(self.idTF == textField){
        [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    }
    [self historyList:YES];
    return YES;
}

#pragma mark - tableView dataSource delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.idsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.backgroundColor = UIColorFromRGBHex(0xecf3ff);
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.textLabel.text = self.idsArray[indexPath.row];
    cell.textLabel.textAlignment = NSTextAlignmentRight;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.idTF.text = self.idsArray[indexPath.row];
    
    [self historyList:YES];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    if (self.tableView.editing) {
    //        return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
    //    }
    //    else
    //    {
    return UITableViewCellEditingStyleDelete;
    //    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //        DownloadListModel * model = self.dataSource[indexPath.row];
        //        [self.downloadManager deleteDownload:model.playbackID success:^(id result) {
        //

        UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
        [self remove:NewIDsStr value:cell.textLabel.text];
    }
}

//是否可以编辑  默认YES
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

#pragma mark - 存储数据到本地
- (void)saveValue:(NSString *)key Value:(NSString *)value
{
    @synchronized (self) {
        if (!value) {
            return;
        }
        if([[NSUserDefaults standardUserDefaults] objectForKey:key] == nil || [[[NSUserDefaults standardUserDefaults] objectForKey:key] isKindOfClass:[NSNull class]]){
            
            NSMutableArray * mutable = [NSMutableArray array];
            [mutable addObject:value];
            if (mutable.count != 0) {
                [[NSUserDefaults standardUserDefaults] setValue:mutable forKey:key];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
        }
        else{
            NSMutableArray * mutable = [[[NSUserDefaults standardUserDefaults] objectForKey:key] mutableCopy];
            //本地数据是否已经包含
            BOOL contains = [mutable containsObject:value];
            
            if (!contains)
            {
                
            }
            else
            {
                [mutable removeObject:value];
            }
            [mutable insertObject:value atIndex:0];
            if (mutable.count != 0) {
                [[NSUserDefaults standardUserDefaults] setValue:mutable forKey:key];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
        }
        //拿出更新后的数据
        [self.idsArray removeAllObjects];
        [self.idsArray addObjectsFromArray:[self getNSUserDefaultWithKey:NewIDsStr]];
        if (self.idTF.isFirstResponder) {
            [self reloadData];
        }
    }
}

- (void)remove:(NSString *)key value:(NSString *)value{
    @synchronized (self) {
        if (!value) {
            return;
        }
        if([[NSUserDefaults standardUserDefaults] objectForKey:key] == nil || [[[NSUserDefaults standardUserDefaults] objectForKey:key] isKindOfClass:[NSNull class]]){
            return;
        }else{
            NSMutableArray * mutable = [[[NSUserDefaults standardUserDefaults] objectForKey:key] mutableCopy];
            //本地数据是否已经包含
            BOOL contains = [mutable containsObject:value];
            if (contains)
            {
                [mutable removeObject:value];
            }
            [[NSUserDefaults standardUserDefaults] setValue:mutable forKey:key];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        //拿出更新后的数据
        [self.idsArray removeAllObjects];
        [self.idsArray addObjectsFromArray:[self getNSUserDefaultWithKey:NewIDsStr]];
        if (self.idTF.isFirstResponder) {
            [self reloadData];
        }
    }
}

#pragma mark - 拿本地存储的数据
- (id)getNSUserDefaultWithKey:(NSString *)key{
    
    id obj = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    return obj;
}

- (void)reloadData{
    [self.tableView reloadData];
    CGRect frame = self.tableView.frame;
    frame.size.height = self.tableView.contentSize.height<30*5?self.tableView.contentSize.height:30*5;
    self.tableView.frame = frame;
}

- (void)historyList:(BOOL)hide
{
    WeakSelf
    //    CGFloat textFieldWidth = self.containerView.frame.size.width;
    if (hide) {
        [UIView animateWithDuration:0.3 animations:^{
            [weakSelf.tableView setFrame:CGRectMake(CGRectGetMinX(weakSelf.tableView.frame), CGRectGetMinY(weakSelf.containerView.frame) + CGRectGetMaxY(weakSelf.idTF.frame), CGRectGetWidth(weakSelf.tableView.frame), 0)];
        }];
    }
    else{
        [UIView animateWithDuration:0.3 animations:^{
            //            [weakSelf.tableView setFrame:CGRectMake(CGRectGetMinX(weakSelf.tableView.frame), CGRectGetMinY(weakSelf.containerView.frame) + CGRectGetMaxY(weakSelf.idTF.frame), CGRectGetWidth(weakSelf.tableView.frame), weakSelf.tableView.contentSize.height)];
            [self reloadData];
        }];
    }
}

- (NSMutableArray *)idsArray{
    if (!_idsArray) {
        _idsArray = [NSMutableArray new];
    }
    return _idsArray;
}

- (void)keyboardWillShow:(NSNotification *)notification{
    [UIView animateWithDuration:0.25 animations:^{
        for (UIView * view in self.view.subviews) {
            view.transform = CGAffineTransformMakeTranslation(0, -44);
        }
        CGRect frame = self.tableView.frame;
        frame.origin.y = CGRectGetMinY(self.containerView.frame) + CGRectGetMaxY(self.idTF.frame);
        self.tableView.frame = frame;
        
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification{
    [UIView animateWithDuration:0.25 animations:^{
        for (UIView * view in self.view.subviews) {
            view.transform = CGAffineTransformIdentity;;
        }
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];[self historyList:YES];
    if (!self.isPlayback) {
        [self selectLiveBtn:self.liveBtn.selected];
    };
}

- (UITableView *)tableView
{
    if (!_tableView) {
        //========= 创建tableView（显示登陆过的帐号）==========
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.containerView.frame), CGRectGetMinY(self.containerView.frame) + CGRectGetMaxY(self.idTF.frame), CGRectGetWidth(self.containerView.frame), 0) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        //        _tableView.editing = YES;
        _tableView.rowHeight = 30;
        _tableView.layer.borderWidth = 1.5;
        _tableView.layer.borderColor = BLUECOLOR.CGColor;
        
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.separatorColor = [UIColor whiteColor];
        _tableView.bounces = NO;
        //        _tableView.scrollEnabled = NO;
        
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

@end
