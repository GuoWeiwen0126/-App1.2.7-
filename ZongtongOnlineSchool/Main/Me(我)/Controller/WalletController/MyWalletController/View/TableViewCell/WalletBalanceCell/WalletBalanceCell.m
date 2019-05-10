//
//  WalletBalanceCell.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/1/15.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import "WalletBalanceCell.h"
#import "Tools.h"

@implementation WalletBalanceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.balanceLabel.text = [NSString stringWithFormat:@"%ld",IsLocalAccount ? [USER_DEFAULTS integerForKey:User_sum_LocalAccount]:[USER_DEFAULTS integerForKey:User_sum]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
