//
//  DataDownloadHeaderView.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/8/15.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import "DataDownloadHeaderView.h"
#import "Tools.h"

@interface DataDownloadHeaderView () <OptionButtonViewDelegate>
@end

@implementation DataDownloadHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    self = [[NSBundle mainBundle] loadNibNamed:@"DataDownloadHeaderView" owner:self options:nil].lastObject;
    if (self)
    {
        self.frame = frame;
        
        self.bgButton.adjustsImageWhenHighlighted = NO;
        [self.portraitImgView sd_setImageWithURL:[NSURL URLWithString:[USER_DEFAULTS objectForKey:User_portrait]] placeholderImage:PortraitPlaceholder];
        self.nameLabel.text = IsLocalAccount ? @"试用账号":[USER_DEFAULTS objectForKey:User_nickName];
        
        self.optionView = [[OptionButtonView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 50) optionArray:@[@"资料下载区", @"我的资料"] selectedColor:MAIN_RGB lineSpace:10 haveLineView:YES selectIndex:0];
        self.optionView.optionViewDelegate = self;
        [self.bgView addSubview:self.optionView];
    }
    
    return self;
}
- (IBAction)getDownloadCoin:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"FileGetDownloadCoin" object:nil];
}

#pragma mark - optionButtonView 代理方法
- (void)optionViewButtonClickedWithBtnTag:(NSInteger)btnTag {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"FileOptionViewButtonClicked" object:[NSString stringWithFormat:@"%ld",(long)btnTag]];
}
#pragma mark - 选择按钮点击方法
- (IBAction)leftBtnClicked:(id)sender {
    self.leftBtn.selected = !self.leftBtn.selected;
    [self.leftBtn setTitle:self.leftBtn.selected == YES ? @"默认顺序 ▼":@"默认顺序 ▶" forState:UIControlStateNormal];
    [self.leftBtn setTitleColor:self.leftBtn.selected == YES ? MAIN_RGB:MAIN_RGB_MainTEXT forState:UIControlStateNormal];
    if (self.leftBtn.selected == YES) {
        self.rightBtn.selected = NO;
        [self.rightBtn setTitle:@"筛选 ▶" forState:UIControlStateNormal];
        [self.rightBtn setTitleColor:MAIN_RGB_MainTEXT forState:UIControlStateNormal];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"FileLeftButtonClicked" object:[NSString stringWithFormat:@"%d",self.leftBtn.selected]];
}
- (IBAction)rightBtnClicked:(id)sender {
    self.rightBtn.selected = !self.rightBtn.selected;
    [self.rightBtn setTitle:self.rightBtn.selected == YES ? @"筛选 ▼":@"筛选 ▶" forState:UIControlStateNormal];
    [self.rightBtn setTitleColor:self.rightBtn.selected == YES ? MAIN_RGB:MAIN_RGB_MainTEXT forState:UIControlStateNormal];
    if (self.rightBtn.selected == YES) {
        self.leftBtn.selected = NO;
        [self.leftBtn setTitle:@"默认顺序 ▶" forState:UIControlStateNormal];
        [self.leftBtn setTitleColor:MAIN_RGB_MainTEXT forState:UIControlStateNormal];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"FileRightButtonClicked" object:[NSString stringWithFormat:@"%d",self.rightBtn.selected]];
}


@end
