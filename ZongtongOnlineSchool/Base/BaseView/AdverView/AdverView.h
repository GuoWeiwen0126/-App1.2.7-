//
//  AdverView.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2019/4/17.
//  Copyright © 2019年 ZongTongEdu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDCycleScrollView.h"

@protocol AdverViewDelegate <NSObject>

- (void)adverViewClickedWithAdModel:(id)model;

@end

NS_ASSUME_NONNULL_BEGIN

@interface AdverView : UIView <SDCycleScrollViewDelegate>

@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;
@property (nonatomic, strong) NSMutableArray *adArray;
@property (nonatomic, weak) id <AdverViewDelegate> delegate;

- (void)refreshWithAdArray:(NSMutableArray *)adArray;

@end

NS_ASSUME_NONNULL_END
