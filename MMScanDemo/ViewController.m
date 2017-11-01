//
//  ViewController.m
//  MMScanDemo
//
//  Created by 郭永红 on 2017/6/28.
//  Copyright © 2017年 keeponrunning. All rights reserved.
//

#import "ViewController.h"
#import "MMScanViewController.h"
#import "TestDrawQrViewController.h"
#import "TestDrawBarViewController.h"
@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ViewController
{
    NSArray *dataArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    dataArray = @[@"扫一扫",@"扫描二维码",@"扫描条形码",@"绘制二维码",@"绘制条形码"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
    }
    cell.textLabel.text = dataArray[indexPath.row];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        MMScanViewController *scanVc = [[MMScanViewController alloc] initWithQrType:MMScanTypeAll onFinish:^(NSString *result, NSError *error) {
            if (error) {
                NSLog(@"error: %@",error);
            } else {
                NSLog(@"扫描结果：%@",result);
                [self showInfo:result];
            }
        }];
        [self.navigationController pushViewController:scanVc animated:YES];
    } else if (indexPath.row == 1) {
        MMScanViewController *scanVc = [[MMScanViewController alloc] initWithQrType:MMScanTypeQrCode onFinish:^(NSString *result, NSError *error) {
            if (error) {
                NSLog(@"error: %@",error);
            } else {
                NSLog(@"扫描结果：%@",result);
                [self showInfo:result];
            }
        }];
        [self.navigationController pushViewController:scanVc animated:YES];
    } else if (indexPath.row == 2) {
        MMScanViewController *scanVc = [[MMScanViewController alloc] initWithQrType:MMScanTypeBarCode onFinish:^(NSString *result, NSError *error) {
            if (error) {
                NSLog(@"error: %@",error);
            } else {
                NSLog(@"扫描结果：%@",result);
                [self showInfo:result];
            }
        }];
        [self.navigationController pushViewController:scanVc animated:YES];
    } else if (indexPath.row == 3) {
        TestDrawQrViewController *drawQrVC = [self.storyboard instantiateViewControllerWithIdentifier:@"drawQr"];
        [self.navigationController pushViewController:drawQrVC animated:YES];
    } else {
        TestDrawBarViewController *drawBarVC = [self.storyboard instantiateViewControllerWithIdentifier:@"drawBar"];
        [self.navigationController pushViewController:drawBarVC animated:YES];
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
