//
//  VideoEvaluateViewController.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/1/1.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import "BaseViewController.h"
@class VideoDetailModel;

@protocol VideoEvaluateVCDelegate <NSObject>
- (void)evaluateSuccessAndReload;
@end

@interface VideoEvaluateViewController : BaseViewController

@property (nonatomic, assign) BOOL isQVideoType;
@property (nonatomic, copy)   NSString *qid;
@property (nonatomic, strong) VideoDetailModel *vDetailModel;
@property (nonatomic, weak) id <VideoEvaluateVCDelegate> delegate;

@end
