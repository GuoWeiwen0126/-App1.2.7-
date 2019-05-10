//
//  WalletRechargeCell.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/1/15.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import "WalletRechargeCell.h"
#import "Tools.h"
#import "WalletModel.h"
#import "CoinButton.h"

@implementation WalletRechargeCell
{
    NSMutableArray *_productModelArray;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)createCoinButtonWithProductArray:(NSMutableArray *)proArray
{
    _productModelArray = proArray;
    CGFloat space = SCREEN_FIT_WITH(15, 15, 20, 15, 50);
    CGFloat coinWidth = (UI_SCREEN_WIDTH - space*4)/3;
    CGFloat coinHeight = coinWidth/2;
    for (int i = 0; i < proArray.count; i ++)
    {
        ProductModel *proModel = proArray[i];
        CoinButton *coinBtn = [[CoinButton alloc] initWithFrame:CGRectMake(space + (space+coinWidth)*(i%3), 40 + (space+coinHeight)*(i/3), coinWidth, coinHeight)];
        coinBtn.coinNumLabel.text = [NSString stringWithFormat:@"%ld个",(long)proModel.Key];
        coinBtn.priceNumLabel.text = [NSString stringWithFormat:@" ¥%@",proModel.Price];
        coinBtn.isSelect = NO;
        coinBtn.tag = i + 10;
        [coinBtn addTarget:self action:@selector(coinBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:coinBtn];
    }
    
    self.goldDetailLabel = [[UILabel alloc] initWithFrame:CGRectMake(space, 40 + (coinHeight+space)*(proArray.count/3), UI_SCREEN_WIDTH - space*2, 30)];
    self.goldDetailLabel.text = @"";
    self.goldDetailLabel.textColor = MAIN_RGB;
    self.goldDetailLabel.textAlignment = NSTextAlignmentRight;
    self.goldDetailLabel.font = FontOfSize(SCREEN_FIT_WITH_DEVICE(16.0, 24.0));
    [self addSubview:self.goldDetailLabel];
}

- (void)coinBtnClicked:(CoinButton *)btn
{
    ProductModel *proModel = _productModelArray[btn.tag - 10];
    for (id obj in self.subviews) {
        if ([obj isKindOfClass:[CoinButton class]]) {
            CoinButton *temBtn = (CoinButton *)obj;
            if (temBtn.tag == btn.tag) {
                temBtn.isSelect = YES;
                self.goldDetailLabel.text = [NSString stringWithFormat:@"花费%@元可以获取%ld个金币",proModel.Price,(long)proModel.Key];
            } else {
                temBtn.isSelect = NO;
            }
        }
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdatePayMoney" object:proModel];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
