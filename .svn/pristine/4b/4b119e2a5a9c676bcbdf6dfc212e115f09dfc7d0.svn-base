//
//  CCAVTrimCommand.m
//  AV_Demo
//
//  Created by chencheng on 2019/3/22.
//  Copyright © 2019年 chen. All rights reserved.
//

#import "CCAVTrimCommand.h"

@implementation CCAVTrimCommand

- (void)performWithAsset:(AVAsset *)asset context:(NSDictionary *)context {
    [self insertAssetForCompositionWith:asset context:context insertVideo:YES insertAudio:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:CCAVEditCommandCompletionNotification object:self];
}

@end
