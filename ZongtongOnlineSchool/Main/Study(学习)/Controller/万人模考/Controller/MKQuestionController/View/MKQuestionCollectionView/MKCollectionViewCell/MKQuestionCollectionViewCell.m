//
//  MKQuestionCollectionViewCell.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2019/3/19.
//  Copyright © 2019年 ZongTongEdu. All rights reserved.
//

#import "MKQuestionCollectionViewCell.h"
#import "Tools.h"

@implementation MKQuestionCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.tableView = [[MKQuestionTableView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height) style:UITableViewStylePlain];
        [self addSubview:self.tableView];
    }
    
    return self;
}

@end
