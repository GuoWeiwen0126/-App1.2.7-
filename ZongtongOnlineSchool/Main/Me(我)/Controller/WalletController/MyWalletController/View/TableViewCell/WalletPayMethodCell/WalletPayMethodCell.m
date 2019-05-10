//
//  WalletPayMethodCell.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/1/15.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import "WalletPayMethodCell.h"
#import "Tools.h"

@implementation WalletPayMethodCell
{
    PayMethodButton *_payMethodBtn;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _payMethodBtn = [[PayMethodButton alloc] initWithFrame:CGRectMake(20, 50, UI_SCREEN_WIDTH - 20*2, 30)];
    _payMethodBtn.payMethod = IOSIPAPayMethod;
    _payMethodBtn.isSelected = YES;
    [self addSubview:_payMethodBtn];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
