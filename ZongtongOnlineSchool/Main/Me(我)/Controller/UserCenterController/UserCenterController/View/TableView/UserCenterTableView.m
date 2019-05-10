//
//  UserCenterTableView.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/11/22.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import "UserCenterTableView.h"
#import "Tools.h"
#import "UserPortraitTableViewCell.h"
#import "UserNickNameTableViewCell.h"
#import "UserSexTableViewCell.h"
#import "UserGradeTableViewCell.h"
#import "UserOtherTableViewCell.h"

@implementation UserCenterTableView
{
    NSArray *_titleArray;
}
static NSString *cellID_Protrait = @"cellID_Protrait";
static NSString *cellID_NickName = @"cellID_NickName";
static NSString *cellID_Sex      = @"cellID_Sex";
static NSString *cellID_Grade    = @"cellID_Grade";
static NSString *cellID_Other    = @"cellID_Other";
- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self)
    {
        _titleArray = @[@[@"头像", @"昵称", @"性别"], @[@"经验等级", @"VIP等级"], @[@"修改密码"], @[@"邮寄地址"]];
        self.delegate = self;
        self.dataSource = self;
        [self registerNib:[UINib nibWithNibName:@"UserPortraitTableViewCell" bundle:nil] forCellReuseIdentifier:cellID_Protrait];
        [self registerNib:[UINib nibWithNibName:@"UserNickNameTableViewCell" bundle:nil] forCellReuseIdentifier:cellID_NickName];
        [self registerNib:[UINib nibWithNibName:@"UserSexTableViewCell" bundle:nil] forCellReuseIdentifier:cellID_Sex];
        [self registerNib:[UINib nibWithNibName:@"UserGradeTableViewCell" bundle:nil] forCellReuseIdentifier:cellID_Grade];
        [self registerNib:[UINib nibWithNibName:@"UserOtherTableViewCell" bundle:nil] forCellReuseIdentifier:cellID_Other];
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
    return 4;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_titleArray[section] count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.section == 0 && indexPath.row == 0 ? 60.0f:44.0f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            UserPortraitTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID_Protrait forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.titleLabel.text = _titleArray[indexPath.section][indexPath.row];
            [cell.portraitImgView sd_setImageWithURL:[NSURL URLWithString:[USER_DEFAULTS objectForKey:User_portrait]] placeholderImage:[UIImage imageNamed:@"portrait.png"]];
            
            return cell;
        }
        else if (indexPath.row == 1)
        {
            UserNickNameTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID_NickName forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.titleLabel.text = _titleArray[indexPath.section][indexPath.row];
            cell.nickNameLabel.text = [USER_DEFAULTS objectForKey:User_nickName];
            
            return cell;
        }
        else
        {
            UserSexTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID_Sex forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.titleLabel.text = _titleArray[indexPath.section][indexPath.row];
            if ([[USER_DEFAULTS objectForKey:User_sexType] integerValue] == 0)
            {
                cell.maleBtn.selected = YES;
                cell.femaleBtn.selected = NO;
            }
            else
            {
                cell.maleBtn.selected = NO;
                cell.femaleBtn.selected = YES;
            }
            
            return cell;
        }
    }
    else if (indexPath.section == 1)
    {
        UserGradeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID_Grade forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.titleLabel.text = _titleArray[indexPath.section][indexPath.row];
        cell.gradeLabel.text = [NSString stringWithFormat:@"等级 Lv%ld",[[USER_DEFAULTS objectForKey:User_grade] integerValue]];
        if (indexPath.row == 1)
        {
            cell.progressView.hidden = YES;
            cell.gradeLabel.hidden = YES;
//            cell.imgView.hidden = YES;
            cell.worthLabel.text = @"普通";
            cell.worthLabel.font = FontOfSize(12.0);
            cell.worthLabel.textColor = MAIN_RGB_TEXT;
        }
        cell.imgView.hidden = YES;
        
        return cell;
    }
    else
    {
        UserOtherTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID_Other forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.titleLabel.text = _titleArray[indexPath.section][indexPath.row];
        if (indexPath.section == 3)
        {
            cell.addressLabel.hidden = NO;
            cell.addressLabel.text = [NSString stringWithFormat:@"%@ %@ %@",[USER_DEFAULTS objectForKey:User_Address_Province],[USER_DEFAULTS objectForKey:User_Address_City],[USER_DEFAULTS objectForKey:User_Address_Address]];
        }
        
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.userCenterDelegate respondsToSelector:@selector(userCenterTableViewCellDidSelectWithIndexPath:)])
    {
        [self.userCenterDelegate userCenterTableViewCellDidSelectWithIndexPath:indexPath];
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


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
