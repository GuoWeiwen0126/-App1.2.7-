//
//  HeaderCellButton.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/11/22.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import "HeaderCellButton.h"
#import "Macros.h"

@implementation HeaderCellButton

- (instancetype)initWithFrame:(CGRect)frame imageName:(NSString *)imageName imageScale:(CGFloat)imageScale imageOffsetY:(CGFloat)imageOffsetY title:(NSString *)title titleFont:(CGFloat)titleFont titleOffsetY:(CGFloat)titleOffsetY
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.height*imageScale, self.height*imageScale)];
        self.imgView.center = CGPointMake(self.width/2, self.height/2 - self.imgView.height/2 + imageOffsetY);
        self.imgView.image = [UIImage imageNamed:imageName];
        [self addSubview:self.imgView];
        
        self.label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height/3)];
        self.label.center = CGPointMake(self.width/2, self.height/2 + self.label.height/2 + titleOffsetY);
        self.label.text = title;
        self.label.font = FontOfSize(titleFont);
        self.label.textColor = MAIN_RGB_TEXT;
        self.label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.label];
        
//        self.imgView.backgroundColor = [UIColor greenColor];
//        self.label.backgroundColor = [UIColor redColor];
//        self.backgroundColor = MAIN_RGB_TEXT;
    }
    
    return self;
}

@end
