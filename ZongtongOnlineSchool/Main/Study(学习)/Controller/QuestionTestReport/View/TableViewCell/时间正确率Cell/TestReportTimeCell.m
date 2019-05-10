//
//  TestReportTimeCell.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/12/20.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import "TestReportTimeCell.h"
#import "Tools.h"

@implementation TestReportTimeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.optionView = [[OptionLabelView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height - 1) optionArray:@[@"", @"", @""] labelTextColor:[UIColor blackColor] labelFont:14.0f isAttr:NO lineSpace:0.0f enableTap:NO];
    [self addSubview:self.optionView];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.optionView.bottom, UI_SCREEN_WIDTH, 1)];
    lineView.backgroundColor = MAIN_RGB_LINE;
    [self addSubview:lineView];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
