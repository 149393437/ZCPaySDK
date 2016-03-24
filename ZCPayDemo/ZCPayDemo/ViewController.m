//
//  ViewController.m
//  ZCPayDemo
//
//  Created by zhangcheng on 16/3/23.
//  Copyright © 2016年 zhangcheng. All rights reserved.
//

#import "ViewController.h"

#import "ZCPaySDK.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)aliPayClick:(id)sender {
    [[ZCPaySDK shareManager]aliPayWithSKUNum:@"4577612" productName:@"测试商品" desStr:@"测试商品,送你吃糖,么么哒" appScheme:@"alisdkdemo" money:0.01 Block:^(BOOL isSuccess) {
        if (isSuccess) {
            NSLog(@"支付宝支付成功");
        }else{
            NSLog(@"支付宝支付失败");
        }
        
    }];
}
- (IBAction)wxPayClick:(id)sender {
    [[ZCPaySDK shareManager]wxPayWithURLStr:@"http://wxpay.weixin.qq.com/pub_v2/app/app_pay.php?plat=ios" Block:^(BOOL isSuccess) {
        
        if (isSuccess) {
            NSLog(@"微信支付成功");
        }else{
            NSLog(@"微信支付失败");
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
