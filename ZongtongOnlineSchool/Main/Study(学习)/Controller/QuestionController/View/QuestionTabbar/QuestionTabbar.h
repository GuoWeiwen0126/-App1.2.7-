//
//  QuestionTabbar.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/12/5.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, QTabbarBottomType)
{
    BottomCollect  = 10,
    BottomQCard    = 11,
    BottomHandIn   = 12,
};

@protocol QuestionTabbarDelegate <NSObject>

- (void)QuestionTabbarClickedWithTag:(NSInteger)tag;

@end

@interface QuestionTabbar : UIView

@property (nonatomic, weak) id <QuestionTabbarDelegate> QTabbarDelegate;

- (instancetype)initWithFrame:(CGRect)frame titleArray:(NSArray *)titleArray imgArray:(NSArray *)imgArray;
- (void)createTabbarButtonWithTitleArray:(NSArray *)titleArray ImgArray:(NSArray *)imgArray;
- (void)qTabbarRefreshCollectBtnWithCollectState:(NSInteger)collectState;

@end
