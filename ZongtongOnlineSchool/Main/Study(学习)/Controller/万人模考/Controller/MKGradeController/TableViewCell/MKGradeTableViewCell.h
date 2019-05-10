//
//  MKGradeTableViewCell.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2019/3/20.
//  Copyright © 2019年 ZongTongEdu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EmkUserGradeModel;

NS_ASSUME_NONNULL_BEGIN

@interface MKGradeTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *examTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *courseLabel;
@property (weak, nonatomic) IBOutlet UIView *progressBgView;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *gradeLabel;
@property (weak, nonatomic) IBOutlet UIButton *examBtn;

@property (nonatomic, copy) NSString *naviTitle;
@property (nonatomic, strong) EmkUserGradeModel *userGradeModel;

@end

NS_ASSUME_NONNULL_END
