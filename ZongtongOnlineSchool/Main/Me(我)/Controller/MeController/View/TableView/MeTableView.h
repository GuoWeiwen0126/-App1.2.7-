//
//  MeTableView.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/11/21.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MeTableViewDelegate <NSObject>

- (void)meTableViewRowsClickedWithIndexPath:(NSIndexPath *)indexPath;

@end

@interface MeTableView : UITableView <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSArray *titleArray;

@property (nonatomic, weak) id <MeTableViewDelegate> meTableViewDelegate;

@end
