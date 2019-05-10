//
//  FileDownTableView.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/9/5.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import "FileDownTableView.h"
#import "FileDownDetailCell.h"
#import "FileDownHistoryCell.h"

@interface FileDownTableView () <UITableViewDelegate, UITableViewDataSource>
@end

@implementation FileDownTableView
static NSString *cellID_Detail = @"cellID_Detail";
static NSString *cellID_History = @"cellID_History";
- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self)
    {
        self.delegate = self;
        self.dataSource = self;
        [self registerNib:[UINib nibWithNibName:@"FileDownDetailCell" bundle:nil] forCellReuseIdentifier:cellID_Detail];
        [self registerNib:[UINib nibWithNibName:@"FileDownHistoryCell" bundle:nil] forCellReuseIdentifier:cellID_History];
        self.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
//        self.separatorStyle = UITableViewCellSeparatorStyleNone;
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
    return 80.0f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isDetail) {
        FileDownDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID_Detail forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.fileCoinLogModel = self.dataArray[indexPath.row];
        
        return cell;
    } else {
        FileDownHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID_History forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.fileCoinHistoryModel = self.dataArray[indexPath.row];
        
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
