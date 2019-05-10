//
//  OtherNoteTableView.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/12/19.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import "OtherNoteTableView.h"
#import "Tools.h"
#import "OtherNoteModel.h"
#import "OtherNoteTableViewCell.h"

@interface OtherNoteTableView () <UITableViewDelegate, UITableViewDataSource>

@end
static NSString *cellID = @"cellID";
@implementation OtherNoteTableView

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style noteArray:(NSMutableArray *)noteArray
{
    self = [super initWithFrame:frame style:style];
    if (self)
    {
        self.noteArray = noteArray;
        self.delegate = self;
        self.dataSource = self;
        [self registerNib:[UINib nibWithNibName:@"OtherNoteTableViewCell" bundle:nil] forCellReuseIdentifier:cellID];
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
    OtherNoteModel *noteModel = self.noteArray[indexPath.row];
    return [ManagerTools adaptHeightWithString:noteModel.content FontSize:14.0f SizeWidth:UI_SCREEN_WIDTH - 115] + 70;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OtherNoteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.noteModel = self.noteArray[indexPath.row];
    
    return cell;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
