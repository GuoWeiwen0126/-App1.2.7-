//
//  VideoPlayTableView.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/12/28.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class VideoDetailModel;

typedef NS_ENUM(NSInteger, VideoPlayTableViewType)
{
    VideoCourseType   = 10,
    VideoHandoutType  = 11,
    VideoEvaluateType = 12,
};

@interface VideoPlayTableView : UITableView

@property (nonatomic, strong) NSMutableArray *videoSecDataArray;
@property (nonatomic, strong) NSMutableArray *evaluateArray;
@property (nonatomic, assign) BOOL isQVideoType;
@property (nonatomic, assign) VideoPlayTableViewType tableViewType;
@property (nonatomic, strong) VideoDetailModel *vDetailModel;


@end
