//
//  SectionTypeTableView.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2019/1/30.
//  Copyright © 2019年 ZongTongEdu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SectionTypeTableView : UITableView <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *dataArray;

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style array:(NSMutableArray *)array;

@end

NS_ASSUME_NONNULL_END
