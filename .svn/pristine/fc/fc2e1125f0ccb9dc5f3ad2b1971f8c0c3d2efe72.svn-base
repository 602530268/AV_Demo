
//
//  CCAVTool.m
//  AV_Demo
//
//  Created by chencheng on 2019/3/26.
//  Copyright © 2019年 chen. All rights reserved.
//

#import "CCAVTool.h"

@implementation CCAVTool

+ (void)obtainVideoFrameWith:(AVAsset *)asset
                     success:(void(^)(UIImage *image, NSInteger index))success
                        fail:(void(^)(void))fail {
    
//    AVAsset *asset = [AVAsset assetWithURL:self.fileURL];
    AVAssetImageGenerator *imageGenerator = [AVAssetImageGenerator assetImageGeneratorWithAsset:asset];
    CGFloat totalTime = asset.duration.value / asset.duration.timescale;
    if (totalTime < 0) {
        NSLog(@"视频总时长小于0");
        return;
    }
    NSLog(@"total: %f",totalTime);
    imageGenerator.requestedTimeToleranceBefore = kCMTimeZero;
    imageGenerator.requestedTimeToleranceAfter = kCMTimeZero;
    imageGenerator.appliesPreferredTrackTransform = YES;
    
    dispatch_queue_t queue = dispatch_queue_create("imageFrames_queue", DISPATCH_QUEUE_SERIAL);
    CGFloat interval = 1.f / 10;
    for (int i = 0; i < 10; i++) {
        dispatch_async(queue, ^{
            CGFloat atTime = interval * i;
            CGFloat value = totalTime * atTime;
            CGFloat timeScale = asset.duration.timescale;
            
            value = MAX(value,0);
            value = MIN(value,asset.duration.value);
            
            CMTime requestTime = CMTimeMakeWithSeconds(value, timeScale);
            NSError *error = nil;
            CGImageRef imageRef = [imageGenerator copyCGImageAtTime:requestTime actualTime:NULL
                                                              error:&error];
            if (error) {
                NSLog(@"error: %@",error.localizedRecoverySuggestion);
                if (fail) fail();
            }else {
                UIImage *image = [UIImage imageWithCGImage:imageRef];
                NSLog(@"image: %@",image);
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (success) success(image,i);
                });
            }
        });
    }
}

@end
