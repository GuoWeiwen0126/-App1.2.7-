//
//  CourseOptionRightTableView.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/7/2.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CourseRightDelegate <NSObject>
- (void)courseRightTableViewClickedWithIndex:(NSInteger)index cellModel:(id)cellModel;
@end

@interface CourseOptionRightTableView : UITableView <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, assign) NSInteger rightIndex;
@property (nonatomic, weak) id <CourseRightDelegate> rightDelegate;

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style dataArray:(NSArray *)dataArray;

@end
