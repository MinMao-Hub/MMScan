//
//  MMScanView.m
//  MMScanDemo
//
//  Created by 郭永红 on 2017/6/29.
//  Copyright © 2017年 keeponrunning. All rights reserved.
//

#define LeftDistance 60


#import "MMScanView.h"
@interface MMScanView()

@property (nonatomic, assign) NSInteger heightScale;
@property (nonatomic, strong) UIImageView *lineImageView;

@end

@implementation MMScanView
{
    BOOL needStop;
}

-(id)initWithFrame:(CGRect)frame style:(NSString *)style
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor clearColor];
        _scanType = MMScanTypeQrCode;
        self.heightScale = 1;
        self.lineImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"scan_blue_line" inBundle:[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"resource" ofType: @"bundle"]] compatibleWithTraitCollection:nil]];
        
        needStop = NO;
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat Left = LeftDistance / _heightScale;
    CGSize sizeRetangle = CGSizeMake(self.frame.size.width - Left * 2, self.frame.size.width - Left * 2);
    CGFloat YMinRetangle = self.frame.size.height / 2.0 - sizeRetangle.height/(2.0 * _heightScale);
    _lineImageView.frame = CGRectMake(Left, YMinRetangle + 2, sizeRetangle.width - 4, 5);
    
    [self addSubview:_lineImageView];
}

- (void)setScanType:(MMScanType)scanType
{
    _scanType = scanType;
    if (scanType == MMScanTypeBarCode) {
        self.heightScale = 3;
        _lineImageView.alpha = 0;
    } else {
        self.heightScale = 1;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            needStop = NO;
            [self startAnimating];
        });
    }
    
    [self setNeedsDisplay];
    [self setNeedsLayout];
}

- (void)startAnimating {
    
    if (needStop) {
        return;
    }
    
    CGFloat Left = LeftDistance / _heightScale;
    CGSize sizeRetangle = CGSizeMake(self.frame.size.width - Left * 2, (self.frame.size.width - Left * 2) / _heightScale);
    CGFloat YMinRetangle = self.frame.size.height / 2.0 - sizeRetangle.height/2.0;
    CGFloat YMaxRetangle = YMinRetangle + sizeRetangle.height;
    CGRect initFrame = CGRectMake(Left, YMinRetangle + 2, sizeRetangle.width - 4, 5);
    
    _lineImageView.frame = initFrame;
    _lineImageView.alpha = 1;
    __weak typeof (self)weakSelf = self;
    [UIView animateWithDuration:1.5 animations:^{
        _lineImageView.frame = CGRectMake(initFrame.origin.x, YMaxRetangle - 2, initFrame.size.width, initFrame.size.height);
    } completion:^(BOOL finished) {
        _lineImageView.alpha = 0;
        _lineImageView.frame = initFrame;
        [weakSelf performSelector:@selector(startAnimating) withObject:nil afterDelay:0.3];
    }];
}

- (void)stopAnimating {
    needStop = YES;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    [self drawScanRect];
}

- (void)drawScanRect {
    //扫码区域Y轴最小坐标
    CGFloat Left = LeftDistance / _heightScale;
    CGSize sizeRetangle = CGSizeMake(self.frame.size.width - Left * 2, self.frame.size.width - Left * 2);
    CGFloat YMinRetangle = self.frame.size.height / 2.0 - sizeRetangle.height/(2.0 * _heightScale);
    CGFloat YMaxRetangle = YMinRetangle + sizeRetangle.height / _heightScale;
    CGFloat XRetangleRight = self.frame.size.width - Left;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    //非扫码区域半透明
    //设置非识别区域颜色
    CGContextSetRGBFillColor(context, 0, 0, 0, 0.5);
    
    //扫码区域上面填充
    CGRect rect = CGRectMake(0, 0, self.frame.size.width, YMinRetangle);
    CGContextFillRect(context, rect);
    
    
    //扫码区域左边填充
    rect = CGRectMake(0, YMinRetangle, Left, sizeRetangle.height/_heightScale);
    CGContextFillRect(context, rect);
    
    //扫码区域右边填充
    rect = CGRectMake(XRetangleRight, YMinRetangle, Left,sizeRetangle.height/_heightScale);
    CGContextFillRect(context, rect);
    
    //扫码区域下面填充
    rect = CGRectMake(0, YMaxRetangle, self.frame.size.width, self.frame.size.height - YMaxRetangle);
    CGContextFillRect(context, rect);
    //执行绘画
    CGContextStrokePath(context);
    //执行绘画
    CGContextStrokePath(context);
    
    //中间画矩形(正方形)
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:255 green:255 blue:255 alpha:1.00].CGColor);
    CGContextSetLineWidth(context, 1);
    CGContextAddRect(context, CGRectMake(Left, YMinRetangle, sizeRetangle.width, sizeRetangle.height/_heightScale));
    CGContextStrokePath(context);
    
    //画矩形框4格外围相框角
    //相框角的宽度和高度
    int wAngle = 15;
    int hAngle = 15;
    
    //4个角的 线的宽度
    CGFloat linewidthAngle = 4;// 经验参数：6和4
    
    //画扫码矩形以及周边半透明黑色坐标参数
    CGFloat diffAngle = linewidthAngle/3;
    //diffAngle = linewidthAngle / 2; //框外面4个角，与框有缝隙
    //diffAngle = linewidthAngle/2;  //框4个角 在线上加4个角效果
    //diffAngle = 0;//与矩形框重合
    
    
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:0.110 green:0.659 blue:0.894 alpha:1.00].CGColor);
    CGContextSetRGBFillColor(context, 1.0, 1.0, 1.0, 1.0);
    
    // Draw them with a 2.0 stroke width so they are a bit more visible.
    CGContextSetLineWidth(context, linewidthAngle);
    
    
    //
    CGFloat leftX = Left - diffAngle;
    CGFloat topY = YMinRetangle - diffAngle;
    CGFloat rightX = XRetangleRight + diffAngle;
    CGFloat bottomY = YMaxRetangle + diffAngle;
    
    //左上角水平线
    CGContextMoveToPoint(context, leftX-linewidthAngle/2, topY);
    CGContextAddLineToPoint(context, leftX + wAngle, topY);
    
    //左上角垂直线
    CGContextMoveToPoint(context, leftX, topY-linewidthAngle/2);
    CGContextAddLineToPoint(context, leftX, topY+hAngle);
    
    
    //左下角水平线
    CGContextMoveToPoint(context, leftX-linewidthAngle/2, bottomY);
    CGContextAddLineToPoint(context, leftX + wAngle, bottomY);
    
    //左下角垂直线
    CGContextMoveToPoint(context, leftX, bottomY+linewidthAngle/2);
    CGContextAddLineToPoint(context, leftX, bottomY - hAngle);
    
    
    //右上角水平线
    CGContextMoveToPoint(context, rightX+linewidthAngle/2, topY);
    CGContextAddLineToPoint(context, rightX - wAngle, topY);
    
    //右上角垂直线
    CGContextMoveToPoint(context, rightX, topY-linewidthAngle/2);
    CGContextAddLineToPoint(context, rightX, topY + hAngle);
    
    
    //右下角水平线
    CGContextMoveToPoint(context, rightX+linewidthAngle/2, bottomY);
    CGContextAddLineToPoint(context, rightX - wAngle, bottomY);
    
    //右下角垂直线
    CGContextMoveToPoint(context, rightX, bottomY+linewidthAngle/2);
    CGContextAddLineToPoint(context, rightX, bottomY - hAngle);
    
    CGContextStrokePath(context);
}

@end
