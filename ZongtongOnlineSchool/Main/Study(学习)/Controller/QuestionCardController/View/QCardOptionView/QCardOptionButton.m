//
//  QCardOptionButton.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2019/1/10.
//  Copyright © 2019年 ZongTongEdu. All rights reserved.
//

#import "QCardOptionButton.h"
#import "Tools.h"

@implementation QCardOptionButton

- (void)setCanClicked:(BOOL)canClicked {
    if (_canClicked != canClicked) {
        _canClicked = canClicked;
    }
    self.backgroundColor = MAIN_RGB_LightLINE;
    if (canClicked) {
        [self setTitleColor:MAIN_RGB forState:UIControlStateNormal];
    } else {
        [self setTitleColor:MAIN_RGB_LINE forState:UIControlStateNormal];
    }
}

@end
