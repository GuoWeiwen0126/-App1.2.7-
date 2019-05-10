//
//  QuestionTabbar.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/12/5.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import "QuestionTabbar.h"
#import "Tools.h"
#import "HeaderCellButton.h"

@implementation QuestionTabbar

- (instancetype)initWithFrame:(CGRect)frame titleArray:(NSArray *)titleArray imgArray:(NSArray *)imgArray
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = MAIN_RGB_LINE;
        
        [self createTabbarButtonWithTitleArray:titleArray ImgArray:imgArray];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 1)];
        lineView.backgroundColor = MAIN_RGB_TEXT;
        [self addSubview:lineView];
    }
    return self;
}
#pragma mark - 创建tabbar按钮
- (void)createTabbarButtonWithTitleArray:(NSArray *)titleArray ImgArray:(NSArray *)imgArray
{
    //先移除按钮
    for (id obj in self.subviews) {
        if ([obj isKindOfClass:[HeaderCellButton class]]) {
            [obj removeFromSuperview];
        }
    }
    //再创建按钮
    for (int i = 0; i < imgArray.count; i ++)
    {
        HeaderCellButton *tabbarButton = [[HeaderCellButton alloc] initWithFrame:CGRectMake(UI_SCREEN_WIDTH/imgArray.count*i, 0, UI_SCREEN_WIDTH/imgArray.count, self.height)                            imageName:imgArray[i]
                                                                      imageScale:0.45f
                                                                    imageOffsetY:4
                                                                           title:titleArray[i]
                                                                       titleFont:10.0f
                                                                    titleOffsetY:4];
        [tabbarButton addTarget:self action:@selector(tabbarButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        tabbarButton.tag = i + 10;
        [self addSubview:tabbarButton];
    }
}
#pragma mark - tabbarButton点击方法
- (void)tabbarButtonClicked:(UIButton *)btn
{
    if ([self.QTabbarDelegate respondsToSelector:@selector(QuestionTabbarClickedWithTag:)])
    {
        [self.QTabbarDelegate QuestionTabbarClickedWithTag:btn.tag];
    }
}
#pragma mark - 刷新收藏按钮状态
- (void)qTabbarRefreshCollectBtnWithCollectState:(NSInteger)collectState
{
    for (id obj in self.subviews) {
        if ([obj isKindOfClass:[HeaderCellButton class]]) {
            HeaderCellButton *collectBtn = (HeaderCellButton *)obj;
            if (collectBtn.tag == BottomCollect) {
                collectBtn.imgView.image = [UIImage imageNamed:collectState == 0 ? @"shouchang1.png":@"shouchang.png"];
            }
        }
    }
}

@end
