//
//  CCAVAddWaterMarkCommand.m
//  AV_Demo
//
//  Created by chencheng on 2019/3/25.
//  Copyright © 2019年 chen. All rights reserved.
//

#import "CCAVAddWaterMarkCommand.h"

@implementation CCAVAddWaterMarkCommand

- (void)performWithAsset:(AVAsset *)asset context:(NSDictionary *)context {
    //statement
    AVAssetTrack *assetVideoTrack = nil;
    AVAssetTrack *assetAudioTrack = nil;

    CGSize videoSize;
    
    //step1 insert
    if ([[asset tracksWithMediaType:AVMediaTypeVideo] count] != 0) {
        assetVideoTrack = [asset tracksWithMediaType:AVMediaTypeVideo][0];
    }
    if ([[asset tracksWithMediaType:AVMediaTypeAudio] count] != 0) {
        assetAudioTrack = [asset tracksWithMediaType:AVMediaTypeAudio][0];
    }
    [self insertAssetForCompositionWith:asset context:context insertVideo:YES insertAudio:YES];
    
    //step2
    if (assetVideoTrack) {
        self.mutableVideoComposition = [AVMutableVideoComposition videoComposition];
        self.mutableVideoComposition.frameDuration = CMTimeMake(1, 30); //30 fps
        self.mutableVideoComposition.renderSize = assetVideoTrack.naturalSize;
        
        AVMutableVideoCompositionInstruction *passThroughInstruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
        passThroughInstruction.timeRange = CMTimeRangeMake(kCMTimeZero, self.mutableComposition.duration);
        
        AVAssetTrack *videoTrack = [self.mutableComposition tracksWithMediaType:AVMediaTypeVideo][0];
        AVMutableVideoCompositionLayerInstruction *passThroughLayer = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoTrack];
        
        passThroughInstruction.layerInstructions = @[passThroughLayer];
        self.mutableVideoComposition.instructions = @[passThroughInstruction];
    }
    
    videoSize = self.mutableVideoComposition.renderSize;
    self.watermarkLayer = [self watermarkLayerForSize:videoSize];

    [[NSNotificationCenter defaultCenter] postNotificationName:CCAVEditCommandCompletionNotification object:self];
    NSLog(@"add watermark CCAVEditCommandCompletionNotification");
}

- (CALayer *)watermarkLayerForSize:(CGSize)videoSize {
    CALayer *_watermarkLayer = [CALayer layer];
    
    CATextLayer *titleLayer = [CATextLayer layer];
    titleLayer.string = @"CCAV_WaterMark";
    titleLayer.foregroundColor = [[UIColor whiteColor] CGColor];
    titleLayer.shadowOpacity = 0.5;
    titleLayer.alignmentMode = kCAAlignmentCenter;
    titleLayer.bounds = CGRectMake(0, 0, videoSize.width, videoSize.height/4);
//    titleLayer.backgroundColor = [[UIColor orangeColor]colorWithAlphaComponent:0.3f].CGColor;

    [_watermarkLayer addSublayer:titleLayer];
    return _watermarkLayer;
}

@end
