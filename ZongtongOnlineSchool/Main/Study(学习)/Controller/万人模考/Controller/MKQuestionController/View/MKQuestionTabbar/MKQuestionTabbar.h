//
//  MKQuestionTabbar.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2019/3/19.
//  Copyright © 2019年 ZongTongEdu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, MKQTabbarBottomType)
{
    BottomQCard    = 10,
    BottomHandIn   = 11,
};

@protocol MKQuestionTabbarDelegate <NSObject>

- (void)MKQuestionTabbarClickedWithTag:(NSInteger)tag;

@end

@interface MKQuestionTabbar : UIView

@property (nonatomic, weak) id <MKQuestionTabbarDelegate> MKQTabbarDelegate;

- (instancetype)initWithFrame:(CGRect)frame titleArray:(NSArray *)titleArray imgArray:(NSArray *)imgArray;
- (void)createTabbarButtonWithTitleArray:(NSArray *)titleArray ImgArray:(NSArray *)imgArray;

@end

NS_ASSUME_NONNULL_END
