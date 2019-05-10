//
//  LiveTableViewHeaderView.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/12/4.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import "LiveTableViewHeaderView.h"
#import "Tools.h"
#import "LiveModel.h"

@implementation LiveTableViewHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithReuseIdentifier:reuseIdentifier])
    {
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(20, 15, 5, 20)];
        leftView.backgroundColor = MAIN_RGB;
        [self addSubview:leftView];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 15, 240, 20)];
        self.titleLabel.font = FontOfSize(16.0);
        [self addSubview:self.titleLabel];
    }
    
    return self;
}
- (void)setListModel:(LiveClassListModel *)listModel {
    if (_listModel != listModel) {
        _listModel = listModel;
    }
    self.titleLabel.text = listModel.typeList.count == 0 ? [NSString stringWithFormat:@"%@（暂无直播课程）",listModel.ltTitle]:listModel.ltTitle;
}

@end
