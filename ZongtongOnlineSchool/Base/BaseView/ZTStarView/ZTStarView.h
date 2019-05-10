//
//  ZTStarView.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/12/29.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZTStarViewDelegate <NSObject>
- (void)ztStarViewClickedWithGrade:(NSInteger)grade;
@end

@interface ZTStarView : UIView

@property (nonatomic, assign) NSInteger grade;
@property (nonatomic, weak) id <ZTStarViewDelegate> starViewDelegate;

- (instancetype)initWithFrame:(CGRect)frame isEnable:(BOOL)isEnable;

@end
