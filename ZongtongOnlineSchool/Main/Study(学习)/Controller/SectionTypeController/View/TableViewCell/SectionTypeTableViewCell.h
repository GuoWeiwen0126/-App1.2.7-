//
//  SectionTypeTableViewCell.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2019/1/30.
//  Copyright © 2019年 ZongTongEdu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SecTypeModel;

NS_ASSUME_NONNULL_BEGIN

@interface SectionTypeTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) SecTypeModel *secTypeModel;

@end

NS_ASSUME_NONNULL_END
