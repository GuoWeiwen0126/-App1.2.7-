//
//  LiveCourseTableViewCell.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/12/5.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LiveBasicListModel;

NS_ASSUME_NONNULL_BEGIN

@interface LiveCourseTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *courseLabel;
@property (weak, nonatomic) IBOutlet UILabel *teacherLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *playLabel;
@property (weak, nonatomic) IBOutlet UIImageView *stateImgView;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;

@property (nonatomic, strong) LiveBasicListModel *basicModel;

@end

NS_ASSUME_NONNULL_END
