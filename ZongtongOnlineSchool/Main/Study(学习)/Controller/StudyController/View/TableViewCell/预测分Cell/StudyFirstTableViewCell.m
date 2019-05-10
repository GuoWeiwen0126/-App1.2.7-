//
//  StudyFirstTableViewCell.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/11/29.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import "StudyFirstTableViewCell.h"
#import "Tools.h"

@interface StudyFirstTableViewCell () <OptionLabelViewDelegate>

@end

@implementation StudyFirstTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    NSMutableAttributedString *firstAttrStr = [ManagerTools getMutableAttributedStringWithContent:@"10\n您的分数" rangeStr:@"您的分数" color:[UIColor blackColor] font:16.0];
    NSMutableAttributedString *secondAttrStr = [ManagerTools getMutableAttributedStringWithContent:@"100\n题目总分" rangeStr:@"题目总分" color:[UIColor blackColor] font:16.0];
    
    OptionLabelView *optionView = [[OptionLabelView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height) optionArray:@[firstAttrStr, secondAttrStr] labelTextColor:MAIN_RGB labelFont:16.0f isAttr:YES lineSpace:30.0f enableTap:YES];
    optionView.optionViewDelegate = self;
    [self addSubview:optionView];
}
#pragma mark - OptionLabelView代理方法
- (void)optionViewLabelTapWithLabelTag:(NSInteger)labelTag
{
    NSLog(@"---%ld---",(long)labelTag);
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
