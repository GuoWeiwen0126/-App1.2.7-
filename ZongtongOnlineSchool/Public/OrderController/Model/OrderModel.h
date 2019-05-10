//
//  OrderModel.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/1/19.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import <Foundation/Foundation.h>


/*** OrderCouponModel ***/
@interface OrderCouponModel : NSObject
@property (nonatomic, assign) NSInteger ciuid;             //ID
@property (nonatomic, assign) NSInteger uid;               //用户ID
@property (nonatomic, assign) NSInteger ciid;              //优惠券ID
@property (nonatomic, copy)   NSString *cdkey;             //优惠码
@property (nonatomic, copy)   NSString *name;              //名称
@property (nonatomic, assign) NSInteger type;              //类别
@property (nonatomic, copy)   NSString *typeName;          //类别说明
@property (nonatomic, strong) NSDecimalNumber *money;      //优惠金额
@property (nonatomic, strong) NSDecimalNumber *fillMoney;  //满足金额
@property (nonatomic, copy)   NSString *endTime;           //过期时间
@property (nonatomic, assign) NSInteger state;             //状态
@property (nonatomic, copy)   NSString *stateTitle;        //状态说明
@property (nonatomic, copy)   NSString *insertTime;        //录入时间
@property (nonatomic, assign) NSInteger oid;               //绑定订单
@property (nonatomic, copy)   NSString *useTime;           //使用时间
@end


/*** OrderDealItemBasicModel ***/
@interface OrderDealItemBasicModel : NSObject
@property (nonatomic, assign) NSInteger odiid;         //订单详情ID
@property (nonatomic, assign) NSInteger uid;           //用户ID
@property (nonatomic, assign) NSInteger pid;           //产品ID
@property (nonatomic, copy)   NSString *title;         //产品名称
@property (nonatomic, copy)   NSString *key;           //主键信息，预留
@property (nonatomic, strong) NSDecimalNumber *price;  //产品价格
@property (nonatomic, assign) NSInteger num;           //数量
@property (nonatomic, copy)   NSString *remark;        //备注说明
@end
/*** OrderModel ***/
@interface OrderModel : NSObject
@property (nonatomic, assign) NSInteger oid;                    //订单ID
@property (nonatomic, assign) NSInteger examid;                 //考试信息
@property (nonatomic, copy)   NSString *orderNumber;            //订单编号
@property (nonatomic, strong) NSDecimalNumber *payableMoney;    //总金额
@property (nonatomic, strong) NSDecimalNumber *discountsMoney;  //优惠金额
@property (nonatomic, strong) NSDecimalNumber *actuallyMoney;   //订单实付
@property (nonatomic, assign) NSInteger discount;               //折扣
@property (nonatomic, assign) NSInteger ciid;                   //优惠券ID
@property (nonatomic, copy)   NSString *cdkey;                  //优惠码
@property (nonatomic, assign) NSInteger payType;                //支付类别
@property (nonatomic, assign) NSInteger uid;                    //用户uid
@property (nonatomic, assign) NSInteger state;                  //状态
@property (nonatomic, copy)   NSString *stateExplain;           //状态说明
@property (nonatomic, copy)   NSString *remark;                 //备注
@property (nonatomic, copy)   NSString *payOrder;               //支付商订单号
@property (nonatomic, copy)   NSString *insertTime;             //录入时间
@property (nonatomic, strong) NSMutableArray<OrderDealItemBasicModel *> *itemList;  //产品详情
@end



/*** OrderDealItemAdvanceModel ***/
@interface OrderDealItemAdvanceModel : NSObject
@property (nonatomic, assign) NSInteger pid;           //产品ID
@property (nonatomic, copy)   NSString *title;         //产品名称
@property (nonatomic, copy)   NSString *key;           //关键参数 留后用
@property (nonatomic, strong) NSDecimalNumber *price;  //价格
@property (nonatomic, assign) NSInteger num;           //数量
@property (nonatomic, assign) NSInteger state;         //状态
@property (nonatomic, copy)   NSString *stateTitle;    //状态值
@end
/*** OrderAdvanceModel ***/
@interface OrderAdvanceModel : NSObject
/*
 * 结果中的 state 和最外的 Status 的说明不一样。
 * 当 结果中 state 返回 不等于 0 时，提示 explain 的内容，但不影响支付。
 * 当 最外的 Status 返回 不等 0 时，则运行错误，是不能运行支付的。
 */
@property (nonatomic, assign) NSInteger state;                  //状态值
@property (nonatomic, copy)   NSString *explain;                //说明
@property (nonatomic, strong) NSDecimalNumber *payableMoney;    //总金额
@property (nonatomic, strong) NSDecimalNumber *discountsMoney;  //优惠金额
@property (nonatomic, strong) NSDecimalNumber *actuallyMoney;   //订单实付
@property (nonatomic, assign) NSInteger discount;               //打折 默认是 100
@property (nonatomic, assign) NSInteger ciid;                   //优惠券ID
@property (nonatomic, copy)   NSString *cdkey;                  //优惠码
@property (nonatomic, strong) NSMutableArray<OrderDealItemAdvanceModel *> *productList;  //产品列表
@end



