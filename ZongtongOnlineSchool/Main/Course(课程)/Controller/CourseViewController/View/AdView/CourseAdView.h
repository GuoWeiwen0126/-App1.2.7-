//
//  CourseAdView.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2019/1/24.
//  Copyright © 2019年 ZongTongEdu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDCycleScrollView.h"

NS_ASSUME_NONNULL_BEGIN

@interface CourseAdView : UIView <SDCycleScrollViewDelegate>

@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;
@property (nonatomic, strong) NSMutableArray *adArray;

- (void)refreshWithAdArray:(NSMutableArray *)adArray;

@end

NS_ASSUME_NONNULL_END
