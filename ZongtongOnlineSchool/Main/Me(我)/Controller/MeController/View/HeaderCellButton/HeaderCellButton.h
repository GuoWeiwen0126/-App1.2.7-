//
//  HeaderCellButton.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/11/22.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeaderCellButton : UIButton

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel     *label;

- (instancetype)initWithFrame:(CGRect)frame
                    imageName:(NSString *)imageName
                   imageScale:(CGFloat)imageScale
                 imageOffsetY:(CGFloat)imageOffsetY
                        title:(NSString *)title
                    titleFont:(CGFloat)titleFont
                 titleOffsetY:(CGFloat)titleOffsetY;

@end
