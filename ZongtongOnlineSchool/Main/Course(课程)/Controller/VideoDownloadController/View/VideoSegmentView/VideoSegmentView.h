//
//  VideoSegmentView.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/1/16.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol VideoSegmentControlDelegate <NSObject>
- (void)videoDownloadSegmentControlValueChanged:(NSInteger)segmentIndex;
@end

@interface VideoSegmentView : UIView

@property (nonatomic, weak) id <VideoSegmentControlDelegate> videoSegControlDelegate;

@end
