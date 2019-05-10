//
//  OptionButtonView.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/11/13.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OptionButtonViewDelegate <NSObject>

- (void)optionViewButtonClickedWithBtnTag:(NSInteger)btnTag;

@end

@interface OptionButtonView : UIView

@property (nonatomic, weak) id <OptionButtonViewDelegate> optionViewDelegate;

- (instancetype)initWithFrame:(CGRect)frame optionArray:(NSArray *)optionArray selectedColor:(UIColor *)selectedColor lineSpace:(CGFloat)lineSpace haveLineView:(BOOL)haveLineView selectIndex:(NSInteger)selectIndex;

- (void)optionButtonChangeTitleWithArray:(NSArray *)array;

@end
