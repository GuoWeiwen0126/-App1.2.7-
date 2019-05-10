//
//  CourseOptionFirstTableView.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/5/7.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CourseOptionFirstTableView : UITableView <UITableViewDelegate, UITableViewDataSource>

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style dataArray:(NSArray *)dataArray;

@end
