//
//  LiveTableViewHeaderView.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/12/4.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LiveClassListModel;

NS_ASSUME_NONNULL_BEGIN

@interface LiveTableViewHeaderView : UITableViewHeaderFooterView

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) LiveClassListModel *listModel;

@end

NS_ASSUME_NONNULL_END
