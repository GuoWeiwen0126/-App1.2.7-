//
//  MKRankListTableViewCell.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2019/3/15.
//  Copyright © 2019年 ZongTongEdu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MKRankModel;

NS_ASSUME_NONNULL_BEGIN

@interface MKRankListTableViewCell : UITableViewCell

@property (nonatomic, strong) MKRankModel *rankModel;

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *rankLabel;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalGradeLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end

NS_ASSUME_NONNULL_END
