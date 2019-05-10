//
//  CoinButton.m
//  XiaoXiaQuestionBank
//
//  Created by GuoWeiwen on 2018/1/10.
//  Copyright © 2018年 GuoWeiwen. All rights reserved.
//

#import "CoinButton.h"
#import "Tools.h"

@implementation CoinButton

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.height/2, self.height/2)];
        imgView.center = CGPointMake(self.width/2 - 15, self.height/4 + 2);
        imgView.image = [UIImage imageNamed:@"zongtongbi.png"];
        [self addSubview:imgView];
        
        self.priceNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(imgView.right, imgView.top, self.width/2 + 15, self.height/2)];
        self.priceNumLabel.font = FontOfSize(SCREEN_FIT_WITH_DEVICE(14.0, 20.0));
        self.priceNumLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:self.priceNumLabel];
        
        self.coinNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.height/2, self.width, self.height/2)];
        self.coinNumLabel.font = FontOfSize(SCREEN_FIT_WITH_DEVICE(14.0, 20.0));
        self.coinNumLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.coinNumLabel];
        
        self.selectImgView = [[UIImageView alloc] initWithFrame:CGRectMake(self.width - 15, 0, 15, 15)];
        self.selectImgView.image = [UIImage imageNamed:@"coinjiaobiao.png"];
        self.selectImgView.hidden = YES;
        [self addSubview:self.selectImgView];
    }
    
    return self;
}
- (void)setIsSelect:(BOOL)isSelect
{
    if (_isSelect != isSelect)
    {
        _isSelect = isSelect;
    }
    if (isSelect) {
        self.coinNumLabel.textColor = MAIN_RGB;
        self.priceNumLabel.textColor = MAIN_RGB;
        self.selectImgView.hidden = NO;
        VIEW_BORDER_RADIUS(self, [UIColor whiteColor], 5, 1, MAIN_RGB)
    } else {
        self.coinNumLabel.textColor = MAIN_RGB_TEXT;
        self.priceNumLabel.textColor = MAIN_RGB_TEXT;
        self.selectImgView.hidden = YES;
        VIEW_BORDER_RADIUS(self, [UIColor whiteColor], 5, 1, MAIN_RGB_TEXT)
    }
}

@end
