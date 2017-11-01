//
//  TextDrawQrViewController.m
//  MMScanDemo
//
//  Created by 郭永红 on 2017/7/4.
//  Copyright © 2017年 keeponrunning. All rights reserved.
//

#import "TestDrawQrViewController.h"
#import "MMScanViewController.h"

@interface TestDrawQrViewController ()<UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *qrImageView;

@property (weak, nonatomic) IBOutlet UITextField *linkTfd;

@end

@implementation TestDrawQrViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
}
- (IBAction)createQrBtnClicked:(id)sender {
    
    if (_linkTfd.text == nil || _linkTfd.text.length == 0) {
        _linkTfd.text = @"http://www.baidu.com";
    }
    
    UIImage *image = [MMScanViewController createQRImageWithString:_linkTfd.text QRSize:CGSizeMake(250, 250) QRColor:[UIColor blackColor] bkColor:[UIColor colorWithRed:0.318 green:0.690 blue:0.839 alpha:1.00]];
    //如果不需要设置背景色以及前景色，则使用下面代码  默认白色底黑色码
    //UIImage *image = [ScanViewController createQRImageWithString:_linkTfd.text QRSize:CGSizeMake(250, 250)];
    [_qrImageView setImage: image];
    
}

//长按保存图片
- (IBAction)tapImage:(id)sender {
    
    if(_qrImageView.image) {
        UIImageWriteToSavedPhotosAlbum(_qrImageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
    } else {
        [self showInfo:@"请先生成二维码"];
    }
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    NSLog(@"image = %@, error = %@, contextInfo = %@", image, error, contextInfo);
    if(error) {
        [self showInfo:[NSString stringWithFormat:@"error: %@",error]];
    } else {
        [self showInfo:@"保存成功"];
    }
}

#pragma mark - Error handle
- (void)showInfo:(NSString*)str {
    [self showInfo:str andTitle:@"提示"];
}

- (void)showInfo:(NSString*)str andTitle:(NSString *)title
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:str preferredStyle:UIAlertControllerStyleAlert];
    
    
    UIAlertAction *action1 = ({
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:NULL];
        action;
    });
    [alert addAction:action1];
    [self presentViewController:alert animated:YES completion:NULL];
}

@end
