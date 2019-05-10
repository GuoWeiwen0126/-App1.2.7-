//
//  PayMethodButton.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/1/15.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, PayMethodType)
{
    TaoBaoPayMethod = 1,
    ALiPayMethod    = 2,
    WechatPayMethod = 3,
    WalletPayMethod = 4,
    IOSIPAPayMethod = 10,
};

@interface PayMethodButton : UIButton

@property (nonatomic, assign) PayMethodType payMethod;
@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, strong) UIImageView *payImgView;
@property (nonatomic, strong) UILabel     *methodLabel;
@property (nonatomic, strong) UIImageView *selectImgView;

@end
