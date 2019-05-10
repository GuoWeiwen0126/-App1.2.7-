//
//  TalkfunWindow.m
//  TalkfunSDKDemo
//
//  Created by Sunzn on 2017/4/19.
//  Copyright © 2017年 Talkfun. All rights reserved.
//

#import "TalkfunWindow.h"

@implementation TalkfunWindow

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
        
    if (!CGRectContainsPoint(self.viewFrame, point)) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"HideMoreView" object:nil];
    }
    
    return YES;
}

@end
