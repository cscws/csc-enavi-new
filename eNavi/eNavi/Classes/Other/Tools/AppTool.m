//
//  appTool.m
//  eNavi
//
//  Created by zuotoujing on 16/4/28.
//  Copyright © 2016年 csc. All rights reserved.
//

#import "AppTool.h"

@implementation AppTool
+ (void)sentPName:(NSString *)Pname CName:(NSString *)Cname success:(void(^)(NSString *str))name
{
    if([Pname isEqualToString:@"北京市"] && [Cname isEqualToString:@"全市"])
    {
        name(@"北京市");
    }
    else if ([Pname isEqualToString:@"上海市"] && [Cname isEqualToString:@"全市"])
    {
        name(@"上海市");
    }
    else if ([Pname isEqualToString:@"天津市"] && [Cname isEqualToString:@"全市"])
    {
        name(@"天津市");
    }
    else if ([Pname isEqualToString:@"重庆市"] && [Cname isEqualToString:@"全市"])
    {
        name(@"重庆市");
    }
    
    else
    {
        name(Cname);
    }

}
@end
