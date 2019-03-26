//
//  CCAVCommand.m
//  AV_Demo
//
//  Created by chencheng on 2019/3/22.
//  Copyright © 2019年 chen. All rights reserved.
//

#import "CCAVCommand.h"

@implementation CCAVCommand

- (instancetype)initWithComposition:(AVMutableComposition *)composition videoComposition:(AVMutableVideoComposition *)videoComposition audioMix:(AVMutableAudioMix *)audioMix {
    if (self = [super init]) {
        self.mutableComposition = composition;
        self.mutableVideoComposition = videoComposition;
        self.mutableAudioMix = audioMix;
    }
    return self;
}

- (void)performWithAsset:(AVAsset *)asset context:(NSDictionary *)context {
    [self doesNotRecognizeSelector:_cmd];
}

- (void)insertAssetForCompositionWith:(AVAsset *)asset context:(NSDictionary *)context insertVideo:(BOOL)insertVideo insertAudio:(BOOL)insertAudio {
    CGFloat start = [context[@"left"] floatValue];
    CGFloat end = [context[@"right"] floatValue];
    
    self.mutableComposition = [AVMutableComposition composition];
    
    AVAssetTrack *assetVideoTrack = nil;
    AVAssetTrack *assetAudioTrack = nil;
    
    if (insertVideo && [[asset tracksWithMediaType:AVMediaTypeVideo] count] != 0) {
        assetVideoTrack = [asset tracksWithMediaType:AVMediaTypeVideo][0];
    }
    if (insertAudio && [[asset tracksWithMediaType:AVMediaTypeAudio] count] != 0) {
        assetAudioTrack = [asset tracksWithMediaType:AVMediaTypeAudio][0];
    }
    
    double startDuration = CMTimeGetSeconds(asset.duration) * start;
    double endDuration = CMTimeGetSeconds(asset.duration) * (end - start);
    
    CGFloat nominalFrameRate = assetVideoTrack.nominalFrameRate;
    
    CMTime startTime = CMTimeMakeWithSeconds(startDuration, nominalFrameRate);
    CMTime endTime = CMTimeMakeWithSeconds(endDuration, nominalFrameRate);
    
    NSError *error = nil;
    if (insertVideo &&assetVideoTrack != nil) {
        AVMutableCompositionTrack *compositionVideoTrack = [self.mutableComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
        [compositionVideoTrack insertTimeRange:CMTimeRangeMake(startTime, endTime) ofTrack:assetVideoTrack atTime:kCMTimeZero error:&error];
        if (error) {
            NSLog(@"video插入失败: %@",error);
        }
        error = nil;
    }
    if (insertAudio && assetAudioTrack != nil) {
        AVMutableCompositionTrack *compositionAudioTrack = [self.mutableComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
        [compositionAudioTrack insertTimeRange:CMTimeRangeMake(startTime, endTime) ofTrack:assetAudioTrack atTime:kCMTimeZero error:&error];
        if (error) {
            NSLog(@"audio插入失败: %@",error);
        }
        error = nil;
    }
}

@end
