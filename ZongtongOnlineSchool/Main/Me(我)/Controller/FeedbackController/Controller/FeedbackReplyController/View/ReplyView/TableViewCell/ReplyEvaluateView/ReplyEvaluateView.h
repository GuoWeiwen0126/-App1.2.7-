//
//  ReplyEvaluateView.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/1/8.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ReplyEvaluateViewDelegate <NSObject>
- (void)submitReplyEvalauteWithGrade:(NSInteger)grade frComment:(NSString *)frComment;
@end

@interface ReplyEvaluateView : UIView

@property (nonatomic, weak) id <ReplyEvaluateViewDelegate> delegate;

@end
