//
//  CCPlayer.m
//  AV_Demo
//
//  Created by chencheng on 2019/3/13.
//  Copyright © 2019年 chen. All rights reserved.
//

#import "CCPlayer.h"

static CGFloat const playerProgressTime = 1.f;    //隔多久监听播放进度
static NSString *const kObserveOfPlayItemStatus = @"player.currentItem.status";
static NSString *const kObserveOfPlayItemLoadedTimeRanges = @"player.currentItem.loadedTimeRanges";
static NSString *const kObserVeOfPlayerReadyForDisplay = @"playerLayer.readyForDisplay";

static void *CCPlayerLayerItemStatusContext = &CCPlayerLayerItemStatusContext;
static void *CCPlayerLayerReadyForDisplay = &CCPlayerLayerReadyForDisplay;

@interface CCPlayer ()

@property(nonatomic,assign) CGFloat nominalFrameRate; //视频帧率
@property(nonatomic,strong) AVPlayerItem *currentItem;
@property(nonatomic,strong) id playProgressObserver; //播放进度监听对象

@end

@implementation CCPlayer

#pragma mark - Init
- (instancetype)initWithPath:(NSString *)path {
    NSURL *url = [NSURL fileURLWithPath:path];
    return [self initWithURL:url];
}

- (instancetype)initWithUrlString:(NSString *)urlString {
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *url = [NSURL URLWithString:urlString];
    return [self initWithURL:url];
}

- (instancetype)initWithURL:(NSURL *)url {
    if (self = [super init]) {
        self.fileURL = url;
        _videoGravity = AVLayerVideoGravityResizeAspect;
        [self initializedPlayerWith:url];
    }
    return self;
}

#pragma mark - API (public)
- (void)playOrPause {
    if (self.status == CCPlayerStatusPlaying) {
        [self pause];
    }else {
        [self play];
    }
}

- (void)play {
    if (_player && _player.rate == 0) {
        [_player play];
        [self callbackWith:CCPlayerStatusPlaying];
    }
}

- (void)pause {
    if (_player && _player.rate != 0) {
        [_player pause];
        [self callbackWith:CCPlayerStatusPause];
    }
}

- (void)jumpProgressBySeconds:(CGFloat)value {
    if (_playerLayer == nil) return;
    CMTime time = CMTimeMakeWithSeconds(value * CMTimeGetSeconds(_player.currentItem.duration), _player.currentItem.currentTime.timescale);
    [self.player seekToTime:time];
}

- (void)jumpProgressByTime:(CGFloat)value {
    if (_playerLayer == nil) return;
    CGFloat timeScale = self.nominalFrameRate != 0 ? self.nominalFrameRate : 15.f;
    CMTime time = CMTimeMakeWithSeconds(value * CMTimeGetSeconds(_player.currentItem.duration), timeScale);
    [self.player seekToTime:time toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
}

- (void)updatePlayerLayerFrame {
    //第一次设置frame的时候禁止动画效果
    if (CGRectEqualToRect(self.playerLayer.frame, CGRectZero)) {
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        self.playerLayer.frame = self.containerView.bounds;
        [CATransaction commit];
    }else
        self.playerLayer.frame = self.containerView.bounds;
}

- (void)replacePlayerItemWith:(AVPlayerItem *)playerItem {
    [self removeObserver];
    _asset = playerItem.asset;
    AVAssetTrack *videoTrack = [[self.asset tracksWithMediaType:AVMediaTypeVideo] firstObject];
    self.nominalFrameRate = videoTrack.nominalFrameRate;
    [self.player replaceCurrentItemWithPlayerItem:playerItem];
    self.currentItem = playerItem;
    [self addObserver];
}

- (void)replacePlayerItemWithURL:(NSURL *)url {
    [self removeObserver];
    self.fileURL = url;
    [self asset];
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:url];
    [self.player replaceCurrentItemWithPlayerItem:playerItem];
    [self addObserver];
}

#pragma mark - APIs (private)
- (void)initializedPlayerWith:(NSURL *)url {
    [self asset];
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:url];    //资源管理器
    _player = [AVPlayer playerWithPlayerItem:playerItem];
    
    _playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
    _playerLayer.videoGravity  = _videoGravity;
    self.currentItem = _player.currentItem;
    NSLog(@"player: %@",self.player);

    [self addObserver];
    [self addObserveOfProgress];
}

- (void)addObserver {
    [self addObserverOfPlayerItem];
    [self addObserveOfPlayerFinish];
}

- (void)removeObserver {
    [self removeObserveOfPlayerItem];
    [self removeObserveOfPlayerFinish];
}

- (void)callbackWith:(CCPlayerStatus)status {
    _status = status;
    switch (status) {
        case CCPlayerStatusDidNotPlay:
            break;
        case CCPlayerStatusPlaying:
            if (self.playBlock) {
                self.playBlock();
            }
            break;
        case CCPlayerStatusPause:
            if (self.pauseBlock) {
                self.pauseBlock();
            }
            break;
        case CCPlayerStatusFinish:
            if (self.finishBlock) {
                self.finishBlock();
            }
            break;
        default:
            break;
    }
}

#pragma mark - Setter/Getter
/*
 视频填充模式
 AVLayerVideoGravityResizeAspect    默认，按视频比例显示，直到宽或高占满，未达到的地方显示父视图
 AVLayerVideoGravityResizeAspectFill    按原比例显示视频，直到两边屏幕占满，但视频部分内容可能无法显示
 AVLayerVideoGravityResize  按父视图尺寸显示，可能与原视频比例不同
 */
- (void)setVideoGravity:(AVLayerVideoGravity)videoGravity {
    if (!_playerLayer) return;
    _playerLayer.videoGravity = videoGravity;
}

- (void)setFileURL:(NSURL *)fileURL {
    _fileURL = fileURL;
}

- (void)setContainerView:(UIView *)containerView {
    [self.playerLayer removeFromSuperlayer];
    _containerView = containerView;
    [_containerView.layer addSublayer:self.playerLayer];
    [self updatePlayerLayerFrame];
}

- (AVAsset *)asset {
    if (!self.fileURL) {
        NSLog(@"fileURL can not be nil");
        return nil;
    };
    _asset = [[AVURLAsset alloc] initWithURL:self.fileURL options:nil];
    NSArray *assetKeysToLoadAndTest = @[@"playable"];   //@[@"playable", @"composable", @"tracks", @"duration"]
    [_asset loadValuesAsynchronouslyForKeys:assetKeysToLoadAndTest completionHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"asset load finish.");
        });
    }];
    AVAssetTrack *videoTrack = [[_asset tracksWithMediaType:AVMediaTypeVideo] firstObject];
    self.nominalFrameRate = videoTrack.nominalFrameRate;
    return _asset;
}

#pragma mark - Observer
- (void)addObserverOfPlayerItem {
    [self addObserver:self forKeyPath:kObserveOfPlayItemStatus options:NSKeyValueObservingOptionNew context:CCPlayerLayerItemStatusContext];    //开始或暂停
    [self addObserver:self forKeyPath:kObserveOfPlayItemLoadedTimeRanges options:NSKeyValueObservingOptionNew context:CCPlayerLayerItemStatusContext];  //缓存进度
    [self addObserver:self forKeyPath:kObserVeOfPlayerReadyForDisplay options:NSKeyValueObservingOptionNew context:CCPlayerLayerReadyForDisplay];
}

- (void)removeObserveOfPlayerItem {
    @try {
        [self removeObserver:self forKeyPath:kObserveOfPlayItemStatus context:CCPlayerLayerItemStatusContext];
        [self removeObserver:self forKeyPath:kObserveOfPlayItemLoadedTimeRanges context:CCPlayerLayerItemStatusContext];
        [self removeObserver:self forKeyPath:kObserVeOfPlayerReadyForDisplay context:CCPlayerLayerReadyForDisplay];
    } @catch (NSException *exception) {
        NSLog(@"多次移除观察者引发crash事件");
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (context == CCPlayerLayerItemStatusContext) {
        AVPlayerItem *playerItem = [[object player] currentItem];
        if ([keyPath isEqualToString:kObserveOfPlayItemStatus]) {
            AVPlayerStatus status = [[change valueForKey:@"new"] integerValue];
            if (status == AVPlayerStatusReadyToPlay) {
                CGFloat totalTime = CMTimeGetSeconds(playerItem.duration);
                NSLog(@"开始播放，视频总长度为: %02f",totalTime);
            }else {
                NSLog(@"视频status显示不正常，当前状态为: %ld",status);
            }
        }else if ([keyPath isEqualToString:kObserveOfPlayItemLoadedTimeRanges]) {
            NSArray *array = playerItem.loadedTimeRanges;
            //本次缓存时间范围
            CMTimeRange timeRange = [array.firstObject CMTimeRangeValue];
            CGFloat startSeconds = CMTimeGetSeconds(timeRange.start);
            CGFloat durationSecond = CMTimeGetSeconds(timeRange.duration);
            CGFloat totalTime = CMTimeGetSeconds(playerItem.duration);
            //缓存总长度
            NSTimeInterval totalBuffer = startSeconds + durationSecond;
            CGFloat bufferProgress = totalBuffer / totalTime;
            if (_bufferBlock) {
                _bufferBlock(bufferProgress);
            }
        }
    }else if (context == CCPlayerLayerReadyForDisplay) {
        NSLog(@"playerLayer ready for display");
        if (self.readyForDisplay) self.readyForDisplay();
        [self updatePlayerLayerFrame];
    }
}

- (void)addObserveOfProgress {
//    AVPlayerItem *playerItem = _player.currentItem;
//    if (playerItem == nil) return;
    
    //先移除上一个视频的监听
    if (_playProgressObserver) {    // && self.player.rate == 1.f
        [_player removeTimeObserver:_playProgressObserver];
    }
    
    //每隔一段时间监听播放进度
    __weak typeof(self) weakSelf = self;
    /*
     CMTimeMake(value,timeScale):
     value表示第几帧，timeScale表示帧率，即每秒多少帧
     CMTimeMake(1,10):第一帧，帧率为每秒10帧，转换为时间公式:value/timeScale,即1/10=0.1,表示在视频的0.1秒时刻
     CMTimeMakeWithSeconds的第一个参数可以使float，其他都一样,不过因为这个比较好用，所以我一般用这个
     */
    _playProgressObserver = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(playerProgressTime, playerProgressTime) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        AVPlayerItem *playerItem = weakSelf.currentItem;
        if (!playerItem) return;
        CGFloat currentTime = CMTimeGetSeconds(time);
        CGFloat totalTime = CMTimeGetSeconds(playerItem.duration);
        if (currentTime > 0) {
            CGFloat playerProgress = currentTime / totalTime;
            if (weakSelf.progressBlock) {
                weakSelf.progressBlock(playerProgress, currentTime, totalTime);
            }
        }
    }];
}

//播放完成通知
- (void)addObserveOfPlayerFinish {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playFinishNotify) name:AVPlayerItemDidPlayToEndTimeNotification object:_player.currentItem];
}

- (void)playFinishNotify {
    [self callbackWith:CCPlayerStatusFinish];
}

- (void)removeObserveOfPlayerFinish {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
}

#pragma mark - dealloc
- (void)dealloc {
    [self removeObserver];
    if (_playProgressObserver) {
        [_player removeTimeObserver:_playProgressObserver];
    }
    self.currentItem = nil;
    self.player = nil;
    [self.playerLayer removeFromSuperlayer];
    self.playerLayer = nil;
    self.containerView = nil;
    NSLog(@"dealloc: %@",[self class]);
}

@end
