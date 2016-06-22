//
//  KCUtilDevice.m
//  
//
//  Created by zihong on 12-8-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "KCUtilDevice.h"
//#include <sys/types.h>
#include <sys/sysctl.h>


@implementation KCUtilDevice

static const char * __jb_app = NULL;
+ (BOOL)isJailbroken {
	static const char * __jb_apps[] =
	{
		"/Application/Cydia.app",
		"/Application/limera1n.app",
		"/Application/greenpois0n.app",
		"/Application/blackra1n.app",
		"/Application/blacksn0w.app",
		"/Application/redsn0w.app",
		NULL
	};
    
	__jb_app = NULL;
    
	// method 1
    for ( int i = 0; __jb_apps[i]; ++i )
    {
        if ( [[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithUTF8String:__jb_apps[i]]] )
        {
			__jb_app = __jb_apps[i];
			return YES;
        }
    }
    
    // method 2
	if ( [[NSFileManager defaultManager] fileExistsAtPath:@"/private/var/lib/apt/"] )
	{
		return YES;
	}
    
	// method 3
	if ( 0 == system("ls") )
	{
		return YES;
	}
    
    return NO;
}

+ (NSString *)jailBreaker
{
	if ( __jb_app )
	{
		return [NSString stringWithUTF8String:__jb_app];
	}
	else
	{
		return @"";
	}
}


+(NSString*)createUUID
{
    CFUUIDRef uuid_ref = CFUUIDCreate(NULL);
    CFStringRef uuid_string_ref= CFUUIDCreateString(NULL, uuid_ref);
    
    CFRelease(uuid_ref);
    NSString *uuid = [NSString stringWithString:(__bridge NSString*)uuid_string_ref];
    
    CFRelease(uuid_string_ref);
    return uuid;
}


@end
