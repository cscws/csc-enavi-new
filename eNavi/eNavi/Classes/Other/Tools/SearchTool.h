//
//  SearchTool.h
//  eNavi
//
//  Created by zuotoujing on 16/4/22.
//  Copyright © 2016年 csc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <iNaviCore/MBPoiQuery.h>
@interface SearchTool : NSObject
@property (nonatomic, copy) void (^search)(id result);
+ (void)searchWithStr:(NSString *)str search:(void(^)(MBPoiTypeIndex result[],int count))search;

@end
