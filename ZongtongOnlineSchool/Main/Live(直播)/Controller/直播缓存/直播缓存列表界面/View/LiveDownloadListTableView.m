//
//  LiveDownloadListTableView.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/12/28.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import "LiveDownloadListTableView.h"
#import "LiveModel.h"
#import "LiveCourseTableViewHeaderView.h"
#import "LiveDownloadListCell.h"

#import "ZFPlayer.h"
#import "ZFDownloadManager.h"

static NSString *cellID = @"cellID";
//static NSString *cellID_Header = @"cellID_Header";
@implementation LiveDownloadListTableView

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self)
    {
        self.delegate = self;
        self.dataSource = self;
        [self registerNib:[UINib nibWithNibName:@"LiveDownloadListCell" bundle:nil] forCellReuseIdentifier:cellID];
//        [self registerClass:[LiveCourseTableViewHeaderView class] forHeaderFooterViewReuseIdentifier:cellID_Header];
        self.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    return self;
}
#pragma mark - tableView协议方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataArray[section] count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LiveDownloadListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    ZFFileModel *fileModel = self.dataArray[indexPath.section][indexPath.row];
    cell.courseLabel.text = fileModel.lvTitle;
    cell.teacherLabel.text = fileModel.lvTeacher;
    cell.sizeLabel.text = [ZFCommonHelper getFileSizeString:fileModel.fileSize];
    
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
    ZFFileModel *fileInfo = self.dataArray[indexPath.section][indexPath.row];
    [[ZFDownloadManager sharedDownloadManager] deleteFinishFile:fileInfo];
    [self.dataArray[indexPath.section] removeObjectAtIndex:indexPath.row];
    [tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]] withRowAnimation:UITableViewRowAnimationBottom];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZFFileModel *fileModel = self.dataArray[indexPath.section][indexPath.row];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LiveDownloadListClicked" object:fileModel];
}

@end
