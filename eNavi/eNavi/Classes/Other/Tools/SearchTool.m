//
//  SearchTool.m
//  eNavi
//
//  Created by zuotoujing on 16/4/22.
//  Copyright © 2016年 csc. All rights reserved.
//

#import "SearchTool.h"

@implementation SearchTool

#pragma 垃圾代码 后面维护的兄弟对不住了

+ (void)searchWithStr:(NSString *)str search:(void(^)(MBPoiTypeIndex result[],int count))search;
{
//加油站
if([str isEqualToString:@"中国石油"])
{
   MBPoiTypeIndex i[] = {0x4081};
    int cout = sizeof(i)/sizeof(int);
    search(i,cout);
}
    else if ([str isEqualToString:@"中国石化"])
    {
       MBPoiTypeIndex i[] = {0x4082};
       int cout = sizeof(i)/sizeof(int);
        search(i,cout);
    }
    else if ([str isEqualToString:@"加气站"])
    {
        MBPoiTypeIndex i[] = {0x40A0,0x40A1};
        int cout = sizeof(i)/sizeof(int);
        search(i,cout);
    }
    //酒店
    else if ([str isEqualToString:@"连锁酒店"])
    {
        MBPoiTypeIndex i[] = {0x5480,0x50EF,0x50EE,0x50ED,0x50EC};
        int cout = sizeof(i)/sizeof(int);
        search(i,cout);
    }
    else if ([str isEqualToString:@"星级酒店"])
    {
        MBPoiTypeIndex i[] = {0x5083,0x5084,0x5085};
        int cout = sizeof(i)/sizeof(int);
        search(i,cout);
    }
    else if ([str isEqualToString:@"旅店"])
    {
        MBPoiTypeIndex i[] = {0x5380,0x5082,0x5080};
        int cout = sizeof(i)/sizeof(int);
        search(i,cout);
    }
    else if ([str isEqualToString:@"农家乐"])
    {
        MBPoiTypeIndex i[] = {0x6700};
        int cout = sizeof(i)/sizeof(int);
        search(i,cout);
    }
    else if ([str isEqualToString:@"度假村"])
    {
        MBPoiTypeIndex i[] = {0x5400};
        int cout = sizeof(i)/sizeof(int);
        search(i,cout);
    }
    //休闲娱乐
    else if ([str isEqualToString:@"电影院"])
    {
        MBPoiTypeIndex i[] = {0x6500};
        int cout = sizeof(i)/sizeof(int);
        search(i,cout);
    }
    else if ([str isEqualToString:@"KTV"])
    {
        MBPoiTypeIndex i[] = {0x0301};
        int cout = sizeof(i)/sizeof(int);
        search(i,cout);
    }
    else if ([str isEqualToString:@"酒吧"])
    {
        MBPoiTypeIndex i[] = {0x1500};
        int cout = sizeof(i)/sizeof(int);
        search(i,cout);
    }
    else if ([str isEqualToString:@"咖啡厅"])
    {
        MBPoiTypeIndex i[] = {0x1602};
        int cout = sizeof(i)/sizeof(int);
        search(i,cout);
    }
    else if ([str isEqualToString:@"游乐园"])
    {
        MBPoiTypeIndex i[] = {0x6300};
        int cout = sizeof(i)/sizeof(int);
        search(i,cout);
    }
    else if ([str isEqualToString:@"商场"])
    {
        MBPoiTypeIndex i[] = {0x0603};
        int cout = sizeof(i)/sizeof(int);
        search(i,cout);
    }
    //汽车服务
    else if ([str isEqualToString:@"停车场"])
    {
        MBPoiTypeIndex i[] = {0x4100};
        int cout = sizeof(i)/sizeof(int);
        search(i,cout);
    }
    else if ([str isEqualToString:@"汽车维修"])
    {
        MBPoiTypeIndex i[] = {0x4500};
        int cout = sizeof(i)/sizeof(int);
        search(i,cout);
    }
    else if ([str isEqualToString:@"汽车美容"])
    {
        MBPoiTypeIndex i[] = {0x4300};
        int cout = sizeof(i)/sizeof(int);
        search(i,cout);
    }
    else if ([str isEqualToString:@"租车"])
    {
        MBPoiTypeIndex i[] = {0x4280};
        int cout = sizeof(i)/sizeof(int);
        search(i,cout);
    }
    else if ([str isEqualToString:@"汽车销售"])
    {
        MBPoiTypeIndex i[] = {0x4300};
        int cout = sizeof(i)/sizeof(int);
        search(i,cout);
    }
    //景区
    else if ([str isEqualToString:@"名胜古迹"])
    {
        MBPoiTypeIndex i[] = {0x0401};
        int cout = sizeof(i)/sizeof(int);
        search(i,cout);
    }else if ([str isEqualToString:@"博物馆"])
    {
        MBPoiTypeIndex i[] = {0x9380};
        int cout = sizeof(i)/sizeof(int);
        search(i,cout);
    }
    else if ([str isEqualToString:@"公园"])
    {
        MBPoiTypeIndex i[] = {0x7300};
        int cout = sizeof(i)/sizeof(int);
        search(i,cout);
    }
    else if ([str isEqualToString:@"动植物园"])
    {
        MBPoiTypeIndex i[] = {0x0403};
        int cout = sizeof(i)/sizeof(int);
        search(i,cout);
    }
    //生活服务
    else if ([str isEqualToString:@"厕所"])
    {
        MBPoiTypeIndex i[] = {0x7880};
        int cout = sizeof(i)/sizeof(int);
        search(i,cout);
    }
    else if ([str isEqualToString:@"ATM/银行"])
    {
        MBPoiTypeIndex i[] = {0xA199};
        int cout = sizeof(i)/sizeof(int);
        search(i,cout);
    }
    else if ([str isEqualToString:@"咖啡厅"])
    {
        MBPoiTypeIndex i[] = {0x1602};
        int cout = sizeof(i)/sizeof(int);
        search(i,cout);
    }
    else if ([str isEqualToString:@"电信营业厅"])
    {
        MBPoiTypeIndex i[] = {0xAB01};
        int cout = sizeof(i)/sizeof(int);
        search(i,cout);
    }
    else if ([str isEqualToString:@"药店"])
    {
        MBPoiTypeIndex i[] = {0x2800};
        int cout = sizeof(i)/sizeof(int);
        search(i,cout);
    }
    else if ([str isEqualToString:@"医院"])
    {
        MBPoiTypeIndex i[] = {0x02};
        int cout = sizeof(i)/sizeof(int);
        search(i,cout);
    }
    else if ([str isEqualToString:@"超市"])
    {
        MBPoiTypeIndex i[] = {0x0601};
        int cout = sizeof(i)/sizeof(int);
        search(i,cout);
    }
    //交通出行
    else if ([str isEqualToString:@"公交车站"])
    {
        MBPoiTypeIndex i[] = {0x8801};
        int cout = sizeof(i)/sizeof(int);
        search(i,cout);
    }
    else if ([str isEqualToString:@"地铁站"])
    {
        MBPoiTypeIndex i[] = {0x0902};
        int cout = sizeof(i)/sizeof(int);
        search(i,cout);
    }
    else if ([str isEqualToString:@"火车站"])
    {
        MBPoiTypeIndex i[] = {0x0901};
        int cout = sizeof(i)/sizeof(int);
        search(i,cout);
    }
    else if ([str isEqualToString:@"长途汽车站"])
    {
        MBPoiTypeIndex i[] = {0x8083};
        int cout = sizeof(i)/sizeof(int);
        search(i,cout);
    }
    //美食
    else if ([str isEqualToString:@"中餐厅"])
    {
        MBPoiTypeIndex i[] = {0x0201};
        int cout = sizeof(i)/sizeof(int);
        search(i,cout);
    }
    else if ([str isEqualToString:@"小吃快餐"])
    {
        MBPoiTypeIndex i[] = {0x0203};
        int cout = sizeof(i)/sizeof(int);
        search(i,cout);
    }
    else if ([str isEqualToString:@"特色餐厅"])
    {
        MBPoiTypeIndex i[] = {0x1980};
        int cout = sizeof(i)/sizeof(int);
        search(i,cout);
    }
    else if ([str isEqualToString:@"火锅"])
    {
        MBPoiTypeIndex i[] = {0x1397};
        int cout = sizeof(i)/sizeof(int);
        search(i,cout);
    }
    else if ([str isEqualToString:@"川菜"])
    {
        MBPoiTypeIndex i[] = {0x1381};
        int cout = sizeof(i)/sizeof(int);
        search(i,cout);
    }
    else if ([str isEqualToString:@"日韩料理"])
    {
        MBPoiTypeIndex i[] = {0x13EF,0x13EE};
        int cout = sizeof(i)/sizeof(int);
        search(i,cout);
    }
    else if ([str isEqualToString:@"西餐"])
    {
        MBPoiTypeIndex i[] = {0x1300};
        int cout = sizeof(i)/sizeof(int);
        search(i,cout);
    }
    else if ([str isEqualToString:@"甜点"])
    {
        MBPoiTypeIndex i[] = {0x1680};
        int cout = sizeof(i)/sizeof(int);
        search(i,cout);
    }
    else if ([str isEqualToString:@"K记/M记"])
    {
        MBPoiTypeIndex i[] = {0x10C1,0x10C0};
        int cout = sizeof(i)/sizeof(int);
        search(i,cout);
    }
    else{}
}

@end
