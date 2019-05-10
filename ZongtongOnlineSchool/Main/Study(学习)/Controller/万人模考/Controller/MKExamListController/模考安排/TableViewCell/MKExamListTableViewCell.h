//
//  MKExamListTableViewCell.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2019/3/15.
//  Copyright © 2019年 ZongTongEdu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EmkBasicListModel;

NS_ASSUME_NONNULL_BEGIN

@interface MKExamListTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *peopleNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *examTimeLabel;

@property (nonatomic, strong) EmkBasicListModel *basicListModel;

@end

NS_ASSUME_NONNULL_END
