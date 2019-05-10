//
//  FeedbackButton.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/12/15.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import "FeedbackButton.h"
#import "Tools.h"

@implementation FeedbackButton

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title
{
    if (self = [super initWithFrame:frame])
    {
        self.titleLabel.font = FontOfSize(SCREEN_FIT_WITH(11.0f, 12.0f, 14.0f, 12.0f, 18.0f));
        [self setTitle:title forState:UIControlStateNormal];
        [self setTitleColor:MAIN_RGB_TEXT forState:UIControlStateNormal];
        self.layer.borderWidth = 1;
        self.layer.borderColor = MAIN_RGB_LINE.CGColor;
    }
    
    return self;
}

- (void)setIsSelect:(BOOL)isSelect
{
    if (_isSelect != isSelect)
    {
        _isSelect = isSelect;
    }
    if (isSelect) {
        [self setTitleColor:MAIN_RGB forState:UIControlStateNormal];
        self.layer.borderWidth = 1;
        self.layer.borderColor = MAIN_RGB.CGColor;
    } else {
        [self setTitleColor:MAIN_RGB_TEXT forState:UIControlStateNormal];
        self.layer.borderWidth = 1;
        self.layer.borderColor = MAIN_RGB_LINE.CGColor;
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
