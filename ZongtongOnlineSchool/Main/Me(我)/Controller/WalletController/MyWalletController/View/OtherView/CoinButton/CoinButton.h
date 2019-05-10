//
//  CoinButton.h
//  XiaoXiaQuestionBank
//
//  Created by GuoWeiwen on 2018/1/10.
//  Copyright © 2018年 GuoWeiwen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CoinButton : UIButton

@property (nonatomic, strong) UILabel *coinNumLabel;
@property (nonatomic, strong) UILabel *priceNumLabel;
@property (nonatomic, strong) UIImageView *selectImgView;

@property (nonatomic, assign) BOOL isSelect;

@end
