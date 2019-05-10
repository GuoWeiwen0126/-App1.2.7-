//
//  FileDownHistoryCell.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/9/6.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import "FileDownHistoryCell.h"
#import "FileModel.h"

@implementation FileDownHistoryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setFileCoinHistoryModel:(FileCoinHistoryModel *)fileCoinHistoryModel {
    if (_fileCoinHistoryModel != fileCoinHistoryModel) {
        _fileCoinHistoryModel = fileCoinHistoryModel;
    }
    self.titleLabel.text = fileCoinHistoryModel.fileTitle;
    self.coinNumLabel.text = [NSString stringWithFormat:@"%ld 个积分",(long)fileCoinHistoryModel.goldNumber];
    self.numLabel.text = [NSString stringWithFormat:@"-%ld",(long)fileCoinHistoryModel.goldNumber];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
