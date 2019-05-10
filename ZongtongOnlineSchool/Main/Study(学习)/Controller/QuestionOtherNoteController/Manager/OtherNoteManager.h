//
//  OtherNoteManager.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/12/19.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^OtherNoteManagerBlock)(id obj);

@interface OtherNoteManager : NSObject

#pragma mark - 试题所有笔记
+ (void)otherNoteManagerBasicPageWithCourseid:(NSString *)courseid qid:(NSString *)qid page:(NSString *)page pagesize:(NSString *)pagesize completed:(OtherNoteManagerBlock)completed;

@end
