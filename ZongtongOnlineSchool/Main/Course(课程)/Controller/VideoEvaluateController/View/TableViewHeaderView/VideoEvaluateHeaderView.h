//
//  VideoEvaluateHeaderView.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/1/2.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZTStarView.h"

typedef void(^VideoEvaluateHeaderViewExpandCallBack)(BOOL isExpand);
typedef void(^VideoEvaluateHeaderViewGradeCallBack)(NSInteger grade);

@interface VideoEvaluateHeaderView : UIView <ZTStarViewDelegate>

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) ZTStarView *starView;
@property (nonatomic, strong) UILabel *scoreLabel;
@property (nonatomic, strong) UILabel *evaluateLabel;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;

@property (nonatomic, copy) VideoEvaluateHeaderViewExpandCallBack expandCallBack;
@property (nonatomic, copy) VideoEvaluateHeaderViewGradeCallBack gradeCallBack;

- (instancetype)initWithFrame:(CGRect)frame section:(NSInteger)section gradeArray:(NSMutableArray *)gradeArray;

@end
