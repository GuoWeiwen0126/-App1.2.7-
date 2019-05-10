//
//  AppEvaluateFeedbackCell.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/1/24.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import "AppEvaluateFeedbackCell.h"

@implementation AppEvaluateFeedbackCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.feedbackTV.delegate = self;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateAppEvaluateFeedbackContent" object:textView.text];
    return YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
