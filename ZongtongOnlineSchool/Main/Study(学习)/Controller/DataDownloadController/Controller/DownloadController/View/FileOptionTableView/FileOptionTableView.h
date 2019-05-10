//
//  FileOptionTableView.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/8/21.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FileOptionDelegate <NSObject>
- (void)fileOptionTableViewClickedWithIndex:(NSInteger)index isleft:(BOOL)isleft;
@end

@interface FileOptionTableView : UITableView

@property (nonatomic, assign) BOOL isleft;
@property (nonatomic, strong) NSArray *array;
@property (nonatomic, assign) NSInteger leftIndex;
@property (nonatomic, assign) NSInteger rightIndex;

@property (nonatomic, weak) id <FileOptionDelegate> fileOptionDelegate;

@end
