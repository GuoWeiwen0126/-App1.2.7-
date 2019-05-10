//
//  QCardOptionView.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2019/1/10.
//  Copyright © 2019年 ZongTongEdu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QCardOptionButton.h"

NS_ASSUME_NONNULL_BEGIN

@interface QCardOptionView : UIView

@property (nonatomic, strong) QCardOptionButton *lastBtn;
@property (nonatomic, strong) QCardOptionButton *nextBtn;

@end

NS_ASSUME_NONNULL_END
