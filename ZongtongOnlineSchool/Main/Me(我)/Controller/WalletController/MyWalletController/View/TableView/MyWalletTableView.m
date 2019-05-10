//
//  MyWalletTableView.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/1/15.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import "MyWalletTableView.h"
#import "Tools.h"

#import "WalletBalanceCell.h"
#import "WalletRechargeCell.h"
#import "WalletPayMoneyCell.h"
#import "WalletPayMethodCell.h"
#import "WalletPayCell.h"

@interface MyWalletTableView () <UITableViewDelegate, UITableViewDataSource>
{
    NSMutableArray *_coinArray;
}
@end

@implementation MyWalletTableView
static NSString *cellID_Balance   = @"cellID_Balance";
static NSString *cellID_Recharge  = @"cellID_Recharge";
static NSString *cellID_PayMoney  = @"cellID_PayMoney";
static NSString *cellID_PayMethod = @"cellID_PayMethod";
static NSString *cellID_Pay       = @"cellID_Pay";
- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style coinArray:(NSMutableArray *)coinArray
{
    self = [super initWithFrame:frame style:style];
    if (self)
    {
        _coinArray = coinArray;
        self.delegate = self;
        self.dataSource = self;
        [self registerNib:[UINib nibWithNibName:@"WalletBalanceCell" bundle:nil]   forCellReuseIdentifier:cellID_Balance];
        [self registerNib:[UINib nibWithNibName:@"WalletRechargeCell" bundle:nil]  forCellReuseIdentifier:cellID_Recharge];
        [self registerNib:[UINib nibWithNibName:@"WalletPayMoneyCell" bundle:nil]  forCellReuseIdentifier:cellID_PayMoney];
        [self registerNib:[UINib nibWithNibName:@"WalletPayMethodCell" bundle:nil] forCellReuseIdentifier:cellID_PayMethod];
        [self registerNib:[UINib nibWithNibName:@"WalletPayCell" bundle:nil]       forCellReuseIdentifier:cellID_Pay];
        self.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.bounces = NO;
        self.showsVerticalScrollIndicator = NO;
    }
    
    return self;
}
#pragma mark - tableView协议方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 120;
    } else if (indexPath.row == 1) {
        CGFloat space = SCREEN_FIT_WITH(15, 15, 20, 15, 50);
        CGFloat coinWidth = (UI_SCREEN_WIDTH - space*4)/3;
        CGFloat coinHeight = coinWidth/2;
        if (_coinArray.count%3 == 0) {
            return 40 + (coinHeight+space)*(_coinArray.count/3) + 30;
        } else {
            return 40 + (coinHeight+space)*(_coinArray.count/3 + 1) + 30;
        }
    } else if (indexPath.row == 2) {
        return 50;
    }
//    else if (indexPath.row == 3) {
//        return 50*2 - 10;
//    }
    else {
        return 100;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        WalletBalanceCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID_Balance forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    else if (indexPath.row == 1)
    {
        WalletRechargeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID_Recharge forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell createCoinButtonWithProductArray:_coinArray];
        
        return cell;
    }
    else if (indexPath.row == 2)
    {
        WalletPayMoneyCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID_PayMoney forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if ([self.payStr integerValue] == 0) {
            cell.payNumLabel.text = @"¥ 0元";
        } else {
            cell.payNumLabel.text = [NSString stringWithFormat:@"¥ %@元",self.payStr];
        }
        
        return cell;
    }
//    else if (indexPath.row == 3)
//    {
//        WalletPayMethodCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID_PayMethod forIndexPath:indexPath];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        
//        return cell;
//    }
    else
    {
        WalletPayCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID_Pay forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
}


@end
