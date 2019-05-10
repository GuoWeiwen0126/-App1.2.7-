//
//  UpdatePWTableView.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/11/23.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UpdatePWTableViewCell.h"

@interface UpdatePWTableView : UITableView <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UpdatePWTableViewCell *cell_Phone;
@property (nonatomic, strong) UpdatePWTableViewCell *cell_oldPW;
@property (nonatomic, strong) UpdatePWTableViewCell *cell_newPW;
@property (nonatomic, strong) UpdatePWTableViewCell *cell_confirmPW;

@end
