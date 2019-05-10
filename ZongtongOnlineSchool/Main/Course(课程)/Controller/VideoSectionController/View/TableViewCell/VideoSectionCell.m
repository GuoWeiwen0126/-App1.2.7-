//
//  VideoSectionCell.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/12/26.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import "VideoSectionCell.h"
#import "Tools.h"
#import "VideoSectionModel.h"

@interface VideoSectionCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *vTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *studyNumLabel;
@property (weak, nonatomic) IBOutlet UIButton *downloadBtn;
@property (weak, nonatomic) IBOutlet UIButton *playBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLabelHeight;

@end

@implementation VideoSectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.titleLabel.font = FontOfSize(SCREEN_FIT_WITH(12.0, 13.0, 14.0, 13.0, 16.0));
}
#pragma mark - 播放视频、查看讲义点击
- (IBAction)playBtnClicked:(id)sender
{
    if (self.vSecStatus == 0) {  //课程
        [[NSNotificationCenter defaultCenter] postNotificationName:@"VideoTableViewCellPlayVideo" object:self.vSectionModel];
    } else {  //讲义
        [[NSNotificationCenter defaultCenter] postNotificationName:@"VideoTableViewCellOpenHandout" object:self.vSectionModel];
    }
}
#pragma mark - 下载按钮点击
- (IBAction)downloadBtnClicked:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"VideoTableViewCellDownloadVideo" object:self.vSectionModel];
}
#pragma mark - setter方法
- (void)setVSectionModel:(VideoSectionModel *)vSectionModel
{
    if (_vSectionModel != vSectionModel)
    {
        _vSectionModel = vSectionModel;
    }
    self.titleLabel.text = vSectionModel.title;
    self.titleLabelHeight.constant = [ManagerTools adaptHeightWithString:vSectionModel.title FontSize:SCREEN_FIT_WITH(12.0, 13.0, 14.0, 13.0, 16.0) SizeWidth:UI_SCREEN_WIDTH - 135] + 5;
    self.vTimeLabel.text = [NSString stringWithFormat:@"%ld/%ld分钟",(long)vSectionModel.srTime,(long)vSectionModel.vtime];
    self.studyNumLabel.text = [NSString stringWithFormat:@"%ld人观看",(long)vSectionModel.studyNum];
    [self.playBtn setBackgroundImage:[UIImage imageNamed:vSectionModel.isBuy == YES ? @"suo.png":(self.vSecStatus == 0 ? @"ship.png":@"dati.png")] forState:UIControlStateNormal];
    if (vSectionModel.vid == 0) {  //有子集
        self.playBtn.hidden = YES;
        self.studyNumLabel.hidden = YES;
        self.downloadBtn.hidden = YES;
        if (vSectionModel.infoList.count > 0) {
            self.imgView.image = [UIImage imageNamed:vSectionModel.belowCount > 0 ? @"jianhao.png":@"jiahao.png"];
        } else {
            self.imgView.image = [UIImage imageNamed:@"xiaoyuan.png"];
        }
    } else {
        self.playBtn.hidden = NO;
        self.studyNumLabel.hidden = NO;
        if (vSectionModel.isBuy == YES || IsLocalAccount) {
            self.downloadBtn.hidden = YES;
        } else {
            self.downloadBtn.hidden = NO;
        }
        self.imgView.image = [UIImage imageNamed:@"xiaoyuan.png"];
    }
    if (self.vSecStatus != 0) {
        self.downloadBtn.hidden = YES;
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
