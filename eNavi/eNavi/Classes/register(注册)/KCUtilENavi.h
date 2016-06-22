//
//  KCUtilENavi.h
//  eNavi
//
//  Created by zihong on 13-12-10.
//
//

#import <Foundation/Foundation.h>
#import "UIDevice+KCHardware.h"
@interface KCUtilENavi : NSObject


typedef void (^btnOkBlock)();
+(void)alertDefaultSingle:(NSString*)msg okBlock:(btnOkBlock)left;
+(void)alertDefault:(NSString*)msg okBlock:(btnOkBlock)left;
+(void)alertDefaultDidDismiss:(NSString*)msg okBlock:(btnOkBlock)left;
+(void)alertDefault:(NSString*)msg title:(NSString*)title okBtnTitle:(NSString*)leftText okBlock:(btnOkBlock)left;
//是否自动锁屏
+(void)setAutoLockScreen:(BOOL)isAutoLock;

+(NSMutableDictionary*)getHeaderInfo;
+(NSMutableDictionary *)getAccountHeaderInfo;

@end
