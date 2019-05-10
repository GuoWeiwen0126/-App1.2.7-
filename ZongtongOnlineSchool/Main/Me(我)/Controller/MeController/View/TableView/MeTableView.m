//
//  MeTableView.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/11/21.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import "MeTableView.h"
#import "Macros.h"
#import "MeTableViewHeaderCell.h"
#import "MeTableViewContentCell.h"

@implementation MeTableView

static NSString *cell_Header_ID  = @"cell_Header_ID";
static NSString *cell_Content_ID = @"cell_Content_ID";

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self)
    {
        if (AfterReview) {
            _titleArray = [NSArray arrayWithObjects:
                           @[@""],
                           @[
                             @{@"image":@"kaitongkecheng",  @"title":@"已开通课程"},
                             @{@"image":@"jifenhuoqu",@"title":@"积分获取"},
                             @{@"image":@"wentifankui.png", @"title":@"问题反馈"},
                             @{@"image":@"xiazaiguanli.png",@"title":@"课程下载管理"},
                             @{@"image":@"zhiboxiazaiguanli.png",@"title":@"直播下载管理"}
                             ],
                           @[
                             @{@"image":@"tongzhi.png",   @"title":@"通知"},
                             @{@"image":@"dingdan.png",   @"title":@"订单"},
                             @{@"image":@"qianbao.png",   @"title":@"钱包"}
//                             @{@"image":@"youhuijuan.png",@"title":@"优惠券"},
//                             @{@"image":@"jihuoma.png",   @"title":@"激活码"}
                             ],
                           @[
                             @{@"image":@"lianxikefu.png",@"title":@"联系客服"},
                             @{@"image":@"grzxshezhi.png",@"title":@"设置"}
                             ], nil];
        } else {
            _titleArray = [NSArray arrayWithObjects:
                           @[@""],
                           @[
                             @{@"image":@"kaitongkecheng",  @"title":@"已开通课程"},
                             @{@"image":@"jifenhuoqu",@"title":@"积分获取"},
                             @{@"image":@"wentifankui.png", @"title":@"问题反馈"},
                             @{@"image":@"xiazaiguanli.png",@"title":@"课程下载管理"},
                             @{@"image":@"zhiboxiazaiguanli.png",@"title":@"直播下载管理"}
                             ],
                           @[
                             @{@"image":@"tongzhi.png",   @"title":@"通知"},
                             @{@"image":@"dingdan.png",   @"title":@"订单"},
                             @{@"image":@"qianbao.png",   @"title":@"钱包"},
                             ],
                           @[
                             @{@"image":@"lianxikefu.png",@"title":@"联系客服"},
                             @{@"image":@"grzxshezhi.png",@"title":@"设置"}
                             ], nil];
        }
        
        self.delegate = self;
        self.dataSource = self;
        [self registerNib:[UINib nibWithNibName:@"MeTableViewHeaderCell" bundle:nil] forCellReuseIdentifier:cell_Header_ID];
        [self registerNib:[UINib nibWithNibName:@"MeTableViewContentCell" bundle:nil] forCellReuseIdentifier:cell_Content_ID];
        self.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        self.sectionHeaderHeight = 0;
        self.sectionFooterHeight = 0;
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
    return section == 0 ? 1:[_titleArray[section] count];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, CGFLOAT_MIN)];
    return headerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return CGFLOAT_MIN;
    }
    return 12.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.section == 0 ? 190.f:60.0f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        MeTableViewHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:cell_Header_ID forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    else
    {
        MeTableViewContentCell *cell = [tableView dequeueReusableCellWithIdentifier:cell_Content_ID forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.dataDic = _titleArray[indexPath.section][indexPath.row];
        
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.meTableViewDelegate respondsToSelector:@selector(meTableViewRowsClickedWithIndexPath:)])
    {
        [self.meTableViewDelegate meTableViewRowsClickedWithIndexPath:indexPath];
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
