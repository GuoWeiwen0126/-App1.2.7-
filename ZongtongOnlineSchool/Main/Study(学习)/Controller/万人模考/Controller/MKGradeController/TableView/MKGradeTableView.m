//
//  MKGradeTableView.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2019/3/20.
//  Copyright © 2019年 ZongTongEdu. All rights reserved.
//

#import "MKGradeTableView.h"
#import "MKModel.h"
#import "MKGradeTableViewCell.h"

@interface MKGradeTableView () <UITableViewDelegate, UITableViewDataSource>
{
    NSString *_naviTitle;
}
@end

@implementation MKGradeTableView

static NSString *cellID = @"cellID";
- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style dataArray:(nonnull NSMutableArray *)dataArray naviTitle:(nonnull NSString *)naviTitle
{
    self = [super initWithFrame:frame style:style];
    if (self)
    {
        self.dataArray = dataArray;
        _naviTitle = naviTitle;
        self.delegate = self;
        self.dataSource = self;
        [self registerNib:[UINib nibWithNibName:@"MKGradeTableViewCell" bundle:nil] forCellReuseIdentifier:cellID];
        self.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    return self;
}
#pragma mark - tableView协议方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 200;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MKGradeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.naviTitle = _naviTitle;
    cell.userGradeModel = self.dataArray[indexPath.row];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
