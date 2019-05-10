//
//  NewStudyTableView.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/11/20.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, MainType)
{
    QuestionType = 0,
    VIPStudent   = 1,
};

@interface NewStudyTableView : UITableView

@property (nonatomic, assign) MainType mainType;
@property (nonatomic, strong) NSMutableArray *moduleArray;
@property (nonatomic, strong) NSMutableArray *vipArray;

@end
