//
//  TFQuestionCell.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/11/30.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TFQuestionModel;
NS_ASSUME_NONNULL_BEGIN

@interface TFQuestionCell : UITableViewCell

@property (nonatomic,strong ) TFQuestionModel       *Model;
@property (nonatomic,copy   ) NSString            * temp;
@property (nonatomic,copy   ) NSString            * nameTime;
@property (nonatomic,assign ) NSInteger           number;
@property (nonatomic,strong ) NSMutableArray      * heightArray;
@property (nonatomic,strong ) NSMutableDictionary * answerHeightDict;
@property (nonatomic,copy   ) NSString            * xid;

@end

NS_ASSUME_NONNULL_END
