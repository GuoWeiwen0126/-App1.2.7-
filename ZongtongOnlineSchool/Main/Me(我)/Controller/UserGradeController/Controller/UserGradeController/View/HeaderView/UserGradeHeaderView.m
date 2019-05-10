//
//  UserGradeHeaderView.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/12/10.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import "UserGradeHeaderView.h"

@implementation UserGradeHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    self = [[NSBundle mainBundle] loadNibNamed:@"UserGradeHeaderView" owner:self options:nil].lastObject;
    if (self)
    {
        self.frame = frame;
    }
    
    return self;
}

@end
