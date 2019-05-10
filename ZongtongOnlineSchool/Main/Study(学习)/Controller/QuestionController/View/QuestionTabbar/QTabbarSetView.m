//
//  QTabbarSetView.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2019/1/7.
//  Copyright © 2019年 ZongTongEdu. All rights reserved.
//

#import "QTabbarSetView.h"
#import "Tools.h"

@implementation QTabbarSetView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    self = [[NSBundle mainBundle] loadNibNamed:@"QTabbarSetView" owner:self options:nil].lastObject;
    if (self)
    {
        self.frame = frame;
        [self.riJianBtn setImage:[UIImage imageNamed:[USER_DEFAULTS boolForKey:Question_DayNight] ? @"rijianmoshi.png":@"rijianmoshise.png"] forState:UIControlStateNormal];
        [self.yeJianBtn setImage:[UIImage imageNamed:[USER_DEFAULTS boolForKey:Question_DayNight] ? @"yejianmoshise.png":@"yejianmoshi.png"] forState:UIControlStateNormal];
    }
    
    return self;
}
- (IBAction)setBtnClicked:(id)sender {
    UIButton *temBtn = (UIButton *)sender;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"QTabbarSetViewBtnClicked" object:[NSString stringWithFormat:@"%ld",(long)temBtn.tag]];
}

@end
