//
//  QCardButton.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/12/11.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import "QCardButton.h"
#import "Tools.h"

@implementation QCardButton

#pragma mark - setter方法
- (void)setQCardState:(QCardButtonState)qCardState
{
    if (_qCardState != qCardState)
    {
        _qCardState = qCardState;
    }
    switch (qCardState)
    {
        case NotDone:
        {
            [self setTitleColor:MAIN_RGB forState:UIControlStateNormal];
            VIEW_BORDER_RADIUS(self, [UIColor whiteColor], self.width/2, 1, MAIN_RGB_LINE)
        }
            break;
        case HaveDone:
        {
            [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            VIEW_BORDER_RADIUS(self, MAIN_RGB, self.width/2, 1, MAIN_RGB)
        }
            break;
        case AnswerWrong:
        {
            [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            VIEW_BORDER_RADIUS(self, [UIColor redColor], self.width/2, 1, MAIN_RGB_TEXT)
        }
            break;
            
        default:
            break;
    }
}


@end
