//
//  QCardTableView.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/12/12.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import "QCardTableView.h"
#import "Tools.h"
#import "QuestionModel.h"
#import "QCardTableViewCell.h"

@interface QCardTableView () <UITableViewDelegate, UITableViewDataSource>
{
    NSMutableArray *_qCardArray;
}
@end
static NSString *cellID = @"cellID";
@implementation QCardTableView

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style qCardArray:(NSMutableArray *)qCardArray
{
    self = [super initWithFrame:frame style:style];
    if (self)
    {
        _qCardArray = qCardArray;
        self.delegate = self;
        self.dataSource = self;
        [self registerClass:[QCardTableViewCell class] forCellReuseIdentifier:cellID];
        self.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        self.sectionFooterHeight = 0;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    return self;
}

#pragma mark - tableView协议方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _qCardArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger rowNumber = SCREEN_FIT_WITH(6, 6, 6, 6, 8);
    NSInteger space = SCREEN_FIT_WITH(10, 12, 12, 12, 18);
    if ([_qCardArray[indexPath.section] count]%rowNumber == 0) {
        return ([_qCardArray[indexPath.section] count]/rowNumber) * (space*2+(UI_SCREEN_WIDTH - rowNumber*2*space)/rowNumber);
    } else {
        return ([_qCardArray[indexPath.section] count]/rowNumber + 1) * (space*2+(UI_SCREEN_WIDTH - rowNumber*2*space)/rowNumber);
    }
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    QuestionModel *qModel = _qCardArray[section][0];
    return qModel.qTypeListModel.title;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40.0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    QCardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.isClicked = YES;
    [cell createCardButtonWithArray:_qCardArray[indexPath.section]];
    
    return cell;
}

@end
