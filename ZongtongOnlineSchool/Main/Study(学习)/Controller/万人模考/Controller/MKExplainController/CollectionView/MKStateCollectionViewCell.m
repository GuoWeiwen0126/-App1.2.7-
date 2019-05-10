//
//  MKStateCollectionViewCell.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2019/3/20.
//  Copyright © 2019年 ZongTongEdu. All rights reserved.
//

#import "MKStateCollectionViewCell.h"
#import "Tools.h"
#import "MKModel.h"

@implementation MKStateCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.imgViewWidth.constant = SCREEN_FIT_WITH(60, 70, 80, 80, 240);
    self.courseLabel.font = FontOfSize(SCREEN_FIT_WITH_DEVICE(14, 18));
}
#pragma mark - 点击考试
- (IBAction)examBtnClicked:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MKStateCollectionViewCellClicked" object:self.infoListModel];
}
- (void)setInfoListModel:(EmkInfoListModel *)infoListModel {
    if (_infoListModel != infoListModel) {
        _infoListModel = infoListModel;
    }
    self.courseLabel.text = infoListModel.courserTitle;
    [self.examBtn setTitle:infoListModel.isJoinedExam ? @"查看成绩":@"开始考试" forState:UIControlStateNormal];
}

@end
