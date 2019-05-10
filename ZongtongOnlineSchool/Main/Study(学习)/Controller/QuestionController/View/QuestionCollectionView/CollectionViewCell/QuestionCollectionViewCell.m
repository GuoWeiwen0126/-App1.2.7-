//
//  QuestionCollectionViewCell.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/12/7.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import "QuestionCollectionViewCell.h"
#import "Tools.h"

@implementation QuestionCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.tableView = [[QuestionTableView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height) style:UITableViewStylePlain];
        [self addSubview:self.tableView];
    }
    
    return self;
}

@end
