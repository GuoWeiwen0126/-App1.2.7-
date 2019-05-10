//
//  LiveModel.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/12/3.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import "LiveModel.h"

@implementation LiveModel
@end


@implementation ALiLiveModel
@end


@implementation ALiVideoModel
@end


@implementation LiveClassListModel
+ (NSDictionary *)modelContainerPropertyGenericClass
{
    return @{@"typeList":LiveClassListModel.class, @"basicList":LiveBasicListModel.class};
}
@end


@implementation LiveBasicListModel
@end


//@implementation LiveBasicListModel
//@end
