//
//  ALiVideoPlayViewController.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/1/16.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import "BaseViewController.h"
@class VideoSectionModel;
@class VideoDetailModel;
@class ZFFileModel;

typedef NS_ENUM(NSInteger, VideoPlayVCType)
{
    SectionVideoType  = 0,
    QuestionVideoType = 1,
};

@interface ALiVideoPlayViewController : BaseViewController

@property (nonatomic, assign) BOOL isHtmlVideo;  //是否是html网页视频
@property (nonatomic, assign) VideoPlayVCType vcType;
@property (nonatomic, copy)   NSString *qid;
@property (nonatomic, strong) VideoSectionModel *vSecModel;
@property (nonatomic, strong) VideoDetailModel *vDetailModel;
@property (nonatomic, strong) NSMutableArray *videoSectionDataArray;

//@property (nonatomic, assign) NSInteger vtfid;  //第一节点的vtid（缓存视频使用）
@property (nonatomic, strong) ZFFileModel *fileInfo;  //播放缓存视频使用

@end
