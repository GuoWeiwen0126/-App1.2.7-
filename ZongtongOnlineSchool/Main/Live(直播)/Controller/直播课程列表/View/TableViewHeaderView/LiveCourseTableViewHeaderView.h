//
//  LiveCourseTableViewHeaderView.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/12/5.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LiveClassListModel;

NS_ASSUME_NONNULL_BEGIN

@interface LiveCourseTableViewHeaderView : UITableViewHeaderFooterView

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *arrowImgView;
@property (nonatomic, strong) LiveClassListModel *listModel;

@end

NS_ASSUME_NONNULL_END
