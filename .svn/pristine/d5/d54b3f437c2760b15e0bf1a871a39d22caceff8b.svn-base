//
//  CCEditView.h
//  AV_Demo
//
//  Created by chencheng on 2019/3/21.
//  Copyright © 2019年 chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCEditTrimView.h"

typedef NS_ENUM(NSUInteger,CCVideoEditType) {
    CCVideoEditTypeNone = 0,
    CCVideoEditTypeTrim,    
    CCVideoEditTypeCrop,
    CCVideoEditTypeRotate,
    CCVideoEditTypeAddMusic,
    CCVideoEditTypeAddWarterMark,
    CCVideoEditTypeExport,
};

NS_ASSUME_NONNULL_BEGIN

@interface CCEditView : UIView

@property(nonatomic,strong) UIView *containerView;

@property(nonatomic,strong) UIScrollView *functionView;

@property(nonatomic,strong) UIButton *backBtn;
@property(nonatomic,strong) UIButton *cancelBtn;
@property(nonatomic,strong) UIButton *saveBtn;

@property(nonatomic,strong) CCEditTrimView *trimView;

@property(nonatomic,copy) void(^backBtnEventBlock)(void);
@property(nonatomic,copy) void(^playBtnEventBlock)(void);
@property(nonatomic,copy) void(^rollbackBtnEventBlock)(void);

@property(nonatomic,copy) void(^trimBtnEventBlock)(void);
@property(nonatomic,copy) void(^cropBtnEventBlock)(void);
@property(nonatomic,copy) void(^rotateBtnEventBlock)(void);
@property(nonatomic,copy) void(^addMusicBtnEventBlock)(void);
@property(nonatomic,copy) void(^waterMarkBtnEventBlock)(void);
@property(nonatomic,copy) void(^exportBtnEventBlock)(void);

@property(nonatomic,copy) void(^startOrCancelEditVideoBlock)(void);
@property(nonatomic,copy) void(^saveTheChangesBlock)(id context);

@property(nonatomic,copy) void(^trimDragBarBlock)(CGFloat value);


@end

NS_ASSUME_NONNULL_END
