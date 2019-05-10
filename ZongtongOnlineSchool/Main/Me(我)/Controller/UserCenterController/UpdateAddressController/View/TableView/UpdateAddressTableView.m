//
//  UpdateAddressTableView.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/11/23.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import "UpdateAddressTableView.h"
#import "Tools.h"
#import "UpdateAddressTableViewCell.h"
#import "UpdateAddressAreaTableViewCell.h"
#import "UpdateAddressDetailTableViewCell.h"
#import "UpdateAddressOtherTableViewCell.h"

@implementation UpdateAddressTableView
{
    NSArray *_titleArray;
}

static NSString *cellID        = @"cellID";
static NSString *cellID_Area   = @"cellID_Area";
static NSString *cellID_Detail = @"cellID_Detail";
static NSString *cellID_Other  = @"cellID_Other";

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self)
    {
        _titleArray = @[@[@"收件人", @"手机号码"], @[@"所在地区", @"详细地址"], @[@""]];
        self.areaStr = [NSString stringWithFormat:@"%@ %@",[USER_DEFAULTS objectForKey:User_Address_Province] ? [USER_DEFAULTS objectForKey:User_Address_Province]:@"",[USER_DEFAULTS objectForKey:User_Address_City] ? [USER_DEFAULTS objectForKey:User_Address_City]:@""];
        
        self.delegate = self;
        self.dataSource = self;
        [self registerNib:[UINib nibWithNibName:@"UpdateAddressTableViewCell" bundle:nil] forCellReuseIdentifier:cellID];
        [self registerNib:[UINib nibWithNibName:@"UpdateAddressAreaTableViewCell" bundle:nil] forCellReuseIdentifier:cellID_Area];
        [self registerNib:[UINib nibWithNibName:@"UpdateAddressDetailTableViewCell" bundle:nil] forCellReuseIdentifier:cellID_Detail];
        [self registerNib:[UINib nibWithNibName:@"UpdateAddressOtherTableViewCell" bundle:nil] forCellReuseIdentifier:cellID_Other];
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
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 12.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1 && indexPath.row == 1)
    {
        tableView.estimatedRowHeight = 50.0f;
        return UITableViewAutomaticDimension;
    }
    return 50.0f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        UpdateAddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.titleLabel.text = _titleArray[indexPath.section][indexPath.row];
        if (indexPath.row == 0)
        {
            [cell.detailTF addTarget:self action:@selector(detailTFTextDidChange:) forControlEvents:UIControlEventEditingChanged];
            if (![USER_DEFAULTS objectForKey:User_Address_Name])
            {
                cell.detailTF.placeholder = @"填写收件人";
            }
            else
            {
                cell.detailTF.text = [USER_DEFAULTS objectForKey:User_Address_Name];
            }
        }
        else
        {
            cell.detailTF.enabled = NO;
            if (![USER_DEFAULTS objectForKey:User_phone])
            {
                cell.detailTF.placeholder = @"填写联系电话";
            }
            else
            {
                cell.detailTF.text = [USER_DEFAULTS objectForKey:User_phone];
            }
        }
        
        return cell;
    }
    else if (indexPath.section == 1)
    {
        if (indexPath.row == 0)
        {
            UpdateAddressAreaTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID_Area forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.titleLabel.text = _titleArray[indexPath.section][indexPath.row];
            cell.areaLabel.text = self.areaStr;
            
            return cell;
        }
        else
        {
            UpdateAddressDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID_Detail forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.titleLabel.text = _titleArray[indexPath.section][indexPath.row];
            cell.updateRowHeightBlock = ^(NSString *addressStr) {
                [tableView beginUpdates];
                [tableView endUpdates];
                self.addressStr = addressStr;
            };
            if (![USER_DEFAULTS objectForKey:User_Address_Address])
            {
                cell.detailTextView.text = @"";
            }
            else
            {
                cell.detailTextView.text = [USER_DEFAULTS objectForKey:User_Address_Address];
            }
            
            return cell;
        }
    }
    else
    {
        UpdateAddressOtherTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID_Other forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1 && indexPath.row == 0)
    {
        if ([self.updateAddressDelegate respondsToSelector:@selector(updateAddressChangeArea)])
        {
            [self.updateAddressDelegate updateAddressChangeArea];
        }
    }
}
#pragma mark - textView方法
- (void)detailTFTextDidChange:(UITextField *)textField
{
    self.nameStr = textField.text;
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
