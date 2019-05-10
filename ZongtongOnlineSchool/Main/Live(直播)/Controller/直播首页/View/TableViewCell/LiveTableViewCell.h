//
//  LiveTableViewCell.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/12/3.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LiveClassListModel;

NS_ASSUME_NONNULL_BEGIN

@interface LiveTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *courseLabel;
@property (weak, nonatomic) IBOutlet UILabel *teacherLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (nonatomic, strong) LiveClassListModel *listModel;

@end

NS_ASSUME_NONNULL_END
