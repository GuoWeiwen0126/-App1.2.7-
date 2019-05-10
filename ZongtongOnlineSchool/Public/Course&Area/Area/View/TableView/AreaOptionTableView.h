//
//  AreaOptionTableView.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/11/24.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, AreaType)
{
    ProvinceType = 0,
    CityType     = 1,
};

@protocol AreaOptionTableViewDelegate <NSObject>

- (void)areaOptionClickedWithAreaType:(AreaType)areaType index:(NSInteger)index provinceStr:(NSString *)provinceStr cityStr:(NSString *)cityStr;

@end

@interface AreaOptionTableView : UITableView <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, assign) AreaType areaType;
@property (nonatomic, strong) NSArray *areaArray;

@property (nonatomic, weak) id <AreaOptionTableViewDelegate> areaOptionDelegate;

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style areaArray:(NSArray *)areaArray isExamArea:(BOOL)isExamArea;

@end
