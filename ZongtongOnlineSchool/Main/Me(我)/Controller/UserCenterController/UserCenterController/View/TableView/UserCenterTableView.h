//
//  UserCenterTableView.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/11/22.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UserCenterTableViewCellDelegate <NSObject>

- (void)userCenterTableViewCellDidSelectWithIndexPath:(NSIndexPath *)indexPath;

@end

@interface UserCenterTableView : UITableView <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, weak) id <UserCenterTableViewCellDelegate> userCenterDelegate;

@end
