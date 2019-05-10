//
//  StudyBookButton.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/8/13.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import "StudyBookButton.h"
#import "Tools.h"
#import "HomeModel.h"

@implementation StudyBookButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.imgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, SCREEN_FIT_WITH(40, 40, 50, 40, 60), SCREEN_FIT_WITH(40, 40, 50, 40, 60))];
//        self.imgView.backgroundColor = [UIColor greenColor];
        self.imgView.center = CGPointMake(SCREEN_FIT_WITH(10, 15, 15, 15, 20) + self.imgView.width/2, self.height/2);
        [self addSubview:self.imgView];
        
        self.topLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.imgView.right + 10, self.imgView.top, self.width - self.imgView.right - 10, self.imgView.height/2)];
//        self.topLabel.backgroundColor = [UIColor redColor];
        self.topLabel.font = FontOfSize(SCREEN_FIT_WITH(14, 14, 16, 14, 16));
        self.topLabel.textColor = MAIN_RGB_MainTEXT;
        [self addSubview:self.topLabel];
        
        self.detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.topLabel.left, self.topLabel.bottom, self.topLabel.width, self.topLabel.height)];
//        self.detailLabel.backgroundColor = [UIColor blueColor];
        self.detailLabel.font = FontOfSize(self.topLabel.font.pointSize - 2);
        self.detailLabel.textColor = MAIN_RGB_TEXT;
        [self addSubview:self.detailLabel];
    }
    
    return self;
}

- (void)setModuleModel:(HomeModuleModel *)moduleModel {
    if (_moduleModel != moduleModel) {
        _moduleModel = moduleModel;
    }
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:moduleModel.imgUrl]];
    self.topLabel.text = moduleModel.title;
}

@end
