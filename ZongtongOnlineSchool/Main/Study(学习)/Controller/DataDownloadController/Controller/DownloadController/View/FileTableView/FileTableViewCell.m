//
//  FileTableViewCell.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/8/23.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import "FileTableViewCell.h"
#import "FileModel.h"

@implementation FileTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setFileModel:(FileModel *)fileModel {
    if (_fileModel != fileModel) {
        _fileModel = fileModel;
    }
    self.titleLabel.text = fileModel.fileTitle;
    self.sizeLabel.text = [NSByteCountFormatter stringFromByteCount:[fileModel.fileSize longLongValue]*1000 countStyle:NSByteCountFormatterCountStyleFile];
    if ([fileModel.isBuy boolValue]) {
        self.coinNumLabel.text = @"已购买";
    } else {
        self.coinNumLabel.text = [NSString stringWithFormat:@"%ld 积分",(long)fileModel.goldNumber];
    }
    if ([fileModel.isDownloaded boolValue]) {
        self.downloadLabel.text = @"查看";
        self.downloadLabel.backgroundColor = [UIColor orangeColor];
    } else {
        self.downloadLabel.text = @"下载";
        self.downloadLabel.backgroundColor = [UIColor redColor];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
