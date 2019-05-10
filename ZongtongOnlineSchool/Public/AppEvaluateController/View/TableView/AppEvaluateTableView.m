//
//  AppEvaluateTableView.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/1/24.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import "AppEvaluateTableView.h"
#import "Tools.h"
#import "AppEvaluateTitleCell.h"
#import "AppEvaluateOptionCell.h"
#import "AppEvaluateQQCell.h"
#import "AppEvaluateFeedbackCell.h"
#import "AppEvaluateContactCell.h"

@interface AppEvaluateTableView () <UITableViewDelegate, UITableViewDataSource>
{
    NSArray *_heightArray;
    NSArray *_optionScoreArray;
    NSArray *_optionArray;
}
@end

@implementation AppEvaluateTableView
static NSString *cellID_Title    = @"cellID_Title";
static NSString *cellID_Option   = @"cellID_Option";
static NSString *cellID_QQ       = @"cellID_QQ";
static NSString *cellID_Feedback = @"cellID_Feedback";
static NSString *cellID_Contact  = @"cellID_Contact";
- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self)
    {
        _heightArray = @[@"80", @"40", @"40", @"40", @"40", @"40", @"50", @"150", @"80"];
        _optionScoreArray = @[@"+10", @"+5", @"+1", @"-5", @"-10"];
        _optionArray = @[@"帮助很大，我乐意向朋友们推荐!", @"对考试有一定的帮助，我愿意继续使用", @"很一般，偶尔用用还行", @"体验很差，用下来感觉没什么帮助", @"很不满意，我要吐槽!"];
        self.delegate = self;
        self.dataSource = self;
        [self registerNib:[UINib nibWithNibName:@"AppEvaluateTitleCell" bundle:nil] forCellReuseIdentifier:cellID_Title];
        [self registerNib:[UINib nibWithNibName:@"AppEvaluateOptionCell" bundle:nil] forCellReuseIdentifier:cellID_Option];
        [self registerNib:[UINib nibWithNibName:@"AppEvaluateQQCell" bundle:nil] forCellReuseIdentifier:cellID_QQ];
        [self registerNib:[UINib nibWithNibName:@"AppEvaluateFeedbackCell" bundle:nil] forCellReuseIdentifier:cellID_Feedback];
        [self registerNib:[UINib nibWithNibName:@"AppEvaluateContactCell" bundle:nil] forCellReuseIdentifier:cellID_Contact];
        self.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    return self;
}
#pragma mark - tableView协议方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 9;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [_heightArray[indexPath.row] floatValue];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)  //标题
    {
        AppEvaluateTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID_Title forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if (indexPath.row > 0 && indexPath.row < 6)  //选项
    {
        AppEvaluateOptionCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID_Option forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.tag = indexPath.row;
        cell.scoreLabel.text = _optionScoreArray[indexPath.row - 1];
        cell.optionLabel.text = _optionArray[indexPath.row - 1];
        
        return cell;
    }
    else if (indexPath.row == 6)  //QQ交流群
    {
        AppEvaluateQQCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID_QQ forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if (indexPath.row == 7)  //意见反馈
    {
        AppEvaluateFeedbackCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID_Feedback forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else  //联系方式
    {
        AppEvaluateContactCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID_Contact forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row > 0 && indexPath.row < 6)
    {
        for (id obj in [tableView visibleCells]) {
            if ([obj isKindOfClass:[AppEvaluateOptionCell class]]) {
                AppEvaluateOptionCell *cell = (AppEvaluateOptionCell *)obj;
                if (cell.tag == indexPath.row) {
                    cell.isSelected = YES;
                    if ([self.tableViewDelegate respondsToSelector:@selector(updateAppEvaluateOptionWithScore:option:)])
                    {
                        [self.tableViewDelegate updateAppEvaluateOptionWithScore:_optionScoreArray[indexPath.row - 1] option:_optionArray[indexPath.row - 1]];
                    }
                } else {
                    cell.isSelected = NO;
                }
            }
        }
    }
}


@end
