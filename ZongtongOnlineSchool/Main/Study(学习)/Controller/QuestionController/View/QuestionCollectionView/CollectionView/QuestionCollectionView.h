//
//  QuestionCollectionView.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/12/7.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuestionCollectionViewCell.h"

@protocol QuestionCollectionViewDelegate <NSObject>

- (void)questionCollectionViewScrollWithNowQModel:(QuestionModel *)nowQModel nowIndex:(NSInteger)nowIndex;

@end

@interface QuestionCollectionView : UICollectionView

@property (nonatomic, strong) QuestionCollectionViewCell *cell;
@property (nonatomic, strong) NSMutableArray *collectionDataArray;

@property (nonatomic, weak) id <QuestionCollectionViewDelegate> collectionViewDelegate;

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout;

@end
