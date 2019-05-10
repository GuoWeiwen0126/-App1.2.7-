//
//  PayMethodButton.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/1/15.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import "PayMethodButton.h"
#import "Tools.h"

@implementation PayMethodButton

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.payImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 2, self.height - 2*2, self.height - 2*2)];
        [self addSubview:self.payImgView];
        
        self.methodLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.payImgView.right + 15, 0, self.width/2, self.height)];
        self.methodLabel.textColor = MAIN_RGB_MainTEXT;
        self.methodLabel.font = FontOfSize(16.0);
        [self addSubview:self.methodLabel];
        
        self.selectImgView = [[UIImageView alloc] initWithFrame:CGRectMake(self.width - (self.height - 5*2), 5, self.height - 5*2, self.height - 5*2)];
        self.selectImgView.image = [UIImage imageNamed:@"yuanquan.png"];
        [self addSubview:self.selectImgView];
    }
    
    return self;
}
- (void)setPayMethod:(PayMethodType)payMethod
{
    switch (payMethod) {
        case TaoBaoPayMethod:
        {
            self.payImgView.image = [UIImage imageNamed:@"taobaopay.png"];
            self.methodLabel.text = @"前往淘宝购买";
        }
            break;
        case ALiPayMethod:
        {
            self.payImgView.image = [UIImage imageNamed:@"alipay.png"];
            self.methodLabel.text = @"支付宝支付";
        }
            break;
        case WechatPayMethod:
        {
            self.payImgView.image = [UIImage imageNamed:@"wechatpay.png"];
            self.methodLabel.text = @"微信支付";
        }
            break;
        case WalletPayMethod:
        {
            self.payImgView.image = [UIImage imageNamed:@"zongtongbi.png"];
            self.methodLabel.text = @"钱包余额支付";
        }
            break;
        case IOSIPAPayMethod:
        {
            self.payImgView.image = [UIImage imageNamed:@"appleipa.png"];
            self.methodLabel.text = @"苹果内购方式";
        }
            break;
            
        default:
            break;
    }
}
- (void)setIsSelected:(BOOL)isSelected
{
    if (_isSelected != isSelected)
    {
        _isSelected = isSelected;
    }
    if (isSelected) {
        self.selectImgView.image = [UIImage imageNamed:@"yuandian.png"];
    } else {
        self.selectImgView.image = [UIImage imageNamed:@"yuanquan.png"];
    }
}

@end
