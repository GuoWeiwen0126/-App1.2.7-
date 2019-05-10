//
//  LiveLocalPlayViewController.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/12/6.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import "BaseViewController.h"
@class LiveBasicListModel;

NS_ASSUME_NONNULL_BEGIN

@interface LiveLocalPlayViewController : BaseViewController

@property (nonatomic, copy) NSString *naviTitle;
@property (nonatomic, strong) NSArray *sourceList;
@property (nonatomic, strong) LiveBasicListModel *basicModel;
@property (nonatomic, assign) NSInteger ltid;

@end

NS_ASSUME_NONNULL_END
