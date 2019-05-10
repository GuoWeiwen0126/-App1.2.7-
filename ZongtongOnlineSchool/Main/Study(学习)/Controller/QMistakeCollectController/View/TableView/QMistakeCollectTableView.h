//
//  QMistakeCollectTableView.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/12/22.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol QMistakeCollectTableViewDelegate <NSObject>

- (void)tableViewSectionClickedWithIndex:(NSIndexPath *)indexPath;

@end

@interface QMistakeCollectTableView : UITableView

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) NSInteger tableViewType;
@property (nonatomic, weak) id <QMistakeCollectTableViewDelegate> tableViewDelegate;

@end
