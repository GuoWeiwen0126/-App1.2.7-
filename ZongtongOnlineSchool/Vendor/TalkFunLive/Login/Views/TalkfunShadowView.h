//
//  TalkfunShadowView.h
//  TalkfunSDKDemo
//
//  Created by Sunzn on 2017/4/19.
//  Copyright © 2017年 Talkfun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TalkfunShadowView : UIView

@property (nonatomic, strong) UIImageView *lineView;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) CGSize showSize;
- (void)stopTimer;

@end
