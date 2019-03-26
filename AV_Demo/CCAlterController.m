//
//  CCAlterController.m
//  AV_Demo
//
//  Created by chencheng on 2019/3/26.
//  Copyright © 2019年 chen. All rights reserved.
//

#import "CCAlterController.h"

@implementation CCAlterController

+ (void)showWithTitle:(NSString *)title
              message:(NSString *)message
               action:(NSString *)action
               target:(UIViewController *)target {
    [self showWithTitle:title
                message:message
                  style:nil
           actionTitles:@[action]
           actionStyles:nil
                 target:target
               handlers:nil];
}

+ (void)showWithTitle:(NSString *)title
              message:(NSString *)message
                style:(id)style
         actionTitles:(id)actionTitles
         actionStyles:(id)actionStyles
               target:(UIViewController *)target
             handlers:(void(^)(NSInteger index))handlers {
    
    UIAlertControllerStyle controllerStyle = UIAlertControllerStyleAlert;
    
    if (style == nil) {
        controllerStyle = UIAlertControllerStyleAlert;
    }else {
        controllerStyle = UIAlertControllerStyleActionSheet;
    }
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:controllerStyle];
    
    if ([actionTitles isKindOfClass:[NSString class]]) {
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:actionTitles style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (handlers) {
                handlers(0);
            }
        }];
        [alertController addAction:action];
    }else if ([actionTitles isKindOfClass:[NSArray class]]) {
        
        NSArray *titles = (NSArray *)actionTitles;
        NSArray *styles = (NSArray *)actionStyles;
        
        for (int i = 0; i < titles.count; i++) {
            
            UIAlertActionStyle actionStyle;
            if (styles == nil) {
                actionStyle = UIAlertActionStyleDefault;  //默认
            }else {
                actionStyle = [styles[i] integerValue];
            }
            
            UIAlertAction *action = [UIAlertAction actionWithTitle:titles[i] style:actionStyle handler:^(UIAlertAction * _Nonnull action) {
                if (handlers) {
                    handlers(i);
                }
            }];
            [alertController addAction:action];
        }
        
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [target presentViewController:alertController animated:YES completion:nil];
    });
}

@end
