//
//  MKStateCollectionViewCell.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2019/3/20.
//  Copyright © 2019年 ZongTongEdu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EmkInfoListModel;

NS_ASSUME_NONNULL_BEGIN

@interface MKStateCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgViewWidth;
@property (weak, nonatomic) IBOutlet UILabel *courseLabel;
@property (weak, nonatomic) IBOutlet UIButton *examBtn;

@property (nonatomic, strong) EmkInfoListModel *infoListModel;

@end

NS_ASSUME_NONNULL_END
