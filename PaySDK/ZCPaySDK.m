//
//  ZCPaySDK.m
//  ZCPayDemo
//
//  Created by zhangcheng on 16/3/23.
//  Copyright © 2016年 zhangcheng. All rights reserved.
//

#import "ZCPaySDK.h"

@implementation ZCPaySDK

static ZCPaySDK*sdk=nil;
+(instancetype)shareManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sdk=[[ZCPaySDK alloc]init];
        //进行注册
        //读取info.plist中的值
        NSDictionary*dic=[NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"Info" ofType:@"plist"]];
        NSArray*urlArray=dic[@"CFBundleURLTypes"];
        //进行遍历
        NSString*str1=nil;
        
        for (NSDictionary*urlDic in urlArray) {
            if ([urlDic[@"CFBundleURLName"] isEqualToString:@"weixin"]) {
                //循环遍历
                NSArray*schemesArray=urlDic[@"CFBundleURLSchemes"];
                for (NSString*str in schemesArray) {
                    if ([str hasPrefix:@"wx"]) {
                        str1=str;
                    }
                }
            }
        }
        if (str1==nil) {
            [[[UIAlertView alloc]initWithTitle:@"请设置工程中Info.plist的Schemes" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"", nil]show];
        }else{
            [WXApi registerApp:str1 withDescription:dic[@"CFBundleName"]];
        }
        
    });
    return sdk;
}
-(void)aliPayWithSKUNum:(NSString*)skuNum productName:(NSString*)productName desStr:(NSString*)desStr appScheme:(NSString*)scheme money:(float)money Block: (void(^)(BOOL))a
{
    self.aliPayBlock=a;
    if (money==0) {
        NSLog(@"参数有错,价格不能为0");
        self.aliPayBlock(NO);
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
                if (self.aliPayBlock) {
                    self.aliPayBlock(YES);
                }
            }else{
                if (self.aliPayBlock) {
                    self.aliPayBlock(NO);
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

-(void)wxPayWithURLStr:(NSString*)url Block:(void(^)(BOOL isSuccess))a
{
    
    NSString *urlString   = url;
    self.wxPayBlock=a;
    //解析服务端返回json数据
    //加载一个NSURL对象
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    //将请求的url数据放到NSData对象中
    NSURLSessionConfiguration*config=[NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session=[NSURLSession sessionWithConfiguration:config];
    NSURLSessionDataTask*task= [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if ( response != nil) {
            NSMutableDictionary *dict = NULL;
            //iOS5自带解析类NSJSONSerialization从response中解析出数据放到字典中
            dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
            
            if(dict != nil){
                NSMutableString *retcode = [dict objectForKey:@"retcode"];
                if (retcode.intValue == 0){
                    NSMutableString *stamp  = [dict objectForKey:@"timestamp"];
                    manager= [WXApiManager sharedManager];
                    manager.delegate=self;
                    //调起微信支付
                    PayReq* req             = [[PayReq alloc] init];
                    req.partnerId           = [dict objectForKey:@"partnerid"];
                    req.prepayId            = [dict objectForKey:@"prepayid"];
                    req.nonceStr            = [dict objectForKey:@"noncestr"];
                    req.timeStamp           = stamp.intValue;
                    req.package             = [dict objectForKey:@"package"];
                    req.sign                = [dict objectForKey:@"sign"];
                    [WXApi sendReq:req];
                    //日志输出
                }
            }
        }else{
            if (_wxPayBlock) {
                _wxPayBlock(NO);
            }
        }
        
        
    }];
    [task resume];
    
    
}
-(void)managerDidPayWXReq:(BOOL)isSuccess
{
    //应该不论成功与否,都应该去自己的服务器端验证一下是否支付成功
    
    if (isSuccess) {
        NSLog(@"支付成功");
        if (_wxPayBlock) {
            _wxPayBlock(YES);
        }
    }else{
        NSLog(@"支付失败");
        if (_wxPayBlock) {
            _wxPayBlock(NO);
        }
    }
    
}
-(BOOL)handleOpenURL:(NSURL*)url
{
    [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
        
    }];
    [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
    return YES;
}
-(void)cancalAliPayBlock{
    self.aliPayBlock=nil;
}

@end
