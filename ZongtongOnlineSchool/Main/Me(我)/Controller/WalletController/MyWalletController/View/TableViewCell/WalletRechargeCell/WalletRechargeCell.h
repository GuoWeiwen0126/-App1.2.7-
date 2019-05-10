//
//  WalletRechargeCell.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/1/15.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WalletRechargeCell : UITableViewCell

@property (nonatomic, strong) UILabel *goldDetailLabel;

- (void)createCoinButtonWithProductArray:(NSMutableArray *)proArray;

@end
