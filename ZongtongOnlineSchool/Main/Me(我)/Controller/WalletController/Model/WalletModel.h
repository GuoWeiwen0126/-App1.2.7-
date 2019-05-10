//
//  WalletModel.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/1/15.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WalletModel : NSObject
@end


/*** ProductModel ***/
@interface ProductModel : NSObject
@property (nonatomic, assign) NSInteger pid;           //产品ID
@property (nonatomic, assign) NSInteger examid;        //考试信息
@property (nonatomic, copy)   NSString *Title;         //标题
@property (nonatomic, assign) NSInteger Type;          //产品类别（ 1 金币，2 套餐）
@property (nonatomic, copy)   NSString *TypeName;      //产品类别（ 1 金币，2 套餐）
@property (nonatomic, assign) NSInteger Key;           //产品值（类别为金币则为金币个数，类别为套餐则为套餐ID）
@property (nonatomic, assign) NSInteger Value;         //数量（主要用于套餐，开通时长 单位 月）
@property (nonatomic, strong) NSDecimalNumber *Price;  //产品价格
@property (nonatomic, assign) NSInteger State;         //产品状态（0 正常，1 下架，2 删除）
@property (nonatomic, copy)   NSString *StateTitle;    //状态值
@property (nonatomic, copy)   NSString *insertTime;    //录入时间
@property (nonatomic, copy)   NSString *iosPid;        //iOS内购产品ID
@end


/*** ProductDetailModel ***/
@interface ProductDetailModel : NSObject
@end
