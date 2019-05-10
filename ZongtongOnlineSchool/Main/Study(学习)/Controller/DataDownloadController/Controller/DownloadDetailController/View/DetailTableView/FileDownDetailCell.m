//
//  FileDownDetailCell.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/9/6.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import "FileDownDetailCell.h"
#import "FileModel.h"

@implementation FileDownDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setFileCoinLogModel:(FileCoinLogModel *)fileCoinLogModel {
    if (_fileCoinLogModel != fileCoinLogModel) {
        _fileCoinLogModel = fileCoinLogModel;
    }
    self.detailLabel.text = fileCoinLogModel.explain;
    self.timeLabel.text = fileCoinLogModel.insertTime;
    if (fileCoinLogModel.type == 1) {
        self.numLabel.text = [NSString stringWithFormat:@"+%ld",(long)fileCoinLogModel.changeNum];
        self.numLabel.textColor = [UIColor redColor];
    } else {
        self.numLabel.text = [NSString stringWithFormat:@"-%ld",(long)fileCoinLogModel.changeNum];
        self.numLabel.textColor = [UIColor orangeColor];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
