//
//  UserSexTableViewCell.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/11/22.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import "UserSexTableViewCell.h"
#import "Macros.h"

@implementation UserSexTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

#pragma mark - 性别按钮点击方法
- (IBAction)sexBtnClicked:(id)sender
{
    UIButton *sexBtn = (UIButton *)sender;
    if ([[USER_DEFAULTS objectForKey:User_sexType] integerValue] != sexBtn.tag - 10)
    {
        if (sexBtn.tag == 10)
        {
            self.maleBtn.selected = YES;
            self.femaleBtn.selected = NO;
        }
        else
        {
            self.maleBtn.selected = NO;
            self.femaleBtn.selected = YES;
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateSexType" object:[NSString stringWithFormat:@"%ld",sexBtn.tag - 10]];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
