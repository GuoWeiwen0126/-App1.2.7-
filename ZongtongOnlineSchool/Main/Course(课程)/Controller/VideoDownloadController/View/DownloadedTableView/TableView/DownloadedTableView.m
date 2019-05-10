//
//  DownloadedTableView.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/1/16.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import "DownloadedTableView.h"
#import "VideoDownloadedCell.h"
#import "ZFDownloadManager.h"

@interface DownloadedTableView () <UITableViewDelegate, UITableViewDataSource>
@end

@implementation DownloadedTableView
static NSString *cellID_Loaded  = @"cellID_Loaded";
- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self)
    {
        self.delegate = self;
        self.dataSource = self;
        [self registerNib:[UINib nibWithNibName:@"VideoDownloadedCell" bundle:nil] forCellReuseIdentifier:cellID_Loaded];
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
    return 70;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VideoDownloadedCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID_Loaded forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.fileInfo = self.dataArray[indexPath.row];
    
    return cell;
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZFFileModel *fileInfo = self.dataArray[indexPath.row];
    [[ZFDownloadManager sharedDownloadManager] deleteFinishFile:fileInfo];
    [self.dataArray removeObjectAtIndex:indexPath.row];
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationBottom];
}

@end
