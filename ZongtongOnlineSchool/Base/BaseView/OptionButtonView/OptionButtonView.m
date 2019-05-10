//
//  OptionButtonView.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/11/13.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import "OptionButtonView.h"
#import "Macros.h"

@interface OptionButtonView ()

@property (nonatomic, assign) NSInteger optionCount;
@property (nonatomic, strong) UIColor  *optionColor;
@property (nonatomic, strong) UILabel  *bottomLineLabel;

@end

@implementation OptionButtonView

- (instancetype)initWithFrame:(CGRect)frame optionArray:(NSArray *)optionArray selectedColor:(UIColor *)selectedColor lineSpace:(CGFloat)lineSpace haveLineView:(BOOL)haveLineView selectIndex:(NSInteger)selectIndex
{
    if (self = [super initWithFrame:frame])
    {
        self.optionCount = optionArray.count;
        self.optionColor = selectedColor;
        
        for (int i = 0; i < optionArray.count; i ++)
        {
            UIButton *optionButton = [[UIButton alloc] initWithFrame:CGRectMake(UI_SCREEN_WIDTH/optionArray.count * i, 0, UI_SCREEN_WIDTH/optionArray.count, self.height)];
            [optionButton setTitle:optionArray[i]            forState:UIControlStateNormal];
            [optionButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [optionButton setTitleColor:MAIN_RGB             forState:UIControlStateSelected];
            optionButton.titleLabel.font = FontOfSize(16.0);
            optionButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
            [optionButton addTarget:self action:@selector(optionButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            optionButton.tag = i + 10;
            if (i == selectIndex)
            {
                optionButton.selected = YES;
            }
            [self addSubview:optionButton];
        }
        
        for (int j = 0; j < optionArray.count-1; j ++)
        {
            UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(UI_SCREEN_WIDTH/optionArray.count*(j+1) - 0.5, lineSpace, 1, self.height - lineSpace*2)];
            lineLabel.backgroundColor = MAIN_RGB_LINE;
            [self addSubview:lineLabel];
        }
        
        self.bottomLineLabel = [[UILabel alloc] initWithFrame:CGRectMake(UI_SCREEN_WIDTH/optionArray.count * selectIndex, self.height - 2, UI_SCREEN_WIDTH/optionArray.count, 2)];
        self.bottomLineLabel.backgroundColor = selectedColor;
        [self addSubview:self.bottomLineLabel];
        if (haveLineView == NO) {
            self.bottomLineLabel.hidden = YES;
        }
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - 1, UI_SCREEN_WIDTH, 1)];
        lineView.backgroundColor = MAIN_RGB_LINE;
        [self addSubview:lineView];
    }
    
    return self;
}
#pragma mark - 选项按钮点击方法
- (void)optionButtonClicked:(UIButton *)btn
{
    for (id temBtn in self.subviews)
    {
        if ([temBtn isKindOfClass:[UIButton class]])
        {
            UIButton *selectedBtn = (UIButton *)temBtn;
            selectedBtn.selected = NO;
        }
    }
    btn.selected = YES;
    [UIView animateWithDuration:0.2 animations:^{
        self.bottomLineLabel.frame = CGRectMake(UI_SCREEN_WIDTH/self.optionCount * (btn.tag-10), self.height - 2, UI_SCREEN_WIDTH/self.optionCount, 2);
    }];
    
    if ([self.optionViewDelegate respondsToSelector:@selector(optionViewButtonClickedWithBtnTag:)])
    {
        [self.optionViewDelegate optionViewButtonClickedWithBtnTag:btn.tag - 10];
    }
}
#pragma mark - 按钮标题切换方法
- (void)optionButtonChangeTitleWithArray:(NSArray *)array
{
    for (id temBtn in self.subviews)
    {
        if ([temBtn isKindOfClass:[UIButton class]])
        {
            UIButton *selectedBtn = (UIButton *)temBtn;
            [selectedBtn setTitle:array[selectedBtn.tag - 10] forState:UIControlStateNormal];
        }
    }
}


@end
