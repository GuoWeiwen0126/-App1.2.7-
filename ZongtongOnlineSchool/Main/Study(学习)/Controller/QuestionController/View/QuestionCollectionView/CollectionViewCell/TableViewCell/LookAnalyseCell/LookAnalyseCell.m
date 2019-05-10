//
//  LookAnalyseCell.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2019/1/28.
//  Copyright © 2019年 ZongTongEdu. All rights reserved.
//

#import "LookAnalyseCell.h"
#import "Tools.h"
#import "QuestionModel.h"

@implementation LookAnalyseCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}
- (IBAction)LookAnalyseBtnClicked:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LookAnalyseBtnClicked" object:nil];
}
- (void)setQuestionModel:(QuestionModel *)questionModel {
    if (_questionModel != questionModel)
    {
        _questionModel = questionModel;
    }
    self.backgroundColor = [USER_DEFAULTS boolForKey:Question_DayNight] ? Night_RGB_BGColor:[UIColor whiteColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
