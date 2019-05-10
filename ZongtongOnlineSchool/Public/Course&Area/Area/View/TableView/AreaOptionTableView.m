//
//  AreaOptionTableView.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/11/24.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import "AreaOptionTableView.h"
#import "Tools.h"
#import "AreaOptionTableViewCell.h"

@implementation AreaOptionTableView
{
    NSString *_provinceStr;
    NSString *_cityStr;
}
static NSString *cellID = @"cellID";

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style areaArray:(NSArray *)areaArray isExamArea:(BOOL)isExamArea
{
    self = [super initWithFrame:frame style:style];
    if (self)
    {
        self.areaArray = areaArray;
        if (isExamArea) {
            _provinceStr = [USER_DEFAULTS objectForKey:User_province] ? [USER_DEFAULTS objectForKey:User_province]:@"";
            _cityStr = [USER_DEFAULTS objectForKey:User_city] ? [USER_DEFAULTS objectForKey:User_city]:@"";
        } else {
            _provinceStr = [USER_DEFAULTS objectForKey:User_Address_Province] ? [USER_DEFAULTS objectForKey:User_Address_Province]:@"";
            _cityStr = [USER_DEFAULTS objectForKey:User_Address_City] ? [USER_DEFAULTS objectForKey:User_Address_City]:@"";
        }
        self.delegate = self;
        self.dataSource = self;
        [self registerNib:[UINib nibWithNibName:@"AreaOptionTableViewCell" bundle:nil] forCellReuseIdentifier:cellID];
        self.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    }
    
    return self;
}

#pragma mark - tableView协议方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.areaArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AreaOptionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    
    if (self.areaType == ProvinceType)
    {
        cell.areaLabel.text = self.areaArray[indexPath.row][@"provinceName"];
        cell.isSelected = [_provinceStr isEqualToString:cell.areaLabel.text] == YES ? YES:NO;
    }
    else
    {
        cell.areaLabel.text = self.areaArray[indexPath.row][@"citysName"];
        cell.isSelected = [_cityStr isEqualToString:cell.areaLabel.text] == YES ? YES:NO;
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.areaType == ProvinceType)
    {
        _provinceStr = self.areaArray[indexPath.row][@"provinceName"];
        [tableView reloadData];
    }
    else
    {
        _cityStr = self.areaArray[indexPath.row][@"citysName"];
    }
    
    if ([self.areaOptionDelegate respondsToSelector:@selector(areaOptionClickedWithAreaType:index:provinceStr:cityStr:)])
    {
        [self.areaOptionDelegate areaOptionClickedWithAreaType:self.areaType index:indexPath.row provinceStr:_provinceStr cityStr:_cityStr];
    }
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

@end
