
//小张诚技术博客http://blog.sina.com.cn/u/2914098025
//github代码地址https://github.com/149393437
//欢迎加入iOS研究院 QQ群号305044955    你的关注就是我开源的动力

//商户号,这个是http://open.alipay.com/platform/home.html进行申请的
/*
 集成支付宝需要注意的事项
 一.加入引用库
 libz
 libc++
 SystemConfiguration
 CoreMotion
 CFNetWork
 CoreGraphics
 CoreText
 CoreTelephony
 CoreData
 
 在加入3rd包
 修改宏定义,合作号\公司邮箱\私钥,如果还没申请,请到http://www.baidu.com上面依次进行申请,集成后,一定要记得需要修改对应的参数,进行支付,否则支付到我钱包了哦

 二.在Appdelegate设置
 加入头文件#import <AlipaySDK/AlipaySDK.h>
 在Appdelegate中复制出以下内容
 - (BOOL)application:(UIApplication *)application
 openURL:(NSURL *)url
 sourceApplication:(NSString *)sourceApplication
 annotation:(id)annotation{
 [[ZCAlipaySDK shareManager] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
 NSLog(@"%@",resultDic);
 
 }];
 
 return YES;
 }
 //防止用户跳转支付宝,双击返回应用后,UI卡死情况
 - (void)applicationDidBecomeActive:(UIApplication *)application {
 //取消回调,避免UI冲突
 [[ZCAlipaySDK shareManager]cancalBlock];
 
 }

 三.调用支付
 第一个参数是商品号码(应用自己的)
 第二个参数是商品名称(应用自己的)
 第三个参数是商品详情(应用自己的)
 第四个参数是回调地址 需要注意是回调地址需要在info中加入scheme这个字段才可以
 [[ZCAlipaySDK shareManager]payWithSKUNum:@"hk8jhk6wr7kk86jlj8hkhkk" productName:@"日本充气娃娃" desStr:@"全日本进口,质量可靠,充气不漏气" appScheme:@"alisdkdemo" money:0.01 Block:^(BOOL isSuccess) {
 if (isSuccess) {
 NSLog(@"支付成功");
 }
 }];
 
 
 四.注意事项
 
 集成后,一定要记得需要修改对应的参数,进行支付,否则支付到我钱包了哦
 
 涉及到的问题:在回调中如果用户点击支付到支付宝,但是没支付也没取消,双击home又回到应用,这个时候无法进行处理,所以我们在回到前台的时候,设置回调指空

 */





//合作号
#define PARTNER @"2088911964566894"
//公司邮箱
#define SELLER @"hubeilanyao@163.com"
//私有秘钥
#define PRIVATEKEY @"MIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBALys+oYaxqv4FYju8C1poM6qmHLjWPnXzqEJT0NxyFXgdaK/Qe9DcpcASod9mIAdlLIxJEyYNlWeonAJVYW8pQ+pTVGwI9n0iaT71ldWQzcMN3Dvi/+zpgw3HxxO7HJtEIlR84pvILv1yceCZCqqQ4O/4SemsG00oTiTyD3SM2ZvAgMBAAECgYBLToeX6ywNC7Icu7Hljll+45yBjri+0CJLKFoYw1uA21xYnxoEE9my54zX04uA502oafDhGYfmWLDhIvidrpP6oaluURb/gbV5Bdcm98gGGVgm6lpK+G5N/eawXDjP0ZjxXb114Y/Hn/oVFVM9OqcujFSV+Wg4JgJ4Mmtdr35gYQJBAPbhx030xPcep8/dL5QQMc7ddoOrfxXewKcpDmZJi2ey381X+DhuphQ5gSVBbbunRiDCEcuXFY+R7xrgnP+viWcCQQDDpN8DfqRRl+cUhc0z/TbnSPJkMT/IQoFeFOE7wMBcDIBoQePEDsr56mtc/trIUh/L6evP9bkjLzWJs/kb/i25AkEAtoOf1k/4NUEiipdYjzuRtv8emKT2ZPKytmGx1YjVWKpyrdo1FXMnsJf6k9JVD3/QZnNSuJJPTD506AfZyWS6TQJANdeF2Hxd1GatnaRFGO2y0mvs6U30c7R5zd6JLdyaE7sNC6Q2fppjmeu9qFYq975CKegykYTacqhnX4I8KEwHYQJAby60iHMAYfSUpu//f5LMMRFK2sVif9aqlYbepJcAzJ6zbiSG5E+0xg/MjEj/Blg9rNsqDG4RECGJG2nPR72O8g=="


#define NOTIFYURL @"http://www.xxx.com"






#import <Foundation/Foundation.h>

@interface ZCAlipaySDK : NSObject
@property(nonatomic,copy)void(^myBlock)(BOOL isSuccess);
@property(nonatomic,copy)void(^myBlock1)(NSDictionary*dic);
+(id)shareManager;
//传递数据参数进行支付
-(void)payWithSKUNum:(NSString*)skuNum productName:(NSString*)productName desStr:(NSString*)desStr appScheme:(NSString*)scheme money:(float)money Block: (void(^)(BOOL))a;
//在AppDeleate中的openURL调用
- (void)processOrderWithPaymentResult:(NSURL *)resultUrl
                      standbyCallback:(void(^)(NSDictionary*dic))b;

//在AppDelegate中的applicationDidBecomeActive中调用
-(void)cancalBlock;

@end
