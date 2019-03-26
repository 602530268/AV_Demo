//
//  CCPlayerView.h
//  AV_Demo
//
//  Created by chencheng on 2019/3/13.
//  Copyright © 2019年 chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCPlayerHeaderView.h"
#import "CCPlayerFooterView.h"

NS_ASSUME_NONNULL_BEGIN

@interface CCPlayerView : UIView

@property(nonatomic,copy) void(^backBtnEventBlock)(void);
@property(nonatomic,copy) void(^playBtnEventBlock)(void);
@property(nonatomic,copy) void(^progressEventBlock)(CGFloat value); //暂未实现
@property(nonatomic,copy) void(^fullScreenBtnEventBlock)(BOOL fullScreen);
@property(nonatomic,copy) void(^sliderEventBlock)(CGFloat value);
@property(nonatomic,copy) void(^singleTapEventBlock)(void);
@property(nonatomic,copy) void(^doubleTapEventBlock)(void);

@property(nonatomic,strong) UIView *containerView;
@property(nonatomic,strong) CCPlayerHeaderView *headerView;
@property(nonatomic,strong) CCPlayerFooterView *footerView;
@property(nonatomic,assign) CGFloat navBarHeight; //如果有导航栏的话，需要赋值
@property(nonatomic,assign) BOOL subViewsDoNotHide; 

@property(nonatomic,assign,getter=isFullSceen) BOOL fullScreen; //全屏状态
@property(nonatomic,assign,getter=isPlaying) BOOL playing; //正在播放

- (void)updatePlayProgressWith:(CGFloat)progress currentTime:(CGFloat)currentTime totalTime:(CGFloat)totalTime;

- (void)hideOrShowSubViews:(BOOL)immediate;

- (void)fullScreenLayout;

- (void)smallScreenLayout;

@end

NS_ASSUME_NONNULL_END
