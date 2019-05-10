//
//  FeedbackCell.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/12/8.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import "FeedbackCell.h"

@implementation FeedbackCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
#pragma mark - 问题反馈
- (IBAction)feedbackBtnClicked:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"QuestionGoToFeedback" object:nil];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
