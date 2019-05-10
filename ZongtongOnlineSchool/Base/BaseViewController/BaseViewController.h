//
//  BaseViewController.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/11/14.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NavigationBar;

typedef NS_ENUM(NSUInteger, naviBtnType)
{
    LeftBtnType  = 1,
    RightBtnType = 2,
};

@protocol BaseNaviDelegate <NSObject>

@optional
- (void)baseNaviButtonClickedWithBtnType:(naviBtnType)btnType;

@end

@interface BaseViewController : UIViewController <BaseNaviDelegate>

@property (nonatomic, strong) NavigationBar *navigationBar;
@property (nonatomic, weak) id <BaseNaviDelegate> baseNaviDelegate;

/* 配置导航栏 */
- (void)configNavigationBarWithNaviTitle:(NSString *)naviTitle naviFont:(CGFloat)naviFont leftBtnTitle:(NSString *)leftBtnTitle rightBtnTitle:(NSString *)rightBtnTitle bgColor:(UIColor *)bgColor;

@end
