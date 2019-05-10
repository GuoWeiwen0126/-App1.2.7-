//
//  ReplyTableView.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/1/6.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ReplyHeaderView;

@interface ReplyTableView : UITableView

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) ReplyHeaderView *headerView;

@end
