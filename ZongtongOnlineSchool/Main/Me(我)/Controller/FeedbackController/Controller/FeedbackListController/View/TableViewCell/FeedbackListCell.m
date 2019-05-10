//
//  FeedbackListCell.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/1/5.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import "FeedbackListCell.h"
#import "FeedbackModel.h"

@implementation FeedbackListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
#pragma mark - setter方法
- (void)setFeedbackModel:(FeedbackModel *)feedbackModel
{
    if (_feedbackModel != feedbackModel)
    {
        _feedbackModel = feedbackModel;
    }
    self.fTypeTitleLabel.text = [NSString stringWithFormat:@"【%@】",feedbackModel.fTypeTitle];
    self.statusTitleLabel.text = feedbackModel.statusTitle;
    self.contentLabel.text = feedbackModel.content;
    self.insertTimeLabel.text = feedbackModel.insertTime;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
