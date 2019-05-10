//
//  VideoEvaluateTableView.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/1/1.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol VideoEvaluateTableViewDelegate <NSObject>
- (void)videoEvaluateSubmitWithContent:(NSString *)content gradeArray:(NSMutableArray *)gradeArray isQVideoType:(BOOL)isQVideoType;
@end

@interface VideoEvaluateTableView : UITableView

@property (nonatomic, assign) BOOL isQVideoType;
@property (nonatomic, copy) NSString *contentStr;
@property (nonatomic, weak) id <VideoEvaluateTableViewDelegate> tableViewDelegate;

@end
