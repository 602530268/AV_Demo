//
//  CCRecordFileOutput.m
//  AV_Demo
//
//  Created by chencheng on 2019/3/19.
//  Copyright © 2019年 chen. All rights reserved.
//

#import "CCRecordFileOutput.h"

@interface CCRecordFileOutput ()<AVCaptureFileOutputRecordingDelegate>

@property(nonatomic,strong) AVCaptureMovieFileOutput *fileOutput;
@property(nonatomic,strong) AVCaptureConnection *connection;

@end

@implementation CCRecordFileOutput

- (void)startRunning {
    //播放前的设置
    if (self.type & CCRecordTypeVideo) {
        [self addDeviceInput:self.videoInput];
    }
    if (self.type & CCRecordTypeAudio) {
        [self addDeviceInput:self.audioInput];
    }
    if ([self.session canAddOutput:self.fileOutput]) {
        [self.session addOutput:self.fileOutput];
    }
    
    //预览图层和视频保持方向一致
    self.connection.videoOrientation = [self.previewLayer connection].videoOrientation;
    [self.session startRunning];
}

- (void)stopRunning {
    [self stopRunning];
}

- (void)startRecording {
    if (self.coverSave) {
        if (![CCRecordTool checkFileIfEligible:self.fileURL.path]) {
            NSLog(@"该路径已有其他文件，无法进行录制.");
            return;
        }
    }

    NSLog(@"开始录制...");
    //在session运行后以及不在录制状态时才能录制
    if (self.session.isRunning && self.fileOutput.isRecording == NO) {
        //解决镜像问题
        if (self.connection.isVideoMirroringSupported) {
            self.connection.videoMirrored = self.cameraInput == CCCameraInputFront ? YES : NO;
        }
        self.status = CCRecordStatusRecording;
        unlink([self.fileURL.path UTF8String]);
        NSURL *fileURL = [self availableFileURLToTmp];
        unlink([fileURL.path UTF8String]);
        [self.fileOutput startRecordingToOutputFileURL:fileURL recordingDelegate:self];
    }else {
        NSAssert(self.session.isRunning, @"session muse be running");
    }
}

- (void)pauseRecording {
    NSLog(@"暂停录制");
    self.status = CCRecordStatusPause;
    [self.fileOutput stopRecording];
}

- (void)stopRecording {
    NSLog(@"停止录制");
    if (self.fileOutput.isRecording) {
        [self.fileOutput stopRecording];
    }else {
        [super finishRecording];
    }
}

- (void)finishRecording {
    NSLog(@"完成录制");
    self.status = CCRecordStatusFinish;
    [self stopRecording];
}

#pragma mark - Lazy load
- (AVCaptureMovieFileOutput *)fileOutput {
    if (!_fileOutput) {
        _fileOutput = [[AVCaptureMovieFileOutput alloc] init];
    }
    return _fileOutput;
}

- (AVCaptureConnection *)connection {
    if (!_connection) {
        _connection = [self.fileOutput connectionWithMediaType:AVMediaTypeVideo];
        //开启防抖，如果支持防抖就开启，有的用就用
        if (_connection.isVideoStabilizationSupported) {
            _connection.preferredVideoStabilizationMode = AVCaptureVideoStabilizationModeAuto;
        }
    }
    return _connection;
}

#pragma mark - AVCaptureFileOutputRecordingDelegate
//开始录制时回调
- (void)captureOutput:(AVCaptureFileOutput *)output didStartRecordingToOutputFileAtURL:(NSURL *)fileURL fromConnections:(NSArray<AVCaptureConnection *> *)connections {
    NSLog(@"didStartRecordingToOutputFileAtURL");
    self.status = CCRecordStatusRecording;
    if (self.startRecordBlock) self.startRecordBlock(fileURL);
}

//结束录制时回调
- (void)captureOutput:(AVCaptureFileOutput *)output didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray<AVCaptureConnection *> *)connections error:(NSError *)error {
    NSLog(@"didFinishRecordingToOutputFileAtURL");
    if (![self.videoArr containsObject:outputFileURL]) {
        [self.videoArr addObject:outputFileURL];
    }
    if (self.status == CCRecordStatusPause) {
        if (self.pauseRecordBlock) self.pauseRecordBlock(self.fileURL);
    }
    if (self.status == CCRecordStatusFinish) {
        [super finishRecording];
    }
}

@end
