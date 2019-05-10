//
//  MKRankExamListCell.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2019/3/27.
//  Copyright © 2019年 ZongTongEdu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EmkListModel;

NS_ASSUME_NONNULL_BEGIN

@interface MKRankExamListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *rankBtn;

@property (nonatomic, strong) EmkListModel *emkListModel;

@end

NS_ASSUME_NONNULL_END
