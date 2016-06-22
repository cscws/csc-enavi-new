//
//  KCHTTPRspModel.m
//  eNavi
//
//  Created by Jim on 14-4-4.
//
//

#import "KCHTTPRspModel.h"
#import "JSONKit.h"
#import "KCUtilCoding.h"
#import "NaviDefine.h"

@implementation KCHTTPRspModel

+ (KCHTTPRspModel *)httpRspModelWithData:(NSData *)data
{
    
    KCHTTPRspModel *model = [[self alloc] initWithHTTPRspData:(NSData *)data];
    return model;

}

- (id)initWithHTTPRspData:(NSData *)data
{
    if (nil == data)
    {
       
        return nil;
    }
    
    if (self = [super init])
    {
        NSString *strData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//        NSLog(@"%@", strData);
        
#warning “This is just test, please let server modify data's value”
        //test begin
        
        NSRange range0 = [strData rangeOfString:@"\"des\":\""];
        if (range0.location == NSNotFound)
        {
            range0 = [strData rangeOfString:@"\"des\":{"];
            if (range0.location == NSNotFound)
            {
                range0 = [strData rangeOfString:@"\"des\":["];
                if (range0.location == NSNotFound) {
                    range0 = [strData rangeOfString:@"\"des\":"];
                    if (range0.location != NSNotFound)
                    {
                        NSRange range2 = [strData rangeOfString:@",\"data\""];
                        if (range2.location != NSNotFound)
                        {
                            NSString *temp = [strData substringWithRange:NSMakeRange(range0.location+range0.length, range2.location-range0.location-range0.length)];
                            strData = [strData stringByReplacingOccurrencesOfString:temp withString:[NSString stringWithFormat:@"\"%@\"", temp]];
                        }
                    }
                }
            }
            
        }
        
//        NSLog(@"%@", strData);

        
        NSRange range1 = [strData rangeOfString:@"\"data\":\""];
        if (range1.location == NSNotFound)
        {
            range1 = [strData rangeOfString:@"\"data\":{"];
            if (range1.location == NSNotFound)
            {
                range1 = [strData rangeOfString:@"\"data\":["];
                if (range1.location == NSNotFound) {
                    range1 = [strData rangeOfString:@"\"data\":"];
                    if (range1.location != NSNotFound)
                    {
                        NSRange range2 = [strData rangeOfString:@",\"type\""];
                        if (range2.location != NSNotFound)
                        {
                            NSString *temp = [strData substringWithRange:NSMakeRange(range1.location+range1.length, range2.location-range1.location-range1.length)];
                            strData = [strData stringByReplacingOccurrencesOfString:temp withString:[NSString stringWithFormat:@"\"%@\"", temp]];
                        }
                    }
                }
            }
            
        }

        //NSLog(@"%@", strData);
        
        //test end
        
        NSDictionary *temDic = [strData objectFromJSONString];
        if (nil == temDic)
        {
            self.result = -1;
            self.data = nil;
            self.errorMessage = @"未知错误";
        }
        else
        {
            self.result = [[temDic objectForKey:@"result"] intValue];
            
            if (0 == [[temDic objectForKey:@"type"] intValue])
            {
                self.data = [temDic objectForKey:@"data"];
                self.errorMessage = [[temDic objectForKey:@"data"] objectForKey:@"desc"];
            }
            else
            {
               
                NSString *dataString = [temDic objectForKey:@"data"];
                NSString *data = [KCUtilCoding decryptUseDES:dataString key:kDesKey];
                NSLog(@"%@", data);
                
                self.data = [data objectFromJSONString];
//                NSLog(@"%@",self.data);

                NSString *desc = [self.data objectForKey:@"desc"];
                NSLog(@"%@", desc);
                
                if (desc == nil || desc.length == 0)
                {
                    self.errorMessage = @"未知错误";
                }
                else
                {
                    self.errorMessage = desc;
                }
            }
        }
    }
    return self;
}
@end
