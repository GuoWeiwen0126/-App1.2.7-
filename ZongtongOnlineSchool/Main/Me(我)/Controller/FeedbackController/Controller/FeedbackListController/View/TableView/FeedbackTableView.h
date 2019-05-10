//
//  FeedbackTableView.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/1/5.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FeedbackTableViewDelegate <NSObject>

- (void)tableViewCellClickedWithIndex:(NSIndexPath *)indexPath;

@end

@interface FeedbackTableView : UITableView

@property (nonatomic, strong) NSMutableArray *feedbackArray;
@property (nonatomic, weak) id <FeedbackTableViewDelegate> tableViewDelegate;

@end
