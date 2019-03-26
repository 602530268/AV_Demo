//
//  SVProgressHUD+CCAdd.m
//  ComWell
//
//  Created by chencheng on 2018/6/14.
//  Copyright © 2018年 double chen. All rights reserved.
//

#import "SVProgressHUD+CCAdd.h"

@implementation SVProgressHUD (CCAdd)

+ (void)darkStyle {
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
}

+ (void)showAndDismissByTime:(CGFloat)dissmissByTime {
    [SVProgressHUD show];
    [self dismissByTime:dissmissByTime];
}

+ (void)showWithStatus:(NSString *)status
        dissmissByTime:(CGFloat)dissmissByTime {
    [SVProgressHUD showWithStatus:status];
    [self dismissByTime:dissmissByTime];    
}

+ (void)showSuccessWithStatus:(NSString *)status
               dissmissByTime:(CGFloat)dissmissByTime {
    [SVProgressHUD showSuccessWithStatus:status];
    [self dismissByTime:dissmissByTime];
}

+ (void)showErrorWithStatus:(NSString *)status
             dissmissByTime:(CGFloat)dissmissByTime {
    [SVProgressHUD showErrorWithStatus:status];
    [self dismissByTime:dissmissByTime];
}

+ (void)dismissByTime:(CGFloat)time {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([SVProgressHUD isVisible]) {
            [SVProgressHUD dismiss];
        }
    });
}

@end
