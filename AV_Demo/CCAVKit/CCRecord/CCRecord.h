//
//  CCRecord.h
//  AV_Demo
//
//  Created by chencheng on 2019/3/19.
//  Copyright © 2019年 chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>
#import "CCRecordTool.h"

typedef NS_OPTIONS(NSUInteger, CCRecordType) {
    CCRecordTypeVideo = 1 << 0, //默认录制视频
    CCRecordTypeAudio = 1 << 1,
};

typedef void(^CCStartRecordCallback)(NSURL *fileURL);
typedef void(^CCStopRecordCallback)(NSURL *fileURL);
typedef void(^CCPauseRecordCallback)(NSURL *fileURL);

typedef NS_ENUM(NSUInteger,CCCameraInput) {
    CCCameraInputRear,  //默认后置摄像头
    CCCameraInputFront,
};

typedef NS_ENUM(NSUInteger,CCRecordStatus) {
    CCRecordStatusNone,
    CCRecordStatusRecording,
    CCRecordStatusPause,
    CCRecordStatusFinish,
};

@interface CCRecord : NSObject

@property(nonatomic,strong) UIView *containerView; //视频装载view
@property(nonatomic,strong) NSMutableArray *videoArr;   //视频临时存储数组，录制完成后进行拼接
@property(nonatomic,strong) NSURL *fileURL; //存放路径
@property(nonatomic,assign) BOOL coverSave; //覆盖保存

@property(nonatomic,assign) CCRecordType type;
@property(nonatomic,assign) CCCameraInput cameraInput;
@property(nonatomic,assign) CCRecordStatus status;

@property(nonatomic,strong) AVCaptureSession *session;
@property(nonatomic,strong) AVCaptureVideoPreviewLayer *previewLayer;
@property(nonatomic,strong) AVCaptureDeviceInput *videoInput;
@property(nonatomic,strong) AVCaptureDeviceInput *audioInput;

@property(nonatomic,copy) CCStartRecordCallback startRecordBlock;
@property(nonatomic,copy) CCStopRecordCallback stopRecordBlock;
@property(nonatomic,copy) CCPauseRecordCallback pauseRecordBlock;

- (instancetype)initWithContainerView:(UIView *)containerView;  //默认了一个路径，如需指定请用下面函数初始化
- (instancetype)initWithPath:(NSString *)path containerView:(UIView *)containerView;
- (instancetype)initWithURL:(NSURL *)url containerView:(UIView *)containerView;

#pragma mark - Tools
- (void)switchFlashLightModel:(AVCaptureTorchMode)mode;   //打开or关闭闪光灯

- (void)swithCamera;    //切换摄像头

#pragma mark - Running
//采集意为开始捕捉图像，不表示录制
- (void)startRunning;   //开始采集
- (void)stopRunning;    //停止采集

#pragma mark - Recording
- (void)startRecording; //开始录制
- (void)stopRecording;  //停止录制
- (void)pauseRecording; //暂停录制
- (void)finishRecording;    //完成录制

#pragma mark - Add Device Input
- (void)addDeviceInput:(AVCaptureInput *)input;
- (void)addDeviceOutput:(AVCaptureOutput *)output;

#pragma mark - Other
- (NSURL *)availableFileURLToSave;    //获取一个可用的保存路径
- (NSURL *)availableFileURLToTmp;    //获取一个可用的临时路径
- (void)cancelRecord;   //取消录制
- (void)removeFilePathIfExist:(NSString *)path; //删除已存在的文件

+ (NSArray *)mediaList; //保存在本地的媒体文件
+ (void)removeAllMedia; //删除全部媒体文件

@end
