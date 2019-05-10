//
//  NaviButton.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/12/6.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import "NaviButton.h"

@implementation NaviButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.imageEdgeInsets = UIEdgeInsetsMake(12, 12, 12, 12);
//        self.backgroundColor = [UIColor redColor];
    }
    
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
