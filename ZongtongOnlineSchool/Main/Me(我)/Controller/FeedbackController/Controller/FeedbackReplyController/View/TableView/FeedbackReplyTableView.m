//
//  FeedbackReplyTableView.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/1/5.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import "FeedbackReplyTableView.h"
#import "Tools.h"
#import "QuestionModel.h"
#import "FeedbackModel.h"

#import "FbQTypeCell.h"
#import "FbQIssueCell.h"
#import "FbOptionCell.h"
#import "FbAnswerCell.h"
#import "FbAnalyseCell.h"

@interface FeedbackReplyTableView () <UITableViewDelegate, UITableViewDataSource>
@end

@implementation FeedbackReplyTableView
static NSString *cellID_QType    = @"cellID_QType";
static NSString *cellID_QIssue   = @"cellID_QIssue";
static NSString *cellID_Option   = @"cellID_Option";
static NSString *cellID_Answer   = @"cellID_Answer";
static NSString *cellID_Analyse  = @"cellID_Analyse";
- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self)
    {
        self.delegate = self;
        self.dataSource = self;
        [self registerNib:[UINib nibWithNibName:@"FbQTypeCell" bundle:nil] forCellReuseIdentifier:cellID_QType];
        [self registerNib:[UINib nibWithNibName:@"FbQIssueCell" bundle:nil] forCellReuseIdentifier:cellID_QIssue];
        [self registerNib:[UINib nibWithNibName:@"FbOptionCell" bundle:nil] forCellReuseIdentifier:cellID_Option];
        [self registerNib:[UINib nibWithNibName:@"FbAnswerCell" bundle:nil] forCellReuseIdentifier:cellID_Answer];
        [self registerNib:[UINib nibWithNibName:@"FbAnalyseCell" bundle:nil] forCellReuseIdentifier:cellID_Analyse];
        self.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    return self;
}
#pragma mark - tableView协议方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4 + self.qModel.optionList.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {  //类别Cell
        return 44.0f;
    } else if (indexPath.row == 1) {  //题干Cell
        if (self.qModel.stemTail.length == 0) {
            return [ManagerTools adaptHeightWithString:self.qModel.issue FontSize:14.0f SizeWidth:UI_SCREEN_WIDTH - 20*2] + 20;
        } else {
            return [ManagerTools adaptHeightWithString:[NSString stringWithFormat:@"%@  （%@）",self.qModel.issue,self.qModel.stemTail] FontSize:14.0f SizeWidth:UI_SCREEN_WIDTH - 20*2] + 20;
        }
    } else if (indexPath.row > 1 && indexPath.row < self.qModel.optionList.count + 2) {  //选项Cell
        return [ManagerTools adaptHeightWithString:[ManagerTools deleteSpaceAndNewLineWithString:self.qModel.optionList[indexPath.row - 2].option] FontSize:14.0f SizeWidth:UI_SCREEN_WIDTH - 70] + 20;
    } else if (indexPath.row == self.qModel.optionList.count + 2) {  //答案Cell
        return 70.0f;
    } else {  //解析Cell
        return [ManagerTools adaptHeightWithString:self.qModel.analysis FontSize:14.0f SizeWidth:UI_SCREEN_WIDTH - 110] + 25;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        FbQTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID_QType forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.qTypeLabel.text = self.qModel.qTypeListModel.showName;
        
        return cell;
    } else if (indexPath.row == 1) {
        FbQIssueCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID_QIssue forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (self.qModel.stemTail.length == 0) {
            cell.qIssueLabel.text = self.qModel.issue;
        } else {
            cell.qIssueLabel.attributedText = [ManagerTools getMutableAttributedStringWithContent:[NSString stringWithFormat:@"%@  （%@）",self.qModel.issue,self.qModel.stemTail] rangeStr:[NSString stringWithFormat:@"（%@）",self.qModel.stemTail] color:MAIN_RGB_TEXT font:12.0f];
        }
        
        return cell;
    }  else if (indexPath.row > 1 && indexPath.row < self.qModel.optionList.count + 2) {
        FbOptionCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID_Option forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.answer = self.qModel.answer;
        cell.qTypeShowKey = self.qModel.qTypeListModel.showKey;
        cell.optionModel = self.qModel.optionList[indexPath.row - 2];
        
        return cell;
    }  else if (indexPath.row == self.qModel.optionList.count + 2) {
        FbAnswerCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID_Answer forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.qModel = self.qModel;
        
        return cell;
    }  else {
        FbAnalyseCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID_Analyse forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.analyseLabel.text = self.qModel.analysis;
        
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
