//
//  MKQuestionTypeView.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2019/3/19.
//  Copyright © 2019年 ZongTongEdu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MKQTypeViewDelegate <NSObject>

- (void)MKqTypeViewTimerClicked;

@end

@interface MKQuestionTypeView : UIView

@property (nonatomic, strong) UILabel *qTypeLabel;
@property (nonatomic, strong) UILabel *qNumberLabel;
@property (nonatomic, strong) UIButton *timerButton;

@property (nonatomic, weak) id <MKQTypeViewDelegate> MKqTypeViewDelegate;

- (void)refreshQtypeViewWithQType:(NSString *)qType qNumber:(NSString *)qNumber;

@end

NS_ASSUME_NONNULL_END
