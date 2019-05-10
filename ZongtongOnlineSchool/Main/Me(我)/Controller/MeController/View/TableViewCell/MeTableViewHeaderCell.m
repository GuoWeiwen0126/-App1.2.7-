//
//  MeTableViewHeaderCell.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/11/21.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import "MeTableViewHeaderCell.h"
#import "Tools.h"
#import "HeaderCellButton.h"

@implementation MeTableViewHeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.nameLabel.text = IsLocalAccount ? @"试用账号  ":[USER_DEFAULTS objectForKey:User_nickName];
    self.nameLabelWidth.constant = [ManagerTools adaptWidthWithString:self.nameLabel.text FontSize:14.0f SizeHeight:self.nameLabel.height];
    [self.portraitBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:[USER_DEFAULTS objectForKey:User_portrait]] forState:UIControlStateNormal placeholderImage:PortraitPlaceholder];
    self.sexImgView.image = [UIImage imageNamed:[[USER_DEFAULTS objectForKey:User_sexType] integerValue] == 0 ? @"xingbienan.png":@"xingbienv.png"];
    NSString *phoneStr = @"";
    if ([ManagerTools checkTelNumber:[USER_DEFAULTS objectForKey:User_phone]]) {
        phoneStr = [[USER_DEFAULTS objectForKey:User_phone] stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    } else {
        phoneStr = [USER_DEFAULTS objectForKey:User_phone];
    }
    self.gradeLabel.text = [NSString stringWithFormat:@"账号:%@  等级:Lv%ld",phoneStr,[[USER_DEFAULTS objectForKey:User_grade] integerValue]];
    self.gradeLabel.hidden = IsLocalAccount ? YES:NO;
    
    NSArray *imgArray = @[@"grzxshouchang.png", @"cuoti.png", @"jilu.png", @"biji.png"];
    NSArray *titleArray = @[@"收藏", @"错题", @"历史", @"笔记"];
    
    //删除 bottomView 上的子视图
    for (id obj in self.bottomView.subviews) {
        if ([obj isKindOfClass:[UIView class]]) {
            [obj removeFromSuperview];
        }
    }
    for (int i = 0; i < 4; i ++)
    {
        HeaderCellButton *button = [[HeaderCellButton alloc] initWithFrame:CGRectMake(UI_SCREEN_WIDTH/4*i, 0, UI_SCREEN_WIDTH/4, self.bottomView.height) imageName:imgArray[i] imageScale:0.45f imageOffsetY:12 title:titleArray[i] titleFont:14.0f titleOffsetY:12];
        button.label.textColor = [UIColor whiteColor];
        [button addTarget:self action:@selector(bottomButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = i + 10;
        [self.bottomView addSubview:button];
    }
    for (int j = 0; j < 3; j ++)
    {
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0.5f, self.bottomView.height/2)];
        lineView.center = CGPointMake(UI_SCREEN_WIDTH/4*(j+1), self.bottomView.height/2 + 6);
        lineView.backgroundColor = MAIN_RGB_LINE;
        [self.bottomView addSubview:lineView];
    }
}
#pragma mark -头像按钮点击
- (IBAction)portraitBtnClicked:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MeTableViewHeaderCellPortraitBtnClicked" object:nil];
}
#pragma mark - 底部按钮点击方法
- (void)bottomButtonClicked:(HeaderCellButton *)btn
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MeTableViewHeaderCellBottomBtnClicked" object:[NSString stringWithFormat:@"%ld",btn.tag - 10]];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
