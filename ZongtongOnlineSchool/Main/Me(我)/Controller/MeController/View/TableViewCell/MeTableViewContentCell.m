//
//  MeTableViewContentCell.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/11/21.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import "MeTableViewContentCell.h"

@implementation MeTableViewContentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setDataDic:(NSDictionary *)dataDic
{
    if (_dataDic != dataDic)
    {
        _dataDic = dataDic;
    }
    
    self.imgView.image = [UIImage imageNamed:dataDic[@"image"]];
    self.titleLabel.text = dataDic[@"title"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
