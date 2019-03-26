//
//  CCPlayerFooterView.h
//  AV_Demo
//
//  Created by chencheng on 2019/3/13.
//  Copyright © 2019年 chen. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CCPlayerFooterView : UIView

@property(nonatomic,strong) UIButton *playBtn;
@property(nonatomic,strong) UILabel *timeLbl;
@property(nonatomic,strong) UIButton *forwardBtn;
@property(nonatomic,strong) UIButton *backoffBtn;
@property(nonatomic,strong) UIButton *fullScreenBtn;
@property(nonatomic,strong) UISlider *slider;

@end

NS_ASSUME_NONNULL_END
