//
//  VideoCourseCell.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/12/28.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import "VideoCourseCell.h"
#import "VideoSectionModel.h"

@interface VideoCourseCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *vTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *studyNumLabel;
@property (weak, nonatomic) IBOutlet UIButton *playBtn;

@end

@implementation VideoCourseCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
#pragma mark - 点击播放按钮
- (IBAction)playBtnClicked:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"VideoCourseCellPlayBtnClicked" object:self.vSectionModel];
}
#pragma mark - setter方法
- (void)setVSectionModel:(VideoSectionModel *)vSectionModel
{
    if (_vSectionModel != vSectionModel)
    {
        _vSectionModel = vSectionModel;
    }

    self.titleLabel.text = vSectionModel.title;
    self.vTimeLabel.text = [NSString stringWithFormat:@"%ld/%ld 分钟",(long)vSectionModel.srTime,(long)vSectionModel.vtime];
    self.studyNumLabel.text = [NSString stringWithFormat:@"%ld 人观看",(long)vSectionModel.studyNum];
    [self.playBtn setBackgroundImage:[UIImage imageNamed:vSectionModel.isBuy == YES ? @"suo.png":@"ship.png"] forState:UIControlStateNormal];
    if (vSectionModel.vid == 0) {
        self.playBtn.hidden = YES;
        self.studyNumLabel.hidden = YES;
        if (vSectionModel.infoList.count > 0) {
            self.imgView.image = [UIImage imageNamed:vSectionModel.belowCount > 0 ? @"jianhao.png":@"jiahao.png"];
        } else {
            self.imgView.image = [UIImage imageNamed:@"xiaoyuan.png"];
        }
    } else {
        self.playBtn.hidden = NO;
        self.studyNumLabel.hidden = NO;
        self.imgView.image = [UIImage imageNamed:@"xiaoyuan.png"];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
