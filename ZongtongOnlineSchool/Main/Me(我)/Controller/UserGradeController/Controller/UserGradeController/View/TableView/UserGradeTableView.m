//
//  UserGradeTableView.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/12/10.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import "UserGradeTableView.h"
#import "Tools.h"
#import "UserGradeCell.h"
#import "UserGradeManager.h"

@interface UserGradeTableView () <UITableViewDelegate, UITableViewDataSource>
{
    NSArray *_titleArray;
    NSArray *_imgArray;
    NSArray *_numArray;
}
@end

@implementation UserGradeTableView
static NSString *cellID = @"cellID";
- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self)
    {
        _titleArray = @[@[@"分享到朋友圈", @"分享到微信群", @"分享到QQ空间", @"分享到QQ群"], @[@"集人气"]];
        _imgArray = @[@[@"usergradepengyouquan.png", @"usergradeweixin.png", @"usergradeQQ.png", @"usergradeQQgroup.png"], @[@"usergradejirenqi.png"]];
        _numArray = @[@[@"+10", @"+10", @"+10", @"+10"], @[@"+5"]];
        self.delegate = self;
        self.dataSource = self;
        [self registerNib:[UINib nibWithNibName:@"UserGradeCell" bundle:nil] forCellReuseIdentifier:cellID];
        self.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
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
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @[@"日常任务", @"推荐任务"][section];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UserGradeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.titleLabel.text = _titleArray[indexPath.section][indexPath.row];
    cell.imgView.image = [UIImage imageNamed:_imgArray[indexPath.section][indexPath.row]];
    if (indexPath.section == 0) {
        cell.numLabel.text = [self isCompletedWithIndex:indexPath.row] ? @"完成":_numArray[indexPath.section][indexPath.row];
    } else {
        cell.numLabel.text = _numArray[indexPath.section][indexPath.row];
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UserGradeTableViewClicked" object:indexPath];
}
- (BOOL)isCompletedWithIndex:(NSInteger)index
{
    NSTimeInterval oneDay = 24 * 60 * 60;
    if (![USER_DEFAULTS objectForKey:UserGradeShareArray[index]]) {
        [USER_DEFAULTS setObject:@"0" forKey:UserGradeShareArray[index]];
        [USER_DEFAULTS synchronize];
    }
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[[USER_DEFAULTS objectForKey:UserGradeShareArray[index]] integerValue]];
    NSDate *oldDate = [date dateByAddingTimeInterval:oneDay];
    
    NSDate *nowDate = [NSDate date];
    
    NSComparisonResult result = [oldDate compare:nowDate];
    if (result == NSOrderedAscending) {
        NSLog(@"两个日期升序");
        return NO;
    } else if (result == NSOrderedDescending) {
        NSLog(@"两个日期降序");
        return YES;
    } else  {
        NSLog(@"两个日期相同");
        return NO;
    }
}

@end
