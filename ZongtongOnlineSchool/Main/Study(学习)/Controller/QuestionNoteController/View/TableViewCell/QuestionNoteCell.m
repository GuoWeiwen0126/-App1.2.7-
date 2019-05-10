//
//  QuestionNoteCell.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/1/5.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import "QuestionNoteCell.h"
#import "QuestionModel.h"

@implementation QuestionNoteCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
#pragma mark - setter方法
- (void)setQNoteModel:(QNoteModel *)qNoteModel
{
    if (_qNoteModel != qNoteModel)
    {
        _qNoteModel = qNoteModel;
    }
    self.contentLabel.text = qNoteModel.content;
    self.insertTimeLabel.text = qNoteModel.insertTime;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
