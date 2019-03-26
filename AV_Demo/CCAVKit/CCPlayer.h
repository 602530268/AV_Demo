//
//  CCPlayer.h
//  AV_Demo
//
//  Created by chencheng on 2019/3/13.
//  Copyright © 2019年 chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CCPlayerStatus) {
    CCPlayerStatusDidNotPlay,   //未播放
    CCPlayerStatusPlaying,  //正在播放
    CCPlayerStatusPause,    //暂停
    CCPlayerStatusFinish,   //播放完成
};

typedef void(^CCMidiaTotalTime)(void); //视频总长度回调
typedef void(^CCPLayCallback)(void);  //播放回调
typedef void(^CCPauseCallback)(void); //暂停回调
typedef void(^CCFinishCallback)(void);    //播放完成回调
typedef void(^CCProgressCallback)(CGFloat progress, CGFloat currentTime, CGFloat totalTime);  //播放进度回调
typedef void(^CCBufferCallback)(CGFloat progress);    //缓冲进度回调，在新建对象后就已经开始缓存了
typedef void(^CCReadyForDisplay)(void);  //画面已渲染到屏幕

@interface CCPlayer : NSObject

- (instancetype)initWithPath:(NSString *)path;
- (instancetype)initWithUrlString:(NSString *)urlString;
- (instancetype)initWithURL:(NSURL *)url;

@property(nonatomic,strong) AVAsset *asset;
@property(nonatomic,strong) AVPlayer *player;   //播放器
@property(nonatomic,strong) AVPlayerLayer *playerLayer; //player需要在playerLayer上才能显示

@property(nonatomic,assign) CCPlayerStatus status;  //播放状态
@property(nonatomic,strong) NSURL *fileURL; //播放源
@property(nonatomic,strong) UIView *containerView; //视频承载view
@property(nonatomic,assign) AVLayerVideoGravity videoGravity; //视频填充模式

#pragma mark - block callback
@property(nonatomic,copy) CCPLayCallback playBlock;
@property(nonatomic,copy) CCPauseCallback pauseBlock;
@property(nonatomic,copy) CCFinishCallback finishBlock;
@property(nonatomic,copy) CCProgressCallback progressBlock;
@property(nonatomic,copy) CCBufferCallback bufferBlock;
@property(nonatomic,copy) CCReadyForDisplay readyForDisplay;

//播放or暂停
- (void)playOrPause;

//播放
- (void)play;

//暂停
- (void)pause;

//跳转进度
- (void)jumpProgressBySeconds:(CGFloat)value;    //间隔为秒
- (void)jumpProgressByTime:(CGFloat)value;  //指定时间，可以精确到帧

//更新playerLayer的frame。当containerView的约束发生变化时，调用该函数
- (void)updatePlayerLayerFrame;

//切换播放源
- (void)replacePlayerItemWith:(AVPlayerItem *)playerItem;
- (void)replacePlayerItemWithURL:(NSURL *)url;


@end
