//
//  QuestionCardViewController.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/12/11.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import "BaseViewController.h"

typedef NS_ENUM(NSInteger, QcardType)
{
    QcardMistakeType = 10,
    QcardCollectType = 11,
};

@protocol QuestionCardDelegate <NSObject>
- (void)questionCardClickedWithIndex:(NSInteger)index animated:(BOOL)animated;
- (void)questionCardPageChangedWithArray:(NSMutableArray *)array page:(NSInteger)page;
@end

@interface QuestionCardViewController : BaseViewController

@property (nonatomic, assign) BOOL isMistakeCollect;
@property (nonatomic, strong) NSMutableArray *qCardArray;
@property (nonatomic, weak) id <QuestionCardDelegate> qCardDelegate;

//错题、收藏用
@property (nonatomic, assign) QcardType VCType;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger pagesize;
@property (nonatomic, assign) NSInteger maxPage;

@end
