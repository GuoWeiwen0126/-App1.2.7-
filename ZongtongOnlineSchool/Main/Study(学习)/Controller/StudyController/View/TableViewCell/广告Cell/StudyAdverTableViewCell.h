//
//  StudyAdverTableViewCell.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/1/8.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDCycleScrollView.h"

@interface StudyAdverTableViewCell : UITableViewCell <SDCycleScrollViewDelegate>

@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;
@property (nonatomic, strong) NSMutableArray *adArray;

@end
