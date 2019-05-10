//
//  StudyCourseTableView.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/12/6.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import "StudyCourseTableView.h"
#import "Tools.h"
#import "StudyCourseTableViewCell.h"

@interface StudyCourseTableView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray *courseIdArray;

@end

static NSString *cellID = @"cellID";
@implementation StudyCourseTableView

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style courseIdArray:(NSArray *)courseIdArray
{
    self = [super initWithFrame:frame style:style];
    if (self)
    {
        self.courseIdArray = courseIdArray;
        self.delegate = self;
        self.dataSource = self;
        [self registerNib:[UINib nibWithNibName:@"StudyCourseTableViewCell" bundle:nil] forCellReuseIdentifier:cellID];
        self.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    }
    
    return self;
}
#pragma mark - tableView协议方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.courseIdArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    StudyCourseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.courseNameLabel.text = _courseIdArray[indexPath.row][@"title"];
    if ([self.courseIdArray[indexPath.row][@"courseId"] integerValue] == [[USER_DEFAULTS objectForKey:COURSEID] integerValue])
    {
        cell.courseNameLabel.textColor = MAIN_RGB;
    }
    else
    {
        cell.courseNameLabel.textColor = MAIN_RGB_TEXT;
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = (NSDictionary *)self.courseIdArray[indexPath.row];
    if ([dic[@"courseId"] integerValue] == [[USER_DEFAULTS objectForKey:COURSEID] integerValue]) {
        return;
    }
    [USER_DEFAULTS setObject:dic[@"courseId"] forKey:COURSEID];
    [USER_DEFAULTS setObject:dic[@"title"] forKey:COURSEIDNAME];
    [USER_DEFAULTS synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"StudyVCChangeCourse" object:self.courseIdArray[indexPath.row]];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CourseVCChangeCourse" object:self.courseIdArray[indexPath.row]];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LiveVCChangeCourse" object:self.courseIdArray[indexPath.row]];
}

// 缺失15个像素分割线
-(void)viewDidLayoutSubviews
{
    if ([self respondsToSelector:@selector(setSeparatorInset:)])
    {
        [self setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self respondsToSelector:@selector(setLayoutMargins:)])
    {
        [self setLayoutMargins:UIEdgeInsetsZero];
    }
}
// 缺失分割线
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
    {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
    {
        [cell setLayoutMargins:UIEdgeInsetsZero];
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
