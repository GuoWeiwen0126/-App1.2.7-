//
//  FileDownDetailHeaderView.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/9/5.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import "FileDownDetailHeaderView.h"
#import "Tools.h"

@interface FileDownDetailHeaderView () <OptionButtonViewDelegate>
{
    NSInteger _temTag;
}
@end

@implementation FileDownDetailHeaderView

- (instancetype)initWithFrame:(CGRect)frame praiseNum:(NSString *)praiseNum userCoin:(NSString *)userCoin
{
    self = [super initWithFrame:frame];
    self = [[NSBundle mainBundle] loadNibNamed:@"FileDownDetailHeaderView" owner:self options:nil].lastObject;
    if (self)
    {
        self.frame = frame;
        
        _temTag = 0;
        NSArray *detailArray = @[@"累计积分", @"积分余额"];
        
        for (int i = 0; i < detailArray.count; i ++) {
            UILabel *numLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
            numLabel.center = CGPointMake(i == 0 ? self.bgButton.width/4:self.bgButton.width/4*3, self.bgButton.height/2 - 20);
            numLabel.textAlignment = NSTextAlignmentCenter;
            numLabel.textColor = [UIColor whiteColor];
            numLabel.text = i == 0 ? praiseNum:userCoin;
            numLabel.font = FontOfSize(16.0);
            [self.bgButton addSubview:numLabel];
            
            UILabel *detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
            detailLabel.center = CGPointMake(i == 0 ? self.bgButton.width/4:self.bgButton.width/4*3, self.bgButton.height/2 + 20);
            detailLabel.backgroundColor = i == 0 ? [UIColor orangeColor]:[UIColor redColor];
            detailLabel.textAlignment = NSTextAlignmentCenter;
            detailLabel.textColor = [UIColor whiteColor];
            detailLabel.text = detailArray[i];
            detailLabel.font = FontOfSize(SCREEN_FIT_WITH(14.0, 14.0, 16.0, 16.0, 18.0));
            VIEW_CORNER_RADIUS(detailLabel, 20)
            [self.bgButton addSubview:detailLabel];
        }
        
        self.optionView = [[OptionButtonView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 50) optionArray:@[@"积分明细", @"下载记录"] selectedColor:MAIN_RGB lineSpace:10 haveLineView:YES selectIndex:0];
        self.optionView.optionViewDelegate = self;
        [self.bgView addSubview:self.optionView];
    }
    
    return self;
}
#pragma mark - optionButtonView 代理方法
- (void)optionViewButtonClickedWithBtnTag:(NSInteger)btnTag {
    if (_temTag != btnTag) {
        _temTag = btnTag;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"FileDownDetailViewButtonClicked" object:[NSString stringWithFormat:@"%ld",(long)btnTag]];
    }
}

@end
