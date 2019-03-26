//
//  CCPlayerFooterView.m
//  AV_Demo
//
//  Created by chencheng on 2019/3/13.
//  Copyright © 2019年 chen. All rights reserved.
//

#import "CCPlayerFooterView.h"

@implementation CCPlayerFooterView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.3f];
    
    _playBtn = [[UIButton alloc] init];
//    _playBtn.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:_playBtn];
    [_playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(8.f);
        make.centerY.equalTo(self);
        make.width.height.equalTo(self.mas_height).multipliedBy(0.5f);
    }];
    [_playBtn setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
    [_playBtn setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateSelected];
    
    _timeLbl = [[UILabel alloc] init];
    _timeLbl.textColor = [UIColor whiteColor];
    _timeLbl.textAlignment = NSTextAlignmentLeft;
    _timeLbl.font = [UIFont systemFontOfSize:14.f];
    _timeLbl.text = @"00:00/00:00";
    [self addSubview:_timeLbl];
    [_timeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.playBtn.mas_right).offset(8.f);
        make.centerY.equalTo(self);
        make.width.equalTo(@85.f);
    }];
    
    _fullScreenBtn = [[UIButton alloc] init];
//    _fullScreenBtn.backgroundColor = [UIColor lightGrayColor];
    [_fullScreenBtn setImage:[UIImage imageNamed:@"fullscreen"] forState:UIControlStateNormal];
    [self addSubview:_fullScreenBtn];
    [_fullScreenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-8.f);
        make.centerY.equalTo(self);
        make.width.height.equalTo(self.mas_height).multipliedBy(0.6f);
    }];
    
    _slider = [[UISlider alloc] init];
    [self addSubview:_slider];
    [_slider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.timeLbl.mas_right).offset(8.f);
        make.right.equalTo(self.fullScreenBtn.mas_left).offset(-8.f);
        make.centerY.equalTo(self);
    }];
    
}

@end
