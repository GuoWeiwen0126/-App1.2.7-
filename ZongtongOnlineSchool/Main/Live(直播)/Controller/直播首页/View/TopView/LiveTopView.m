//
//  LiveTopView.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/12/5.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import "LiveTopView.h"
#import "Tools.h"
#import "LiveModel.h"

@interface LiveTopView ()
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *titleLabel;
@end

@implementation LiveTopView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = MAIN_RGB_LightLINE;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, UI_SCREEN_WIDTH/3 - 20, 40)];
        label.text = @"直播预告";
        label.textColor = MAIN_RGB_MainTEXT;
        label.font = FontOfSize(16.0);
        [self addSubview:label];
        
        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(label.right, 5, UI_SCREEN_WIDTH - label.right, 25)];
        self.timeLabel.textColor = MAIN_RGB_MainTEXT;
        self.timeLabel.font = FontOfSize(14.0);
        self.timeLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:self.timeLabel];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.timeLabel.left, self.timeLabel.bottom, self.timeLabel.width, 25)];
        self.titleLabel.textColor = MAIN_RGB_MainTEXT;
        self.titleLabel.font = FontOfSize(14.0);
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:self.titleLabel];
    }
    
    return self;
}
- (void)setLiveBasicModel:(LiveBasicListModel *)liveBasicModel {
    if (_liveBasicModel != liveBasicModel) {
        _liveBasicModel = liveBasicModel;
    }
    self.timeLabel.text = [[liveBasicModel.lvStart substringToIndex:16] substringFromIndex:5];
    self.titleLabel.text = liveBasicModel.lvTitle;
}

@end
