//
//  VideoEditVC.m
//  AV_Demo
//
//  Created by chencheng on 2019/3/21.
//  Copyright © 2019年 chen. All rights reserved.
//

#import "VideoEditVC.h"
#import "CCPlayerView.h"
#import "CCPlayer.h"
#import "CCEditView.h"
#import "PlayerVC.h"

#import "CCAVTrimCommand.h"
#import "CCAVCropCommand.h"
#import "CCAVRotateCommand.h"
#import "CCAVAddMusicCommand.h"
#import "CCAVAddWaterMarkCommand.h"
#import "CCAVExportCommand.h"
#import "CCAVTool.h"

#import "CCAlterController.h"
#import "SVProgressHUD+CCAdd.h"

@interface VideoEditVC ()

@property(nonatomic,strong) CCEditView *editView;
@property(nonatomic,strong) CCPlayer *player;

@end

@implementation VideoEditVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    if (!self.fileURL) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"Movie.m4v" ofType:nil];
//        NSString *path = [[NSBundle mainBundle] pathForResource:@"qq.mp4" ofType:nil];
        self.fileURL = [NSURL fileURLWithPath:path];
//        self.fileURL = [NSURL URLWithString:@"http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4"];
    }
    
    _editView = [[CCEditView alloc] init];
    [self.view addSubview:_editView];
    [_editView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(StateBarAndNavBarHeight, 0, 0, 0));
    }];
    
    _player = [[CCPlayer alloc] initWithURL:self.fileURL];
    _player.containerView = self.editView.containerView;
    
    [self editViewBlockCallback];
    [self playerBlockCallback];
    
    [CCAVTool obtainVideoFrameWith:self.player.asset success:^(UIImage * _Nonnull image, NSInteger index) {
        [self.editView.trimView updateImageFramesWith:image index:index];
    } fail:^{
        
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(editCommandCompletionNotificationReceiver:) name:CCAVEditCommandCompletionNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(exportCommandCompletionNotificationReceiver:) name:CCAVExportCommandCompletionNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.player pause];
}

#pragma mark - Player BLock
- (void)playerBlockCallback {
    __weak typeof(self) weakSelf = self;
    self.player.playBlock = ^{
        NSLog(@"开始播放");
    };
    self.player.pauseBlock = ^{
        NSLog(@"暂停播放");
    };
    self.player.finishBlock = ^{
        NSLog(@"播放完成");
        [weakSelf.player jumpProgressByTime:0];
    };
    self.player.progressBlock = ^(CGFloat progress, CGFloat currentTime, CGFloat totalTime) {
    };
}

#pragma mark - PlayerView Event Block
- (void)editViewBlockCallback {
    __weak typeof(self) weakSelf = self;
    self.editView.backBtnEventBlock = ^{
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    };
    self.editView.playBtnEventBlock = ^{
        [weakSelf.player playOrPause];
    };
    
    self.editView.startOrCancelEditVideoBlock = ^{
        [weakSelf.player updatePlayerLayerFrame];
    };
    self.editView.trimDragBarBlock = ^(CGFloat value) {
        [weakSelf.player jumpProgressByTime:value];
    };
    self.editView.saveTheChangesBlock = ^(id  _Nonnull context) {
        [weakSelf.player updatePlayerLayerFrame];
        [weakSelf editWith:context];
        NSLog(@"context: %@",context);
    };
}

#pragma mark - APIs (private)
- (void)editWith:(NSDictionary *)context {
    int tag = [context[@"tag"] intValue];
    
    CCAVCommand *command = nil;
    switch (tag) {
        case 1:
            command = [[CCAVTrimCommand alloc] init];
            break;
        case 2:
            command = [[CCAVCropCommand alloc] init];
            break;
        case 3:
            command = [[CCAVRotateCommand alloc] init];
            break;
        case 4:
            command = [[CCAVAddMusicCommand alloc] init];
            break;
        case 5:
            command = [[CCAVAddWaterMarkCommand alloc] init];
            break;
        case 6:
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD showWithStatus:@"正在导出..."];
            });
            command = [[CCAVExportCommand alloc] init];
            command.mutableComposition = self.composition;
            command.mutableVideoComposition = self.videoComposition;
            command.mutableAudioMix = self.audioMix;
            [self exportWillBegin];
            break;
        default:
            break;
    }
    [command performWithAsset:self.player.asset context:context];
}

#pragma mark - Notification
- (void)editCommandCompletionNotificationReceiver:(NSNotification *)notification {
    if ([notification.name isEqualToString:CCAVEditCommandCompletionNotification]) {
        NSLog(@"editCommandCompletionNotificationReceiver");
        self.composition = [[notification object] mutableComposition];
        self.videoComposition = [[notification object] mutableVideoComposition];
        self.audioMix = [[notification object] mutableAudioMix];
        self.watermarkLayer = [[notification object] watermarkLayer];

        if (self.watermarkLayer) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD showWithStatus:@"正在导出..."];
            });
            CCAVExportCommand *command = [[CCAVExportCommand alloc] init];
            command.mutableComposition = self.composition;
            command.mutableVideoComposition = self.videoComposition;
            command.mutableAudioMix = self.audioMix;
            command.outputByWatermark = YES;
            [self exportWillBegin];
            [command performWithAsset:self.player.asset context:nil];
        }else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self editCompletionCallback];
            });
        }
    }
}

- (void)exportCommandCompletionNotificationReceiver:(NSNotification *)notification {
    dispatch_async(dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
        BOOL outputByWatermark = [[notification object] outputByWatermark];
        NSString *outputPath = [[notification object] outputPath];
        if (outputByWatermark) {
            if (outputPath) {
                [self previewTheNewVideo:outputPath];
            }
        }else {
            [CCAlterController showWithTitle:nil
                                     message:@"导出成功"
                                       style:nil
                                actionTitles:@[@"预览视频",@"好的"]
                                actionStyles:nil target:self handlers:^(NSInteger index) {
                                    if (index == 0) {
                                        if (outputPath) {
                                            [self previewTheNewVideo:outputPath];
                                        }
                                    }
                                }];
        }
    });
}

- (void)editCompletionCallback {
    [CCAlterController showWithTitle:nil
                             message:@"视音频编辑完成"
                               style:nil
                        actionTitles:@[@"预览",@"导出到相册",@"好的"]
                        actionStyles:nil
                              target:self handlers:^(NSInteger index) {
                                  if (index == 0)
                                      [self previewTheNewVideo:nil];
                                  else if (index == 1)
                                      [self exportTheNewVideo];
                              }];
}

- (void)previewTheNewVideo:(NSString *)path {
    self.videoComposition.animationTool = NULL; //处理后的视频需要刷新player
    
    PlayerVC *vc = [[PlayerVC alloc] init];
    if (path) {
        vc.path = path;
    }else {
        AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:self.composition];
        playerItem.videoComposition = self.videoComposition;
        playerItem.audioMix = self.audioMix;
        vc.playerItem = playerItem;

        CGFloat totalTime = CMTimeGetSeconds(playerItem.duration);
        NSLog(@"编辑后视频时长为: %02fs",totalTime);
    }
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)exportTheNewVideo {
    dispatch_async(dispatch_get_main_queue(), ^{
        [SVProgressHUD showWithStatus:@"正在导出..."];
    });
    CCAVExportCommand *command = [[CCAVExportCommand alloc] init];
    command.mutableComposition = self.composition;
    command.mutableVideoComposition = self.videoComposition;
    command.mutableAudioMix = self.audioMix;
    [self exportWillBegin];
    command.writeToPhotoLibrary = YES;
    [command performWithAsset:self.player.asset context:nil];
}

- (void)updatePlayerView {
    self.videoComposition.animationTool = NULL; //处理后的视频需要刷新player

    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:self.composition];
    playerItem.videoComposition = self.videoComposition;
    playerItem.audioMix = self.audioMix;

    if (self.watermarkLayer) {
        if (self.watermarkLayer.superlayer == nil)
            [self.player.containerView.layer addSublayer:self.watermarkLayer];
        self.watermarkLayer.position = CGPointMake([self.player.containerView bounds].size.width/2, [self.player.containerView bounds].size.height/2);
    }else {
        CGFloat totalTime = CMTimeGetSeconds(playerItem.duration);
        NSLog(@"编辑后视频时长为: %02fs",totalTime);
        PlayerVC *vc = [[PlayerVC alloc] init];
        vc.playerItem = playerItem;
        //    vc.watermarkLayer = self.watermarkLayer;
        [self presentViewController:vc animated:YES completion:nil];
    }
}

- (void)exportWillBegin {
    if (self.watermarkLayer) {
        CALayer *exportWatermarkLayer = [self copyWatermarkLayer:self.watermarkLayer];
        CALayer *parentLayer = [CALayer layer];
        CALayer *videoLayer = [CALayer layer];
        parentLayer.frame = CGRectMake(0, 0, self.videoComposition.renderSize.width, self.videoComposition.renderSize.height);
        videoLayer.frame = CGRectMake(0, 0, self.videoComposition.renderSize.width, self.videoComposition.renderSize.height);
        [parentLayer addSublayer:videoLayer];
        exportWatermarkLayer.position = CGPointMake(self.videoComposition.renderSize.width/2, self.videoComposition.renderSize.height/2);
        [parentLayer addSublayer:exportWatermarkLayer];
        self.videoComposition.animationTool = [AVVideoCompositionCoreAnimationTool videoCompositionCoreAnimationToolWithPostProcessingAsVideoLayer:videoLayer inLayer:parentLayer];
    }
}

- (CALayer*)copyWatermarkLayer:(CALayer*)inputLayer {
    CALayer *exportWatermarkLayer = [CALayer layer];
    CATextLayer *titleLayer = [CATextLayer layer];
    CATextLayer *inputTextLayer = [inputLayer sublayers][0];
    titleLayer.string = inputTextLayer.string;
    titleLayer.foregroundColor = inputTextLayer.foregroundColor;
    titleLayer.font = inputTextLayer.font;
    titleLayer.shadowOpacity = inputTextLayer.shadowOpacity;
    titleLayer.alignmentMode = inputTextLayer.alignmentMode;
    titleLayer.bounds = inputTextLayer.bounds;
    
    [exportWatermarkLayer addSublayer:titleLayer];
    return exportWatermarkLayer;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"dealloc: %@",[self class]);
}

@end

