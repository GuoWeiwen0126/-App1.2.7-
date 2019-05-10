//
//  UserSetTableView.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/11/27.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import "UserSetTableView.h"
#import "Macros.h"
#import "UserSetTableViewCell.h"
#import "UserSetLogoutTableViewCell.h"

@implementation UserSetTableView
{
    NSArray *_titleArray;
}

static NSString *cellID = @"cellID";
static NSString *cellID_Logout = @"cellID_Logout";

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self)
    {
        _titleArray = [NSArray arrayWithObjects:@[@"参加考试"], @[@"修改手机号"], @[@"清除缓存"], @[@"关于总统网校"], @[@""], nil];
        self.delegate = self;
        self.dataSource = self;
        [self registerNib:[UINib nibWithNibName:@"UserSetTableViewCell" bundle:nil] forCellReuseIdentifier:cellID];
        [self registerNib:[UINib nibWithNibName:@"UserSetLogoutTableViewCell" bundle:nil] forCellReuseIdentifier:cellID_Logout];
        self.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, CGFLOAT_MIN)];
        self.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        self.sectionFooterHeight = 0;
        self.bounces = NO;
    }
    
    return self;
}

#pragma mark - tableView协议方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _titleArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_titleArray[section] count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == _titleArray.count - 1)
    {
        UserSetLogoutTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID_Logout forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    else
    {
        UserSetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.titleLabel.text = _titleArray[indexPath.section][indexPath.row];
        if (indexPath.section == 0)
        {
            cell.detailLabel.hidden = NO;
            NSLog(@"报考地区：***%@***%@***",[USER_DEFAULTS objectForKey:User_province],[USER_DEFAULTS objectForKey:User_city]);
            cell.detailLabel.text = indexPath.row == 0 ? [USER_DEFAULTS objectForKey:COURSEIDNAME]:[NSString stringWithFormat:@"%@  %@",[USER_DEFAULTS objectForKey:User_province],[USER_DEFAULTS objectForKey:User_city]];
        }
        
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.userSetDelegate respondsToSelector:@selector(userSetTableViewRowsClickedWithIndexPath:)])
    {
        [self.userSetDelegate userSetTableViewRowsClickedWithIndexPath:indexPath];
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
