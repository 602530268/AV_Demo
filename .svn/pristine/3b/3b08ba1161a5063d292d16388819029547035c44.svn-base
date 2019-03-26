//
//  CCEditView.m
//  AV_Demo
//
//  Created by chencheng on 2019/3/21.
//  Copyright © 2019年 chen. All rights reserved.
//

#import "CCEditView.h"
#import "CCEditTrimView.h"

@interface CCEditView ()

@property(nonatomic,strong) NSArray *titles;
@property(nonatomic,strong) UIView *cancelOrSaveView;

@property(nonatomic,assign) CCVideoEditType type;

@end

@implementation CCEditView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (_functionView) return;
}

- (void)createUI {
    CGFloat smallItemSize = 44.f;
//    CGFloat mediumItmeSize = 50.f;
//    CGFloat bigItemSize = 80.f;
    
    _backBtn = [self generateBtnWithImageName:@"back" superView:self];
    [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self).offset(8.f);
        make.width.height.equalTo(@(smallItemSize));
    }];

    _functionView = [[UIScrollView alloc] init];
    _functionView.backgroundColor = [UIColor blackColor];
    [self addSubview:_functionView];
    [_functionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.equalTo(@60.f);
    }];
    
    self.titles = @[@"Trim",@"Crop",@"Rotate",@"Add Music",@"Water Mark",@"Export"];
    UIView *previousView = nil;
    for (int i = 0; i < self.titles.count; i++) {
        UIButton *btn = [self generateBtnWithTitle:self.titles[i] superView:self.functionView];
        btn.tag = 1000 + i;
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            if (previousView == nil) {
                make.left.equalTo(self.functionView).offset(8.f);
            }else {
                make.left.equalTo(previousView.mas_right).offset(8.f);
            }
            make.top.bottom.equalTo(self.functionView);
            make.height.equalTo(self.functionView);
        }];
        previousView = btn;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        CGFloat sizeWidth = CGRectGetMaxX(previousView.frame);
        self.functionView.contentSize = CGSizeMake(sizeWidth, 0);
    });
    
    _containerView = [[UIView alloc] init];
    [self addSubview:_containerView];
    [_containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.backBtn.mas_bottom);
        make.bottom.equalTo(self.functionView.mas_top);
    }];
    
    
    [self cancelOrSaveView];
    [self trimView];
    [self controlsEvent];    
}

- (void)controlsEvent {
    __weak typeof(self) weakSelf = self;
    
    [[self.backBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        if (weakSelf.backBtnEventBlock) weakSelf.backBtnEventBlock();
    }];
    
    UITapGestureRecognizer *tapEvent = [[UITapGestureRecognizer alloc] init];
    [[tapEvent rac_gestureSignal] subscribeNext:^(id x) {
        if (weakSelf.playBtnEventBlock) weakSelf.playBtnEventBlock();
    }];
    self.containerView.userInteractionEnabled = YES;
    [self.containerView addGestureRecognizer:tapEvent];
    
    for (UIView *sub in self.functionView.subviews) {
        if (![sub isKindOfClass:[UIButton class]]) continue;
        UIButton *btn = (UIButton *)sub;
        NSUInteger tag = btn.tag;
        [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            switch (tag) {
                case 1000:
                    [self startEditVideoWith:CCVideoEditTypeTrim];
                    if (weakSelf.trimBtnEventBlock) weakSelf.trimBtnEventBlock();
                    break;
                case 1001:
                    [self startEditVideoWith:CCVideoEditTypeCrop];
                    if (weakSelf.cropBtnEventBlock) weakSelf.cropBtnEventBlock();
                    break;
                case 1002:
                    [self startEditVideoWith:CCVideoEditTypeRotate];
                    if (weakSelf.rotateBtnEventBlock) weakSelf.rotateBtnEventBlock();
                    break;
                case 1003:
                    [self startEditVideoWith:CCVideoEditTypeAddMusic];
                    if (weakSelf.addMusicBtnEventBlock) weakSelf.addMusicBtnEventBlock();
                    break;
                case 1004:
                    [self startEditVideoWith:CCVideoEditTypeAddWarterMark];
                    if (weakSelf.waterMarkBtnEventBlock) weakSelf.waterMarkBtnEventBlock();
                    break;
                case 1005:
                    if (self.saveTheChangesBlock) self.saveTheChangesBlock(@{@"tag":@(CCVideoEditTypeExport)});
                    break;
                default:
                    break;
            }
        }];
    }
    [[self.cancelBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [weakSelf startEditVideoWith:CCVideoEditTypeNone];
    }];
    [[self.saveBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [weakSelf endEditVideoWith:weakSelf.type];
    }];
}

#pragma mark - APIs (private)
- (void)startEditVideoWith:(CCVideoEditType)type {
    self.type = type;
    if (type == CCVideoEditTypeNone) {
        [self hideControlsWithEdit:NO];
    }else {
        [self hideControlsWithEdit:YES];
    }
}

- (void)hideControlsWithEdit:(BOOL)edit {
    CGFloat alpha = !edit;
    [UIView animateWithDuration:0.25f animations:^{
        self.backBtn.alpha = alpha;
        self.functionView.alpha = alpha;
        self.cancelOrSaveView.alpha = !alpha;
        self.trimView.alpha = !alpha;
        
        [self layoutIfNeeded];
    }];
}

- (void)endEditVideoWith:(CCVideoEditType)type {
    [self hideControlsWithEdit:NO];
    NSMutableDictionary *info = @{}.mutableCopy;

    switch (type) {
        case CCVideoEditTypeNone:
            break;
        case CCVideoEditTypeTrim:
            break;
        case CCVideoEditTypeCrop:
            break;
        case CCVideoEditTypeRotate:
            break;
        case CCVideoEditTypeAddMusic:
            break;
        case CCVideoEditTypeAddWarterMark:
            break;
        default:
            break;
    }
    
    CGFloat left = self.trimView.leftRangeValue;
    CGFloat right = self.trimView.rightRangeVlaue;
    [info setValue:@(type) forKey:@"tag"];
    [info setValue:@(left) forKey:@"left"];
    [info setValue:@(right) forKey:@"right"];

    if (self.saveTheChangesBlock) self.saveTheChangesBlock(info);
    self.type = CCVideoEditTypeNone;
}

#pragma mark - Lazy load
- (UIView *)cancelOrSaveView {
    if (!_cancelOrSaveView) {
        _cancelOrSaveView = [[UIView alloc] init];
        _cancelOrSaveView.backgroundColor = [UIColor blackColor];
        _cancelOrSaveView.alpha = 0;
        [self addSubview:_cancelOrSaveView];
        [_cancelOrSaveView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self);
            make.height.equalTo(@60.f);
        }];
        
        UIButton *cancelBtn = [self generateBtnWithTitle:@"取消" superView:self.cancelOrSaveView];
        [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.height.equalTo(self.cancelOrSaveView);
            make.left.equalTo(self.cancelOrSaveView).offset(8.f);
            make.width.equalTo(@50.f);
        }];

        UIButton *saveBtn = [self generateBtnWithTitle:@"保存" superView:self.cancelOrSaveView];
        [saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.height.equalTo(self.cancelOrSaveView);
            make.right.equalTo(self.cancelOrSaveView).offset(-8.f);
            make.width.equalTo(@50.f);
        }];
        self.cancelBtn = cancelBtn;
        self.saveBtn = saveBtn;
    }
    return _cancelOrSaveView;
}

- (CCEditTrimView *)trimView {
    if (!_trimView) {
        _trimView = [[CCEditTrimView alloc] init];
        _trimView.alpha = 0;
        [self addSubview:_trimView];
        [_trimView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.equalTo(self.containerView.mas_bottom);
            make.bottom.equalTo(self);
        }];
        
        __weak typeof(self) weakSelf = self;
        _trimView.gragBarBlock = ^(CGFloat value) {
            if (weakSelf.trimDragBarBlock) weakSelf.trimDragBarBlock(value);
        };
    }
    return _trimView;
}

#pragma mark - Generate
- (UIButton *)generateBtnWithImageName:(NSString *)imageName superView:(UIView *)superView {
    UIButton *btn = [[UIButton alloc] init];
    if (imageName) {
        [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    }
    [superView addSubview:btn];
    return btn;
}

- (UIButton *)generateBtnWithTitle:(NSString *)title superView:(UIView *)superView {
    UIButton *btn = [[UIButton alloc] init];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [superView addSubview:btn];
    return btn;
}


@end
