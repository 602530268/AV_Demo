//
//  CCEditTrimView.m
//  AV_Demo
//
//  Created by chencheng on 2019/3/21.
//  Copyright © 2019年 chen. All rights reserved.
//

#import "CCEditTrimView.h"

static CGFloat const kDragBarWidth = 5.f;

@interface CCEditTrimView ()

@property(nonatomic,strong) UIView *frameImagesView;
@property(nonatomic,strong) UIView *leftDrag;
@property(nonatomic,strong) UIView *rightDrag;
@property(nonatomic,strong) UIView *currentDrag;

@property(nonatomic,strong) UIView *shaderView;

@end

@implementation CCEditTrimView

#pragma mark - APIs (public)
- (void)updateImageFramesWith:(UIImage *)image index:(NSInteger)index {
    NSArray *imageViews = self.frameImagesView.subviews;
    if (index > imageViews.count - 1) {
        return;
    }
    UIImageView *imgView = imageViews[index];
    imgView.image = image;
}

#pragma mark - UI
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.leftRangeValue = 0;
        self.rightRangeVlaue = 1.f;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (_frameImagesView != nil)
        return;
    [self createUI];
}

- (void)createUI {
    self.backgroundColor = [UIColor grayColor];
    
    _frameImagesView = [[UIView alloc] init];
    [self addSubview:_frameImagesView];
    
    [_frameImagesView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(kDragBarWidth);
        make.right.equalTo(self).offset(-kDragBarWidth);
        make.centerY.equalTo(self);
        make.height.equalTo(self).multipliedBy(0.8f);
    }];
    [self layoutIfNeeded];
    
    CGFloat frameImagesViewWidth = CGRectGetWidth(self.frameImagesView.bounds);
    CGFloat itemWidth = frameImagesViewWidth / 10.f;
    
    UIView *previousView = nil;
    for (int i = 0; i < 10; i++) {
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.contentMode = UIViewContentModeScaleAspectFit;
        NSString *path = [NSString stringWithFormat:@"image%d",i];
        UIImage *img = [UIImage imageNamed:path];
        imgView.image = img;
        [self.frameImagesView addSubview:imgView];
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            if (previousView == nil) {
                make.left.equalTo(self.frameImagesView);
            }else {
                make.left.equalTo(previousView.mas_right);
            }
            make.centerY.equalTo(self.frameImagesView);
            make.width.height.equalTo(@(itemWidth));
        }];
        previousView = imgView;
    }
    
    _shaderView = [[UIView alloc] init];
    _shaderView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.3f];
    [self addSubview:_shaderView];
    
    _leftDrag = [[UIView alloc] init];
    [self addSubview:_leftDrag];
    [_leftDrag mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.left.equalTo(self);
        make.width.equalTo(@5.f);
    }];

    _rightDrag = [[UIView alloc] init];
    [self addSubview:_rightDrag];
    CGFloat selfWidth = CGRectGetWidth(self.bounds);
    [self.rightDrag mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.width.equalTo(self.leftDrag);
        make.left.equalTo(self).offset(selfWidth - kDragBarWidth);
    }];
    _leftDrag.backgroundColor = [UIColor orangeColor];
    _leftDrag.layer.cornerRadius = kDragBarWidth/2.f;
    
    _rightDrag.backgroundColor = [UIColor blueColor];
    _rightDrag.layer.cornerRadius = kDragBarWidth/2.f;
    
    [_shaderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.left.equalTo(self.leftDrag.mas_right).priority(900);
        make.right.equalTo(self.rightDrag.mas_left).priority(900);
    }];
}

#pragma mark - Interaction
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint point = [self getTouchPointWith:touches];
    if ([self checkRangeOfDragBar:self.leftDrag pointX:point.x]) {
        self.currentDrag = _leftDrag;
    }else if ([self checkRangeOfDragBar:self.rightDrag pointX:point.x]) {
        self.currentDrag = _rightDrag;
    }
}

- (BOOL)checkRangeOfDragBar:(UIView *)dragBar pointX:(CGFloat)pointX {
    if (dragBar != self.leftDrag && dragBar != self.rightDrag) return NO;
    CGFloat dragBarCenterX = CGRectGetMinX(dragBar.frame);
    CGFloat dragBarRangeLeft = dragBarCenterX - 15.f;   //增加触控范围，便于用户拖拽
    CGFloat dragBarRangeRight = dragBarCenterX + 15.f;
    if (pointX > dragBarRangeLeft && pointX < dragBarRangeRight) {
        return YES;
    }
    return NO;
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (!self.currentDrag) return;
    
    CGPoint point = [self getTouchPointWith:touches];
    
    CGFloat value = (point.x - kDragBarWidth) / CGRectGetWidth(self.frameImagesView.bounds); //比例计算
    value = value < 0 ? 0 : value;
    value = value > 1.f ? 1.f : value;
    
    CGFloat limitNearDistance = 30.f;   //给定限制距离，两个drag bar不能靠太近或者交错，因为逻辑不允许
    if (self.currentDrag == self.leftDrag) {
        CGFloat theOtherDragBarCenterX = CGRectGetMidX(self.rightDrag.frame);
        CGFloat final = point.x + limitNearDistance;
        if (final >= theOtherDragBarCenterX) return;
        self.leftRangeValue = value;
    }else if (self.currentDrag == self.rightDrag) {
        CGFloat theOtherDragBarCenterX = CGRectGetMidX(self.leftDrag.frame);
        CGFloat final = point.x - limitNearDistance;
        if (final <= theOtherDragBarCenterX) return;
        self.rightRangeVlaue = value;
    }
    
    [self.currentDrag mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(point.x);
    }];
    if (self.gragBarBlock) self.gragBarBlock(value);
//    NSLog(@"%f",value);
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.currentDrag = nil;
}

- (CGPoint)getTouchPointWith:(NSSet<UITouch *> *)touches {
    CGPoint point = [touches.anyObject locationInView:self];
    CGFloat maxWidth = CGRectGetWidth(self.frameImagesView.bounds) + kDragBarWidth;
    point.x = point.x < 0 ? 0 : point.x;
    point.x = point.x > maxWidth ? maxWidth : point.x;
    
    return point;
}

@end
