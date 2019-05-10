//
//  MKExamListHeaderView.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2019/3/23.
//  Copyright © 2019年 ZongTongEdu. All rights reserved.
//

#import "MKExamListHeaderView.h"
#import "Tools.h"
#import "MKModel.h"

@implementation MKExamListHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    self = [[NSBundle mainBundle] loadNibNamed:@"MKExamListHeaderView" owner:self options:nil].lastObject;
    if (self)
    {
        self.frame = frame;
    }
    
    return self;
}

- (IBAction)MKExamListTableViewTopBtnClicked:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MKExamListTableViewTopBtnClicked" object:self.emkListModel];
}
#pragma mark - 点击开始考试
- (IBAction)examBtnClicked:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MKExamListExamBtnClicked" object:self.emkListModel];
}
- (void)setEmkListModel:(EmkListModel *)emkListModel {
    if (_emkListModel != emkListModel) {
        _emkListModel = emkListModel;
    }
    self.imgView.image = [UIImage imageNamed:emkListModel.isOpen ? @"jianhao.png":@"jiahao.png"];
    self.titleLabel.text = emkListModel.title;
    self.timeLabel.text = [NSString stringWithFormat:@"开考时间:%@",emkListModel.stime];
    //    NSLog(@"开考时间：%@------结束时间：%@------结果：%ld",emkListModel.stime,emkListModel.etime,(long)[ManagerTools timestampJudgeWithStarttime:emkListModel.stime endTime:emkListModel.etime]);
    
    if ([ManagerTools timestampJudgeWithStarttime:emkListModel.stime endTime:emkListModel.etime] == 1 || [ManagerTools timestampJudgeWithStarttime:emkListModel.stime endTime:emkListModel.etime] == 2) {
        [self.examBtn setTitle:@"开始考试" forState:UIControlStateNormal];
    } else {
        if ([self checkMKExamIsSignUpWithEiid:[USER_DEFAULTS objectForKey:EIID] emkListModel:emkListModel]) {
            [self.examBtn setTitle:@"已报名" forState:UIControlStateNormal];
        } else {
            [self.examBtn setTitle:@"立即报名" forState:UIControlStateNormal];
        }
    }
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

@end
