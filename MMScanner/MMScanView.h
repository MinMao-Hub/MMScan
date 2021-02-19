//
//  MMScanView.h
//  MMScanDemo
//
//  Created by 郭永红 on 2017/6/29.
//  Copyright © 2017年 keeponrunning. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    MMScanTypeQrCode,
    MMScanTypeBarCode,
    MMScanTypeAll,
} MMScanType;

@interface MMScanView : UIView

-(id)initWithFrame:(CGRect)frame style:(NSString *)style;

//开始扫描动画
- (void)startAnimating;
//停止扫描动画
- (void)stopAnimating;

@property (nonatomic, assign) MMScanType scanType;

@end
