//
//  CourseAdView.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2019/1/24.
//  Copyright © 2019年 ZongTongEdu. All rights reserved.
//

#import "CourseAdView.h"
#import "Tools.h"
#import "HomeModel.h"

@implementation CourseAdView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, self.width, self.height) delegate:self placeholderImage:nil];
        self.cycleScrollView.backgroundColor = [UIColor clearColor];
        self.cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFit;
        self.cycleScrollView.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.cycleScrollView.autoScrollTimeInterval = 2;
        [self addSubview:self.cycleScrollView];
        self.clipsToBounds = YES;
    }
    
    return self;
}
- (void)refreshWithAdArray:(NSMutableArray *)adArray
{
    self.adArray = adArray;
    NSMutableArray *adImgArray = [NSMutableArray arrayWithCapacity:10];
    for (AdInfoModel *adModel in self.adArray) {
        [adImgArray addObject:adModel.imgUrl];
    }
    self.cycleScrollView.imageURLStringsGroup = adImgArray;
}
#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CourseAdverClicked" object:self.adArray[index]];
}

@end
