//
//  FileOptionTableView.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/8/21.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import "FileOptionTableView.h"
#import "Tools.h"
#import "FileOptionTableViewCell.h"

@interface FileOptionTableView () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation FileOptionTableView
static NSString *cellID = @"cellID";
- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self)
    {
        self.delegate = self;
        self.dataSource = self;
        [self registerNib:[UINib nibWithNibName:@"FileOptionTableViewCell" bundle:nil] forCellReuseIdentifier:cellID];
        self.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    return self;
}
#pragma mark - tableView协议方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.array.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FileOptionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (self.isleft) {
        cell.titleLabel.text = _array[indexPath.row];
        cell.isSelected = self.leftIndex == indexPath.row ? YES:NO;
    } else {
        NSDictionary *dic = _array[indexPath.row];
        cell.titleLabel.text = dic[@"title"];
        cell.isSelected = self.rightIndex == indexPath.row ? YES:NO;
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isleft) {
        if (self.leftIndex == indexPath.row) {
            return;
        }
    } else {
        if (self.rightIndex == indexPath.row) {
            return;
        }
    }
    if ([self.fileOptionDelegate respondsToSelector:@selector(fileOptionTableViewClickedWithIndex:isleft:)]) {
        [self.fileOptionDelegate fileOptionTableViewClickedWithIndex:indexPath.row isleft:self.isleft];
    }
}

@end
