//
//  MKRankListTableViewCell.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2019/3/15.
//  Copyright © 2019年 ZongTongEdu. All rights reserved.
//

#import "MKRankListTableViewCell.h"
#import "Tools.h"
#import "MKModel.h"
#import "MKRankLabel.h"

@implementation MKRankListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setRankModel:(MKRankModel *)rankModel
{
    if (_rankModel != rankModel) {
        _rankModel = rankModel;
    }
    self.nickNameLabel.text = [NSString stringWithFormat:@"昵称：%@",rankModel.nickname.length == 0 ? @"匿名用户":rankModel.nickname];
    self.totalGradeLabel.text = [NSString stringWithFormat:@"总分：%@",rankModel.scoreCount];
    
    for (id obj in self.subviews) {
        if ([obj isKindOfClass:[MKRankLabel class]]) {
            [obj removeFromSuperview];
        }
    }
    for (int i = 0; i < rankModel.SingleList.count; i ++) {
        MKRankLabel *label = [[MKRankLabel alloc] initWithFrame:CGRectMake(self.rankLabel.right, 60 + 30*i, (UI_SCREEN_WIDTH - self.rankLabel.width)/3*2, 30)];
        label.text = rankModel.SingleList[i].courserTitle;
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = MAIN_RGB_TEXT;
        label.font = FontOfSize(SCREEN_FIT_WITH_DEVICE(14, 16));
        label.numberOfLines = 2;
        [self addSubview:label];
    }
    for (int i = 0; i < rankModel.SingleList.count; i ++) {
        MKRankLabel *label = [[MKRankLabel alloc] initWithFrame:CGRectMake(self.rankLabel.right + (UI_SCREEN_WIDTH - self.rankLabel.width)/3*2, 60 + 30*i, (UI_SCREEN_WIDTH - self.rankLabel.width)/3, 30)];
        label.text = [NSString stringWithFormat:@"%@分",rankModel.SingleList[i].score];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = MAIN_RGB_TEXT;
        label.font = FontOfSize(SCREEN_FIT_WITH_DEVICE(14, 16));
        [self addSubview:label];
    }
    
    NSString *hourStr = [NSString stringWithFormat:@"%ld",rankModel.timeCount/(60*60)];
    NSString *miniteStr = [NSString stringWithFormat:@"%ld",rankModel.timeCount%(60*60)/60];
    NSString *secondStr = [NSString stringWithFormat:@"%ld",rankModel.timeCount%60];;
    if (miniteStr.length == 1) {
        miniteStr = [NSString stringWithFormat:@"0%@",miniteStr];
    }
    if (secondStr.length == 1) {
        secondStr = [NSString stringWithFormat:@"0%@",secondStr];
    }
    self.timeLabel.text = [NSString stringWithFormat:@"用时：0%@:%@:%@",hourStr,miniteStr,secondStr];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
