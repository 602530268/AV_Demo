//
//  RecordByAssetWriterVC.m
//  AV_Demo
//
//  Created by chencheng on 2019/3/19.
//  Copyright © 2019年 chen. All rights reserved.
//

#import "RecordByAssetWriterVC.h"
#import "CCRecordAssetWriter.h"

@interface RecordByAssetWriterVC ()

@property(nonatomic,strong) CCRecordAssetWriter *assetWriter;

@end

@implementation RecordByAssetWriterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self recordViewBlockCallback];
    [self createRecordAssetWriter];
}

- (void)recordViewBlockCallback {
    __weak typeof(self) weakSelf = self;
    self.recordView.backBtnEventBlock = ^{
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    };
    self.recordView.switchCameraBtnEventBlock = ^{
        [weakSelf.assetWriter swithCamera];
    };
    self.recordView.flashLightBtnEventBlock = ^{
        static BOOL flash = NO;
        if (flash) [weakSelf.assetWriter switchFlashLightModel:AVCaptureTorchModeOff];
        else [weakSelf.assetWriter switchFlashLightModel:AVCaptureTorchModeOn];
        flash = !flash;
    };
    self.recordView.fileterBtnEventBlock = ^{
        
    };
    self.recordView.specialEffectBtnEventBlock = ^{
        
    };
    self.recordView.photoLibraryBtnEventBlock = ^{
        
    };
    self.recordView.rollbackBtnEventBlock = ^{
        
    };
    self.recordView.recordBtnEventBlock = ^{
        if (weakSelf.assetWriter.status == CCRecordStatusRecording) {
            [weakSelf.recordView pauseRecordAnimation];
            [weakSelf.assetWriter pauseRecording];
        }else {
            [weakSelf.recordView startRecordAnimation];
            [weakSelf.assetWriter startRecording];
        }
    };
    self.recordView.finishBtnEventBlock = ^{
        [weakSelf.recordView endRecordAnmation];
        [weakSelf.assetWriter finishRecording];
    };
}

- (void)createRecordAssetWriter {
    
    _assetWriter = [[CCRecordAssetWriter alloc] initWithContainerView:self.recordView.containerView];
    _assetWriter.type = CCRecordTypeVideo | CCRecordTypeAudio;
    _assetWriter.cameraInput = CCCameraInputFront;
    
    //    __weak typeof(self) weakSelf = self;
    _assetWriter.startRecordBlock = ^(NSURL *fileURL) {
        NSLog(@"startRecordBlock");
    };
    _assetWriter.pauseRecordBlock = ^(NSURL *fileURL) {
        NSLog(@"pauseRecordBlock");
    };
    _assetWriter.stopRecordBlock = ^(NSURL *fileURL) {
        NSLog(@"stopRecordBlock");
    };
    
    [_assetWriter startRunning];
}

@end
