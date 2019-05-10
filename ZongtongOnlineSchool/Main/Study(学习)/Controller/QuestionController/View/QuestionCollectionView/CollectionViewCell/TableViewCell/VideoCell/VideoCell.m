//
//  VideoCell.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/12/8.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import "VideoCell.h"

@implementation VideoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.clipsToBounds = YES;
}
#pragma mark - 试题视频按钮点击
- (IBAction)videoBtnClicked:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"VideoCellVideoBtnClicked" object:nil];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
