//
//  FileDownTableView.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/9/5.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FileDownTableView : UITableView

@property (nonatomic, assign) BOOL isDetail;

@property (nonatomic, strong) NSMutableArray *dataArray;

@end
