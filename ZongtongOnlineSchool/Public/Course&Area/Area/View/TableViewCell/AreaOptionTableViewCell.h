//
//  AreaOptionTableViewCell.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/11/24.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AreaOptionTableViewCell : UITableViewCell

@property (nonatomic, assign) BOOL isSelected;
@property (weak, nonatomic) IBOutlet UILabel *areaLabel;
@property (weak, nonatomic) IBOutlet UIImageView *markImgView;

@end
