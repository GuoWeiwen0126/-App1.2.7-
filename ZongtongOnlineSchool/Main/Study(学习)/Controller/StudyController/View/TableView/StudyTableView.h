//
//  StudyTableView.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/11/29.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StudyTableView : UITableView

@property (nonatomic, strong) NSMutableArray *moduleArray;
@property (nonatomic, strong) NSMutableArray *adArray;
@property (nonatomic, strong) NSMutableArray *videoCourseArray;
@property (nonatomic, strong) NSMutableArray *bookArray;

@property (nonatomic, assign) NSInteger videoSrTime;  //学习时长（分钟）
@property (nonatomic, assign) NSInteger videoVtime;   //视频时长（分钟）
@property (nonatomic, assign) CGFloat videoPercent;   //学习进度

@end
