//
//  appTool.h
//  eNavi
//
//  Created by zuotoujing on 16/4/28.
//  Copyright © 2016年 csc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppTool : NSObject
+ (void)sentPName:(NSString *)Pname CName:(NSString *)Cname success:(void(^)(NSString *str))name;
@end
