//
//  BgButton.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/11/28.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import "BgButton.h"

@implementation BgButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
        [self addTarget:self action:@selector(bgButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return self;
}
- (void)bgButtonClicked
{
    [self removeFromSuperview];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
