//
//  LiveLoginViewController.m
//  TalkfunSDKDemo
//
//  Created by 孙兆能 on 16/5/16.
//  Copyright © 2016年 talk-fun. All rights reserved.
//

#import "LiveLoginViewController.h"
#import "TalkfunApplyViewController.h"
//#import "NetworkDetector.h"
#import "UTLHelpper.h"
//#import "UIView+Toast.h"
//#import "TalkfunSDK.h"
#import "PlaybackLoginViewController.h"
#import "TalkfunViewController.h"

#define LIVEROOMID @"liveRoomID"
#define LIVECLASSID @"liveClassID"
#define LIVEPERSISTENTROOMID @"livePersistentRoomID"
#define LIVEPERSISTENTCLASSID @"livePersistentClassID"

@interface LiveLoginViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *navView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *barViewHeight;
//@property (nonatomic,strong) NetworkDetector    * networkDetector;
@property (nonatomic,strong) NSMutableArray            * liveIDArr;
@property (nonatomic,strong) UITableView        * tableView;
@property (weak, nonatomic ) IBOutlet UIButton           *applyBtn;
@property (weak, nonatomic) IBOutlet UIView *tfContainView;
@property (weak, nonatomic) IBOutlet UITextField *nicknameTF;
@property (weak, nonatomic) IBOutlet UITextField *IDTextfield;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextfield;
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;
@property (nonatomic,strong) UIImageView * nicknameRightImageView;
@property (nonatomic,strong) UIView * nicknameSeperateLine;
@property (nonatomic,strong) UIImageView * IDRightImageView;
@property (nonatomic,strong) UIView * IDSeperateLine;
@property (nonatomic,strong) UIImageView * passwordRightImageView;
@property (nonatomic,strong) UIView * passwordSeperateLine;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (weak, nonatomic) IBOutlet UIImageView *selectImageView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *modeSegment;
@property (nonatomic,strong) UIAlertController * errorAlertView;

@end

@implementation LiveLoginViewController

//- (NetworkDetector *)networkDetector
//{
//    if (!_networkDetector) {
//        __weak typeof(self) weakSelf = self;
//        _networkDetector = [[NetworkDetector alloc] init];
//        _networkDetector.networkChangeBlock = ^(NetworkStatus networkStatus){
//
//            if (networkStatus == 0) {
//                PERFORM_IN_MAIN_QUEUE([weakSelf.view toast:@"没有网络" position:ToastPosition];)
////                [weakSelf.view makeToast:@"没有网络" duration:5 position:CSToastPositionCenter];
//            }
//        };
//    }
//    return _networkDetector;
//}

- (NSMutableArray *)liveIDArr
{
    if (!_liveIDArr) {
        _liveIDArr = [NSMutableArray new];
    }
    return _liveIDArr;
}

- (UIAlertController *)errorAlertView
{
    if (!_errorAlertView) {
        _errorAlertView = [UIAlertController alertControllerWithTitle:@"提示" message:@"登录失败，请检查ID或密码是否输入正确" preferredStyle:UIAlertControllerStyleAlert];
        [_errorAlertView addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
    }
    return _errorAlertView;
}

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
        
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navView.backgroundColor = DARKBLUECOLOR;
    [self networkcheck];
    self.versionLabel.text = GetVersionText();
    [self addTextFields];
    
    if (!APPLICATION.statusBarHidden) {
        self.barViewHeight.constant = 64;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardDidShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardDidHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [self.liveIDArr removeAllObjects];
    [self.liveIDArr addObjectsFromArray:[self getNSUserDefaultWithKey:LIVEROOMID]];
    NSString * IDStr = [self getNSUserDefaultWithKey:LIVEPERSISTENTROOMID];
    if (IDStr) {
        self.IDTextfield.text = IDStr;
    }
    
    self.nicknameTF.text = NAME;
    self.passwordTextfield.text = PASSWORD;
//    self.nicknameTF.text = @"ss";
//    self.passwordTextfield.text = @"123456";
//    self.IDTextfield.text = @"550481";
    
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
    
    //nicknameTextfield
    UIView * nicknameRightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 35, 30)];
    UIView * nicknameSeperateLine = [[UIView alloc] initWithFrame:CGRectMake(0, 3.5, 1, 23)];
    nicknameSeperateLine.backgroundColor = GRAYCOLOR;
    self.nicknameSeperateLine = nicknameSeperateLine;
    [nicknameRightView addSubview:nicknameSeperateLine];
    self.nicknameRightImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"acc0"]];
    self.nicknameRightImageView.frame = CGRectMake(7.5, 5, 20, 20);
    [nicknameRightView addSubview:self.nicknameRightImageView];
    self.nicknameTF.rightView = nicknameRightView;
    self.nicknameTF.rightViewMode = UITextFieldViewModeAlways;
    
    //IDTextfield
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
        self.IDTextfield.placeholder = @"房间ID";
        self.passwordTextfield.placeholder = @"房间密码";
        [self.liveIDArr removeAllObjects];
        [self.liveIDArr addObjectsFromArray:[self getNSUserDefaultWithKey:LIVEROOMID]];
        
        classIDEdit = self.IDTextfield.text;
        
        if (!roomIDEdit || [roomIDEdit isEqualToString:@""]) {
            NSString * IDStr = [self getNSUserDefaultWithKey:LIVEPERSISTENTROOMID];
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
        [self.liveIDArr removeAllObjects];
        [self.liveIDArr addObjectsFromArray:[self getNSUserDefaultWithKey:LIVECLASSID]];
        
        roomIDEdit = self.IDTextfield.text;
        
        if (!classIDEdit || [classIDEdit isEqualToString:@""]) {
            NSString * IDStr = [self getNSUserDefaultWithKey:LIVEPERSISTENTCLASSID];
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
    [self.tableView reloadData];
    CGRect frame = self.tableView.frame;
    frame.size.height = self.tableView.contentSize.height;
    self.tableView.frame = frame;
}

- (IBAction)selectBtnClicked:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    if (sender.selected) {
        self.selectImageView.image = [UIImage imageNamed:@"select"];
    }
    else
    {
        self.selectImageView.image = [UIImage imageNamed:@"unselect"];
    }
}

//MARK:按钮点击事件
//MARK:返回按钮
- (IBAction)backBtnClicked:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
//MARK:切换到点播按钮
- (IBAction)switchToPlaybackBtnClicked:(UIButton *)sender {
    
    PlaybackLoginViewController * playbackVC = [[PlaybackLoginViewController alloc] init];
    [self.navigationController pushViewController:playbackVC animated:YES];
    
    NSMutableArray * viewControllers = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    [viewControllers removeObjectAtIndex:1];
    self.navigationController.viewControllers = viewControllers;
}
//MARK:进入直播按钮
- (IBAction)liveButtonClicked:(UIButton *)sender {
    
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
//    
    if (![UTLHelpper NetWorkIsOK]) {
        [self.view toast:@"网络不可用，请检查网络是否已连接！" position:ToastPosition];
//        [self.view makeToast:@"网络不可用，请检查网络是否已连接！" duration:TOASTDURATION position:CSToastPositionBottom];
        return;
    }
    
//    self.IDTextfield.text = @"550481";
//    self.passwordTextfield.text = @"123456";
//    self.nicknameTF.text = @"1ok";
    
    //NSLog(@"login touch.");
    if (TEXTFIELDHASVALUE(self.nicknameTF)) {
        [self.view toast:@"用户名不能为空" position:ToastPosition];
//        [self.view makeToast:@"用户名不能为空" duration:TOASTDURATION position:CSToastPositionCenter];
        return;
    }
    else if (TEXTFIELDHASVALUE(self.IDTextfield))
    {
        [self.view toast:@"ID不能为空" position:ToastPosition];
//        [self.view makeToast:@"ID不能为空" duration:TOASTDURATION position:CSToastPositionCenter];
        return;
    }
    else if(TEXTFIELDHASVALUE(self.passwordTextfield)){
        [self.view toast:@"密码不能为空" position:ToastPosition];
//        [self.view makeToast:@"密码不能为空" duration:TOASTDURATION position:CSToastPositionCenter];
//        return;
    }
    
    NSString * urlStr = @"https://open.talk-fun.com/live/mobile/login.php";
    NSDictionary * params = @{@"id":self.IDTextfield.text,@"password":self.passwordTextfield.text,@"nickname":self.nicknameTF.text,@"mode":@(self.modeSegment.selectedSegmentIndex + 1)};
    
//     NSDictionary * params = @{@"id":@"626321",@"password":@"123456",@"nickname":@"111",@"mode":@(self.modeSegment.selectedSegmentIndex + 1)};
    WeakSelf
    __block TalkfunViewController * myVC = nil;
    
    [self.view startAnimation];
    self.view.userInteractionEnabled = NO;
    [TalkfunHttpTools post:urlStr params:params callback:^(id result) {
    
        if ([result[@"code"] intValue] == TalkfunCodeSuccess) {
//            存储数据
            NSString * str = weakSelf.modeSegment.selectedSegmentIndex == 0?LIVEROOMID:LIVECLASSID;
            [weakSelf saveValue:str Value:weakSelf.IDTextfield.text];
            NSString * IDStr = weakSelf.modeSegment.selectedSegmentIndex == 0?LIVEPERSISTENTROOMID:LIVEPERSISTENTCLASSID;
            
            NSString * persistentID = [weakSelf getNSUserDefaultWithKey:IDStr];
            if (weakSelf.selectBtn.selected && weakSelf.IDTextfield.text.length != 0) {
                [UserDefault removeObjectForKey:IDStr];
                if (![persistentID isEqualToString:weakSelf.IDTextfield.text]) {
                    [UserDefault setObject:weakSelf.IDTextfield.text forKey:IDStr];
                }
            }
            else if ([persistentID isEqualToString:weakSelf.IDTextfield.text])
            {
                [UserDefault removeObjectForKey:IDStr];
            }
            [UserDefault synchronize];
    
            myVC = [[TalkfunViewController alloc] init];
//    myVC.res = @{@"code":@(0),@"data":@{@"access_token":@"dd"}};
            myVC.res = result;
            
            if (result[@"data"][@"access_token"]) {
                
                PERFORM_IN_MAIN_QUEUE([weakSelf presentViewController:myVC animated:NO completion:nil];
                                      
                                      
                                      if (!weakSelf.selectBtn.selected) {
                                          weakSelf.IDTextfield.text = nil;
                                      }
                                      weakSelf.nicknameTF.text = nil;
                                      weakSelf.passwordTextfield.text = nil;
                                      )
            }
    
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

//MARK:申请试用按钮
- (IBAction)applyButtonClicked:(UIButton *)sender {
    
//    ApplyForTrialViewController * applyVC = [[ApplyForTrialViewController alloc] init];
    TalkfunApplyViewController * applyVC = [[TalkfunApplyViewController alloc] init];
    [self.navigationController pushViewController:applyVC animated:YES];
    
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
        NSString * str = self.modeSegment.selectedSegmentIndex == 0?LIVEROOMID:LIVECLASSID;
        [self.liveIDArr removeAllObjects];
        [self.liveIDArr addObjectsFromArray:[self getNSUserDefaultWithKey:str]];
        if (self.IDTextfield.isFirstResponder) {
            [self reloadData];
        }
    }
}

#pragma mark - 拿本地存储的数据
- (id)getNSUserDefaultWithKey:(NSString *)key{
    
    id obj = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    return obj;
    
}

#pragma mark - tableView 代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.liveIDArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    cell.backgroundColor = UIColorFromRGBHex(0xecf3ff);
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
        
    cell.textLabel.text = self.liveIDArr[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.IDTextfield.text = self.liveIDArr[indexPath.row];
    
    [self historyList:YES];
}

//MARK:textField 代理方法
#pragma mark 当点击键盘的返回键（右下角）时，执行该方法。
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if(self.nicknameTF == textField || self.passwordTextfield == textField){
        
        [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
        
    }
    [self historyList:YES];
    return YES;
}

#pragma mark 当输入框获得焦点时 执行该方法
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    if (self.nicknameTF == textField) {
        self.nicknameRightImageView.image = [UIImage imageNamed:@"acc1"];
        self.nicknameSeperateLine.backgroundColor = BLUECOLOR;
    }
    else if (self.IDTextfield == textField) {
        self.IDRightImageView.image = [UIImage imageNamed:@"id1"];
        self.IDSeperateLine.backgroundColor = BLUECOLOR;
        [self.liveIDArr removeAllObjects];
        [self.liveIDArr addObjectsFromArray:[self getNSUserDefaultWithKey:LIVEROOMID]];
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
//    [self historyList:YES];
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

- (void)textfieldUnSelected
{
    self.nicknameRightImageView.image = [UIImage imageNamed:@"acc0"];
    self.nicknameSeperateLine.backgroundColor = GRAYCOLOR;
    self.IDRightImageView.image = [UIImage imageNamed:@"id0"];
    self.IDSeperateLine.backgroundColor = GRAYCOLOR;
    self.passwordRightImageView.image = [UIImage imageNamed:@"p0"];
    self.passwordSeperateLine.backgroundColor = GRAYCOLOR;
}

- (void)textFiledEditChanged:(NSNotification *)notification
{
    UITextField * tf = notification.object;
    NSString * text = tf.text;
    NSString * str = self.modeSegment.selectedSegmentIndex == 0?LIVEROOMID:LIVECLASSID;
    NSArray * IDArray = [self getNSUserDefaultWithKey:str];
    [self.liveIDArr removeAllObjects];
    if (text.length != 0) {
        for (int i = 0; i < IDArray.count; i ++) {
            NSString * t = IDArray[i];
            if ([t hasPrefix:text] && ![t isEqualToString:text]) {
                [self.liveIDArr addObject:t];
            }
        }
    }
    else
    {
        [self.liveIDArr addObjectsFromArray:IDArray];
    }
    
    [self.tableView reloadData];
    [UIView animateWithDuration:0.3 animations:^{
        [self.tableView setFrame:CGRectMake(CGRectGetMinX(self.tfContainView.frame), CGRectGetMinY(self.tfContainView.frame) + CGRectGetMaxY(self.IDTextfield.frame), self.tfContainView.frame.size.width, self.tableView.contentSize.height)];
    }];
}

#pragma mark - 监听键盘
- (void)keyBoardDidShow:(NSNotification *)notification
{
    //NSLog(@"tableviewfr:%f tfcontainview:%f",CGRectGetMinX(self.tableView.frame),CGRectGetMinX(self.tfContainView.frame));
    [UIView animateWithDuration:0.1 animations:^{
        
        NSArray * subViews = self.view.subviews;
        for (UIView * subView in subViews) {
//            if (subView == self.tableView) {
//                continue;
//            }
            subView.transform = CGAffineTransformMakeTranslation(0, - 45);
            if (subView.tag == 10) {
                subView.transform = CGAffineTransformMakeTranslation(0, 0);
            }
        }
        CGRect frame = self.tableView.frame;
//        frame.origin.x = CGRectGetMinX(self.tfContainView.frame);
        frame.origin.y = CGRectGetMinY(self.tfContainView.frame) + CGRectGetMaxY(self.IDTextfield.frame);
        self.tableView.frame = frame;
    }];
    
}

- (void)keyBoardDidHide:(NSNotification *)notification
{
    
    
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
