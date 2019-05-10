//
//  AliLiveViewController.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2019/4/28.
//  Copyright © 2019年 ZongTongEdu. All rights reserved.
//

#import "BaseViewController.h"
@class LiveBasicListModel;

NS_ASSUME_NONNULL_BEGIN

@interface AliLiveViewController : BaseViewController

@property (nonatomic, assign) BOOL isLive;  //直播 or 录播
@property (nonatomic, strong) LiveBasicListModel *basicModel;
@property (nonatomic, assign) NSInteger ltid;

@end

NS_ASSUME_NONNULL_END
