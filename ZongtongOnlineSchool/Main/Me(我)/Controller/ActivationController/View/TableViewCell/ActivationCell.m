//
//  ActivationCell.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/3/13.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import "ActivationCell.h"
#import "Tools.h"
#import "ActivationModel.h"

@interface ActivationCell ()
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *cdkeyLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *useBtn;
@property (weak, nonatomic) IBOutlet UIButton *detailBtn;
@property (weak, nonatomic) IBOutlet UILabel *smTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *smDurationLabel;
@end

@implementation ActivationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
#pragma mark - 立即使用激活码
- (IBAction)useBtnClicked:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ActivationUseCDKEY" object:self.listModel];
}
#pragma mark - 查看激活码详情
- (IBAction)detailBtnClicked:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ActivationCDKEYDetail" object:self.listModel.CDKEY];
}

- (void)setListModel:(ActivationListModel *)listModel
{
    if (_listModel != listModel) {
        _listModel = listModel;
    }
    self.cdkeyLabel.text = listModel.CDKEY;
    if (listModel.state == 2) {  //已绑定
        [self.useBtn setTitle:@"立即使用" forState:UIControlStateNormal];
        self.useBtn.userInteractionEnabled = YES;
        self.timeLabel.text = listModel.insertTime;
        self.bgView.layer.borderColor = MAIN_RGB.CGColor;
        self.useBtn.backgroundColor = MAIN_RGB;
    } else {
        [self.useBtn setTitle:listModel.stateTitle forState:UIControlStateNormal];
        self.useBtn.userInteractionEnabled = NO;
        self.timeLabel.text = listModel.useTime;
        self.bgView.layer.borderColor = MAIN_RGB_TEXT.CGColor;
        self.useBtn.backgroundColor = MAIN_RGB_TEXT;
    }
    if (listModel.isOpen) {
        self.detailBtn.hidden = YES;
        self.smTitleLabel.hidden = NO;
        self.smDurationLabel.hidden = NO;
        self.smTitleLabel.text = [NSString stringWithFormat:@"套餐名称：%@",listModel.smTitle];
        self.smDurationLabel.text = [NSString stringWithFormat:@"开通时长：%ld 个月",(long)listModel.duration];
    } else {
        self.detailBtn.hidden = NO;
        self.smTitleLabel.hidden = YES;
        self.smDurationLabel.hidden = YES;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
