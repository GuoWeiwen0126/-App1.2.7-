//
//  OtherNoteModel.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/12/19.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OtherNoteModel : NSObject

@property (nonatomic, assign) NSInteger nid;        //笔记ID
@property (nonatomic, assign) NSInteger courseid;   //科目ID
@property (nonatomic, assign) NSInteger sid;        //章节ID
@property (nonatomic, assign) NSInteger qid;        //问题ID
@property (nonatomic, assign) NSInteger uid;        //用户ID
@property (nonatomic, copy)   NSString *nickName;   //用户昵称
@property (nonatomic, copy)   NSString *portrait;   //头像
@property (nonatomic, copy)   NSString *content;    //笔记内容
@property (nonatomic, copy)   NSString *insertTime; //录入时间
@property (nonatomic, assign) NSInteger praise;     //点赞数量

@end
