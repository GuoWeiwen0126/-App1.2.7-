//
//  FeedbackListCell.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/1/5.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FeedbackModel;

@interface FeedbackListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *fTypeTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *insertTimeLabel;

@property (nonatomic, strong) FeedbackModel *feedbackModel;

@end
