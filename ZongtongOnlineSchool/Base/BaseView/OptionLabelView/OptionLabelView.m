//
//  OptionLabelView.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/12/6.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import "OptionLabelView.h"
#import "Tools.h"

@implementation OptionLabelView

- (instancetype)initWithFrame:(CGRect)frame optionArray:(NSArray *)optionArray labelTextColor:(UIColor *)labelTextColor labelFont:(CGFloat)labelFont isAttr:(BOOL)isAttr lineSpace:(CGFloat)lineSpace enableTap:(BOOL)enableTap
{
    if (self = [super initWithFrame:frame])
    {
        for (int i = 0; i < optionArray.count; i ++)
        {
            UILabel *optionLabel = [[UILabel alloc] initWithFrame:CGRectMake(UI_SCREEN_WIDTH/optionArray.count * i, 0, UI_SCREEN_WIDTH/optionArray.count, self.height)];
            optionLabel.textColor = labelTextColor;
            optionLabel.font = FontOfSize(labelFont);
            if (isAttr) {
                optionLabel.attributedText = optionArray[i];
            }
            else {
                optionLabel.text = optionArray[i];
            }
            optionLabel.textAlignment = NSTextAlignmentCenter;
            optionLabel.numberOfLines = 0;
            optionLabel.tag = i + 10;
            [self addSubview:optionLabel];
            
            if (enableTap) {
                UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOptionLabel:)];
                [optionLabel addGestureRecognizer:tapGesture];
                optionLabel.userInteractionEnabled = YES;
            }
        }
        
        for (int j = 0; j < optionArray.count-1; j ++)
        {
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(UI_SCREEN_WIDTH/optionArray.count*(j+1) - 0.5, lineSpace, 1, self.height - lineSpace*2)];
            lineView.backgroundColor = MAIN_RGB_LINE;
            [self addSubview:lineView];
        }
    }
    
    return self;
}
#pragma mark - 刷新界面
- (void)refreshLabelViewWithOptionArray:(NSArray *)optionArray isAttr:(BOOL)isAttr
{
    for (int i = 0; i < optionArray.count; i ++)
    {
        UILabel *temLabel = (UILabel *)[self viewWithTag:i + 10];
        if (isAttr)
        {
            temLabel.attributedText = optionArray[i];
        }
        else
        {
            temLabel.text = optionArray[i];
        }
    }
}

#pragma mark - 点击手势
- (void)tapOptionLabel:(UITapGestureRecognizer *)tap
{
    UITapGestureRecognizer *temTap = (UITapGestureRecognizer *)tap;
    if ([self.optionViewDelegate respondsToSelector:@selector(optionViewLabelTapWithLabelTag:)])
    {
        [self.optionViewDelegate optionViewLabelTapWithLabelTag:temTap.view.tag - 10];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
