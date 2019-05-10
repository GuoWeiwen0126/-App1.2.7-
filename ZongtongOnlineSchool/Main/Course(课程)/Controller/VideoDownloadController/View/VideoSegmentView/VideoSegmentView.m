//
//  VideoSegmentView.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/1/16.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import "VideoSegmentView.h"
#import "Tools.h"

@implementation VideoSegmentView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        UISegmentedControl *segControl = [[UISegmentedControl alloc] initWithItems:@[@"正在下载", @"已下载"]];
        segControl.frame = CGRectMake(UI_SCREEN_WIDTH/2 - 120, 10, 240, self.height - 10*2 - 5);
        segControl.selectedSegmentIndex = 0;
        segControl.tintColor = MAIN_RGB;
        [segControl addTarget:self action:@selector(segControlValueChanged:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:segControl];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - 5, UI_SCREEN_WIDTH, 5)];
        lineView.backgroundColor = MAIN_RGB_LINE;
        [self addSubview:lineView];
    }
    
    return self;
}
- (void)segControlValueChanged:(UISegmentedControl *)seg
{
    if ([self.videoSegControlDelegate respondsToSelector:@selector(videoDownloadSegmentControlValueChanged:)])
    {
        [self.videoSegControlDelegate videoDownloadSegmentControlValueChanged:seg.selectedSegmentIndex];
    }
}


@end
