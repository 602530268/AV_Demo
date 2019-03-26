//
//  CCRecordTool.m
//  AV_Demo
//
//  Created by chencheng on 2019/3/19.
//  Copyright © 2019年 chen. All rights reserved.
//

#import "CCRecordTool.h"

@implementation CCRecordTool

//检查指定路径是否可用，如该路径已存在其他文件时返回NO
+ (BOOL)checkFileIfEligible:(NSString *)path {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        return NO;
    }
    return YES;
}

//拼接视频
+ (void)videoCompositionWith:(NSArray <NSURL *>*)urls
                   outputURL:(NSURL *)outputURL
                     success:(Success)success
                        fail:(Fail)fail {
    unlink([outputURL.path UTF8String]);    //移除已存在文件
    
    if (urls.count == 0) {
        if (fail) fail(@"没有可以进行拼接的视频");
        return;
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (urls.count == 1) {
        //只有一段视频不需要拼接
        NSError *error = nil;
        [fileManager moveItemAtURL:urls.firstObject toURL:outputURL error:&error];
        if (error) {
            NSString *content = [NSString stringWithFormat:@"视频移动失败:%@",error.localizedDescription];
            if (fail) fail(content);
        }else {
            if (success) success(outputURL);
        }
        return;
    }
    
    //视频完整性检查模块，可删
    for (NSURL *url in urls) {
        NSString *path = url.path;
        if (![fileManager fileExistsAtPath:path]) {
            NSLog(@"此段视频不存在，可能已经被删除或者路径有误: %@",path);
        }
    }
    
    //剪辑操作类
    AVMutableComposition *mixComposition = [[AVMutableComposition alloc] init];
    //视音频轨道的插入、删除和拓展接口，如果不需要插入视频或音频，不要创建对象，因为addMutableTrackWithMediaType之后不使用会导致拼接失败
    AVMutableCompositionTrack *videoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    AVMutableCompositionTrack *audioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    
    //解决合成视频后视频旋转90度的问题
    videoTrack.preferredTransform =  CGAffineTransformMakeRotation(M_PI/2);
    
    /*
     开始插入视音频
     fromTime: 从哪里算开始，默认为kCMTimeZero从开头开始
     toTime: 到哪里结束，默认为asset.duration到结尾结束
     ofTrack: 插入的媒体类型
     atTime:从哪里开始插入，这里才是真正的插入，注意区分fromTime
     */
    CMTime indexTime = kCMTimeZero; //索引
    for (NSURL *url in urls) {
        AVAsset *asset = [AVAsset assetWithURL:url];    //获取资源
        NSError *error = nil;
        
        //插入视频
        [videoTrack insertTimeRange:CMTimeRangeFromTimeToTime(kCMTimeZero, asset.duration) ofTrack:[asset tracksWithMediaType:AVMediaTypeVideo].firstObject atTime:indexTime error:&error];
        if (error) {
            NSLog(@"插入视频失败: %@",error.localizedDescription);
            error = nil;
        }
        
        //插入音频
        [audioTrack insertTimeRange:CMTimeRangeFromTimeToTime(kCMTimeZero, asset.duration) ofTrack:[asset tracksWithMediaType:AVMediaTypeAudio].firstObject atTime:indexTime error:&error];
        if (error) {
            NSLog(@"插入音频失败: %@",error.localizedDescription);
            error = nil;
        }
        
        indexTime = CMTimeAdd(indexTime, asset.duration); //记录索引
    }
    
    //导出
    AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:mixComposition presetName:AVAssetExportPresetMediumQuality];
    exporter.outputURL = outputURL;
    exporter.outputFileType = AVFileTypeQuickTimeMovie;
    exporter.shouldOptimizeForNetworkUse = YES;
    
    __weak typeof(exporter) weakExporter = exporter;
    [exporter exportAsynchronouslyWithCompletionHandler:^{
        NSLog(@"thread: %@",[NSThread currentThread]);
        
        NSLog(@"导出完成...");
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if ([fileManager fileExistsAtPath:outputURL.path]) {
            CGFloat fileSize = [[NSData dataWithContentsOfURL:outputURL] length] / 1024.f / 1024.f;
            NSLog(@"导出成功，文件大小为: %.2f MB",fileSize);
            if (success) success(outputURL);
        }else {
            NSLog(@"导出失败，文件不存在");
            if (fail) fail(@"导出失败，文件不存在");
        }
        
        switch ([weakExporter status]) {
            case AVAssetExportSessionStatusFailed: {
                NSLog(@"合成失败：%@",[[weakExporter error] description]);
            }
                break;
            case AVAssetExportSessionStatusCancelled:
                break;
            case AVAssetExportSessionStatusCompleted:
                break;
            default:
                break;
        }
    }];
    
}

//获取指定的视频帧
+ (void)takeoutVideoFrameWith:(NSURL *)fileURL
                       atTime:(CGFloat)atTime
                        block:(void(^)(UIImage *image))block
                         fail:(Fail)fail {
    
}

//给视频配音
+ (void)dubForVideoWith:(NSURL *)fileURL
               audioURL:(NSURL *)audioURL
              startTime:(CGFloat)startTime
                success:(Success)success
                   fail:(Fail)fail {
    
}

//给视频添加滤镜
+ (void)filterForVideoWith:(NSURL *)fileURL
                   success:(Success)success
                      fail:(Fail)fail {
    
}

@end
