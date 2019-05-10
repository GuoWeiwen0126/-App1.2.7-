//
//  QHistoryTableViewCell.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/12/25.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class QHistoryModel;

@interface QHistoryTableViewCell : UITableViewCell

@property (nonatomic, assign) NSInteger state;  //状态（0：正在做题(做题进度)，  1：已经交卷(正确率)）
@property (nonatomic, strong) QHistoryModel *qHistoryModel;

@end
