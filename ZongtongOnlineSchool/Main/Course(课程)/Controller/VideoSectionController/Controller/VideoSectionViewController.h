//
//  VideoSectionViewController.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/12/26.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import "BaseViewController.h"
@class VideoTypeModel;

@interface VideoSectionViewController : BaseViewController

//@property (nonatomic, strong) VideoTypeModel *vTypeModel;
@property (nonatomic, copy) NSString *naviTitle;
@property (nonatomic, copy) NSString *courseId;
@property (nonatomic, assign) NSInteger vtfid;

@end
