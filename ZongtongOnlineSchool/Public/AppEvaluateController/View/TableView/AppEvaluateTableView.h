//
//  AppEvaluateTableView.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/1/24.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AppEvaluateTableViewDelegate <NSObject>
- (void)updateAppEvaluateOptionWithScore:(NSString *)score option:(NSString *)option;
@end

@interface AppEvaluateTableView : UITableView

@property (nonatomic, weak) id <AppEvaluateTableViewDelegate> tableViewDelegate;

@end
