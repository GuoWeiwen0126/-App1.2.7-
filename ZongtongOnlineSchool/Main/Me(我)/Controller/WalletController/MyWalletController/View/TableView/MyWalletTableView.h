//
//  MyWalletTableView.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/1/15.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyWalletTableView : UITableView

@property (nonatomic, strong) NSDecimalNumber *payStr;

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style coinArray:(NSMutableArray *)coinArray;

@end
