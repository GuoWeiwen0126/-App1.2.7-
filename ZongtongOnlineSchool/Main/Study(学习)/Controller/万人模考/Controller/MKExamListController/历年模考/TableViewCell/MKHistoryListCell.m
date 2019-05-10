//
//  MKHistoryListCell.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2019/3/27.
//  Copyright © 2019年 ZongTongEdu. All rights reserved.
//

#import "MKHistoryListCell.h"
#import "Tools.h"
#import "MKModel.h"

@implementation MKHistoryListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)MKExamHistoryBtnClicked:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MKExamHistoryListTableViewClicked" object:self.emkListModel];
}
- (void)setEmkListModel:(EmkListModel *)emkListModel {
    if (_emkListModel != emkListModel) {
        _emkListModel = emkListModel;
    }
    self.titleLabel.text = emkListModel.title;
    self.timeLabel.text = [NSString stringWithFormat:@"开考时间:%@",emkListModel.stime];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
