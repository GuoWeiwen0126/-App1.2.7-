//
//  StudyScheduleCell.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/2/5.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol StudyScheduleCellDelegate <NSObject>
- (void)segmentValueCHnagedWithSegIndex:(NSInteger)segIndex;
@end

@interface StudyScheduleCell : UITableViewCell

@property (nonatomic, weak) id <StudyScheduleCellDelegate> cellDelegate;
@property (nonatomic, assign) NSInteger videoSrTime;  //学习时长（分钟）
@property (nonatomic, assign) NSInteger videoVtime;   //视频时长（分钟）
@property (nonatomic, assign) CGFloat videoPercent;   //学习进度

@end
