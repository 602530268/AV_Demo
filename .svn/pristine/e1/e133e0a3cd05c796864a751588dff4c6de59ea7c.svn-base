//
//  CCRecordTool.h
//  AV_Demo
//
//  Created by chencheng on 2019/3/19.
//  Copyright © 2019年 chen. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^Success)(NSURL *url);
typedef void(^Fail)(NSString *error);

NS_ASSUME_NONNULL_BEGIN

@interface CCRecordTool : NSObject

//检查指定路径是否可用，如该路径已存在其他文件时返回NO
+ (BOOL)checkFileIfEligible:(NSString *)path;

//拼接视频
+ (void)videoCompositionWith:(NSArray <NSURL *>*)urls
                   outputURL:(NSURL *)outputURL
                     success:(Success)success
                        fail:(Fail)fail;

//获取指定的视频帧
+ (void)takeoutVideoFrameWith:(NSURL *)fileURL
                       atTime:(CGFloat)atTime
                        block:(void(^)(UIImage *image))block
                         fail:(Fail)fail;

//给视频配音
+ (void)dubForVideoWith:(NSURL *)fileURL
               audioURL:(NSURL *)audioURL
              startTime:(CGFloat)startTime
                success:(Success)success
                   fail:(Fail)fail;

//给视频添加滤镜
+ (void)filterForVideoWith:(NSURL *)fileURL
                   success:(Success)success
                      fail:(Fail)fail;

//给视频添加水印

@end

NS_ASSUME_NONNULL_END
