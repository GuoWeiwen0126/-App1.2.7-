//
//  VideoEvaluateStarCell.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/1/2.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideoEvaluateStarCell : UITableViewCell

@property (nonatomic, strong) NSArray *detailArray;

- (void)createDetailLabelWithSection:(NSInteger)section;

@end
