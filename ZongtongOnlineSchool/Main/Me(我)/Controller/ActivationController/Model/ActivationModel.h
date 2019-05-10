//
//  ActivationModel.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/3/13.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import <Foundation/Foundation.h>

/*** ActivationModel ***/
@interface ActivationModel : NSObject
@property (nonatomic, assign) NSInteger acid;        //激活码ID
@property (nonatomic, assign) NSInteger examid;      //考试ID
@property (nonatomic, copy)   NSString *CDKEY;       //激活码
@property (nonatomic, assign) NSInteger smid;        //套餐ID
@property (nonatomic, assign) NSInteger agentid;     //代理商ID
@property (nonatomic, assign) NSInteger state;       //状态
@property (nonatomic, copy)   NSString *remark;      //备注
@property (nonatomic, assign) NSInteger duration;    //开通时长
@property (nonatomic, assign) NSInteger uid;         //用户ID
@property (nonatomic, copy)   NSString *insertTime;  //录入时间
@end


@interface ActivationListModel : NSObject
@property (nonatomic, assign) NSInteger acuid;       //绑定ID
@property (nonatomic, assign) NSInteger examid;      //考试信息
@property (nonatomic, assign) NSInteger uid;         //用户ID
@property (nonatomic, assign) NSInteger acid;        //激活码id
@property (nonatomic, copy)   NSString *CDKEY;       //激活码
@property (nonatomic, assign) NSInteger state;       //状态值
@property (nonatomic, copy)   NSString *stateTitle;  //状态名称
@property (nonatomic, copy)   NSString *useTime;     //使用时间
@property (nonatomic, copy)   NSString *insertTime;  //录入人
//
@property (nonatomic, assign) BOOL isOpen;         //是否展开
@property (nonatomic, copy)   NSString *smTitle;   //套餐名称
@property (nonatomic, assign) NSInteger duration;  //开通时长
@end

