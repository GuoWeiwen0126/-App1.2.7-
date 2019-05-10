//
//  ZTStarView.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/12/29.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import "ZTStarView.h"

#define Self_Height self.frame.size.height
#define Self_Width  self.frame.size.width

@interface ZTStarView ()

@property (nonatomic, strong) UIView *backStarView;
@property (nonatomic, strong) UIView *foreStarView;

@end

@implementation ZTStarView

- (instancetype)initWithFrame:(CGRect)frame isEnable:(BOOL)isEnable
{
    if (self = [super initWithFrame:frame])
    {
        self.backStarView = [[UIView alloc] initWithFrame:self.bounds];
        //        self.backgroundColor = [UIColor grayColor];
        [self addSubview:self.backStarView];
        
        self.foreStarView = [[UIView alloc] initWithFrame:self.bounds];
        //        self.backgroundColor = [UIColor yellowColor];
        self.foreStarView.clipsToBounds = YES;
        [self addSubview:self.foreStarView];
        
        for (int i = 0; i < 5; i ++)
        {
            UIImageView *backImgView = [[UIImageView alloc] initWithFrame:CGRectMake(Self_Height*i, 0, Self_Height, Self_Height)];
            backImgView.image = [UIImage imageNamed:@"hollowStar.png"];
            [self.backStarView addSubview:backImgView];
            
            UIImageView *foreImgView = [[UIImageView alloc] initWithFrame:CGRectMake(Self_Height*i, 0, Self_Height, Self_Height)];
            foreImgView.image = [UIImage imageNamed:@"solidStar.png"];
            [self.foreStarView addSubview:foreImgView];
        }
        
        if (isEnable)
        {
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureEvent:)];
            [self addGestureRecognizer:tapGesture];
        }
    }
    
    return self;
}

#pragma mark - 设置分数
- (void)setGrade:(NSInteger)grade
{
    _grade = grade;
    
    [self changeStarViewFrameWithGrade:grade];
}

#pragma mark - 点击手势
- (void)tapGestureEvent:(UITapGestureRecognizer *)tap
{
    CGPoint point = [tap locationInView:self];
    NSInteger count = (NSInteger)(point.x/Self_Height) + 1;
    NSLog(@"---%ld---",(long)count);
    self.grade = count;
    if ([self.starViewDelegate respondsToSelector:@selector(ztStarViewClickedWithGrade:)]) {
        [self.starViewDelegate ztStarViewClickedWithGrade:count];
    }
}

#pragma mark - 改变星星数量
- (void)changeStarViewFrameWithGrade:(NSInteger)grade
{
    self.foreStarView.frame = CGRectMake(0, 0, Self_Height * grade, Self_Height);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
