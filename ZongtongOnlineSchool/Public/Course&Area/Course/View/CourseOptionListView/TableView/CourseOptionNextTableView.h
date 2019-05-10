//
//  CourseOptionNextTableView.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/11/10.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CourseOptionNextTableView : UITableView <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *dataArray;

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style dataArray:(NSMutableArray *)dataArray;

@end
