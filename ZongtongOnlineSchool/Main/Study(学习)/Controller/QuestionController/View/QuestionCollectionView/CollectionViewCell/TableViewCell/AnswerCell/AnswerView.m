//
//  AnswerView.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/9/29.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import "AnswerView.h"
#import "Tools.h"

@interface AnswerView ()
{
    UIView *_bgView;
}
@end

@implementation AnswerView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        VIEW_BORDER_RADIUS(_bgView, MAIN_RGB_LightLINE, 5, 1, MAIN_RGB_LINE)
        NSArray *titleArray = @[@"答题人数", @"平均正确率", @"易错项"];
        [self addSubview:_bgView];
        for (int i = 0; i < 3; i ++) {
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _bgView.width/4, 20)];
            titleLabel.center = CGPointMake(_bgView.width/6 + _bgView.width/3*i, _bgView.height/2 + 10);
            titleLabel.font = FontOfSize(12.0f);
            titleLabel.text = titleArray[i];
            titleLabel.textColor = MAIN_RGB_MainTEXT;
            titleLabel.textAlignment = NSTextAlignmentCenter;
            [_bgView addSubview:titleLabel];
            if (i == 0) {
                self.firstLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, titleLabel.width, titleLabel.height)];
                self.firstLabel.center = CGPointMake(titleLabel.center.x, titleLabel.center.y - 20);
                self.firstLabel.font = FontOfSize(14.0f);
                self.firstLabel.textAlignment = NSTextAlignmentCenter;
                self.firstLabel.textColor = MAIN_RGB_MainTEXT;
                [_bgView addSubview:self.firstLabel];
            } else if (i == 1) {
                self.secondLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, titleLabel.width, titleLabel.height)];
                self.secondLabel.center = CGPointMake(titleLabel.center.x, titleLabel.center.y - 20);
                self.secondLabel.font = FontOfSize(14.0f);
                self.secondLabel.textAlignment = NSTextAlignmentCenter;
                self.secondLabel.textColor = MAIN_RGB_MainTEXT;
                [_bgView addSubview:self.secondLabel];
            } else if (i == 2) {
                self.thirdLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, titleLabel.width, titleLabel.height)];
                self.thirdLabel.center = CGPointMake(titleLabel.center.x, titleLabel.center.y - 20);
                self.thirdLabel.font = FontOfSize(14.0f);
                self.thirdLabel.textAlignment = NSTextAlignmentCenter;
                self.thirdLabel.textColor = MAIN_RGB_MainTEXT;
                [_bgView addSubview:self.thirdLabel];
            }
        }
    }
    
    return self;
}
- (void)answerViewRefreshWithArray:(NSArray *)array
{
    self.backgroundColor = [USER_DEFAULTS boolForKey:Question_DayNight] ? Night_RGB_BGColor:[UIColor whiteColor];
    _bgView.backgroundColor = [USER_DEFAULTS boolForKey:Question_DayNight] ? Night_RGB_BGColor:MAIN_RGB_LightLINE;
    
    self.firstLabel.text = array[0];
    self.secondLabel.text = array[1];
    self.thirdLabel.text = array[2];
}

@end
