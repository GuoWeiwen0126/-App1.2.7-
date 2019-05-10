//
//  PlaybackLoginViewController.m
//  TalkfunSDKDemo
//
//  Created by 孙兆能 on 16/5/16.
//  Copyright © 2016年 talk-fun. All rights reserved.
//

#import "PlaybackLoginViewController.h"
#import "TalkfunApplyViewController.h"
//#import "NetworkDetector.h"
#import "UTLHelpper.h"
//#import "UIView+Toast.h"
//#import "TalkfunSDK.h"
#import "AppDelegate.h"
#import "LiveLoginViewController.h"
#import "DownloadListController.h"
#import "TalkfunPlaybackViewController.h"

#define PLAYBACKROOMID @"playbackRoomID"
#define PLAYBACKCLASSID @"playbackClassID"
#define PLAYBACKPERSISTENTROOMID @"playbackPersistentRoomID"
#define PLAYBACKPERSISTENTCLASSID @"PlaybackPersistentClassID"

@interface PlaybackLoginViewController ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *navView;
//@property (nonatomic,strong) NetworkDetector    * networkDetector;

@property (nonatomic,strong) UITableView        * tableView;
@property (nonatomic,strong) NSMutableArray            * IDArr;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *barViewHeight;
@property (weak, nonatomic) IBOutlet UISegmentedControl *modeSegment;
@property (weak, nonatomic ) IBOutlet UIButton           *applyBtn;
@property (weak, nonatomic) IBOutlet UIView *tfContainView;
@property (weak, nonatomic) IBOutlet UITextField *IDTextfield;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextfield;
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;
@property (nonatomic,strong) UIImageView * IDRightImageView;
@property (nonatomic,strong) UIView * IDSeperateLine;
@property (nonatomic,strong) UIImageView * passwordRightImageView;
@property (nonatomic,strong) UIView * passwordSeperateLine;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (weak, nonatomic) IBOutlet UIImageView *selectImageView;
@property (nonatomic,strong) UIAlertController * errorAlertView;

@end

@implementation PlaybackLoginViewController

- (UITableView *)tableView
{
    if (!_tableView) {
        //========= 创建tableView（显示登陆过的帐号）==========
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.tfContainView.frame), CGRectGetMinY(self.tfContainView.frame) + CGRectGetMaxY(self.IDTextfield.frame), CGRectGetWidth(self.tfContainView.frame), 0) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _tableView.rowHeight = 30;
        _tableView.layer.borderWidth = 1.5;
        _tableView.layer.borderColor = BLUECOLOR.CGColor;
        
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.separatorColor = [UIColor whiteColor];
        
        _tableView.scrollEnabled = NO;
        
        PERFORM_IN_MAIN_QUEUE([self.view addSubview:_tableView];)
        
    }
    return _tableView;
}

- (NSMutableArray *)IDArr
{
    if (!_IDArr) {
        _IDArr = [NSMutableArray new];
    }
    return _IDArr;
}

- (UIAlertController *)errorAlertView
{
    if (!_errorAlertView) {
        _errorAlertView = [UIAlertController alertControllerWithTitle:@"提示" message:@"登录失败，请检查ID或密码是否输入正确" preferredStyle:UIAlertControllerStyleAlert];
        [_errorAlertView addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
    }
    return _errorAlertView;
}

//- (NetworkDetector *)networkDetector
//{
//    if (!_networkDetector) {
//        __weak typeof(self) weakSelf = self;
//        _networkDetector = [[NetworkDetector alloc] init];
//        _networkDetector.networkChangeBlock = ^(NetworkStatus networkStatus){
//            
//            if (networkStatus == 0) {
////                [weakSelf.view makeToast:@"没有网络" duration:5 position:CSToastPositionCenter];
//                PERFORM_IN_MAIN_QUEUE([weakSelf.view toast:@"没有网络" position:ToastPosition];)
//            }
//        };
//    }
//    return _networkDetector;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navView.backgroundColor = DARKBLUECOLOR;
    [self networkcheck];
    self.versionLabel.text = GetVersionText();

    [self addTextFields];
    
    [self.IDArr removeAllObjects];
    [self.IDArr addObjectsFromArray:[self getNSUserDefaultWithKey:PLAYBACKROOMID]];
    NSString * IDStr = [self getNSUserDefaultWithKey:PLAYBACKPERSISTENTROOMID];
    if (IDStr) {
        self.IDTextfield.text = IDStr;
    }
    
    if (!APPLICATION.statusBarHidden) {
        self.barViewHeight.constant = 64;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardDidShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardDidHide:) name:UIKeyboardWillHideNotification object:nil];
    
//    [self.view addSubview:self.tableView];
    
//    [self addGesture];
    
    NSAttributedString * attStr = [[NSAttributedString alloc] initWithString:self.applyBtn.titleLabel.text?self.applyBtn.titleLabel.text:@"" attributes:@{NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle)}];
    [self.applyBtn setAttributedTitle:attStr forState:UIControlStateNormal];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:)
                                                name:UITextFieldTextDidChangeNotification object:self.IDTextfield];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"";
    self.navigationItem.backBarButtonItem = backItem;
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
//    [self historyList:YES];
}

- (void)addTextFields
{
    self.tfContainView.layer.borderColor = GRAYCOLOR.CGColor;
    
    //idTextfield
    UIView * idRightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 35, 30)];
    UIView * IDSeperateLine = [[UIView alloc] initWithFrame:CGRectMake(0, 3.5, 1, 23)];
    IDSeperateLine.backgroundColor = GRAYCOLOR;
    self.IDSeperateLine = IDSeperateLine;
    [idRightView addSubview:IDSeperateLine];
    self.IDRightImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"id0"]];
    self.IDRightImageView.frame = CGRectMake(7.5, 5, 20, 20);
    [idRightView addSubview:self.IDRightImageView];
    self.IDTextfield.rightView = idRightView;
    self.IDTextfield.rightViewMode = UITextFieldViewModeAlways;
    
    //passwordTextfield
    UIView * passwordRightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 35, 30)];
    UIView * passwordSeperateLine = [[UIView alloc] initWithFrame:CGRectMake(0, 3.5, 1, 23)];
    passwordSeperateLine.backgroundColor = GRAYCOLOR;
    self.passwordSeperateLine = passwordSeperateLine;
    [passwordRightView addSubview:passwordSeperateLine];
    self.passwordRightImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"p0"]];
    self.passwordRightImageView.frame = CGRectMake(7.5, 5, 20, 20);
    [passwordRightView addSubview:self.passwordRightImageView];
    self.passwordTextfield.rightView = passwordRightView;
    self.passwordTextfield.rightViewMode = UITextFieldViewModeAlways;
    
}

- (IBAction)modeSegmentClicked:(UISegmentedControl *)sender {
    
    static NSString * roomIDEdit = nil;
    static NSString * classIDEdit = nil;
    if (sender.selectedSegmentIndex == 0) {
        self.IDTextfield.placeholder = @"回放ID";
        self.passwordTextfield.placeholder = @"回放密码";
        [self.IDArr removeAllObjects];
        [self.IDArr addObjectsFromArray:[self getNSUserDefaultWithKey:PLAYBACKROOMID]];
        
        classIDEdit = self.IDTextfield.text;
        
        if (!roomIDEdit || [roomIDEdit isEqualToString:@""]) {
            NSString * IDStr = [self getNSUserDefaultWithKey:PLAYBACKPERSISTENTROOMID];
            self.IDTextfield.text = IDStr;
        }
        else
        {
            self.IDTextfield.text = roomIDEdit;
        }
    }
    else
    {
        self.IDTextfield.placeholder = @"课程ID";
        self.passwordTextfield.placeholder = @"课程密码";
        [self.IDArr removeAllObjects];
        [self.IDArr addObjectsFromArray:[self getNSUserDefaultWithKey:PLAYBACKCLASSID]];
        
        roomIDEdit = self.IDTextfield.text;
        
        if (!classIDEdit || [classIDEdit isEqualToString:@""]) {
            NSString * IDStr = [self getNSUserDefaultWithKey:PLAYBACKPERSISTENTCLASSID];
            self.IDTextfield.text = IDStr;
        }
        else
        {
            self.IDTextfield.text = classIDEdit;
        }
    }
    
    if (self.IDTextfield.isFirstResponder) {
        [self reloadData];
    }
}

- (void)reloadData
{
    PERFORM_IN_MAIN_QUEUE([self.tableView reloadData];
                          CGRect frame = self.tableView.frame;
                          frame.size.height = self.tableView.contentSize.height;
                          self.tableView.frame = frame;)
    
}

- (IBAction)selectBtnClicked:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    if (sender.selected) {
        self.selectImageView.image = [UIImage imageNamed:@"select"];
    }
    else{
        self.selectImageView.image = [UIImage imageNamed:@"unselect"];
    }
}

//MARK:按钮点击事件
//MARK:返回按钮
- (IBAction)backBtnClicked:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
//MARK:切换到直播按钮
- (IBAction)switchToLiveBtnClicked:(UIButton *)sender {
    
    LiveLoginViewController * liveVC = [[LiveLoginViewController alloc] init];
    [self.navigationController pushViewController:liveVC animated:YES];
    
    NSMutableArray * viewControllers = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    [viewControllers removeObjectAtIndex:1];
    self.navigationController.viewControllers = viewControllers;
    
}
//MARK:进入点播按钮
- (IBAction)playbackBtnClicked:(UIButton *)sender {
    
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    
//    self.IDTextfield.text = @"1421162";
//    self.passwordTextfield.text = @"141915";
//    self.IDTextfield.text = @"1427511";
//    self.passwordTextfield.text = @"294960";
    
    if (TEXTFIELDHASVALUE(self.IDTextfield)) {
        [self.view toast:@"ID不能为空" position:ToastPosition];
//        [self.view makeToast:@"ID不能为空" duration:1 position:CSToastPositionCenter];
        return;
    }
    else if (TEXTFIELDHASVALUE(self.passwordTextfield))
    {
        [self.view toast:@"密码不能为空" position:ToastPosition];
//        [self.view makeToast:@"密码不能为空" duration:1 position:CSToastPositionCenter];
        return;
    }
    
    NSString * urlStr = @"https://open.talk-fun.com/playback/mobile/login.php";
    
    NSDictionary * params = @{@"id":self.IDTextfield.text,@"password":self.passwordTextfield.text,@"mode":@(self.modeSegment.selectedSegmentIndex + 1)};
    
    WeakSelf
//    __block PlayBackViewController * playbackVC = nil;
    __block TalkfunPlaybackViewController * playbackVC = nil;
    [self.view startAnimation];
    self.view.userInteractionEnabled = NO;
    [TalkfunHttpTools post:urlStr params:params callback:^(id result) {
        
        if ([result[@"code"] intValue] == TalkfunCodeSuccess) {
            //========= 存储数据 ==========
            NSString * str = weakSelf.modeSegment.selectedSegmentIndex == 0?PLAYBACKROOMID:PLAYBACKCLASSID;
            [weakSelf saveValue:str Value:weakSelf.IDTextfield.text];
            
            NSString * IDStr = weakSelf.modeSegment.selectedSegmentIndex == 0?PLAYBACKPERSISTENTROOMID:PLAYBACKPERSISTENTCLASSID;
            
            NSString * persistentID = [weakSelf getNSUserDefaultWithKey:IDStr];
            if (weakSelf.selectBtn.selected && weakSelf.IDTextfield.text.length != 0) {
                [UserDefault removeObjectForKey:IDStr];
                if (![persistentID isEqualToString:weakSelf.IDTextfield.text]) {
                    [UserDefault setObject:weakSelf.IDTextfield.text forKey:IDStr];
                }
                
            }else if (![persistentID isEqualToString:weakSelf.IDTextfield.text])
            {
                [UserDefault removeObjectForKey:IDStr];
            }
            [UserDefault synchronize];
            NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:result];
            parameters[TalkfunPlaybackID] = weakSelf.IDTextfield.text;
            
//            playbackVC = [[PlayBackViewController alloc] init];
            
            playbackVC = [[TalkfunPlaybackViewController alloc] init];
            
            playbackVC.playbackID = weakSelf.IDTextfield.text;
            playbackVC.res = parameters;
            
            //NSLog(@"threaddd:%@",[NSThread currentThread]);
            PERFORM_IN_MAIN_QUEUE(NSLog(@"threaddd:%@",[NSThread currentThread]);
                                  [weakSelf presentViewController:playbackVC animated:NO completion:nil];
                                 
                                  
                                  if (!weakSelf.selectBtn.selected) {
                                      weakSelf.IDTextfield.text = nil;
                                  }
                                  weakSelf.passwordTextfield.text = nil;
                                  )
        }
        else
        {
            if ([result[@"msg"] isEqualToString:@"访问网络失败"]) {
                weakSelf.errorAlertView.message = @"访问网络失败";
            }
            PERFORM_IN_MAIN_QUEUE([weakSelf presentViewController:weakSelf.errorAlertView animated:YES completion:nil];)
        }
        
        PERFORM_IN_MAIN_QUEUE([weakSelf.view stopAnimation];
                              weakSelf.view.userInteractionEnabled = YES;)
    }];

}

//下载页
- (IBAction)downloadListBtnClicked:(UIButton *)sender {
    
    DownloadListController * dv = [[DownloadListController alloc] init];
    
    //[self presentViewController:dv animated:YES completion:nil];
    [self.navigationController pushViewController:dv animated:YES];
    
    return;
    
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
                if (mutable.count == 5){
                    [mutable removeLastObject];
                }
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
        NSString * str = self.modeSegment.selectedSegmentIndex == 0?PLAYBACKROOMID:PLAYBACKCLASSID;
        [self.IDArr removeAllObjects];
        [self.IDArr addObjectsFromArray:[self getNSUserDefaultWithKey:str]];
    }
//    [self reloadData];
    
}

#pragma mark - 拿本地存储的数据
- (id)getNSUserDefaultWithKey:(NSString *)key{
    
    id obj = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    return obj;
    
}

#pragma mark - tableView 代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.IDArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.contentView.backgroundColor = UIColorFromRGBHex(0xecf3ff);
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
        
    cell.textLabel.text = self.IDArr[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.IDTextfield.text = self.IDArr[indexPath.row];
    
    [self historyList:YES];
}

//MARK:textField 代理方法
#pragma mark 当点击键盘的返回键（右下角）时，执行该方法。
//-(BOOL)textFieldShouldReturn:(UITextField *)textField{
//    
//    if(self.IDTextfield == textField){
//        
//        [self.passwordTextfield becomeFirstResponder];
//    }
//    else if (self.passwordTextfield == textField)
//    {
//        [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
//    }
//    [self historyList:YES];
//    return YES;
//}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(self.IDTextfield == textField){
        
        [self.passwordTextfield becomeFirstResponder];
    }
    else if (self.passwordTextfield == textField)
    {
        [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    }
    [self historyList:YES];
    
    return YES;
}

#pragma mark 当输入框获得焦点时 执行该方法
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    if (self.IDTextfield == textField) {
        self.IDRightImageView.image = [UIImage imageNamed:@"id1"];
        self.IDSeperateLine.backgroundColor = BLUECOLOR;
        [self.IDArr removeAllObjects];
        [self.IDArr addObjectsFromArray:[self getNSUserDefaultWithKey:PLAYBACKROOMID]];
        [self.tableView reloadData];
        [self historyList:NO];
    }
    else if (self.passwordTextfield == textField)
    {
        self.passwordRightImageView.image = [UIImage imageNamed:@"p1"];
        self.passwordSeperateLine.backgroundColor = BLUECOLOR;
    }
    
}

#define mark 文本框失去fire responder 时 执行
- (void)textFieldDidEndEditing:(UITextField *)textField{
    [self textfieldUnSelected];
}

- (void)historyList:(BOOL)hide
{
    WeakSelf
    CGFloat textFieldWidth = self.tfContainView.frame.size.width;
    if (hide) {
        [UIView animateWithDuration:0.3 animations:^{
            [weakSelf.tableView setFrame:CGRectMake(CGRectGetMinX(weakSelf.tfContainView.frame), CGRectGetMinY(weakSelf.tfContainView.frame) + CGRectGetMaxY(weakSelf.IDTextfield.frame), textFieldWidth, 0)];
        }];
    }
    else{
        [UIView animateWithDuration:0.3 animations:^{
            [weakSelf.tableView setFrame:CGRectMake(CGRectGetMinX(weakSelf.tfContainView.frame), CGRectGetMinY(weakSelf.tfContainView.frame) + CGRectGetMaxY(weakSelf.IDTextfield.frame), textFieldWidth, weakSelf.tableView.contentSize.height)];
        }];
    }
}

- (IBAction)applyBtnClicked:(UIButton *)sender {
    
//    ApplyForTrialViewController * applyVC = [[ApplyForTrialViewController alloc] init];
    TalkfunApplyViewController * applyVC = [[TalkfunApplyViewController alloc] init];
    [self.navigationController pushViewController:applyVC animated:YES];
    
}

#pragma mark - 监听键盘
- (void)keyBoardDidShow:(NSNotification *)notification
{
    //NSLog(@"tableviewfr:%f tfcontainview:%f",CGRectGetMinX(self.tableView.frame),CGRectGetMinX(self.tfContainView.frame));
    [UIView animateWithDuration:0.1 animations:^{
        
        NSArray * subViews = self.view.subviews;
        for (UIView * subView in subViews) {
            subView.transform = CGAffineTransformMakeTranslation(0, -59);
            if (subView.tag == 10) {
                subView.transform = CGAffineTransformMakeTranslation(0, 0);
            }
        }
        CGRect frame = self.tableView.frame;
        frame.origin.x = CGRectGetMinX(self.tfContainView.frame);
        self.tableView.frame = frame;
    }];
    
}

- (void)textfieldUnSelected
{
    self.IDRightImageView.image = [UIImage imageNamed:@"id0"];
    self.IDSeperateLine.backgroundColor = GRAYCOLOR;
    self.passwordRightImageView.image = [UIImage imageNamed:@"p0"];
    self.passwordSeperateLine.backgroundColor = GRAYCOLOR;
}

- (void)textFiledEditChanged:(NSNotification *)notification
{
    UITextField * tf = notification.object;
    NSString * text = tf.text;
    NSString * str = self.modeSegment.selectedSegmentIndex == 0?PLAYBACKROOMID:PLAYBACKCLASSID;
    NSArray * IDArray = [self getNSUserDefaultWithKey:str];
    [self.IDArr removeAllObjects];
    if (text.length != 0) {
        for (int i = 0; i < IDArray.count; i ++) {
            NSString * t = IDArray[i];
            if ([t hasPrefix:text] && ![t isEqualToString:text]) {
                [self.IDArr addObject:t];
            }
        }
    }
    else
    {
        [self.IDArr addObjectsFromArray:IDArray];
    }
    
    [self.tableView reloadData];
    [UIView animateWithDuration:0.3 animations:^{
        [self.tableView setFrame:CGRectMake(CGRectGetMinX(self.tfContainView.frame), CGRectGetMinY(self.tfContainView.frame) + CGRectGetMaxY(self.IDTextfield.frame), self.tfContainView.frame.size.width, self.tableView.contentSize.height)];
    }];
}

- (void)keyBoardDidHide:(NSNotification *)notification
{
    [self textfieldUnSelected];
    
    [UIView animateWithDuration:0.1 animations:^{
        
        NSArray * subViews = self.view.subviews;
        for (UIView * subView in subViews) {
            subView.transform = CGAffineTransformMakeTranslation(0, 0);
        }
        
    }];
}

//MARK:点击屏幕
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    [self historyList:YES];
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
        [self.view toast:@"启用蜂窝移动数据或无线局域网来访问数据" position:ToastPosition];
//        [self.view makeToast:@"启用蜂窝移动数据或无线局域网来访问数据" duration:4 position:CSToastPositionCenter];
    }
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
