//
//  MKExamListTableView.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2019/3/15.
//  Copyright © 2019年 ZongTongEdu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKExamListTableView : UITableView

@property (nonatomic, strong) NSMutableArray *dataArray;

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style dataArray:(NSMutableArray *)dataArray;

@end

NS_ASSUME_NONNULL_END
