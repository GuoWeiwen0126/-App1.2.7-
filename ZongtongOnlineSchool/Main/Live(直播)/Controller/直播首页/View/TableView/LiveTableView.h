//
//  LiveTableView.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/12/3.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, LiveType) {
    Live_OnLine  = 0,
    Live_OffLine = 1,
};

NS_ASSUME_NONNULL_BEGIN

@interface LiveTableView : UITableView <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, assign) LiveType liveType;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

NS_ASSUME_NONNULL_END
