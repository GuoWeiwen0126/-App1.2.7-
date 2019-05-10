//
//  OpenAppTypeTableView.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/8/2.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UserAppModel;

@protocol OpenAppTypeTableViewDelegate <NSObject>
- (void)openAppTypeTableViewCellClickedWithOpenAppTypeModel:(UserAppModel *)model;
@end

@interface OpenAppTypeTableView : UITableView <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, weak) id <OpenAppTypeTableViewDelegate> appTypeDelegate;

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style dataArray:(NSArray *)dataArray;

@end
