//
//  ZNLXTableViewCell.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/12/4.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import "ZNLXTableViewCell.h"
#import "Tools.h"
#import "ZNLXCellModel.h"

@implementation ZNLXTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
#pragma mark - 做题按钮点击方法
- (IBAction)writeBtnClicked:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ZNLXTableViewCellWriteBtnClicked" object:self.cellModel];
}

#pragma mark - setter方法
- (void)setCellModel:(ZNLXCellModel *)cellModel
{
    if (_cellModel != cellModel)
    {
        _cellModel = cellModel;
    }
    
    self.titleLabel.text = cellModel.title;
    self.titleLabelHeight.constant = [ManagerTools adaptHeightWithString:self.titleLabel.text FontSize:14.0 SizeWidth:UI_SCREEN_WIDTH - 110] + 5;
    self.QNumLabel.text = [NSString stringWithFormat:@"%ld/%ld 道",(long)cellModel.exQNum,(long)cellModel.qCount];
    self.qProgressView.progress = cellModel.qCount == 0 ? 0:1.0*cellModel.exQNum/cellModel.qCount;
    [self.writeBtn setBackgroundImage:[UIImage imageNamed:cellModel.isBuy == YES ? @"suo.png":@"dati.png"] forState:UIControlStateNormal];
    self.imgView.image = [UIImage imageNamed:cellModel.isQues == 1 ? @"jiahao.png":@"jianhao.png"];
    if (cellModel.isQues == 1) {  //有子集
        self.writeBtn.hidden = YES;
        if (cellModel.basicList.count > 0) {
            self.imgView.image = [UIImage imageNamed:cellModel.belowCount > 0 ? @"jianhao.png":@"jiahao.png"];
        } else {
            self.imgView.image = [UIImage imageNamed:@"xiaoyuan.png"];
        }
    } else {
        self.writeBtn.hidden = NO;
        self.imgView.image = [UIImage imageNamed:@"xiaoyuan.png"];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
