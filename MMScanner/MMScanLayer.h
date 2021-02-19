//
//  MMScanLayer.h
//  MMScanDemo
//
//  Created by gyh on 2021/2/18.
//  Copyright © 2021 keeponrunning. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MMScanLayer : CALayer

- (instancetype)initWithBounds:(CGRect)bounds
                     focusRect:(CGRect)focusRect;

//更新扫描区域
- (void)updateFocus:(CGRect)focusRect;

/// 开始扫描线条动画
- (void)startAnimate;

/// 停止扫描线条动画
- (void)stopAnimate;

@end

NS_ASSUME_NONNULL_END
