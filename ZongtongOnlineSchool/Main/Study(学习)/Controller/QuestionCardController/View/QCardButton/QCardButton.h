//
//  QCardButton.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/12/11.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, QCardButtonState)
{
    NotDone     = 0,
    HaveDone    = 1,
    AnswerWrong = 2,
};
@interface QCardButton : UIButton

@property (nonatomic, assign) QCardButtonState qCardState;

@end
