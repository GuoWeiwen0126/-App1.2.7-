//
//  QuestionNoteTableView.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/1/5.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import "QuestionNoteTableView.h"
#import "Tools.h"
#import "QuestionModel.h"
#import "QuestionNoteCell.h"

@interface QuestionNoteTableView () <UITableViewDelegate, UITableViewDataSource>
@end

@implementation QuestionNoteTableView
static NSString *cellID = @"cellID";
- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self)
    {
        self.delegate = self;
        self.dataSource = self;
        [self registerNib:[UINib nibWithNibName:@"QuestionNoteCell" bundle:nil] forCellReuseIdentifier:cellID];
        self.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    return self;
}
#pragma mark - tableView协议方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.noteArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    QNoteModel *qNoteModel = self.noteArray[indexPath.row];
    return [ManagerTools adaptHeightWithString:qNoteModel.content FontSize:14.0 SizeWidth:UI_SCREEN_WIDTH - 20*2] + 40;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    QuestionNoteCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.qNoteModel = self.noteArray[indexPath.row];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.tableViewDelegate respondsToSelector:@selector(tableViewCellClickedWithIndex:)])
    {
        [self.tableViewDelegate tableViewCellClickedWithIndex:indexPath];
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
