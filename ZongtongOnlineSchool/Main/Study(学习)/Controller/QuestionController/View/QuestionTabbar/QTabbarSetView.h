//
//  QTabbarSetView.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2019/1/7.
//  Copyright © 2019年 ZongTongEdu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, QTabbarSetType)
{
    SettingFontMinus = 100,
    SettingFontAdd   = 101,
    SettingDay       = 102,
    SettingNight     = 103,
};

@interface QTabbarSetView : UIView

@property (weak, nonatomic) IBOutlet UIButton *riJianBtn;
@property (weak, nonatomic) IBOutlet UIButton *yeJianBtn;

@end

NS_ASSUME_NONNULL_END
