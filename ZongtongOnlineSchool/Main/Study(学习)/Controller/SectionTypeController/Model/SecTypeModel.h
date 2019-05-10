//
//  SecTypeModel.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2019/1/30.
//  Copyright © 2019年 ZongTongEdu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SecTypeModel : NSObject

@property (nonatomic, assign) NSInteger sfid;     //ID
@property (nonatomic, assign) NSInteger sType;    //题型类别 0 为散体，1为套题
@property (nonatomic, copy)   NSString *title;    //名称
@property (nonatomic, assign) NSInteger order;    //排序
@property (nonatomic, assign) NSInteger sYear;    //年份
@property (nonatomic, assign) NSInteger isUsing;  //是否启用
@property (nonatomic, copy)   NSString *errMsg;   //提示信息
@property (nonatomic, strong) NSMutableArray *basicList;  //子节点列表

@end

NS_ASSUME_NONNULL_END
