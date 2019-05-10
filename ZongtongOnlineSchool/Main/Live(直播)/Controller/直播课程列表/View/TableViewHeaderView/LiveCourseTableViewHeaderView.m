//
//  LiveCourseTableViewHeaderView.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/12/5.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import "LiveCourseTableViewHeaderView.h"
#import "Tools.h"
#import "LiveModel.h"

@interface LiveCourseTableViewHeaderView ()

@end

@implementation LiveCourseTableViewHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithReuseIdentifier:reuseIdentifier])
    {
        self.backgroundColor = MAIN_RGB_LightLINE;
        
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 15, 20, 20)];
        imgView.image = [UIImage imageNamed:@"liveTitle.png"];
        [self addSubview:imgView];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(imgView.right + 10, 10, 200, 30)];
        self.titleLabel.textColor = MAIN_RGB_TEXT;
        self.titleLabel.font = FontOfSize(16.0);
        [self addSubview:self.titleLabel];
        
        self.arrowImgView = [[UIImageView alloc] initWithFrame:CGRectMake(UI_SCREEN_WIDTH - 30, 17, 16, 16)];
        [self addSubview:self.arrowImgView];
        
        //点击手势
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureEvent:)];
        [self addGestureRecognizer:tapGesture];
    }
    
    return self;
}
- (void)tapGestureEvent:(UITapGestureRecognizer *)tap {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CourseHeaderViewClicked" object:[NSString stringWithFormat:@"%ld",(long)self.tag]];
}
- (void)setListModel:(LiveClassListModel *)listModel {
    if (_listModel != listModel) {
        _listModel = listModel;
    }
    self.titleLabel.text = listModel.ltTitle;
    self.titleLabel.textColor = listModel.isDefault == 1 ? MAIN_RGB:MAIN_RGB_TEXT;
    self.arrowImgView.image = [UIImage imageNamed:listModel.isDefault == 1 ? @"arrowDown.png":@"arrowRight.png"];
}

@end
