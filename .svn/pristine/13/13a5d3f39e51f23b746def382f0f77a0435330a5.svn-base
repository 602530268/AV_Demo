//
//  CCAVCommand.h
//  AV_Demo
//
//  Created by chencheng on 2019/3/22.
//  Copyright © 2019年 chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

static NSString *const CCAVEditCommandCompletionNotification = @"CCAVEditCommandCompletionNotification";
static NSString *const CCAVExportCommandCompletionNotification = @"CCAVExportCommandCompletionNotification";

@interface CCAVCommand : NSObject

@property(nonatomic,strong) AVMutableComposition *mutableComposition;
@property(nonatomic,strong) AVMutableVideoComposition *mutableVideoComposition;
@property(nonatomic,strong) AVMutableAudioMix *mutableAudioMix;
@property(nonatomic,strong) CALayer *watermarkLayer;

- (instancetype)initWithComposition:(AVMutableComposition *)composition videoComposition:(AVMutableVideoComposition *)videoComposition audioMix:(AVMutableAudioMix *)audioMix;

- (void)performWithAsset:(AVAsset *)asset context:(NSDictionary *)context;

- (void)insertAssetForCompositionWith:(AVAsset *)asset context:(NSDictionary *)context insertVideo:(BOOL)insertVideo insertAudio:(BOOL)insertAudio;

@end

