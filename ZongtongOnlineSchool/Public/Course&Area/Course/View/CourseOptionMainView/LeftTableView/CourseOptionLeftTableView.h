//
//  CourseOptionLeftTableView.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/7/2.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CourseLeftDelegate <NSObject>
- (void)courseLeftTableViewClickedWithIndex:(NSInteger)index;
@end

@interface CourseOptionLeftTableView : UITableView <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, assign) NSInteger leftIndex;
@property (nonatomic, weak) id <CourseLeftDelegate> leftDelegate;

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style dataArray:(NSArray *)dataArray;

@end
