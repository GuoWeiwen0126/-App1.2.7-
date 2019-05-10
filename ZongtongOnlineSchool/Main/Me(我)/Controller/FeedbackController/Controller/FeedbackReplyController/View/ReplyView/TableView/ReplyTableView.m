//
//  ReplyTableView.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/1/6.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import "ReplyTableView.h"
#import "Tools.h"
#import "FeedbackModel.h"

#import "ReplyHeaderView.h"
#import "ReplyLeftCell.h"
#import "ReplyRightCell.h"

@interface ReplyTableView () <UITableViewDelegate, UITableViewDataSource>
@end

@implementation ReplyTableView
static NSString *cellID_Evaluate = @"cellID_Evaluate";
static NSString *cellID_Left     = @"cellID_Left";
static NSString *cellID_Right    = @"cellID_Right";
- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self)
    {
        self.delegate = self;
        self.dataSource = self;
        [self registerNib:[UINib nibWithNibName:@"ReplyEvaluateCell" bundle:nil] forCellReuseIdentifier:cellID_Evaluate];
        [self registerNib:[UINib nibWithNibName:@"ReplyLeftCell" bundle:nil] forCellReuseIdentifier:cellID_Left];
        [self registerNib:[UINib nibWithNibName:@"ReplyRightCell" bundle:nil] forCellReuseIdentifier:cellID_Right];
        self.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.bounces = NO;
    }
    
    return self;
}
#pragma mark - tableView协议方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.headerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FeedbackReplyModel *fbReplyModel = self.dataArray[indexPath.row];
    return [ManagerTools adaptHeightWithString:fbReplyModel.content FontSize:14.0f SizeWidth:UI_SCREEN_WIDTH - 125] + 60;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FeedbackReplyModel *fbReplyModel = self.dataArray[indexPath.row];
    if (fbReplyModel.userType == 0)
    {
        ReplyLeftCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID_Left forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.fbReplyModel = fbReplyModel;
        
        return cell;
    }
    else
    {
        ReplyRightCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID_Right forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.fbReplyModel = fbReplyModel;
        
        return cell;
    }
}

#pragma mark - 懒加载
- (ReplyHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[ReplyHeaderView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 50)];
    }
    return _headerView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
