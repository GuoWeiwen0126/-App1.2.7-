//
//  DownloadingTableView.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/1/16.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import "DownloadingTableView.h"
#import "VideoDownloadingCell.h"
#import "ZFDownloadManager.h"

@interface DownloadingTableView () <UITableViewDelegate, UITableViewDataSource>
@end

@implementation DownloadingTableView
static NSString *cellID_Loading = @"cellID_Loading";
- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self)
    {
        self.delegate = self;
        self.dataSource = self;
        [self registerNib:[UINib nibWithNibName:@"VideoDownloadingCell" bundle:nil] forCellReuseIdentifier:cellID_Loading];
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
    VideoDownloadingCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID_Loading forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    ZFHttpRequest *request = self.dataArray[indexPath.row];
    if (request == nil)
    {
        return [[VideoDownloadingCell alloc] init];
    }
    ZFFileModel *fileInfo = [request.userInfo objectForKey:@"File"];
//    __weak typeof(self) weakSelf = self;
//    cell.downloadBtnClickBlock = ^{
//        [weakSelf initData];
//    };
    cell.fileInfo = fileInfo;
    cell.request = request;
    
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
    ZFHttpRequest *request = self.dataArray[indexPath.row];
    [[ZFDownloadManager sharedDownloadManager] deleteRequest:request];
    [self.dataArray removeObjectAtIndex:indexPath.row];
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationBottom];
}

@end
