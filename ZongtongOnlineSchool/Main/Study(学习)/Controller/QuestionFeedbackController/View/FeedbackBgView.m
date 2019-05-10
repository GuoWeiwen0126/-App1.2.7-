//
//  FeedbackBgView.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/12/15.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import "FeedbackBgView.h"
#import "Tools.h"

@interface FeedbackBgView ()
{
    NSArray *_titleArray;
    FeedbackButton *_selectBtn;
}
@end

@implementation FeedbackBgView

- (instancetype)initWithFrame:(CGRect)frame titleArray:(NSArray *)titleArray
{
    if (self = [super initWithFrame:frame])
    {
        _selectBtn = [[FeedbackButton alloc] init];
        self.fType = FType_NoChoose;
        CGFloat btnWidth = ((UI_SCREEN_WIDTH-30*2) - 10*2)/3;
        CGFloat btnHeight = ((UI_SCREEN_WIDTH-30*2)*0.25 - 10)/2;
        for (int i = 0; i < titleArray.count; i ++)
        {
            FeedbackButton *button = [[FeedbackButton alloc] initWithFrame:CGRectMake((btnWidth+10)*(i%3), (btnHeight+10)*(i/3), btnWidth, btnHeight) title:titleArray[i]];
            button.isSelect = NO;
            if (i < titleArray.count - 1) {
                button.tag = i + 11;
            } else {
                button.tag = 99 + 10;
            }
            [button addTarget:self action:@selector(feedbackButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:button];
        }
    }
    
    return self;
}
- (void)feedbackButtonClicked:(FeedbackButton *)btn
{
    if (_selectBtn) {
        _selectBtn.isSelect = NO;
    }
    _selectBtn = btn;
    _selectBtn.isSelect = YES;
    self.fType = btn.tag - 10;
    
//    for (id obj in self.subviews) {
//        if ([obj isKindOfClass:[FeedbackButton class]]) {
//            FeedbackButton *temBtn = (FeedbackButton *)obj;
//            if (temBtn.tag == btn.tag) {
//                temBtn.isSelect = YES;
//                self.fType = btn.tag - 10;
//            } else {
//                temBtn.isSelect = NO;
//            }
//        }
//    }
}

@end
