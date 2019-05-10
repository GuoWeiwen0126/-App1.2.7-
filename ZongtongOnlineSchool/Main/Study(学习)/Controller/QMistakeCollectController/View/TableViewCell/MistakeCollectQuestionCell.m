//
//  MistakeCollectQuestionCell.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/12/22.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import "MistakeCollectQuestionCell.h"
#import "Tools.h"
#import "QuestionModel.h"

@interface MistakeCollectQuestionCell ()

@property (weak, nonatomic) IBOutlet UILabel *questionLabel;

@end

@implementation MistakeCollectQuestionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
#pragma mark - setter方法
- (void)setQuestionModel:(QuestionModel *)questionModel
{
    if (_questionModel != questionModel)
    {
        _questionModel = questionModel;
    }
    if (questionModel.stemTail.length == 0) {
        self.questionLabel.text = questionModel.issue;
    } else {
        self.questionLabel.attributedText = [ManagerTools getMutableAttributedStringWithContent:[NSString stringWithFormat:@"%@  （%@）",questionModel.issue,questionModel.stemTail] rangeStr:[NSString stringWithFormat:@"（%@）",questionModel.stemTail] color:MAIN_RGB_TEXT font:12.0];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
