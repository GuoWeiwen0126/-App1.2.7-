//
//  VideoDownloadedCell.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/1/16.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import "VideoDownloadedCell.h"
#import "ZFDownloadManager.h"

@interface VideoDownloadedCell ()

@property (weak, nonatomic) IBOutlet UILabel *videoNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *videoSizeLabel;

@end

@implementation VideoDownloadedCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
#pragma mark - fileInfo---setter方法
- (void)setFileInfo:(ZFFileModel *)fileInfo
{
    _fileInfo = fileInfo;
    NSString *totalSize = [ZFCommonHelper getFileSizeString:fileInfo.fileSize];
    self.videoNameLabel.text = [NSString stringWithFormat:@"%@",fileInfo.vTitle];
    self.videoSizeLabel.text = totalSize;
}
#pragma mark - 点击视频播放
- (IBAction)videoPlayBtnClicked:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PlayLocalVideo" object:_fileInfo];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
