//
//  TestReportTableView.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/12/20.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class QExerinfoModel;

@interface TestReportTableView : UITableView

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style qExerinfoModel:(QExerinfoModel *)qExerinfoModel dataArray:(NSMutableArray *)dataArray detailArray:(NSMutableArray *)detailArray submitTimeStr:(NSString *)submitTimeStr;

@end
