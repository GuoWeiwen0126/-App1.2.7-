//
//  QHistoryTableView.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/12/25.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol QHistoryTableViewDelegate <NSObject>

- (void)tableViewCellClickedWithIndex:(NSIndexPath *)indexPath;

@end

@interface QHistoryTableView : UITableView

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) NSInteger state;
@property (nonatomic, weak) id <QHistoryTableViewDelegate> tableViewDelegate;

@end
