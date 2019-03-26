//
//  PlayerVC.m
//  AV_Demo
//
//  Created by chencheng on 2019/3/13.
//  Copyright © 2019年 chen. All rights reserved.
//

#import "PlayerVC.h"
#import "CCPlayerView.h"
#import "CCPlayer.h"
#import "AppDelegate.h"

@interface PlayerVC ()

@property(nonatomic,strong) CCPlayerView *playerView;
@property(nonatomic,strong) CCPlayer *player;
@property(nonatomic,strong) NSURL *fileURL;

@end

@implementation PlayerVC

#pragma mark - Life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createUI];
    
    /*
     
     
     https://blog.csdn.net/weixin_41010198/article/details/88055078#URL_8
     
     http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4
     http://vjs.zencdn.net/v/oceans.mp4
     
     MP3:
     http://www.170mv.com/kw/other.web.nm01.sycdn.kuwo.cn/resource/n1/31/10/1763161771.mp3
     */
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"Movie.m4v" ofType:nil];
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"陶喆-寂寞的季节.mp4" ofType:nil];
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"陈奕迅-单车.mp3" ofType:nil];
    
//    NSString *urlString = @"http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4";
//    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
//    self.fileUrl = [NSURL URLWithString:urlString];
    
    if (self.playerItem) {
        [self.player replacePlayerItemWith:self.playerItem];
    }else {
        if (!self.path) {
            self.path = [[NSBundle mainBundle] pathForResource:@"Movie.m4v" ofType:nil];
        }
        self.fileURL = [NSURL fileURLWithPath:self.path];
    }
}

#pragma mark - PlayerView Event Block
- (void)playerViewBlockCallback {
    __weak typeof(self) weakSelf = self;
    self.playerView.backBtnEventBlock = ^{
        if (weakSelf.playerView.isFullSceen)
            [weakSelf changeVideoSizeWith:NO];
        else
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
    };
    self.playerView.playBtnEventBlock = ^{
        [weakSelf.player playOrPause];
    };
    self.playerView.progressEventBlock = ^(CGFloat value) {
        
    };
    self.playerView.fullScreenBtnEventBlock = ^(BOOL fullScreen) {
        [weakSelf changeVideoSizeWith:fullScreen];
    };
    self.playerView.sliderEventBlock = ^(CGFloat value) {
        [weakSelf.player jumpProgressByTime:value];
        [weakSelf.playerView hideOrShowSubViews:NO];
    };
    self.playerView.singleTapEventBlock = ^{
        [weakSelf.playerView hideOrShowSubViews:YES];
    };
    self.playerView.doubleTapEventBlock = ^{
        [weakSelf.player playOrPause];
        [weakSelf.playerView hideOrShowSubViews:NO];
    };
}

#pragma mark - Player BLock
- (void)playerBlockCallback {
    __weak typeof(self) weakSelf = self;
    self.player.playBlock = ^{
        NSLog(@"开始播放");
        weakSelf.playerView.playing = YES;
        [weakSelf.playerView hideOrShowSubViews:NO];
    };
    self.player.pauseBlock = ^{
        NSLog(@"暂停播放");
        weakSelf.playerView.playing = NO;
    };
    self.player.finishBlock = ^{
        NSLog(@"播放完成");
        weakSelf.playerView.playing = NO;
    };
    self.player.progressBlock = ^(CGFloat progress, CGFloat currentTime, CGFloat totalTime) {
//        NSLog(@"播放进度: %.2f,当前秒:%.2f,总时长:%.2f",progress,currentTime,totalTime);
        [weakSelf.playerView updatePlayProgressWith:progress currentTime:currentTime totalTime:totalTime];
    };
    self.player.bufferBlock = ^(CGFloat progress) {
        NSLog(@"缓冲进度: %.2f",progress);
    };
    self.player.readyForDisplay = ^{
        [weakSelf.player play];
    };
}

#pragma mark - UI
- (void)createUI {
    self.view.backgroundColor = [UIColor whiteColor];

    _playerView = [[CCPlayerView alloc] init];
    _playerView.navBarHeight = StateBarAndNavBarHeight;
    [self.view addSubview:_playerView];
    [_playerView smallScreenLayout];
    
    [self playerViewBlockCallback];
}

- (CCPlayer *)player {
    if (!_player) {
        [self createCCPlayer];
    }
    return _player;
}

- (void)createCCPlayer {
    NSLog(@"create ccplayer by %@",self.fileURL.path);
    _player = [[CCPlayer alloc] initWithURL:self.fileURL];
    _player.containerView = self.playerView.containerView;
    [self playerBlockCallback];
    
    self.playerView.headerView.titleLbl.text = self.fileURL.path.lastPathComponent;
}

#pragma mark - APIs (private)
- (void)changeVideoSizeWith:(BOOL)fullScreen {
    
    /*
     这里要注意修改约束要在强制横屏之前，因为强制横屏之后，屏幕宽高就会调转，在修改约束的时候就会有误，
     所以先修改约束，横屏后系统会自动进行转换
     */
    if (fullScreen) {
        [self.playerView fullScreenLayout];
    }else {
        [self.playerView smallScreenLayout];
    }
    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.allowRotation = fullScreen;
    [self.player updatePlayerLayerFrame];
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

- (void)dealloc {
    NSLog(@"dealloc: %@",[self class]);
}

@end
