//
//  CCAVRotateCommand.m
//  AV_Demo
//
//  Created by chencheng on 2019/3/25.
//  Copyright © 2019年 chen. All rights reserved.
//

#import "CCAVRotateCommand.h"

#define degreesToRadians( degrees ) ( ( degrees ) / 180.0 * M_PI )

@implementation CCAVRotateCommand

- (void)performWithAsset:(AVAsset *)asset context:(NSDictionary *)context {    
    //statement
    AVMutableVideoCompositionInstruction *instruction = nil;
    AVMutableVideoCompositionLayerInstruction *layerInstruction = nil;
    CGAffineTransform t1;
    CGAffineTransform t2;
    
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
    
    //step2 rotate
    t1 = CGAffineTransformMakeTranslation(assetVideoTrack.naturalSize.height, 0);
    CGFloat degressToRedians = 90.f / 180.f * M_PI; //旋转弧度
    t2 = CGAffineTransformRotate(t1, degressToRedians);
    
    self.mutableVideoComposition = [AVMutableVideoComposition videoComposition];
    self.mutableVideoComposition.renderSize = CGSizeMake(assetVideoTrack.naturalSize.height, assetVideoTrack.naturalSize.width);
    self.mutableVideoComposition.frameDuration = CMTimeMake(1, 30);
    
    instruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    instruction.timeRange = CMTimeRangeMake(kCMTimeZero, self.mutableComposition.duration);
    layerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:self.mutableComposition.tracks[0]];
    [layerInstruction setTransform:t2 atTime:kCMTimeZero];
    
    instruction.layerInstructions = @[layerInstruction];
    self.mutableVideoComposition.instructions = @[instruction];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:CCAVEditCommandCompletionNotification object:self];
}

@end
