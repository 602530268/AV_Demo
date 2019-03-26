//
//  CCAlterController.h
//  AV_Demo
//
//  Created by chencheng on 2019/3/26.
//  Copyright © 2019年 chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CCAlterController : NSObject

+ (void)showWithTitle:(NSString *)title
              message:(NSString *)message
               action:(NSString *)action
               target:(UIViewController *)target;

+ (void)showWithTitle:(NSString *)title
              message:(NSString *)message
                style:(id)style
         actionTitles:(id)actionTitles
         actionStyles:(id)actionStyles
               target:(UIViewController *)target
             handlers:(void(^)(NSInteger index))handlers;

@end

