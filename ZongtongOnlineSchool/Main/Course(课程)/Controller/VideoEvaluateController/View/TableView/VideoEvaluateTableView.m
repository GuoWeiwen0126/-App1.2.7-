//
//  VideoEvaluateTableView.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/1/1.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import "VideoEvaluateTableView.h"
#import "Tools.h"
#import "VideoEvaluateHeaderView.h"
#import "VideoEvaluateStarCell.h"
#import "VideoEvaluateContentCell.h"
#import "VideoEvaluateSubmitCell.h"

@interface VideoEvaluateTableView () <UITableViewDelegate, UITableViewDataSource>
{
    NSMutableArray *_expandArray;
    NSMutableArray *_starGradeArray;
}
@property (nonatomic, strong) VideoEvaluateContentCell *contentCell;
@end
static NSString *cellID_Header  = @"cellID_Header";
static NSString *cellID_Star    = @"cellID_Star";
static NSString *cellID_Content = @"cellID_Content";
static NSString *cellID_Submit  = @"cellID_Submit";
@implementation VideoEvaluateTableView

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self)
    {
        _expandArray = [NSMutableArray arrayWithObjects:@"0", @"0", @"0", nil];
        _starGradeArray = [NSMutableArray arrayWithObjects:@"5",@"5",@"5", nil];
        self.delegate = self;
        self.dataSource = self;
        [self registerNib:[UINib nibWithNibName:@"VideoEvaluateStarCell" bundle:nil] forCellReuseIdentifier:cellID_Star];
        [self registerNib:[UINib nibWithNibName:@"VideoEvaluateContentCell" bundle:nil] forCellReuseIdentifier:cellID_Content];
        [self registerNib:[UINib nibWithNibName:@"VideoEvaluateSubmitCell" bundle:nil] forCellReuseIdentifier:cellID_Submit];
        self.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    return self;
}
#pragma mark - tableView协议方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.isQVideoType == YES) {
        return 1;
    }
    return _expandArray.count + 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.isQVideoType == YES) {
        return 2;
    }
    if (section < _expandArray.count) {
        return [_expandArray[section] integerValue] == 1 ? 1:0;
    } else {
        return 1;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (self.isQVideoType == YES) {
        return nil;
    }
    if (section < _expandArray.count) {
        VideoEvaluateHeaderView *headerView = [[VideoEvaluateHeaderView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 50) section:section gradeArray:_starGradeArray];
        headerView.gradeCallBack = ^(NSInteger grade) {
            _starGradeArray[section] = [NSString stringWithFormat:@"%ld",(long)grade];
            [tableView reloadData];
        };
        headerView.expandCallBack = ^(BOOL isExpand) {
            for (int i = 0; i < _expandArray.count; i ++)
            {
                _expandArray[i] = i == section ? ([_expandArray[i] integerValue] == 1 ? @"0":@"1"):@"0";
            }
            [tableView reloadData];
        };
        return headerView;
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.isQVideoType == YES) {
        return 0;
    }
    if (section < _expandArray.count) {
        return 50;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isQVideoType == YES) {
        return [@[@"180", @"80"][indexPath.row] floatValue];
    }
    return [@[@"60", @"90", @"60", @"180", @"80"][indexPath.section] floatValue];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isQVideoType == YES) {
        if (indexPath.row == 0) {
            self.contentCell = [tableView dequeueReusableCellWithIdentifier:cellID_Content forIndexPath:indexPath];
            self.contentCell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            self.contentCell.contentTextView.text = self.contentStr;
            
            return self.contentCell;
        } else {
            VideoEvaluateSubmitCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID_Submit forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.submitBtn addTarget:self action:@selector(submitBtnClicked) forControlEvents:UIControlEventTouchUpInside];
            
            return cell;
        }
    } else {
        if (indexPath.section < _expandArray.count) {
            VideoEvaluateStarCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID_Star forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            [cell createDetailLabelWithSection:indexPath.section];
            
            return cell;
        } else if (indexPath.section == 3) {
            self.contentCell = [tableView dequeueReusableCellWithIdentifier:cellID_Content forIndexPath:indexPath];
            self.contentCell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            self.contentCell.contentTextView.text = self.contentStr;
            
            return self.contentCell;
        } else {
            VideoEvaluateSubmitCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID_Submit forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.submitBtn addTarget:self action:@selector(submitBtnClicked) forControlEvents:UIControlEventTouchUpInside];
            
            return cell;
        }
    }
}
#pragma mark - 提交按钮代理方法
- (void)submitBtnClicked
{
    if ([self.tableViewDelegate respondsToSelector:@selector(videoEvaluateSubmitWithContent:gradeArray:isQVideoType:)]) {
        [self.tableViewDelegate videoEvaluateSubmitWithContent:self.contentCell.contentTextView.text gradeArray:_starGradeArray isQVideoType:self.isQVideoType];
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
