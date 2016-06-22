//
//  KCMainBundle.h
//  
//
//  Created by zihong on 12-11-15.
//
//

#import <Foundation/Foundation.h>

@interface KCMainBundle : NSObject

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

+ (BOOL)isFirstLaunch;
+ (BOOL)isFirstLaunchAfterVersionChanged;

+ (NSString*)getIdentifier;
+ (BOOL)isSelfApp:(NSString*)identifier;
+ (NSString*)getVersion;
+ (NSString*)getVersionFullName;
+ (NSString*)getDisplayName;
+ (CGSize)getScreenSize;
+ (CGFloat)getStateBarHeight;

//identifier for device
+ (NSString*)getGUDID;
//identifier for app is creaded when first launch
+ (NSString*)getGUUID;
//identifier for app is creaded when first launch after version changed
+ (NSString*)getUUID;

+ (NSString*)getKeychainAccount;

@end
