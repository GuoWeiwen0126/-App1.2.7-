//
//  UpdateAddressTableView.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/11/23.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UpdateAddressDelegate <NSObject>

- (void)updateAddressChangeArea;

@end

@interface UpdateAddressTableView : UITableView <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, weak) id <UpdateAddressDelegate> updateAddressDelegate;
@property (nonatomic, copy) NSString *areaStr;

@property (nonatomic, copy) NSString *nameStr;
@property (nonatomic, copy) NSString *phoneStr;
@property (nonatomic, copy) NSString *provinceStr;
@property (nonatomic, copy) NSString *cityStr;
@property (nonatomic, copy) NSString *addressStr;

@end
