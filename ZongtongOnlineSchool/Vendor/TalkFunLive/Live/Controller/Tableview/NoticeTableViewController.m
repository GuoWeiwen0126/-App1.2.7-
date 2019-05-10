//
//  NoticeTableViewController.m
//  Talkfun_demo
//
//  Created by talk－fun on 16/1/26.
//  Copyright © 2016年 talk-fun. All rights reserved.
//

#import "NoticeTableViewController.h"
#import "TalkfunNoticeCell.h"

@interface NoticeTableViewController ()

@property (nonatomic,strong) NSDictionary * mess;

@end

@implementation NoticeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notice:) name:@"notice" object:nil];
    //TODO:公告
    self.timeLabel              = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, self.view.frame.size.width - 10, 30)];
//    [self.view addSubview:self.timeLabel];
    self.timeLabel.font         = [UIFont systemFontOfSize:13];
    self.timeLabel.textColor    = [UIColor whiteColor];

    self.gongGaoLabel           = [[UILabel alloc] initWithFrame:CGRectMake(5, 40, self.view.frame.size.width - 10, 30)];
//    [self.view addSubview:self.gongGaoLabel];
    self.gongGaoLabel.text      = @"公告:";
    self.gongGaoLabel.font      = [UIFont systemFontOfSize:13];
    self.gongGaoLabel.textColor = LIGHTBLUECOLOR;

    self.content                = [[UILabel alloc] initWithFrame:CGRectMake(5, 75, self.view.frame.size.width - 10, 30)];
    self.content.font           = [UIFont systemFontOfSize:13];
    self.content.textColor      = [UIColor whiteColor];
//    [self.view addSubview:self.content];
    
}

//==================监听notice回来的数据处理======================
- (void)notice:(NSNotification *)notification
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"noticeMessageCome" object:nil];
    NSDictionary * params = notification.userInfo;
    self.mess = params[@"mess"];
    NSString * time       = params[@"mess"][@"time"];
    NSString * content    = params[@"mess"][@"content"];
    self.timeLabel.text   = time;
    if (params[@"mess"][@"content"] == [NSNull null]) {
        self.content.text = @"";
        return;
    }
    NSArray * contentArr       = [content componentsSeparatedByString:@"\n"];
    NSString * newContent      = [contentArr componentsJoinedByString:@" "];

    CGRect rect                = [newContent boundingRectWithSize:CGSizeMake(self.view.frame.size.width - 10, 9999) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
    self.content.numberOfLines = 0;
    self.content.frame         = CGRectMake(5, 75, rect.size.width, rect.size.height);
    self.content.text          = newContent;
    
//    self.tableView.rowHeight = CGRectGetMaxY(self.content.frame);
    [self.tableView reloadData];
}

- (void)recalculateCellHeight
{
    NSString * string        = self.content.text;
    CGRect rect              = [string boundingRectWithSize:CGSizeMake(self.view.frame.size.width - 10, 9999) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];

    self.content.frame       = CGRectMake(5, 75, rect.size.width, rect.size.height);

    self.tableView.rowHeight = CGRectGetMaxY(self.content.frame);
}

#pragma mark - tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TalkfunNoticeCell * cell = [tableView dequeueReusableCellWithIdentifier:@"noticeCell"];
//    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"TalkfunNoticeCell" owner:nil options:nil][0];
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = DARKBLUECOLOR;
    
    NSString * time       = self.mess[@"time"];
    NSString * content    = self.mess[@"content"];
    NSString * notice = @"公告: ";
    cell.time.text        = time;
    NSString * finalStr = nil;
    if (self.mess[@"content"] == [NSNull null]) {
//        cell.contentTextView.text = notice;
        finalStr = notice;
    }else{
        NSArray * contentArr       = [content componentsSeparatedByString:@"\n"];
        NSString * newContent      = [contentArr componentsJoinedByString:@" "];
        finalStr = newContent?[NSString stringWithFormat:@"%@%@",notice,newContent]:notice;
    }
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineSpacing:4];
    NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc] initWithString:finalStr attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSParagraphStyleAttributeName:style}];
    [attrStr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGBHex(0xff9000) range:NSMakeRange(0, notice.length)];
    cell.contentTextView.attributedText = attrStr;
//    [cell.contentView addSubview:self.timeLabel];
//    [cell.contentView addSubview:self.gongGaoLabel];
//    [cell.contentView addSubview:self.content];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString * time       = self.mess[@"time"];
    NSString * content    = self.mess[@"content"];
    self.timeLabel.text   = time;
    if (!self.mess||self.mess[@"content"] == [NSNull null]) {
        return 81.0;
    }
    NSString * notice = @"公告: ";
    NSArray * contentArr       = [content componentsSeparatedByString:@"\n"];
    NSString * newContent      = [contentArr componentsJoinedByString:@" "];
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineSpacing:4];
    CGRect rect                = [newContent?[newContent stringByAppendingString:notice]:notice boundingRectWithSize:CGSizeMake(self.view.frame.size.width - 40, 9999) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSParagraphStyleAttributeName:style} context:nil];
    
    return rect.size.height+65;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
