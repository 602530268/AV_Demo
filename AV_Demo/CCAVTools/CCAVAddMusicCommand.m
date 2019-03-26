//
//  CCAVAddMusicCommand.m
//  AV_Demo
//
//  Created by chencheng on 2019/3/25.
//  Copyright © 2019年 chen. All rights reserved.
//

#import "CCAVAddMusicCommand.h"

@implementation CCAVAddMusicCommand

- (void)performWithAsset:(AVAsset *)asset context:(NSDictionary *)context {
    //statement
    AVAssetTrack *assetVideoTrack = nil;
    AVAssetTrack *assetAudioTrack = nil;
    
    //step1 insert
    if ([[asset tracksWithMediaType:AVMediaTypeVideo] count] != 0) {
        assetVideoTrack = [asset tracksWithMediaType:AVMediaTypeVideo][0];
    }
    if ([[asset tracksWithMediaType:AVMediaTypeAudio] count] != 0) {
        assetAudioTrack = [asset tracksWithMediaType:AVMediaTypeAudio][0];
    }
    [self insertAssetForCompositionWith:asset context:context insertVideo:YES insertAudio:YES];
    
    //step2 insert music
    NSString *audioPath = [[NSBundle mainBundle] pathForResource:@"music.wav" ofType:nil];
    AVAsset *audioAsset = [[AVURLAsset alloc] initWithURL:[NSURL fileURLWithPath:audioPath] options:nil];
    AVAssetTrack *newAudioTrack = [audioAsset tracksWithMediaType:AVMediaTypeAudio][0];

    NSError *error = nil;
    AVMutableCompositionTrack *customAudioTrack = [self.mutableComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    [customAudioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, self.mutableComposition.duration) ofTrack:newAudioTrack atTime:kCMTimeZero error:&error];
    if (error) {
        NSLog(@"插入配音失败: %@",error);
    }
    
    AVMutableAudioMixInputParameters *mixParameters = [AVMutableAudioMixInputParameters audioMixInputParametersWithTrack:customAudioTrack];
    [mixParameters setVolumeRampFromStartVolume:1 toEndVolume:0 timeRange:CMTimeRangeMake(kCMTimeZero, self.mutableComposition.duration)];
    
    self.mutableAudioMix = [AVMutableAudioMix audioMix];
    self.mutableAudioMix.inputParameters = @[mixParameters];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:CCAVEditCommandCompletionNotification object:self];
}

@end
