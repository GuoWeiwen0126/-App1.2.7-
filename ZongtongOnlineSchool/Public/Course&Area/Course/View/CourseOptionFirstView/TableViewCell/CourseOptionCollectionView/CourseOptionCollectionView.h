//
//  CourseOptionCollectionView.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/5/7.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CourseOptionCollectionView : UICollectionView <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) NSMutableArray *courseArray;

@end
