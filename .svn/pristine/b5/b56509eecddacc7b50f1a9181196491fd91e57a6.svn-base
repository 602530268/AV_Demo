//
//  RecordByFileOutputVC.m
//  AV_Demo
//
//  Created by chencheng on 2019/3/19.
//  Copyright © 2019年 chen. All rights reserved.
//

#import "RecordByFileOutputVC.h"
#import "CCRecordFileOutput.h"

@interface RecordByFileOutputVC ()

@property(nonatomic,strong) CCRecordFileOutput *fileOutput;

@end

@implementation RecordByFileOutputVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self recordViewBlockCallback];
    [self createRecordFileOutput];
}

- (void)recordViewBlockCallback {
    __weak typeof(self) weakSelf = self;
    self.recordView.backBtnEventBlock = ^{
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    };
    self.recordView.switchCameraBtnEventBlock = ^{
        [weakSelf.fileOutput swithCamera];
    };
    self.recordView.flashLightBtnEventBlock = ^{
        static BOOL flash = NO;
        if (flash) [weakSelf.fileOutput switchFlashLightModel:AVCaptureTorchModeOff];
        else [weakSelf.fileOutput switchFlashLightModel:AVCaptureTorchModeOn];
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
        if (weakSelf.fileOutput.status == CCRecordStatusRecording) {
            [weakSelf.recordView pauseRecordAnimation];
            [weakSelf.fileOutput pauseRecording];
        }else {
            [weakSelf.recordView startRecordAnimation];
            [weakSelf.fileOutput startRecording];
        }
    };
    self.recordView.finishBtnEventBlock = ^{
        [weakSelf.recordView endRecordAnmation];
        [weakSelf.fileOutput finishRecording];
    };
}

- (void)createRecordFileOutput {
    
    _fileOutput = [[CCRecordFileOutput alloc] initWithContainerView:self.recordView.containerView];
    _fileOutput.type = CCRecordTypeVideo | CCRecordTypeAudio;
    _fileOutput.cameraInput = CCCameraInputFront;
    
//    __weak typeof(self) weakSelf = self;
    _fileOutput.startRecordBlock = ^(NSURL *fileURL) {
        NSLog(@"startRecordBlock");
    };
    _fileOutput.pauseRecordBlock = ^(NSURL *fileURL) {
        NSLog(@"pauseRecordBlock");
    };
    _fileOutput.stopRecordBlock = ^(NSURL *fileURL) {
        NSLog(@"stopRecordBlock");
    };
    
    [_fileOutput startRunning];
}

@end
