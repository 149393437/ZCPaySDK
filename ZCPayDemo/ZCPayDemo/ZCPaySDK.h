//
//  ZCPaySDK.h
//  ZCPayDemo
//
//  Created by zhangcheng on 16/3/23.
//  Copyright © 2016年 zhangcheng. All rights reserved.
//
//支付宝相关参数
//合作号
#define PARTNER @"2088911964566894"
//公司邮箱
#define SELLER @"hubeilanyao@163.com"
//私有秘钥
#define PRIVATEKEY @"MIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBALys+oYaxqv4FYju8C1poM6qmHLjWPnXzqEJT0NxyFXgdaK/Qe9DcpcASod9mIAdlLIxJEyYNlWeonAJVYW8pQ+pTVGwI9n0iaT71ldWQzcMN3Dvi/+zpgw3HxxO7HJtEIlR84pvILv1yceCZCqqQ4O/4SemsG00oTiTyD3SM2ZvAgMBAAECgYBLToeX6ywNC7Icu7Hljll+45yBjri+0CJLKFoYw1uA21xYnxoEE9my54zX04uA502oafDhGYfmWLDhIvidrpP6oaluURb/gbV5Bdcm98gGGVgm6lpK+G5N/eawXDjP0ZjxXb114Y/Hn/oVFVM9OqcujFSV+Wg4JgJ4Mmtdr35gYQJBAPbhx030xPcep8/dL5QQMc7ddoOrfxXewKcpDmZJi2ey381X+DhuphQ5gSVBbbunRiDCEcuXFY+R7xrgnP+viWcCQQDDpN8DfqRRl+cUhc0z/TbnSPJkMT/IQoFeFOE7wMBcDIBoQePEDsr56mtc/trIUh/L6evP9bkjLzWJs/kb/i25AkEAtoOf1k/4NUEiipdYjzuRtv8emKT2ZPKytmGx1YjVWKpyrdo1FXMnsJf6k9JVD3/QZnNSuJJPTD506AfZyWS6TQJANdeF2Hxd1GatnaRFGO2y0mvs6U30c7R5zd6JLdyaE7sNC6Q2fppjmeu9qFYq975CKegykYTacqhnX4I8KEwHYQJAby60iHMAYfSUpu//f5LMMRFK2sVif9aqlYbepJcAzJ6zbiSG5E+0xg/MjEj/Blg9rNsqDG4RECGJG2nPR72O8g=="

//公司回调地址,用于接受是否成功
#define NOTIFYURL @"http://www.xxx.com"

//微信需要参数
/*
 微信需要一个id 需要进行申请,之后需要服务器提供一个连接返回相关提交预先支付的订单,然后在根据这个相关参数进行支付,获得结果
 */


/*
 一.引用库
 libz
 libsqlite3.0
 libc++
 CoreTelephony
 SystemConfiguration
 CoreMotion

 修改宏定义,合作号\公司邮箱\私钥

 二.配置Scheme
 2.1 点击程序中的info.plist右键选择openAs选择Source Code,显示为xml,加入以下这段,以下这段包含了适配iOS9的https代码
 其中wxb4ba3c02aa476ea1这段是需要你进行替换修改为你自己的  alisdkdemo字段是你应用跳转也需要替换为你自己的
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
 <dict>
 <key>CFBundleTypeRole</key>
 <string>Editor</string>
 <key>CFBundleURLSchemes</key>
 <array>
 <string>alisdkdemo</string>
 </array>
 </dict>
	</array>

 <key>NSAppTransportSecurity</key>
	<dict>
 <key>NSAllowsArbitraryLoads</key>
 <true/>
	</dict>
 
 三.先配置AppDelegate
 - (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
 return  [[ZCPaySDK shareManager]handleOpenURL:url];
 
 }
 
 - (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
  
 return [[ZCPaySDK shareManager]handleOpenURL:url];
 
 }
 //防止用户跳转支付宝,双击返回应用后,UI卡死情况
 - (void)applicationDidBecomeActive:(UIApplication *)application {
 //取消回调,避免UI冲突
 [[ZCPaySDK shareManager]cancalAliPayBlock];
 }
 
 四.支付代码
 
微信支付
 [[ZCPaySDK shareManager]wxPayWithURLStr:@"http://wxpay.weixin.qq.com/pub_v2/app/app_pay.php?plat=ios" Block:^(BOOL isSuccess) {
 
 if (isSuccess) {
 NSLog(@"微信支付成功");
 }else{
 NSLog(@"微信支付失败");
 }
 }];
 
支付宝支付
 第一个参数是商品号码(应用自己的)
 第二个参数是商品名称(应用自己的)
 第三个参数是商品详情(应用自己的)
 第四个参数是回调地址 需要注意是回调地址需要在info中加入scheme这个字段才可以
 [[ZCPaySDK shareManager]aliPayWithSKUNum:@"457761" productName:@"测试商品" desStr:@"测试商品,送你吃糖,么么哒" appScheme:@"alisdkdemo" money:0.01 Block:^(BOOL isSuccess) {
 if (isSuccess) {
 NSLog(@"支付宝支付成功");
 }else{
 NSLog(@"支付宝支付失败");
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

 五.注意事项
 
 集成后,一定要记得需要修改对应的参数,进行支付,否则支付到我钱包了哦
 
 涉及到的问题:在回调中如果用户点击支付到支付宝,但是没支付也没取消,双击home又回到应用,这个时候无法进行处理,所以我们在回到前台的时候,设置回调指空
 最后需要注意的是无论怎么支付,都需要你对服务器进行验证是否钱到账了


 */

#import <Foundation/Foundation.h>
//支付宝需要头文件
#import <AlipaySDK/AlipaySDK.h>
#import "Order.h"
#import "DataSigner.h"
//微信需要头文件
#import "WXApiRequestHandler.h"
#import "WXApiManager.h"
@interface ZCPaySDK : NSObject<WXApiManagerDelegate>
{
    WXApiManager* manager;
}
//支付宝回调
@property(nonatomic,copy)void(^aliPayBlock)(BOOL);
//微信回调
@property(nonatomic,copy)void(^wxPayBlock)(BOOL);
+(instancetype)shareManager;
//支付宝
-(void)aliPayWithSKUNum:(NSString*)skuNum productName:(NSString*)productName desStr:(NSString*)desStr appScheme:(NSString*)scheme money:(float)money Block: (void(^)(BOOL))a;
//微信
-(void)wxPayWithURLStr:(NSString*)url Block:(void(^)(BOOL isSuccess))a;

-(BOOL)handleOpenURL:(NSURL*)url;

-(void)cancalAliPayBlock;

@end









