//
//  QMistakeCollectTableView.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/12/22.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import "QMistakeCollectTableView.h"
#import "Tools.h"
#import "MistakeCollectQuestionCell.h"
#import "MistakeCollectOptionCell.h"
#import "QuestionModel.h"

@interface QMistakeCollectTableView () <UITableViewDelegate, UITableViewDataSource>

@end
static NSString *cellID_Question = @"cellID_Question";
static NSString *cellID_Option   = @"cellID_Option";
@implementation QMistakeCollectTableView

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self)
    {
        self.delegate = self;
        self.dataSource = self;
        [self registerNib:[UINib nibWithNibName:@"MistakeCollectQuestionCell" bundle:nil] forCellReuseIdentifier:cellID_Question];
        [self registerNib:[UINib nibWithNibName:@"MistakeCollectOptionCell" bundle:nil] forCellReuseIdentifier:cellID_Option];
        self.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 0.01)];
        self.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 0.01)];
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.sectionHeaderHeight = 0;
        self.sectionFooterHeight = 0;
    }
    
    return self;
}
#pragma mark - tableView协议方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    QuestionModel *qModel = self.dataArray[section];
    return 1 + qModel.optionList.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    QuestionModel *qModel = self.dataArray[indexPath.section];
    if (indexPath.row == 0) {
        return [ManagerTools adaptHeightWithString:[NSString stringWithFormat:@"%@  （%@）",qModel.issue,qModel.stemTail] FontSize:14.0f SizeWidth:UI_SCREEN_WIDTH - 20*2] + 20;
    } else {
        return [ManagerTools adaptHeightWithString:[ManagerTools deleteSpaceAndNewLineWithString:qModel.optionList[indexPath.row - 1].option] FontSize:14.0f SizeWidth:UI_SCREEN_WIDTH - 70] + 16;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        MistakeCollectQuestionCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID_Question forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.questionModel = self.dataArray[indexPath.section];
        
        return cell;
    }
    else
    {
        MistakeCollectOptionCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID_Option forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        QuestionModel *qModel = self.dataArray[indexPath.section];
        cell.uAnswer = qModel.userQModel ? qModel.userQModel.uAnswer:qModel.qExerinfoBasicModel.uAnswer;
        cell.answer = qModel.answer;
        QuestionOptionModel *optionModel = qModel.optionList[indexPath.row - 1];
        cell.qTypeShowKey = qModel.qTypeListModel.showKey;
        cell.optionModel = optionModel;
        
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.tableViewDelegate respondsToSelector:@selector(tableViewSectionClickedWithIndex:)])
    {
        [self.tableViewDelegate tableViewSectionClickedWithIndex:indexPath];
    }
}

@end
