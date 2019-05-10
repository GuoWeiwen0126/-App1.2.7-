//
//  NoteCell.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/12/8.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import "NoteCell.h"

@implementation NoteCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.clipsToBounds = YES;
}
#pragma mark - 按钮点击方法（查看个人笔记、添加笔记、查看他人笔记）
- (IBAction)noteBtnClicked:(id)sender
{
    UIButton *temBtn = (UIButton *)sender;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NoteCellButtonClicked" object:[NSString stringWithFormat:@"%ld",(long)temBtn.tag]];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
