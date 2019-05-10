//
//  MKRankExamListCell.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2019/3/27.
//  Copyright © 2019年 ZongTongEdu. All rights reserved.
//

#import "MKRankExamListCell.h"
#import "Tools.h"
#import "MKModel.h"

@implementation MKRankExamListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
#pragma mark - 查看排行
- (IBAction)rankBtnClicked:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MKRankExamListRankBtnClicked" object:self.emkListModel];
}
- (void)setEmkListModel:(EmkListModel *)emkListModel {
    if (_emkListModel != emkListModel) {
        _emkListModel = emkListModel;
    }
    self.titleLabel.text = emkListModel.title;
    self.timeLabel.text = [NSString stringWithFormat:@"考试时间：%@",emkListModel.stime];
    if ([ManagerTools timestampJudgeWithStarttime:emkListModel.stime endTime:emkListModel.etime] == 1 || [ManagerTools timestampJudgeWithStarttime:emkListModel.stime endTime:emkListModel.etime] == 2) {
        [self.rankBtn setTitle:@"查看排行" forState:UIControlStateNormal];
    } else {
        [self.rankBtn setTitle:@"暂未排行" forState:UIControlStateNormal];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
