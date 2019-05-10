//
//  VideoPlayController.m
//  TalkfunSDK
//
//  Created by LuoLiuyou on 16/7/21.
//  Copyright © 2016年 Talkfun. All rights reserved.
//

#import "TalkfunMoviePlayerController.h"
#import "TalkfunMoviePlayer.h"

//#import "TimeCalculation.h"
#import <MediaPlayer/MediaPlayer.h>
#define APPLICATION [UIApplication sharedApplication]
#define ORIENTATION [UIDevice currentDevice].orientation
#define ScreenSize [UIScreen mainScreen].bounds.size

#define TalkfunMediaPlayerAppid @"10000"
#define TalkfunMediaPlayerAccessKey @"8f584a00fd532dd436a7e2e0b8e21e86"

#define APPLICATION [UIApplication sharedApplication]
#define ORIENTATION [UIDevice currentDevice].orientation
#define ScreenSize [UIScreen mainScreen].bounds.size
#define APPLICATION [UIApplication sharedApplication]
@interface TalkfunMoviePlayerController ()
@property (nonatomic,strong) TalkfunMoviePlayer *player;
@property (nonatomic,strong)   NSTimer *timer;
@property (nonatomic,assign)BOOL  isPlayer;

@property (weak, nonatomic) IBOutlet UISlider *ProgressBar;

@property (weak, nonatomic) IBOutlet UILabel *totalDurationLabel;

@property (weak, nonatomic) IBOutlet UILabel *currentTimeLabel;
@property (nonatomic,assign) BOOL isFirst;//记得方向

@property (nonatomic,strong)UIView *VideoView;//视频预览View

@end

@implementation TalkfunMoviePlayerController

- (void)viewDidLoad {
    [super viewDidLoad];
    

    //视频预览View
    /*
    UIView *VideoView = [[UIView alloc]init];
    VideoView.backgroundColor = [UIColor whiteColor];
    VideoView.frame =  self.view.frame;
    NSLog(@"moviePlayerController width:%f,height:%f",self.view.frame.size.width,self.view.frame.size.height);
    self.VideoView.autoresizesSubviews = YES;
    self.VideoView.backgroundColor = [UIColor blackColor];
    self.VideoView = VideoView;*/
    
    //设置播放器
    [self Setplayer];
    

    
}

- (void)Setplayer
{
    self.player = [[TalkfunMoviePlayer alloc] initWithContentURLString:@"http://p2-2.talk-fun.com/bGl2ZS8yMjEvMTM3NDQvbXRtN216aXltcS8xMzYzMjIxX3ZpZGVvLWNsaWVudC0xLm1wNHw0MDgyMjU5MDg2.mp4?limit=40K&encrypt=1"];

    self.player.view.frame =self.view.frame;
    self.player.view.backgroundColor = [UIColor blackColor];
    
    self.player.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.VideoView insertSubview:self.player.view atIndex:1];
    [self.view addSubview:self.player.view];
    [self.view addSubview:self.tool];
    [self.view addSubview:self.exitButton];
    self.player.scalingMode = TalkfunMPMovieScalingModeAspectFit;
    self.player.shouldAutoplay = YES;
    self.view.autoresizesSubviews = YES;
    [self installMovieNotificationObservers];
 
    self.view.backgroundColor = [UIColor redColor];
}



- (IBAction)ClickPlay:(UIButton *)sender {
      sender.selected = !sender.selected;
    
    self.isPlayer = !self.isPlayer;
    
    if (sender.selected) {
        [ sender setImage:[UIImage imageNamed:@"full_pause_btn"] forState:UIControlStateNormal];
        if (![_player isPlaying]) {
            [self.player prepareToPlay];
            [self.player play];
        //self.player.musicPlayer.volume  = 0.1;
            NSLog(@"============play=============");
        }
        
    }else
    {
        [ sender setImage:[UIImage imageNamed:@"full_play_btn"] forState:UIControlStateNormal];
        [self.timer invalidate];
        _timer = nil;
        [self.player pause];
    }
    
    if (_timer != nil){
        return;
    }
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}


- (void)timeFireMethod
{
    self.totalDurationLabel.text = [self stringWithTime:self.player.duration];
    self.currentTimeLabel.text = [self stringWithTime:self.player.currentPlaybackTime];
    self.ProgressBar.minimumValue = 0;  //设置滑轮所能滚动到的最小值
    self.ProgressBar.maximumValue = (int) self.player.duration;
    [self.ProgressBar setValue:self.player.currentPlaybackTime animated:YES];
    
}

//开始滑动时调用
- (IBAction)down:(UISlider *)sender {
     if (self.timer) {
     [self.timer invalidate];
     _timer = nil;
     }
     if (self.isPlayer) {
     [self.player pause];
     }
    
}

//滑动中调用
- (IBAction)ProgressBarVolume:(UISlider *)sender {
    
    self.currentTimeLabel.text = [self stringWithTime:sender.value];

}


//滑动结束调用
- (IBAction)didSliderTouchUpInside:(UISlider *)sender {
    
    if (sender.maximumValue  == sender.value)
    {
        self.player.currentPlaybackTime = sender.value;
        return;
    }

    //跳到这里播放
    self.player.currentPlaybackTime = sender.value;
            if (!self.isPlayer) {
                return;
            }
            [self.player  prepareToPlay];
            [self.player  play];
            if (_timer != nil){//如果定时器已经添加,就不能再添加定时器,否则定时速度出错
                return;
            }
            _timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}
- (void)loadStateDidChange:(NSNotification*)notification {
    TalkfunMPMovieLoadState loadState = _player.loadState;
    
    if ((loadState & TalkfunMPMovieLoadStatePlaythroughOK) != 0) {
        NSLog(@"LoadStateDidChange: TalkfunMovieLoadStatePlayThroughOK: %d\n",(int)loadState);
    }else if ((loadState & TalkfunMPMovieLoadStateStalled) != 0) {
        NSLog(@"loadStateDidChange: TalkfunMPMovieLoadStateStalled: %d\n", (int)loadState);
    } else {
        NSLog(@"loadStateDidChange: ???: %d\n", (int)loadState);
    }
}

- (void)moviePlayBackFinish:(NSNotification*)notification {
    int reason =[[[notification userInfo] valueForKey:TalkfunMPMoviePlayerPlaybackDidFinishReasonUserInfoKey] intValue];
    switch (reason) {
        case TalkfunMPMovieFinishReasonPlaybackEnded:
            NSLog(@"playbackStateDidChange: TalkfunMPMovieFinishReasonPlaybackEnded: %d\n", reason);
            break;
            
        case TalkfunMPMovieFinishReasonUserExited:
            NSLog(@"playbackStateDidChange: TalkfunMPMovieFinishReasonUserExited: %d\n", reason);
            break;
            
        case TalkfunMPMovieFinishReasonPlaybackError:
            NSLog(@"playbackStateDidChange: TalkfunMPMovieFinishReasonPlaybackError: %d\n", reason);
            break;
            
        default:
            NSLog(@"playbackPlayBackDidFinish: ???: %d\n", reason);
            break;
    }
}

- (void)mediaIsPreparedToPlayDidChange:(NSNotification*)notification {
    NSLog(@"mediaIsPrepareToPlayDidChange\n");
}

- (void)moviePlayBackStateDidChange:(NSNotification*)notification {
    switch (_player.playbackState) {
        case TalkfunMPMoviePlaybackStateStopped:
            
            //直播退出的时候 会来
            NSLog(@"TalkfunMPMoviePlayBackStateDidChange %d: stoped", (int)_player.playbackState);
            break;
            
        case TalkfunMPMoviePlaybackStatePlaying:
            NSLog(@"TalkfunMPMoviePlayBackStateDidChange %d: playing", (int)_player.playbackState);
            break;
            
        case TalkfunMPMoviePlaybackStatePaused:
            NSLog(@"TalkfunMPMoviePlayBackStateDidChange %d: paused", (int)_player.playbackState);
            break;
            
        case TalkfunMPMoviePlaybackStateInterrupted:
            NSLog(@"TalkfunMPMoviePlayBackStateDidChange %d: interrupted", (int)_player.playbackState);
            break;
            
        case TalkfunMPMoviePlaybackStateSeekingForward:
        case TalkfunMPMoviePlaybackStateSeekingBackward: {
            NSLog(@"TalkfunMPMoviePlayBackStateDidChange %d: seeking", (int)_player.playbackState);
            break;
        }
            
        default: {
            NSLog(@"TalkfunMPMoviePlayBackStateDidChange %d: unknown", (int)_player.playbackState);
            break;
        }
    }
}

#pragma Install Notifiacation

- (void)installMovieNotificationObservers {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadStateDidChange:)
                                                 name:TalkfunMPMoviePlayerLoadStateDidChangeNotification
                                               object:_player];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackFinish:)
                                                 name:TalkfunMPMoviePlayerPlaybackDidFinishNotification
                                               object:_player];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(mediaIsPreparedToPlayDidChange:)
                                                 name:TalkfunMPMoviePlaybackIsPreparedToPlayDidChangeNotification
                                               object:_player];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackStateDidChange:)
                                                 name:TalkfunMPMoviePlayerPlaybackStateDidChangeNotification
                                               object:_player];
    
}


- (void)removeMovieNotificationObservers {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:TalkfunMPMoviePlayerLoadStateDidChangeNotification
                                                  object:_player];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:TalkfunMPMoviePlayerPlaybackDidFinishNotification
                                                  object:_player];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:TalkfunMPMoviePlaybackIsPreparedToPlayDidChangeNotification
                                                  object:_player];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:TalkfunMPMoviePlayerPlaybackStateDidChangeNotification
                                                  object:_player];
}


- (IBAction)switchOrientation:(UIButton *)sender {
    
    
    [APPLICATION sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    
    [self reloadInputViews];
    if (APPLICATION.statusBarOrientation == UIInterfaceOrientationPortrait) {
        [self orientationLandscape];
    }else
    {
        [self orientationPortrait];
    }

    
}
- (IBAction)exit:(id)sender {
    [self.timer invalidate];
    self.timer = nil;
    [self removeMovieNotificationObservers];
    [self.player stop];
    [self.player shutdown];
  


    self.player = nil;
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSTimer * )timer
{
    if (_timer ==nil) {
        _timer = [[NSTimer alloc]init];
        
    }
    return _timer;
}


#pragma mark - 旋转
- (BOOL)shouldAutorotate
{
    
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    if (APPLICATION.statusBarOrientation == UIInterfaceOrientationLandscapeRight) {
        return UIInterfaceOrientationMaskLandscapeRight;
    }
    if (APPLICATION.statusBarOrientation == UIInterfaceOrientationPortrait) {
        return UIInterfaceOrientationMaskPortrait;
    }
    return UIInterfaceOrientationMaskPortrait;
}
//坚屏
- (void)orientationPortrait
{
    UIColor * color = self.VideoView.backgroundColor;
    self.VideoView.backgroundColor = [UIColor blackColor];
    [UIView animateWithDuration:1 animations:^{
    //如果现在的statusBar不是竖直方向就旋转
    if (APPLICATION.statusBarOrientation != UIInterfaceOrientationPortrait) {
        [APPLICATION setStatusBarOrientation:UIInterfaceOrientationPortrait animated:YES];
        self.view.transform = CGAffineTransformRotate(self.view.transform, - M_PI_2);
        //记得方向
        self.isFirst = NO;
    }
    self.view.bounds = CGRectMake(0, 0, ScreenSize.width, ScreenSize.height);
 // self.VideoView.frame = CGRectMake(0, 0, ScreenSize.width, ScreenSize.height);

          self.player.view.frame = CGRectMake(0, 0, ScreenSize.width, ScreenSize.height);
    } completion:^(BOOL finished) {
        self.VideoView.backgroundColor = color;
      }];
      self.player.currentPlaybackTime = self.ProgressBar.value+1;
     self.player.currentPlaybackTime = self.ProgressBar.value+1;
}


#pragma mark - 横屏的适配
- (void)orientationLandscape
{
  
    
    UIColor * color = self.VideoView.backgroundColor;
    self.VideoView.backgroundColor = [UIColor blackColor];
    [UIView animateWithDuration:1 animations:^{
    //如果现在的statusBar是竖直方向就旋转
    if (APPLICATION.statusBarOrientation == UIInterfaceOrientationPortrait) {
        [APPLICATION setStatusBarOrientation:UIInterfaceOrientationLandscapeRight animated:YES];
        
        self.view.transform = CGAffineTransformRotate(self.view.transform, M_PI_2);
        
        //记得方向
        self.isFirst = YES;
    }
    
    self.view.bounds = CGRectMake(0, 0, ScreenSize.width, ScreenSize.height);
  
    double version = [[UIDevice currentDevice].systemVersion doubleValue];
    if (version < 8.0) {
        self.view.bounds = CGRectMake(0, 0, ScreenSize.height, ScreenSize.width);
    }
    
   self.player.view.frame = CGRectMake(0, 0, ScreenSize.width, ScreenSize.height);
     self.player.currentPlaybackTime = self.ProgressBar.value+1;
          self.player.currentPlaybackTime = self.ProgressBar.value+1;
    } completion:^(BOOL finished) {
        self.VideoView.backgroundColor = color;
   
      }];
}

- (NSString *)stringWithTime:(NSTimeInterval)Time
{
    NSString *name = @"";
    
    int hour = (int)Time/3600%24;
    int minute = (int)Time/60%60;
    int sec = (int)Time%60;
    
    
    if(hour>0){
        
        if (hour<10) {
            name = [NSString stringWithFormat:@"%02d:%2d:%2d",hour,minute,sec];
        }else{
            name = [NSString stringWithFormat:@"%2d:%2d:%2d",hour,minute,sec];
        }
    }
    else
    {
        if (minute>0) {
            
            if (sec<10) {
                name = [NSString stringWithFormat:@"%2d:%02d",minute,sec];
            }else{
                name = [NSString stringWithFormat:@"%2d:%2d",minute,sec];
            }
            
        }else
        {
            
            if (sec<10) {
                name = [NSString stringWithFormat:@"%2d:%02d",minute,sec];
            }else{
                name = [NSString stringWithFormat:@"%2d:%2d",minute,sec];
            }
            
            
        }
        
        
    }
    
    return [NSString stringWithFormat:@"%@", name];
}

@end
