//
//  TalkfunInputNameViewController.m
//  TalkfunSDKDemo
//
//  Created by Sunzn on 2017/4/19.
//  Copyright © 2017年 Talkfun. All rights reserved.
//

#import "TalkfunInputNameViewController.h"
#import "TalkfunButton.h"

@interface TalkfunInputNameViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *logoImage;
@property (weak, nonatomic) IBOutlet UILabel *classNameLabel;
@property (weak, nonatomic) IBOutlet UIView *tfContainerView;
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *secretTF;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tfContainerHeight;
@property (weak, nonatomic) IBOutlet UIButton *getInBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerHeight;

@end

@implementation TalkfunInputNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)configView{
    self.containerHeight.constant = self.scanIn?361:361-61;
    self.tfContainerHeight.constant = self.scanIn?82:31;
    self.tfContainerView.clipsToBounds = YES;
    [self configTF];
    [self configGetInBtn];
    
}

- (void)configTF{
    
    TalkfunButton * selectModeBtn = [TalkfunButton buttonWithType:UIButtonTypeCustom];
    selectModeBtn.frame = CGRectMake(0, 0, 50, 30);
    selectModeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [selectModeBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [selectModeBtn setTitle:@"昵称" forState:UIControlStateNormal];
    self.nameTF.leftView = selectModeBtn;
    self.nameTF.delegate = self;
    self.nameTF.leftViewMode = UITextFieldViewModeAlways;
    
    TalkfunButton * secretBtn = [TalkfunButton buttonWithType:UIButtonTypeCustom];
    secretBtn.frame = CGRectMake(0, 0, 50, 30);
    secretBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [secretBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [secretBtn setTitle:@"密码" forState:UIControlStateNormal];
    self.secretTF.leftView = secretBtn;
    self.secretTF.delegate = self;
    self.secretTF.leftViewMode = UITextFieldViewModeAlways;
}

- (void)configGetInBtn{
    self.getInBtn.layer.shadowOffset = CGSizeMake(0, 5);
    self.getInBtn.layer.shadowColor = [UIColor grayColor].CGColor;
    self.getInBtn.layer.shadowOpacity = 0.5;
}

- (void)keyboardWillShow:(NSNotification *)notification{
    NSDictionary * keyboardInfo = [notification userInfo];
    NSValue * keyboardFrameEnd  = [keyboardInfo valueForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardFrameEndRect = [keyboardFrameEnd CGRectValue];
    [UIView animateWithDuration:0.25 animations:^{
        for (UIView * view in self.view.subviews) {
            view.transform = CGAffineTransformMakeTranslation(0, -keyboardFrameEndRect.size.height);
        }
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification{
    [UIView animateWithDuration:0.25 animations:^{
        for (UIView * view in self.view.subviews) {
            view.transform = CGAffineTransformIdentity;;
        }
    }];
}

- (IBAction)getInBtnClicked:(UIButton *)sender {
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

@end
