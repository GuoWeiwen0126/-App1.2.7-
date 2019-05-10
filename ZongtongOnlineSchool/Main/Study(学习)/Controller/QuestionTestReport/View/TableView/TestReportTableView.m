//
//  TestReportTableView.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/12/20.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import "TestReportTableView.h"
#import "Tools.h"
#import "QuestionModel.h"
#import "TestReportScoreCell.h"
#import "TestReportTimeCell.h"
#import "TestReportNumberCell.h"
#import "QCardTableViewCell.h"

@interface TestReportTableView () <UITableViewDelegate, UITableViewDataSource>
{
    NSMutableArray *_dataArray;
    NSMutableArray *_detailArray;
    NSString *_submitTimeStr;
}
@property (nonatomic, strong) QExerinfoModel *qExerinfoModel;

@end
static NSString *cellID_Score  = @"cellID_Score";
static NSString *cellID_Time   = @"cellID_Time";
static NSString *cellID_Number = @"cellID_Number";
static NSString *cellID_QCard  = @"cellID_QCard";
@implementation TestReportTableView

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style qExerinfoModel:(QExerinfoModel *)qExerinfoModel dataArray:(NSMutableArray *)dataArray detailArray:(NSMutableArray *)detailArray submitTimeStr:(NSString *)submitTimeStr
{
    self = [super initWithFrame:frame style:style];
    if (self)
    {
        self.qExerinfoModel = qExerinfoModel;
        _dataArray = dataArray;
        _detailArray = detailArray;
        _submitTimeStr = submitTimeStr;
        self.delegate = self;
        self.dataSource = self;
        [self registerNib:[UINib nibWithNibName:@"TestReportScoreCell" bundle:nil]  forCellReuseIdentifier:cellID_Score];
        [self registerNib:[UINib nibWithNibName:@"TestReportTimeCell" bundle:nil]   forCellReuseIdentifier:cellID_Time];
        [self registerNib:[UINib nibWithNibName:@"TestReportNumberCell" bundle:nil] forCellReuseIdentifier:cellID_Number];
        [self registerClass:[QCardTableViewCell class] forCellReuseIdentifier:cellID_QCard];
        self.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.sectionFooterHeight = 0;
    }
    
    return self;
}

#pragma mark - tableView协议方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _detailArray.count + 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 3;
    }
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 120.0f;
        } else if (indexPath.row == 1) {
            return 80.0f;
        } else {
            return 60.0f;
        }
    }
    NSInteger rowNumber = SCREEN_FIT_WITH(6, 6, 6, 6, 8);
    NSInteger space = SCREEN_FIT_WITH(10, 12, 12, 12, 18);
    if ([_detailArray[indexPath.section - 1] count]%rowNumber == 0) {
        return ([_detailArray[indexPath.section - 1] count]/rowNumber) * (space*2+(UI_SCREEN_WIDTH - rowNumber*2*space)/rowNumber);
    } else {
        return ([_detailArray[indexPath.section - 1] count]/rowNumber + 1) * (space*2+(UI_SCREEN_WIDTH - rowNumber*2*space)/rowNumber);
    }
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"";
    }
    QuestionModel *qModel = _detailArray[section - 1][0];
    return qModel.qTypeListModel.title;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.0f;
    }
    return 30.0f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            TestReportScoreCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID_Score forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            NSLog(@"用户得分：***%f***",[self.qExerinfoModel.userScore floatValue]);
            cell.scoreLabel.text = [NSString stringWithFormat:@"%.1f",[self.qExerinfoModel.userScore floatValue]];
            
            return cell;
        }
        else if (indexPath.row == 1)
        {
            TestReportTimeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID_Time forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            NSInteger hour   = self.qExerinfoModel.useTime/3600;
            NSInteger minute = (self.qExerinfoModel.useTime%3600)/60;
            NSInteger second = self.qExerinfoModel.useTime%60;
            NSString *useTimeStr = [NSString stringWithFormat:@"%02ld:%02ld:%02ld\n答题用时",hour,minute,second];
            
            NSString *percentStr = @"";
            if (self.qExerinfoModel.mistakeNum == 0) {
                if (self.qExerinfoModel.rightNum == 0) {
                    percentStr = [NSString stringWithFormat:@"0%%\n正确率"];
                } else {
                    percentStr = [NSString stringWithFormat:@"100%%\n正确率"];
                }
            } else {
                percentStr = [NSString stringWithFormat:@"%.0f%%\n正确率",1.0*self.qExerinfoModel.rightNum/(self.qExerinfoModel.rightNum+self.qExerinfoModel.mistakeNum)*100];
            }
            
            [cell.optionView refreshLabelViewWithOptionArray:@[_submitTimeStr, useTimeStr, percentStr] isAttr:NO];
            
            return cell;
        }
        else
        {
            TestReportNumberCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID_Number forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.qNumLabel.text = [NSString stringWithFormat:@"%ld/%ld",self.qExerinfoModel.rightNum+self.qExerinfoModel.mistakeNum,_dataArray.count];
            
            return cell;
        }
    }
    else
    {
        QCardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID_QCard forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.isClicked = NO;
        [cell createCardButtonWithArray:_detailArray[indexPath.section - 1]];
        
        return cell;
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
