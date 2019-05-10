//
//  StudyCollectionViewFlowLayout.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/11/30.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class StudyCollectionViewFlowLayout;

@protocol StudyFlowLayoutDelegate <NSObject>

- (NSInteger)numberOfColumnsWithLayout:(StudyCollectionViewFlowLayout *)flowLayout;
- (NSInteger)numberOfRowsWithLayout:(StudyCollectionViewFlowLayout *)flowLayout;

@end

@interface StudyCollectionViewFlowLayout : UICollectionViewFlowLayout

@property (nonatomic, assign) NSInteger rows;     //行
@property (nonatomic, assign) NSInteger columns;  //列

@property (nonatomic, weak) id <StudyFlowLayoutDelegate> layoutDelegate;

@end
