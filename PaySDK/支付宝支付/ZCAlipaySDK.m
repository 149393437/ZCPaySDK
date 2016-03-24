//
//  ZCAlipaySDK.m
//  AliPayDemo
//
//  Created by zhangcheng on 16/3/21.
//  Copyright © 2016年 zhangcheng. All rights reserved.
//

#import "ZCAlipaySDK.h"
#import  <AlipaySDK/AlipaySDK.h>
//商品
#import "Order.h"
#import "DataSigner.h"
static ZCAlipaySDK*manager=nil;

@implementation ZCAlipaySDK
+(id)shareManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager=[[ZCAlipaySDK alloc]init];
    });
    return manager;
}

-(void)payWithSKUNum:(NSString*)skuNum productName:(NSString*)productName desStr:(NSString*)desStr appScheme:(NSString*)scheme money:(float)money Block: (void(^)(BOOL))a
{
    self.myBlock=a;
    if (money==0) {
        NSLog(@"参数有错,价格不能为0");
        self.myBlock(NO);
    }
    Order*order=[[Order alloc]init];
    order.partner = PARTNER;
    order.seller = SELLER;
    order.tradeNO = skuNum; //订单ID（由商家自行制定）
    order.productName = productName; //商品标题
    order.productDescription = desStr; //商品描述
    order.amount = [NSString stringWithFormat:@"%.2f",money]; //商品价格
    order.notifyURL = NOTIFYURL; //回调URL(这个后台传的）
    //应用注册scheme,在Info.plist定义URL types
    NSString *appScheme =scheme;
    NSString *orderSpec = [order description];
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(PRIVATEKEY);
    NSString *signedString = [signer signString:orderSpec];
    NSString*orderString=nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            if ([resultDic[@"resultStatus"]intValue]==9000) {
                if (self.myBlock) {
                    self.myBlock(YES);
                }
            }else{
                if (self.myBlock) {
                    self.myBlock(NO);
                }
            
            }
           
            /*
             支付失败
             reslut = {
             memo = "";
             result = "";
             resultStatus = 6001;
             }
             支付成功
             reslut = {
             memo = "";
             result = "partner=\"2088911964566894\"&seller_id=\"hubeilanyao@163.com\"&out_trade_no=\"hk8jhk6wr7kk86jlj8hkhkk\"&subject=\"\U65e5\U672c\U5145\U6c14\U5a03\U5a03\"&body=\"\U5168\U65e5\U672c\U8fdb\U53e3,\U8d28\U91cf\U53ef\U9760,\U5145\U6c14\U4e0d\U6f0f\U6c14\"&total_fee=\"0.01\"&notify_url=\"http://www.xxx.com\"&success=\"true\"&sign_type=\"RSA\"&sign=\"f33XDhm4t+NQ3zahn9m5rWZAUhUGRMDTE93d5fdDbUkX8EBi1YA5a+LNOf2BgIqVCGSR1AP9t4sC08LRBMKE49H/6+T7fJ5ufcXNtq3oByEhh9ghK0SFHGWDk7aNGrqofM3SbgqyUXJtqO4ZSXf62BaRz6XH6Oh3hERJuAZ+EGs=\"";
             resultStatus = 9000;
             }
             */
        }];
    }

}
- (void)processOrderWithPaymentResult:(NSURL *)resultUrl
                      standbyCallback:(void(^)(NSDictionary*dic))b
{
    self.myBlock1=b;
    [[AlipaySDK defaultService] processOrderWithPaymentResult:resultUrl standbyCallback:^(NSDictionary *resultDic) {
        if (self.myBlock1) {
            self.myBlock1(resultDic);
        }
    }];

}
-(void)cancalBlock{
    self.myBlock=nil;

}

@end
