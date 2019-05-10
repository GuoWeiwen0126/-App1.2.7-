//
//  CouponHeaderView.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/1/9.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import "CouponHeaderView.h"
#import "Tools.h"

@interface CouponHeaderView ()
@property (nonatomic, strong) UITextField *textField;
@end

@implementation CouponHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor whiteColor];
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(20, 10, UI_SCREEN_WIDTH - 20*2, self.height - 10*2)];
        VIEW_BORDER_RADIUS(bgView, [UIColor whiteColor], 0, 1, MAIN_RGB_LINE)
        [self addSubview:bgView];
        
        UIButton *convertBtn = [[UIButton alloc] initWithFrame:CGRectMake(bgView.width - 70, 0, 70, bgView.height)];
        convertBtn.backgroundColor = MAIN_RGB;
        [convertBtn setTitle:@"兑换" forState:UIControlStateNormal];
        [convertBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [convertBtn addTarget:self action:@selector(convertBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:convertBtn];
        
        self.textField = [[UITextField alloc] initWithFrame:CGRectMake(10, 5, bgView.width - convertBtn.width - 10, bgView.height - 5*2)];
        self.textField.placeholder = @"请输入兑换码";
        self.textField.textColor = MAIN_RGB;
        self.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        [bgView addSubview:self.textField];
        
        HorizontalLineView *lineView = [[HorizontalLineView alloc] initWithFrame:CGRectMake(20, self.height - 1, UI_SCREEN_WIDTH - 20*2, 1)];
        lineView.backgroundColor = [UIColor whiteColor];
        [self addSubview:lineView];
    }
    
    return self;
}
#pragma mark - 兑换码
- (void)convertBtnClicked
{
    if (self.textField.text.length == 0) {
        [XZCustomWaitingView showAutoHidePromptView:@"请输入兑换码" background:nil showTime:0.8];
        return;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ConvertCoupon" object:self.textField.text];
}

@end
