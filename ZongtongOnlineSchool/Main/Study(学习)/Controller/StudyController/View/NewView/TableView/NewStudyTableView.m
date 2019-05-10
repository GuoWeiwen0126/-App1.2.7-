//
//  NewStudyTableView.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/11/20.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import "NewStudyTableView.h"
#import "Tools.h"
#import "HomeModel.h"
#import "NewStudyModuleTableViewCell.h"
#import "NewStudyVIPTableViewCell.h"

@interface NewStudyTableView () <UITableViewDelegate, UITableViewDataSource>
@end

@implementation NewStudyTableView

static NSString *cellID_Module = @"cellID_Module";
static NSString *cellID_VIP    = @"cellID_VIP";
- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self)
    {
        self.delegate = self;
        self.dataSource = self;
        [self registerNib:[UINib nibWithNibName:@"NewStudyModuleTableViewCell" bundle:nil] forCellReuseIdentifier:cellID_Module];
        [self registerNib:[UINib nibWithNibName:@"NewStudyVIPTableViewCell" bundle:nil] forCellReuseIdentifier:cellID_VIP];
        self.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    return self;
}
#pragma mark - tableView协议方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.mainType == QuestionType ? 1:self.vipArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.mainType == QuestionType) {
        return UI_SCREEN_WIDTH/2;
    } else {
        return 60;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.mainType == QuestionType) {
        NewStudyModuleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID_Module forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.collectionView.moduleDataArray = _moduleArray;
        [cell.collectionView reloadData];
        
        return cell;
    } else {
        NewStudyVIPTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID_VIP forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.moduleModel = self.vipArray[indexPath.row];
        
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.mainType == VIPStudent) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"BookBtnClicked" object:self.vipArray[indexPath.row]];
    }
}

@end
