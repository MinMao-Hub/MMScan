//
//  MMScanLayer.m
//  MMScanDemo
//
//  Created by gyh on 2021/2/18.
//  Copyright © 2021 keeponrunning. All rights reserved.
//

#import "MMScanLayer.h"

#define RECTANGLE_LINE_W 0.5
#define ANGLE_LINE_W     3.0
#define ANGLE_LINE_H     15.0

@interface MMScanLayer()<CAAnimationDelegate>

//扫描区域坐标
@property (nonatomic, assign) CGRect focusRect;

/// 扫描线
@property (nonatomic, strong) CAGradientLayer * lineLayer;

/// 矩形动画时长
@property (assign,nonatomic) CGFloat animateDurationWhenFocusChange;

/// 扫描线一次扫描动画时长
@property (assign,nonatomic) CGFloat lineAnimateDuration;

@end

@implementation MMScanLayer

@dynamic focusRect;

- (instancetype)initWithBounds:(CGRect)bounds
                     focusRect:(CGRect)focusRect {
    if (self = [super init]) {
        self.anchorPoint = CGPointZero;
        self.position = CGPointZero;
        self.bounds = bounds;
        self.animateDurationWhenFocusChange = 0.4;
        self.lineAnimateDuration = 1.5;
        self.contentsScale = [UIScreen mainScreen].scale;
        self.needsDisplayOnBoundsChange = true;
        self.focusRect = focusRect;
        self.lineLayer = ({
            CAGradientLayer *layer = [CAGradientLayer layer];
            layer.colors = @[
                (__bridge id)[UIColor colorWithRed:0.110 green:0.659 blue:0.894 alpha:0.6].CGColor,
                (__bridge id)[UIColor colorWithRed:0.110 green:0.659 blue:0.894 alpha:1.00].CGColor,
                (__bridge id)[UIColor colorWithRed:0.110 green:0.659 blue:0.894 alpha:0.6].CGColor
            ];
            layer.startPoint = CGPointMake(0, 0);
            layer.startPoint = CGPointMake(1, 0);
            layer.frame = CGRectMake(focusRect.origin.x, focusRect.origin.y, focusRect.size.width, 2);
            layer;
        });
        [self addSublayer:self.lineLayer];
        [self setNeedsDisplay];
//        [self startAnimate];
    }
    return self;
}

//属性动画
+ (BOOL)needsDisplayForKey:(NSString *)key {
    if ([key isEqualToString:@"focusRect"]) {
        return true;
    }
    return [super needsDisplayForKey:key];
}

//属性动画
- (id<CAAction>)actionForKey:(NSString *)event {
    if ([event isEqualToString:@"focusRect"]) {
        CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:event];
        anim.fromValue = [[self presentationLayer] valueForKey:event];
        anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        anim.delegate = self;
        anim.duration = self.animateDurationWhenFocusChange;
        [anim setValue:@"scanFocusChageAnimation" forKey:@"scanFocusKey"];
        return anim;
    }
    return [super actionForKey:event];
}

//更新矩形区域位置以及大小
- (void)updateFocus:(CGRect)focusRect {
    self.focusRect = focusRect;
    self.lineAnimateDuration = focusRect.size.width/focusRect.size.height > 1 ? 1.2 : 1.5;
}

//绘制
-(void)drawInContext:(CGContextRef)ctx {
    //半透明区域
    UIBezierPath * focusPath = [self createBezierPathWithBounds:self.bounds focusRect:self.focusRect];
    CGContextAddPath(ctx, focusPath.CGPath);
    CGContextSetFillColorWithColor(ctx, [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5].CGColor);
    //奇偶填充规则填充上下文路径
    CGContextEOFillPath(ctx);
    
    //矩形框
    UIBezierPath * beziper = [UIBezierPath bezierPathWithRect:self.focusRect];
    CGContextAddPath(ctx, beziper.CGPath);
    CGContextSetStrokeColorWithColor(ctx, [UIColor whiteColor].CGColor);
    CGContextSetLineWidth(ctx, RECTANGLE_LINE_W);
    CGContextStrokePath(ctx);
    
    //设置边角颜色和线宽
    CGContextSetStrokeColorWithColor(ctx, [UIColor colorWithRed:0.110 green:0.659 blue:0.894 alpha:1.00].CGColor);
    CGContextSetLineWidth(ctx, ANGLE_LINE_W);
    
    //四个角 - 左上
    CGContextMoveToPoint(ctx, self.focusRect.origin.x + ANGLE_LINE_H, self.focusRect.origin.y);
    CGContextAddLineToPoint(ctx, self.focusRect.origin.x,self.focusRect.origin.y);
    CGContextAddLineToPoint(ctx, self.focusRect.origin.x, self.focusRect.origin.y + ANGLE_LINE_H);
    CGContextStrokePath(ctx);
    
    // - 右上
    CGContextMoveToPoint(ctx, self.focusRect.origin.x + self.focusRect.size.width - ANGLE_LINE_H, self.focusRect.origin.y);
    CGContextAddLineToPoint(ctx, self.focusRect.origin.x + self.focusRect.size.width, self.focusRect.origin.y);
    CGContextAddLineToPoint(ctx, self.focusRect.origin.x + self.focusRect.size.width, self.focusRect.origin.y + ANGLE_LINE_H);
    CGContextStrokePath(ctx);
    
    // - 右下
    CGContextMoveToPoint(ctx, self.focusRect.origin.x + self.focusRect.size.width, self.focusRect.origin.y + self.focusRect.size.height - ANGLE_LINE_H);
    CGContextAddLineToPoint(ctx,self.focusRect.origin.x + self.focusRect.size.width,self.focusRect.origin.y + self.focusRect.size.height);
    CGContextAddLineToPoint(ctx, self.focusRect.origin.x + self.focusRect.size.width - ANGLE_LINE_H, self.focusRect.origin.y + self.focusRect.size.height);
    CGContextStrokePath(ctx);
    
    // - 左下
    CGContextMoveToPoint(ctx, self.focusRect.origin.x, self.focusRect.origin.y - ANGLE_LINE_H + self.focusRect.size.height);
    CGContextAddLineToPoint(ctx,self.focusRect.origin.x,self.focusRect.origin.y+self.focusRect.size.height);
    CGContextAddLineToPoint(ctx, self.focusRect.origin.x + ANGLE_LINE_H, self.focusRect.origin.y + self.focusRect.size.height);
    CGContextStrokePath(ctx);
}

//创建镂空区域路径
- (UIBezierPath *)createBezierPathWithBounds:(CGRect)bounds focusRect:(CGRect)focusRect {
    UIBezierPath * bezierPath = [UIBezierPath bezierPathWithRect:bounds];
    UIBezierPath * focusPath = [UIBezierPath bezierPathWithRect:focusRect];
    [bezierPath appendPath:focusPath];
    return bezierPath;
}

//开始线条动画
- (void)startAnimate {
    //阻止重复添加 - 导致动画开始时有错乱现象
    if ([self.lineLayer.animationKeys containsObject:@"linePositionAnimation"]) return;
    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanTrue
                     forKey:kCATransactionDisableActions];
    self.lineLayer.frame = CGRectMake(self.focusRect.origin.x, self.focusRect.origin.y, self.focusRect.size.width, 1);
    self.lineLayer.hidden = false;
    [CATransaction commit];
    
    CABasicAnimation * animation = [CABasicAnimation animation];
    animation.keyPath = @"position.y";
    animation.toValue = @(self.focusRect.origin.y + self.focusRect.size.height);
    animation.duration = self.lineAnimateDuration;
    animation.repeatCount = HUGE_VALF;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [self.lineLayer addAnimation:animation forKey:@"linePositionAnimation"];
}

//结束线条动画
- (void)stopAnimate {
    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanTrue
                     forKey:kCATransactionDisableActions];
    self.lineLayer.hidden = true;
    [CATransaction commit];
    [self.lineLayer removeAllAnimations];
}

#pragma mark - CAAnimationDelegate
- (void)animationDidStart:(CAAnimation *)anim {
    if ([[anim valueForKey:@"scanFocusKey"] isEqualToString:@"scanFocusChageAnimation"]) {
        [self stopAnimate];
    }
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if ([[anim valueForKey:@"scanFocusKey"] isEqualToString:@"scanFocusChageAnimation"]) {
        [self startAnimate];
    }
}

@end
