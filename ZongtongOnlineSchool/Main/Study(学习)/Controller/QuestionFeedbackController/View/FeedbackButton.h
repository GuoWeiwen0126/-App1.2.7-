//
//  FeedbackButton.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/12/15.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeedbackButton : UIButton

@property (nonatomic, assign) BOOL isSelect;

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title;

@end
