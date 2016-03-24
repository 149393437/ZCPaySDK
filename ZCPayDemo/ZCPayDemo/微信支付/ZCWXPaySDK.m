//
//  WXPaySDK.m
//  weixinPayDemo
//
//  Created by zhangcheng on 16/3/22.
//  Copyright © 2016年 zhangcheng. All rights reserved.
//

#import "ZCWXPaySDK.h"

@implementation ZCWXPaySDK
static ZCWXPaySDK*sdk=nil;
+(instancetype)shareManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sdk=[[ZCWXPaySDK alloc]init];
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
-(void)wxPayWithURLStr:(NSString*)url Block:(void(^)(BOOL isSuccess))a
{
    
    NSString *urlString   = url;
    self.myBlock=a;
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
            if (_myBlock) {
                self.myBlock(NO);
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
        if (_myBlock) {
            self.myBlock(YES);
        }
    }else{
        NSLog(@"支付失败");
        if (_myBlock) {
            self.myBlock(NO);
        }
    }
    
}
-(BOOL)handleOpenURL:(NSURL*)url
{
    return [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
}
@end
