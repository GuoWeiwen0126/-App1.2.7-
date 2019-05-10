//
//  WalletPayCell.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/1/15.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import "WalletPayCell.h"

@implementation WalletPayCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
#pragma mark - 立即充值
- (IBAction)payBtnClicked:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UserPay" object:nil];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
