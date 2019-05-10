//
//  CALayer+XibBorderUIColor.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/11/6.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import "CALayer+XibBorderUIColor.h"
#import <UIKit/UIKit.h>

@implementation CALayer (XibBorderUIColor)

-(void)setBorderUIColor:(UIColor*)color
{
    self.borderColor = color.CGColor;
}

@end
