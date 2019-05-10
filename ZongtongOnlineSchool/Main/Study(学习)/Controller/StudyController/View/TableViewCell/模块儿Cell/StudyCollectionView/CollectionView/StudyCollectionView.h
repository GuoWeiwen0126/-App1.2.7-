//
//  StudyCollectionView.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/11/29.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol StudyCollectionViewDelegate <NSObject>

- (void)studyCollectionViewPageControlChangeWithNewPage:(NSInteger)newPage;

@end

@interface StudyCollectionView : UICollectionView <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) NSMutableArray *moduleDataArray;
@property (nonatomic, weak) id <StudyCollectionViewDelegate> collectionViewDelegate;

@end
