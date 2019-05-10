//
//  QuestionTypeView.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/12/7.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol QTypeViewDelegate <NSObject>

- (void)qTypeViewTimerClicked;

@end

@interface QuestionTypeView : UIView

@property (nonatomic, strong) UILabel *qTypeLabel;
@property (nonatomic, strong) UILabel *qNumberLabel;
@property (nonatomic, strong) UIButton *timerButton;

@property (nonatomic, weak) id <QTypeViewDelegate> qTypeViewDelegate;

- (void)refreshQtypeViewWithQType:(NSString *)qType qNumber:(NSString *)qNumber;

@end
