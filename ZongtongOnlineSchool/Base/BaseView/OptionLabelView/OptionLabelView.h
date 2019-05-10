//
//  OptionLabelView.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/12/6.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OptionLabelViewDelegate <NSObject>

- (void)optionViewLabelTapWithLabelTag:(NSInteger)labelTag;

@end

@interface OptionLabelView : UIView

@property (nonatomic, weak) id <OptionLabelViewDelegate> optionViewDelegate;

- (instancetype)initWithFrame:(CGRect)frame
                  optionArray:(NSArray *)optionArray
               labelTextColor:(UIColor *)labelTextColor
                    labelFont:(CGFloat)labelFont
                       isAttr:(BOOL)isAttr
                    lineSpace:(CGFloat)lineSpace
                    enableTap:(BOOL)enableTap;

- (void)refreshLabelViewWithOptionArray:(NSArray *)optionArray isAttr:(BOOL)isAttr;

@end
