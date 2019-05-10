//
//  VideoPlayView.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/1/17.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideoPlayView : UIView

- (id)initWithFrame:(CGRect)frame videoUrl:(NSString *)videoUrl isHtml:(BOOL)isHtml;
- (void)refreshVideoWithVideoUrl:(NSString *)videoUrl;

@end
