//
//  KCUtilENavi.m
//  eNavi
//
//  Created by zihong on 13-12-10.
//
//

#import "KCUtilENavi.h"
#import "KCBaseDefine.h"

#import "KCMainBundle.h"
//#import "PubDataMgr.h"
#import "KCUtilCoding.h"
#import "NaviDefine.h"
//#import "UIDevice+KCHardware.h"
//#import "KCAuthManager.h"


@implementation KCUtilENavi



#pragma mark

+(void)alertDefaultSingle:(NSString*)msg okBlock:(btnOkBlock)ok
{
//    RIButtonItem* item1 = [RIButtonItem itemWithLabel:@"确定"];
//    item1.action = ^
//    {
//        ok();
//    };
//    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:msg cancelButtonItem:item1 otherButtonItems: nil];
//    
//    [alert show];
//    KCRelease(alert);
}

+(void)alertDefault:(NSString*)msg okBlock:(btnOkBlock)ok
{
    [self alertDefault:msg title:@"提示" okBtnTitle:@"确定" okBlock:ok];
}

+(void)alertDefaultDidDismiss:(NSString*)msg okBlock:(btnOkBlock)ok
{
//    RIButtonItem* item1 = [RIButtonItem itemWithLabel:@"确定"];
//    item1.actionDidDismiss = ^
//    {
//        ok();
//    };
//    RIButtonItem* item2 = [RIButtonItem itemWithLabel:@"取消"];
//    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:msg cancelButtonItem:item1 otherButtonItems:item2, nil];
//    
//    [alert show];
//    KCRelease(alert);
}

+(void)alertDefault:(NSString*)msg title:(NSString*)title okBtnTitle:(NSString*)okText okBlock:(btnOkBlock)ok
{
//    RIButtonItem* item1 = [RIButtonItem itemWithLabel:okText];
//    item1.action = ^
//    {
//        ok();
//    };
//    RIButtonItem* item2 = [RIButtonItem itemWithLabel:@"取消"];
//    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:title message:msg cancelButtonItem:item2 otherButtonItems:item1, nil];
//    
//    [alert show];
//    KCRelease(alert);
}

//是否自动锁屏
+(void)setAutoLockScreen:(BOOL)isAutoLock
{
    [[UIApplication sharedApplication] setIdleTimerDisabled:!isAutoLock];
}

#warning 头信息加密
//static NSDictionary* s_strHeaderInfo = nil;

+(NSMutableDictionary*)getHeaderInfo
{
  //  NSString *mdn = [[KCAuthManager sharedInstance] getUserMdn];
    //httpMdn
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *httpMdn = [user objectForKey:@"httpMdn"];
// if (mdn==nil && ![httpMdn isEqualToString:@""""])
// {
//     g_pubDataMgr.pSysMgr.sysSetting.userPhoneNumber = httpMdn;
// }
// else
// {
//     g_pubDataMgr.pSysMgr.sysSetting.userPhoneNumber = mdn;
// }
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
   // KCAutorelease(dic);
    NSString* version =  [KCMainBundle getVersion];
    [dic setObject:[NSString stringWithFormat:@"tianyi_navi_pdager_IP v%@ App", version] forKey:HTTP_HEADER_AGENT];
    [dic setObject:[NSString stringWithFormat:@"v%@", version] forKey:@"x-up-devcap-appinfo"];
    [dic setObject:[KCUtilCoding encryptUseDES:[KCMainBundle getGUDID] key:kDesKey] forKey:@"x-up-imsi"];
    [dic setObject:[NSString stringWithFormat:@"iPhone %@", [[UIDevice currentDevice] systemVersion]] forKey:@"x-up-devcap-platform-id"];
    [dic setObject:@"-1,-1,-1" forKey:@"x-up-devcap-brewlicense"];
    [dic setObject:[KCMainBundle getGUDID] forKey:@"x-up-macaddr"];
    [dic setObject:[KCMainBundle getGUDID] forKey:@"x-up-gudid"];
    
//    if (g_pubDataMgr.pSysMgr.sysSetting.userPhoneNumber != nil)
//    {
//        
//        if (mdn==nil && ![httpMdn isEqualToString:@""""])
//        {
//            
//          [dic setObject:[KCUtilCoding encryptUseDES:httpMdn key:kDesKey] forKey:HTTP_HEADER_MDN];
//           // [dic setObject:httpMdn forKey:kDesKey];
//            
//        }
//        else
//        {
//           [dic setObject:[KCUtilCoding encryptUseDES:mdn key:kDesKey] forKey:HTTP_HEADER_MDN];
//            [dic setObject:mdn forKey:kDesKey];
//        }
//
//    }
               [dic setObject:[KCUtilCoding encryptUseDES:@"18855121624" key:kDesKey] forKey:HTTP_HEADER_MDN];
                [dic setObject:@"18855121624" forKey:kDesKey];
    NSLog(@"%@",dic);
    return dic;
}

+ (NSMutableDictionary *)getAccountHeaderInfo
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    KCAutorelease(dic);
    
    [dic setObject:[KCMainBundle getGUDID] forKey:@"X-DEVICE-ID"];
//    [dic setObject:@"" forKey:@"X-UID"];
    [dic setObject:[NSString stringWithFormat:@"%@", [[UIDevice currentDevice] hardwareDescription]] forKey:@"X-PLATFORM"];
    
    NSString* version =  [KCMainBundle getVersion];
    [dic setObject:[NSString stringWithFormat:@"v%@", version] forKey:@"X-CLIENT-VERSION"];
    
    [dic setObject:[NSString stringWithFormat:@"%@", [[UIDevice currentDevice] systemVersion]] forKey:@"X-SDK-VERSION"];
//    [dic setObject:@"" forKey:@"X-LOCAL-IP"];
    [dic setObject:[[UIDevice currentDevice] macaddress] forKey:@"X-MAC"];
    
    return dic;
}

@end
