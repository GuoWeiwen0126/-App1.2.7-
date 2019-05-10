//
//  MKQuestionCollectionView.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2019/3/19.
//  Copyright © 2019年 ZongTongEdu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MKQuestionCollectionViewCell.h"

NS_ASSUME_NONNULL_BEGIN
@protocol MKQuestionCollectionViewDelegate <NSObject>

- (void)MKquestionCollectionViewScrollWithNowQModel:(QuestionModel *)nowQModel nowIndex:(NSInteger)nowIndex;

@end

@interface MKQuestionCollectionView : UICollectionView

@property (nonatomic, strong) MKQuestionCollectionViewCell *cell;
@property (nonatomic, strong) NSMutableArray *collectionDataArray;

@property (nonatomic, weak) id <MKQuestionCollectionViewDelegate> MKcollectionViewDelegate;

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout;

@end

NS_ASSUME_NONNULL_END
