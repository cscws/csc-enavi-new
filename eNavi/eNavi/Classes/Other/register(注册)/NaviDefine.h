//
//  NaviDefine.h
//  eNavi
//
//  Created by zihong on 13-11-13.
//
//

#ifndef eNavi_NaviDefine_h
#define eNavi_NaviDefine_h

#define IS_IPHONE5 (([[UIScreen mainScreen] bounds].size.height-568)?NO:YES)
#define IsIOS7 ([[[[UIDevice currentDevice] systemVersion] substringToIndex:1] intValue]>=7)
#define CGRECT_NO_NAV(x,y,w,h) CGRectMake((x), (y+(IsIOS7?20:0)), (w), (h))
#define CGRECT_HAVE_NAV(x,y,w,h) CGRectMake((x), (y+(IsIOS7?64:0)), (w), (h))

#define IOS7_Setting_In_VC if([[[[UIDevice currentDevice] systemVersion] substringToIndex:1] intValue]>=7)\
{self.extendedLayoutIncludesOpaqueBars = NO;\
self.modalPresentationCapturesStatusBarAppearance =NO;\
self.edgesForExtendedLayout = UIRectEdgeNone;\
CGRect rt = self.view.bounds;\
rt.origin.y -= 20;\
rt.size.height -= 20;\
self.view.bounds = rt;\
}

#define IOS7_StateBar_Offset (IsIOS7 ? 20 : 0)

#define searchType_eNavi 0
#define searchType_searchCore 1

#define KC_RGB_Color(r,g,b) ([UIColor colorWithRed:r/255.f green:g/255.f blue:b/255.f alpha:1.f])

//图片拉伸
#define kCStretchImage(image) ([image stretchableImageWithLeftCapWidth:floorf(image.size.width/2) topCapHeight:floorf(image.size.height/2)])
/****************************************************
 import
 ****************************************************/
//#import "PubLink.h"
//#import "KCLog.h"

#define kDesKey @"Tianyi_navi_pdager_AN"

#define kUserDefaultsMdnKey @"Tianyi_navi_pdager_IP_Mdn_Key"
#define kUserDefaultsProductIdKey @"Tianyi_navi_pdager_IP_ProductId_Key"

#define __Test_Mdn__ 0


/***公司、家的设置***/
#define Height_SearchView 44
#define Height_TitleView 44
#define TOPINFO_H                   (66)
#define GAP_SPACE   (18)

#define kShowCityNameLen 3

#define TOP_BACKGROUND_LINE_COLOR   ([UIColor colorWithRed:191.0/255.0 green:191.0/255.0 blue:191.0/255.0 alpha:1])
#define VIEW_BACKGROUND_LINE_COLOR   ([UIColor colorWithRed:248.0/255.0 green:248.0/255.0 blue:248.0/255.0 alpha:1])
#define VIEW_FONT_COLOR   ([UIColor colorWithRed:104.0/255.0 green:112.0/255.0 blue:120.0/255.0 alpha:1])

#define HOME_SETTING_NAME @"homeSettingName"
#define HOME_SETTING_LON @"homeSettingLon"
#define HOME_SETTING_LAT @"homeSettingLat"

#define COMPANY_SETTING_NAME @"companySettingName"
#define COMPANY_SETTING_LON @"companySettingLon"
#define COMPANY_SETTING_LAT @"companySettingLat"

#endif
