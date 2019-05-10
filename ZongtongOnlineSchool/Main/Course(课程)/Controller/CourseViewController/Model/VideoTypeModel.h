//
//  VideoTypeModel.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/12/26.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VideoTypeModel : NSObject

@property (nonatomic, assign) NSInteger vtfid;   //类别ID
@property (nonatomic, copy)   NSString *vtTitle; //标题
@property (nonatomic, assign) NSInteger vtOrder; //排序
@property (nonatomic, assign) NSInteger vtYear;  //年份
@property (nonatomic, assign) NSInteger isUsing; //是否启用 （0 为启用 ）
@property (nonatomic, copy)   NSString *errMsg;  //标题

@end
