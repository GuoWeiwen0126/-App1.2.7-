//
//  MKExamListTableViewCell.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2019/3/15.
//  Copyright © 2019年 ZongTongEdu. All rights reserved.
//

#import "MKExamListTableViewCell.h"
#import "Tools.h"
#import "MKModel.h"

@implementation MKExamListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setBasicListModel:(EmkBasicListModel *)basicListModel {
    if (_basicListModel != basicListModel) {
        _basicListModel = basicListModel;
    }
    self.titleLabel.text = basicListModel.courserTitle;
    self.peopleNumLabel.text = [NSString stringWithFormat:@"%ld人已做",(long)basicListModel.pepeopleNum];
    self.examTimeLabel.text = [NSString stringWithFormat:@"总时长：%ld分钟",(long)basicListModel.examTime];
}
- (BOOL)checkMKExamIsSignUpWithEiid:(NSString *)eiid emkListModel:(EmkListModel *)emkListModel
{
    NSMutableArray *array = [NSMutableArray arrayWithContentsOfFile:GetFileFullPath(MKExamSignUpPlist)];
    for (NSString *str in array) {
        if ([str isEqualToString:[NSString stringWithFormat:@"%@-%ld-%ld",eiid,(long)emkListModel.emkid,(long)emkListModel.year]]) {
            return YES;
        }
    }
    return NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
