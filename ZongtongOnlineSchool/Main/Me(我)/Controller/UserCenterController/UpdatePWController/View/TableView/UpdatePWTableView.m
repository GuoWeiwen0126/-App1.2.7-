//
//  UpdatePWTableView.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/11/23.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import "UpdatePWTableView.h"
#import "Macros.h"

@implementation UpdatePWTableView
{
    NSArray *_titleArray;
}
static NSString *cellID = @"cellID";

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self)
    {
        _titleArray = @[@"账户名", @"原密码", @"新密码", @"确认密码"];
        self.delegate = self;
        self.dataSource = self;
        [self registerNib:[UINib nibWithNibName:@"UpdatePWTableViewCell" bundle:nil] forCellReuseIdentifier:cellID];
        self.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    return self;
}

#pragma mark - tableView协议方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _titleArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        self.cell_Phone = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
        self.cell_Phone.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.cell_Phone.titleLabel.text = _titleArray[indexPath.row];
        self.cell_Phone.textField.text = [USER_DEFAULTS objectForKey:User_phone];
        self.cell_Phone.textField.enabled = NO;
        self.cell_Phone.textField.secureTextEntry = NO;
        
        return self.cell_Phone;
    }
    else if (indexPath.row == 1)
    {
        self.cell_oldPW = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
        self.cell_oldPW.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.cell_oldPW.titleLabel.text = _titleArray[indexPath.row];
        
        return self.cell_oldPW;
    }
    else if (indexPath.row == 2)
    {
        self.cell_newPW = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
        self.cell_newPW.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.cell_newPW.titleLabel.text = _titleArray[indexPath.row];
        
        return self.cell_newPW;
    }
    else
    {
        self.cell_confirmPW = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
        self.cell_confirmPW.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.cell_confirmPW.titleLabel.text = _titleArray[indexPath.row];
        
        return self.cell_confirmPW;
    }
}

@end
