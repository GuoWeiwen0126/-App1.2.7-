//
//  StudyCourseView.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/12/6.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StudyCourseTableView.h"

@protocol StudyCourseViewDelegate <NSObject>

- (void)StudyCourseViewCourseButtonClicked;

@end

@interface StudyCourseView : UIView

@property (nonatomic, assign) BOOL isOpen;  //是否展开
@property (nonatomic, strong) StudyCourseTableView *courseTableView;
@property (nonatomic, weak) id <StudyCourseViewDelegate> courseViewDelegate;

- (instancetype)initWithFrame:(CGRect)frame courseIdArray:(NSArray *)courseIdArray;

@end
