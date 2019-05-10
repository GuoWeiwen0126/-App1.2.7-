//
//  UserSetTableView.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/11/27.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UserSetTableViewDelegate <NSObject>

- (void)userSetTableViewRowsClickedWithIndexPath:(NSIndexPath *)indexPath;

@end

@interface UserSetTableView : UITableView <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, weak) id <UserSetTableViewDelegate> userSetDelegate;

@end
