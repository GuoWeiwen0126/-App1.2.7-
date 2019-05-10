//
//  NavigationBar.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/11/6.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NavigationBar : UIView

@property(nonatomic,strong) UIButton *leftButton;
@property(nonatomic,strong) UIButton *rightButton;
@property(nonatomic,strong) UIButton *titlebutton;

- (id)initWithLeftButtonTitle:(NSString *)leftTitle RightButtonTitle:(NSString *)rightTitle NaviTitle:(NSString *)naviTitle NaviFont:(CGFloat)naviFont BgColor:(UIColor *)bgColor;

- (void)refreshTitleButtonFrameWithNaviTitle:(NSString *)naviTitle;

@end
