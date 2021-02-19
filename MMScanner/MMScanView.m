//
//  MMScanView.m
//  MMScanDemo
//
//  Created by 郭永红 on 2017/6/29.
//  Copyright © 2017年 keeponrunning. All rights reserved.
//

#define LeftDistance 60

#import "MMScanView.h"
#import "MMScanLayer.h"

@interface MMScanView()

@property (nonatomic, assign) NSInteger heightScale;
@property (nonatomic, strong) MMScanLayer *scanRectLayer;

@end

@implementation MMScanView {
    BOOL needStop;
}

-(id)initWithFrame:(CGRect)frame style:(NSString *)style {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        _scanType = MMScanTypeQrCode;
        self.heightScale = 1;
        [self createLayer];
    }
    return self;
}

- (void)createLayer {
    CGFloat Left = LeftDistance / _heightScale;
    CGSize sizeRetangle = CGSizeMake(self.frame.size.width - Left * 2, (self.frame.size.width - Left * 2) / _heightScale);
    CGFloat YMinRetangle = self.frame.size.height / 2.0 - sizeRetangle.height/2.0;
    
    _scanRectLayer = [[MMScanLayer alloc] initWithBounds:self.bounds focusRect:CGRectMake(Left, YMinRetangle, sizeRetangle.width, sizeRetangle.height)];
    [self.layer addSublayer:_scanRectLayer];
}

- (void)setScanType:(MMScanType)scanType {
    _scanType = scanType;
    self.heightScale = scanType == MMScanTypeBarCode ? 3 : 1;
    
    CGFloat Left = LeftDistance / _heightScale;
    CGSize sizeRetangle = CGSizeMake(self.frame.size.width - Left * 2, (self.frame.size.width - Left * 2) / _heightScale);
    CGFloat YMinRetangle = self.frame.size.height / 2.0 - sizeRetangle.height/2.0;
    [_scanRectLayer updateFocus:CGRectMake(Left,
                                           YMinRetangle,
                                           sizeRetangle.width,
                                           sizeRetangle.height)];
}

- (void)startAnimating {
    [_scanRectLayer startAnimate];
}

- (void)stopAnimating {
    [_scanRectLayer stopAnimate];
}

@end
