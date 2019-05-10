//
//  CouponModel.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/1/9.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import <Foundation/Foundation.h>


/*** CouponListModel ***/
@interface CouponListModel : NSObject
@property (nonatomic, assign) NSInteger ciuid;             //ID
@property (nonatomic, assign) NSInteger uid;               //用户ID
@property (nonatomic, assign) NSInteger ciid;              //优惠券ID
@property (nonatomic, copy)   NSString *cdkey;             //券码
@property (nonatomic, copy)   NSString *name;              //券名称
@property (nonatomic, assign) NSInteger type;              //优惠类别
@property (nonatomic, copy)   NSString *typeName;          //类别说明
@property (nonatomic, strong) NSDecimalNumber *money;      //优惠金额
@property (nonatomic, strong) NSDecimalNumber *fillMoney;  //满足金额
@property (nonatomic, copy)   NSString *endTime;           //过期时间
@property (nonatomic, assign) NSInteger state;             //状态值
@property (nonatomic, copy)   NSString *stateTitle;        //状态标题
@property (nonatomic, copy)   NSString *insertTime;        //录入时间
@property (nonatomic, assign) NSInteger oid;               //绑定订单
@property (nonatomic, copy)   NSString *useTime;           //使用时间
@end


/*** CouponModel ***/
@interface CouponModel : NSObject
@property (nonatomic, assign) NSInteger ciid;              //ID
@property (nonatomic, assign) NSInteger cid;               //优惠券ID
@property (nonatomic, copy)   NSString *cdkey;             //券码
@property (nonatomic, copy)   NSString *name;              //券名称
@property (nonatomic, assign) NSInteger type;              //优惠类别
@property (nonatomic, strong) NSDecimalNumber *money;      //优惠金额
@property (nonatomic, strong) NSDecimalNumber *fillMoney;  //满足金额
@property (nonatomic, copy)   NSString *endTime;           //过期时间
@property (nonatomic, assign) NSInteger agentid;           //代理商ID
@property (nonatomic, assign) NSInteger state;             //状态值
@property (nonatomic, copy)   NSString *stateName;         //状态说明
@property (nonatomic, copy)   NSString *remark;            //说明
@property (nonatomic, copy)   NSString *insertName;        //录入人
@property (nonatomic, assign) NSInteger uid;               //用户ID
@property (nonatomic, copy)   NSString *useTime;           //使用时间
@end


