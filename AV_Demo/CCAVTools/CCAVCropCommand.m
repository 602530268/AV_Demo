//
//  CCAVCropCommand.m
//  AV_Demo
//
//  Created by chencheng on 2019/3/25.
//  Copyright © 2019年 chen. All rights reserved.
//

#import "CCAVCropCommand.h"

@implementation CCAVCropCommand

- (void)performWithAsset:(AVAsset *)asset context:(NSDictionary *)context {    
    //statement
    AVMutableVideoCompositionInstruction *instruction = nil;
    AVMutableVideoCompositionLayerInstruction *layerInstruction = nil;
    CGAffineTransform t1;
    
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
    
    //step2 crop with renderSize
    self.mutableVideoComposition = [AVMutableVideoComposition videoComposition];
    self.mutableVideoComposition.renderSize = CGSizeMake(assetVideoTrack.naturalSize.width/2, assetVideoTrack.naturalSize.height/2);
    self.mutableVideoComposition.frameDuration = CMTimeMake(1, 30);
    
    instruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    instruction.timeRange = CMTimeRangeMake(kCMTimeZero, [self.mutableComposition duration]);
    layerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:(self.mutableComposition.tracks)[0]];
    
    t1 = CGAffineTransformMakeTranslation(-1*assetVideoTrack.naturalSize.width/2, -1*assetVideoTrack.naturalSize.height/2);
    [layerInstruction setTransform:t1 atTime:kCMTimeZero];
    
    instruction.layerInstructions = @[layerInstruction];
    self.mutableVideoComposition.instructions = @[instruction];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:CCAVEditCommandCompletionNotification object:self];
}

@end
