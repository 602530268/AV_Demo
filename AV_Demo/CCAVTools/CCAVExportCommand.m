//
//  CCAVExportCommand.m
//  AV_Demo
//
//  Created by chencheng on 2019/3/26.
//  Copyright © 2019年 chen. All rights reserved.
//

#import "CCAVExportCommand.h"

@implementation CCAVExportCommand

- (void)performWithAsset:(AVAsset *)asset context:(NSDictionary *)context {
    if (!self.mutableComposition) {
        NSLog(@"无法导出空的视音频文件");
        return;
    }
    NSLog(@"开始导出...");
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *outputPath = paths[0];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager createDirectoryAtPath:outputPath withIntermediateDirectories:YES attributes:nil error:nil];
    outputPath = [outputPath stringByAppendingPathComponent:@"output.mp4"];
    
    [fileManager removeItemAtPath:outputPath error:nil];
    
    //AVAssetExportPresetLowQuality AVAssetExportPresetMediumQuality
    self.exportSession = [[AVAssetExportSession alloc] initWithAsset:self.mutableComposition presetName:AVAssetExportPresetMediumQuality];
    self.exportSession.videoComposition = self.mutableVideoComposition;
    self.exportSession.audioMix = self.mutableAudioMix;
    self.exportSession.outputURL = [NSURL fileURLWithPath:outputPath];
    self.exportSession.outputFileType = AVFileTypeAppleM4V;
    
    __weak typeof(self) weakSelf = self;
    [self.exportSession exportAsynchronouslyWithCompletionHandler:^{
        switch (self.exportSession.status) {
            case AVAssetExportSessionStatusCompleted:
                NSLog(@"导出成功");
                if (weakSelf.writeToPhotoLibrary) {
                    [weakSelf writeVideoToPhotoLibrary:outputPath];
                }
                weakSelf.outputPath = outputPath;
                [[NSNotificationCenter defaultCenter] postNotificationName:CCAVExportCommandCompletionNotification object:self];
                break;
            case AVAssetExportSessionStatusCancelled:
                NSLog(@"取消导出");
                break;
            case AVAssetExportSessionStatusFailed:
                NSLog(@"导出失败");
                break;
            default:
                break;
        }
    }];
}

- (void)writeVideoToPhotoLibrary:(NSString *)videoPath {
    if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(videoPath)) {
        //保存相册核心代码
        UISaveVideoAtPathToSavedPhotosAlbum(videoPath, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
    }
}

- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error) {
        NSLog(@"保存视频失败%@", error.localizedDescription);
    }
    else {
        NSLog(@"保存视频成功");
    }
}


@end
