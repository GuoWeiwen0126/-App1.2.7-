//
//  IPAPayViewController.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/1/16.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import "BaseViewController.h"
@class ProductModel;

@interface IPAPayViewController : BaseViewController

@property (nonatomic, strong) ProductModel *proModel;
@property (nonatomic, copy)   NSString *oid;

@end
