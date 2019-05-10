//
//  MKExamListHeaderView.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2019/3/23.
//  Copyright © 2019年 ZongTongEdu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EmkListModel;

NS_ASSUME_NONNULL_BEGIN

@interface MKExamListHeaderView : UITableViewHeaderFooterView

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *examBtn;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@property (nonatomic, strong) EmkListModel *emkListModel;

@end

NS_ASSUME_NONNULL_END
