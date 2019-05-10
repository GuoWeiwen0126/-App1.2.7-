//
//  TalkfunButton.m
//  TalkfunSDKDemo
//
//  Created by Sunzn on 2017/4/18.
//  Copyright © 2017年 Talkfun. All rights reserved.
//

#import "TalkfunButton.h"

@implementation TalkfunButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)layoutSubviews{
    [super layoutSubviews];
    self.titleLabel.frame = CGRectMake(4, 0, CGRectGetWidth(self.frame)-4, 30);
    self.imageView.frame = CGRectMake(CGRectGetWidth(self.frame)*6.0/7.0, CGRectGetHeight(self.frame)/2.0-5, 10, 10);
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
}

@end
