//
//  OpenCourseHeaderView.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/7/27.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import "OpenCourseHeaderView.h"
#import "Tools.h"
#import "OpenCourseModel.h"

@interface OpenCourseHeaderView ()

@property (nonatomic, strong) UIImageView *iconImgView;
@property (nonatomic, strong) UILabel *headerLabel;
@property (nonatomic, strong) UIImageView *arrowImgView;

@end

@implementation OpenCourseHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithReuseIdentifier:reuseIdentifier])
    {
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 5)];
        lineView.backgroundColor = MAIN_RGB_LINE;
        [self addSubview:lineView];
        
        self.iconImgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 30, 30)];
        [self addSubview:self.iconImgView];
        
        self.headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.iconImgView.right + 10, 5, UI_SCREEN_WIDTH - self.iconImgView.width - 100, 50 - 5*2)];
        self.headerLabel.textColor = MAIN_RGB_MainTEXT;
        self.headerLabel.font = FontOfSize(16.0f);
        [self addSubview:self.headerLabel];
        
        self.arrowImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 15, 15)];
        self.arrowImgView.center = CGPointMake(UI_SCREEN_WIDTH - 30, 50/2);
        self.arrowImgView.image = [UIImage imageNamed:@"arrowRight.png"];
        [self addSubview:self.arrowImgView];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHeaderView:)];
        [self addGestureRecognizer:tapGesture];
    }
    
    return self;
}
#pragma mark - 点击手势
- (void)tapHeaderView:(UITapGestureRecognizer *)tap
{
    if (self.expandCallBack)
    {
        self.expandCallBack([self.courseModel.isSelected boolValue]);
    }
}

#pragma mark - setter方法
- (void)setCourseModel:(OpenCourseModel *)courseModel
{
    if (_courseModel != courseModel)
    {
        _courseModel = courseModel;
    }
    
    [self.iconImgView sd_setImageWithURL:[NSURL URLWithString:courseModel.eiIco]];
    self.headerLabel.text = courseModel.title;
    self.arrowImgView.image = [UIImage imageNamed:[courseModel.isSelected boolValue] == YES ? @"arrowDown.png":@"arrowRight.png"];
}



@end
