//
//  WXPaySDK.h
//  weixinPayDemo
//
//  Created by zhangcheng on 16/3/22.
//  Copyright © 2016年 zhangcheng. All rights reserved.
//
/*
 一.添加引用库
 SystemConfiguration
 libz
 libsqlite3.0
 libc++
 Security
 CoreTelephony
 二.配置Scheme
 2.1 点击程序中的info.plist右键选择openAs选择Source Code,显示为xml,加入以下这段
 其中wxb4ba3c02aa476ea1这段是需要你进行替换修改为你自己的
 <key>CFBundleURLTypes</key>
	<array>
 <dict>
 <key>CFBundleTypeRole</key>
 <string>Editor</string>
 <key>CFBundleURLName</key>
 <string>weixin</string>
 <key>CFBundleURLSchemes</key>
 <array>
 <string>wxb4ba3c02aa476ea1</string>
 </array>
 </dict>
	</array>
 
 2.2 需要在plist中加入http降级处理的操作,适配iOS9
 <key>NSAppTransportSecurity</key>
	<dict>
 <key>NSAllowsArbitraryLoads</key>
 <true/>
	</dict>
 三.先配置AppDelegate
 - (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
 return  [[ZCWXPaySDK shareManager]handleOpenURL:url];
 }
 
 - (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
 return [[ZCWXPaySDK shareManager]handleOpenURL:url];
 }
 四.支付代码
 
 [[ZCWXPaySDK shareManager]wxPayWithURLStr:@"http://wxpay.weixin.qq.com/pub_v2/app/app_pay.php?plat=ios" Block:^(BOOL isSuccess) {
 if (isSuccess) {
 NSLog(@"支付成功");
 }else{
 NSLog(@"支付失败");
 }
 }];
 
 http://wxpay.weixin.qq.com/pub_v2/app/app_pay.php?plat=ios
 以上这个链接是服务器提供的,服务端也需要集成微信的API,向微信服务器进行请求统一下单的接口,之后提供给你支付需要相关参数,这个链接要求返回为一个字典,内容包含以下
 {
 "appid": "wxb4ba3c02aa476ea1",
 "noncestr": "2c4032a66885ec5a95d5a1cba479e303",
 "package": "Sign=WXPay",
 "partnerid": "10000100",
 "prepayid": "wx20160323181931c39ad6c6c30747319441",
 "timestamp": "1458728371",
 "sign": "7D3F5D5D618F3BD4DA2FF3E523AB6982"
 }
 */
#import <Foundation/Foundation.h>
#import "WXApiRequestHandler.h"
#import "WXApiManager.h"
@interface ZCWXPaySDK : NSObject<WXApiManagerDelegate>
{
    WXApiManager*manager;
}
@property(nonatomic,copy)void(^myBlock)(BOOL isSuccess);
+(instancetype)shareManager;
//传递参数
-(void)wxPayWithURLStr:(NSString*)url Block:(void(^)(BOOL isSuccess))a;
-(BOOL)handleOpenURL:(NSURL*)url;
@end
