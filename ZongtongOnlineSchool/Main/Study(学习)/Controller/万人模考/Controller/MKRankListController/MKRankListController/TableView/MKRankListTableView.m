//
//  MKRankListTableView.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2019/3/15.
//  Copyright © 2019年 ZongTongEdu. All rights reserved.
//

#import "MKRankListTableView.h"
#import "MKRankListTableViewCell.h"
#import "MKModel.h"

@interface MKRankListTableView () <UITableViewDelegate, UITableViewDataSource>
{
    NSMutableArray *_dataArray;
}
@end
@implementation MKRankListTableView

static NSString *cellID = @"cellID";
- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style dataArray:(NSMutableArray *)dataArray
{
    self = [super initWithFrame:frame style:style];
    if (self)
    {
        _dataArray = dataArray;
        self.delegate = self;
        self.dataSource = self;
        [self registerNib:[UINib nibWithNibName:@"MKRankListTableViewCell" bundle:nil] forCellReuseIdentifier:cellID];
        self.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.bounces = NO;
    }
    
    return self;
}
#pragma mark - tableView协议方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MKRankModel *rankModel = _dataArray[indexPath.row];
    return 60 + rankModel.SingleList.count * 30;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MKRankListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.rankModel = _dataArray[indexPath.row];
    cell.rankLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row + 1];
    if (indexPath.row < 3) {
        cell.imgView.hidden = NO;
        cell.imgView.image = [UIImage imageNamed:@[@"mkrank01.png", @"mkrank02.png", @"mkrank03.png"][indexPath.row]];
    } else {
        cell.imgView.hidden = YES;
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
