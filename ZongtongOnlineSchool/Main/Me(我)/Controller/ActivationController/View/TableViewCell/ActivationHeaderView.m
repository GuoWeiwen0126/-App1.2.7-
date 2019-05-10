//
//  ActivationHeaderView.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/3/20.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import "ActivationHeaderView.h"
#import "Tools.h"

@interface ActivationHeaderView ()
@property (nonatomic, strong) UITextField *textField;
@end

@implementation ActivationHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor whiteColor];
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(20, 10, UI_SCREEN_WIDTH - 20*2, self.height - 10*2)];
        VIEW_BORDER_RADIUS(bgView, [UIColor whiteColor], 0, 1, MAIN_RGB_LINE)
        [self addSubview:bgView];
        
        UIButton *bindingBtn = [[UIButton alloc] initWithFrame:CGRectMake(bgView.width - 70, 0, 70, bgView.height)];
        bindingBtn.backgroundColor = MAIN_RGB;
        [bindingBtn setTitle:@"绑定" forState:UIControlStateNormal];
        [bindingBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [bindingBtn addTarget:self action:@selector(bindingBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:bindingBtn];
        
        self.textField = [[UITextField alloc] initWithFrame:CGRectMake(10, 5, bgView.width - bindingBtn.width - 10, bgView.height - 5*2)];
        self.textField.placeholder = @"请输入激活码";
        self.textField.textColor = MAIN_RGB;
        self.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        [bgView addSubview:self.textField];
        
        HorizontalLineView *lineView = [[HorizontalLineView alloc] initWithFrame:CGRectMake(20, self.height - 1, UI_SCREEN_WIDTH - 20*2, 1)];
        lineView.backgroundColor = [UIColor whiteColor];
        [self addSubview:lineView];
    }
    
    return self;
}
#pragma mark - 绑定激活码
- (void)bindingBtnClicked
{
    if (self.textField.text.length == 0) {
        [XZCustomWaitingView showAutoHidePromptView:@"请输入激活码" background:nil showTime:0.8];
        return;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ActivationBindingCDKEY" object:self.textField.text];
}

@end
