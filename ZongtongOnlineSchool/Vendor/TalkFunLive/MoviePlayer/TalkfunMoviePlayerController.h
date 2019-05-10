//
//  VideoPlayController.h
//
//
//  Created by LuoLiuyou on 16/7/21.
//  Copyright © 2016年 LuoLiuyou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TalkfunMoviePlayerController : UIViewController
@property (nonatomic,strong)NSString *URL;

@property (weak, nonatomic) IBOutlet UIButton *exitButton;
@property (weak, nonatomic) IBOutlet UIView *tool;

@end
