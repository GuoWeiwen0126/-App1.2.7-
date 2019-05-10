//
//  AnswerView.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/9/29.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnswerView : UIView

@property (nonatomic, strong) UILabel *firstLabel;
@property (nonatomic, strong) UILabel *secondLabel;
@property (nonatomic, strong) UILabel *thirdLabel;

- (void)answerViewRefreshWithArray:(NSArray *)array;

@end
