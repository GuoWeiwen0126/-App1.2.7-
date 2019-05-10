//
//  CourseTableView.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/12/26.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class VideoTypeModel;

@protocol CourseTableViewDelegate <NSObject>

- (void)courseTableViewCellClickedWithVTypeModel:(VideoTypeModel *)vTypeModel;

@end

@interface CourseTableView : UITableView

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, weak) id <CourseTableViewDelegate> tableViewDelegate;

@end
