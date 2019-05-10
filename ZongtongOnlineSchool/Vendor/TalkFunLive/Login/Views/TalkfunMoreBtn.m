//
//  TalkfunMoreBtn.m
//  TalkfunSDKDemo
//
//  Created by Sunzn on 2017/4/19.
//  Copyright © 2017年 Talkfun. All rights reserved.
//

#import "TalkfunMoreBtn.h"

@implementation TalkfunMoreBtn

- (void)layoutSubviews{
    [super layoutSubviews];
    self.titleLabel.frame = CGRectMake(10, 0, CGRectGetWidth(self.frame)-10, CGRectGetHeight(self.frame));
    self.imageView.frame = CGRectMake(0, 0 , 10, 20);
    self.imageView.center = CGPointMake(CGRectGetWidth(self.frame)/2, CGRectGetHeight(self.frame)/2);
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
}

@end
