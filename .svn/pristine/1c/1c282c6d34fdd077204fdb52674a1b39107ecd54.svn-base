//
//  CCRecordAssetWriter.h
//  AV_Demo
//
//  Created by chencheng on 2019/3/19.
//  Copyright © 2019年 chen. All rights reserved.
//

#import "CCRecord.h"

typedef void(^CCVideoImageCallback)(UIImage *image);
typedef void(^CCVideoDataCallback)(NSData *data);
typedef void(^CCSampleBufferRefCallback)(CMSampleBufferRef sampleBuffer);

@interface CCRecordAssetWriter : CCRecord

@property(nonatomic,copy) CCVideoImageCallback videoImageBlock;
@property(nonatomic,copy) CCVideoDataCallback videoDataBlock;
@property(nonatomic,copy) CCSampleBufferRefCallback sampleBufferRefBlock;

@end
