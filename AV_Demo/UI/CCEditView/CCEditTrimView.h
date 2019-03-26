//
//  CCEditTrimView.h
//  AV_Demo
//
//  Created by chencheng on 2019/3/21.
//  Copyright © 2019年 chen. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CCEditTrimView : UIView

@property(nonatomic,assign) CGFloat leftRangeValue; //default 0
@property(nonatomic,assign) CGFloat rightRangeVlaue; //default 1.f

@property(nonatomic,copy) void(^gragBarBlock)(CGFloat value);

- (void)updateImageFramesWith:(UIImage *)image index:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
