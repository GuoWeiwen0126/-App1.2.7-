//
//  StudyCourseView.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/12/6.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import "StudyCourseView.h"
#import "Tools.h"

@implementation StudyCourseView

- (instancetype)initWithFrame:(CGRect)frame courseIdArray:(NSArray *)courseIdArray
{
    if (self = [super initWithFrame:frame])
    {
        self.clipsToBounds = YES;
        
        self.courseTableView = [[StudyCourseTableView alloc] initWithFrame:CGRectMake(0, 0, self.width, (courseIdArray.count > 6 ? 6:courseIdArray.count)*44) style:UITableViewStylePlain courseIdArray:courseIdArray];
        [self addSubview:self.courseTableView];
        
        UIButton *bottomBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, self.courseTableView.bottom, self.width, 44)];
        bottomBtn.backgroundColor = MAIN_RGB;
        [bottomBtn setTitle:@"切换参加的考试科目 >" forState:UIControlStateNormal];
        bottomBtn.titleLabel.font = FontOfSize(14.0f);
        [bottomBtn addTarget:self action:@selector(changeCourseButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:bottomBtn];
    }
    
    return self;
}
#pragma mark - 切换考试科目
- (void)changeCourseButtonClicked
{
    if ([self.courseViewDelegate respondsToSelector:@selector(StudyCourseViewCourseButtonClicked)])
    {
        [self.courseViewDelegate StudyCourseViewCourseButtonClicked];
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
