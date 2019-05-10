//
//  StudyHeaderView.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/11/29.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OptionButtonView;
@class OptionLabelView;

@protocol StudyHeaderViewDelegate <NSObject>
- (void)studyHeaderViewOptionViewButtonClickedWithBtnTag:(NSInteger)btnTag;
@end

@interface StudyHeaderView : UIView 

@property (nonatomic, strong) OptionButtonView *optionButtonView;
@property (nonatomic, strong) OptionLabelView *optionLabelView;
@property (nonatomic, weak) id <StudyHeaderViewDelegate> headerViewDelegate;
@property (nonatomic, assign) NSInteger videoSrTime;  //学习时长（分钟）
@property (nonatomic, assign) NSInteger videoVtime;   //视频时长（分钟）
@property (nonatomic, assign) CGFloat videoPercent;   //学习进度

@end
