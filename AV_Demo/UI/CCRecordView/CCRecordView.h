//
//  CCRecordView.h
//  AV_Demo
//
//  Created by chencheng on 2019/3/19.
//  Copyright © 2019年 chen. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CCRecordView : UIView

@property(nonatomic,strong) UIView *containerView;

@property(nonatomic,strong) UIView *functionView;
@property(nonatomic,strong) UIButton *switchCameraBtn;
@property(nonatomic,strong) UIButton *flashLightBtn;
@property(nonatomic,strong) UIButton *fileterBtn;
@property(nonatomic,strong) UIButton *specialEffectBtn;
@property(nonatomic,strong) UIButton *photoLibraryBtn;

@property(nonatomic,strong) UIButton *backBtn;
@property(nonatomic,strong) UIButton *rollbackBtn;
@property(nonatomic,strong) UIButton *recordBtn;
@property(nonatomic,strong) UIButton *finishBtn;

@property(nonatomic,copy) void(^backBtnEventBlock)(void);
@property(nonatomic,copy) void(^switchCameraBtnEventBlock)(void);
@property(nonatomic,copy) void(^flashLightBtnEventBlock)(void);
@property(nonatomic,copy) void(^rollbackBtnEventBlock)(void);
@property(nonatomic,copy) void(^specialEffectBtnEventBlock)(void);
@property(nonatomic,copy) void(^fileterBtnEventBlock)(void);
@property(nonatomic,copy) void(^recordBtnEventBlock)(void);
@property(nonatomic,copy) void(^finishBtnEventBlock)(void);
@property(nonatomic,copy) void(^photoLibraryBtnEventBlock)(void);

- (void)startRecordAnimation;
- (void)pauseRecordAnimation;
- (void)endRecordAnmation;

@end

NS_ASSUME_NONNULL_END
