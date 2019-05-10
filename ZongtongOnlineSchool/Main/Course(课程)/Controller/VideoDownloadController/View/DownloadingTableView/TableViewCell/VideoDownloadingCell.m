//
//  VideoDownloadingCell.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/1/16.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import "VideoDownloadingCell.h"

@interface VideoDownloadingCell ()
@property (weak, nonatomic) IBOutlet UILabel *videoNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *speedLabel;
@property (weak, nonatomic) IBOutlet UILabel *progressLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UIButton *downloadBtn;
@end

@implementation VideoDownloadingCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
#pragma mark - 下载按钮点击
- (IBAction)downloadBtnClicked:(UIButton *)sender
{
    // 执行操作过程中应该禁止该按键的响应 否则会引起异常
    sender.userInteractionEnabled = NO;
    ZFFileModel *downFile = self.fileInfo;
    ZFDownloadManager *filedownmanage = [ZFDownloadManager sharedDownloadManager];
    if(downFile.downloadState == ZFDownloading) { //文件正在下载，点击之后暂停下载 有可能进入等待状态
        self.downloadBtn.selected = YES;
        [filedownmanage stopRequest:self.request];
    } else {
        self.downloadBtn.selected = NO;
        [filedownmanage resumeRequest:self.request];
    }
    
    // 暂停意味着这个Cell里的ASIHttprequest已被释放，要及时更新table的数据，使最新的ASIHttpreqst控制Cell
    if (self.downloadBtnClickBlock) {
        self.downloadBtnClickBlock();
    }
    sender.userInteractionEnabled = YES;
}
#pragma mark - fileInfo---setter方法
- (void)setFileInfo:(ZFFileModel *)fileInfo
{
    _fileInfo = fileInfo;
    if (fileInfo.vTitle && fileInfo.vTitle.length > 0) {
        self.videoNameLabel.text = [NSString stringWithFormat:@"%@",fileInfo.vTitle];
    } else {
        self.videoNameLabel.text = [NSString stringWithFormat:@"%@",fileInfo.lvTitle];
    }
    // 服务器可能响应的慢，拿不到视频总长度 && 不是下载状态
    if ([fileInfo.fileSize longLongValue] == 0 && !(fileInfo.downloadState == ZFDownloading))
    {
        self.progressLabel.text = @"";
        if (fileInfo.downloadState == ZFStopDownload)
        {
            self.speedLabel.text = @"已暂停";
            [self.downloadBtn setBackgroundImage:[UIImage imageNamed:@"videodownloadxiazai.png"] forState:UIControlStateNormal];
        } else if (fileInfo.downloadState == ZFWillDownload)
        {
            self.downloadBtn.selected = YES;
            self.speedLabel.text = @"等待下载";
            [self.downloadBtn setBackgroundImage:[UIImage imageNamed:@"videodownloaddengdai.png"] forState:UIControlStateNormal];
        }
        self.progressView.progress = 0.0;
        return;
    }
    NSString *currentSize = [ZFCommonHelper getFileSizeString:fileInfo.fileReceivedSize];
    NSString *totalSize = [ZFCommonHelper getFileSizeString:fileInfo.fileSize];
    // 下载进度
    float progress = (float)[fileInfo.fileReceivedSize longLongValue] / [fileInfo.fileSize longLongValue];
    
    self.progressLabel.text = [NSString stringWithFormat:@"%@/%@",currentSize, totalSize];
    
    self.progressView.progress = progress;
    
    // NSString *spped = [NSString stringWithFormat:@"%@/S",[ZFCommonHelper getFileSizeString:[NSString stringWithFormat:@"%lu",[ASIHTTPRequest averageBandwidthUsedPerSecond]]]];
    if (fileInfo.speed)
    {
        NSString *speed = [NSString stringWithFormat:@"%@",fileInfo.speed];
        self.speedLabel.text = speed;
    }
    else
    {
        self.speedLabel.text = @"正在获取";
    }
    
    if (fileInfo.downloadState == ZFDownloading)
    {
        //文件正在下载
        self.downloadBtn.selected = NO;
        [self.downloadBtn setBackgroundImage:[UIImage imageNamed:@"videodownloadzanting.png"] forState:UIControlStateNormal];
    }
    else if (fileInfo.downloadState == ZFStopDownload&&!fileInfo.error)
    {
        self.downloadBtn.selected = YES;
        self.speedLabel.text = @"已暂停";
        [self.downloadBtn setBackgroundImage:[UIImage imageNamed:@"videodownloadxiazai.png"] forState:UIControlStateNormal];
    }
    else if (fileInfo.downloadState == ZFWillDownload&&!fileInfo.error)
    {
        self.downloadBtn.selected = YES;
        self.speedLabel.text = @"等待下载";
        [self.downloadBtn setBackgroundImage:[UIImage imageNamed:@"videodownloaddengdai.png"] forState:UIControlStateNormal];
    }
    else if (fileInfo.error)
    {
        self.downloadBtn.selected = YES;
        self.speedLabel.text = @"错误";
        [self.downloadBtn setBackgroundImage:[UIImage imageNamed:@"videodownloadxiazai.png"] forState:UIControlStateNormal];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
