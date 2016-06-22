//
//  PubLink.h
//  eNavi
//
//  Created by lijian on 2/27/13.
//
//

//#ifndef eNavi_PubLink_h
//#define eNavi_PubLink_h



#define VOICEINPUT_NAME         @"Iphone"
#define VOICEINPUT_APPID        @"52258d91"

#define CITYURL                 (@"http://platform.enavi.118114.cn:8081/telecomnavi/PoiSearchSv?ID=5&CX=%f&CY=%f&DV=1001")

#define POIRND_KEYSRH_URL		(@"http://platform.enavi.118114.cn:8081/telecomnavi/PoiSearchSv?ID=33&CX=%f&CY=%f&QS=%@&RG=%d&DV=1001")
#define POIRND_KINDSRH_URL		(@"http://platform.enavi.118114.cn:8081/telecomnavi/PoiSearchSv?ID=32&CX=%f&CY=%f&CS=%@&RG=%d&DV=1001")

#define POI_KEYSRH_URL         (@"http://platform.enavi.118114.cn:8081/TYUnityService/PoiKeySearch?ID=2007&QS=%@&AC=%d")

#define BUSNUM_DETAIL_URL     (@"http://engine.enavi.118114.cn:8081/busproject/BusNumberDetailInfo?ID=73&AC=%d&QBL=%@")

#define BUSSTA_DETAIL_URL (@"http://engine.enavi.118114.cn:8081/busproject/BusStationDetailInfo?ID=72&AC=%d&QBS=%@")


//bus-------------------------------------------------------
//新增加
#define USE_ENAVI_BUSURL 1  //只控制以下的URL

#if USE_ENAVI_BUSURL

    #define BUSSCHEMEURL		(@"http://platform.enavi.118114.cn:8081/busproject/BusChangeDetailInfo?ID=70&SX=%f&SY=%f&SAC=%d&DX=%f&DY=%f&DAC=%d&BS=%@&DV=1001")
    #define WALKBUSSCHEMEURL	(@"http://platform.enavi.118114.cn:8081/busproject/BusAddWalkChanageDetailInfo?ID=71&SX=%f&SY=%f&SAC=%d&DX=%f&DY=%f&DAC=%d&BS=%@&DV=1001")

    #define BUSDETAILURL		(@"http://platform.enavi.118114.cn:8081/telecomnavi/BusSearchSv?ID=42&TID=%d&DV=1001")
    #define WALKBUSDETAILURL	(@"http://platform.enavi.118114.cn:8081/busproject/busSearchDetailInfo?ID=45&TID=%@&DV=1001")

    #define BUSCITYURL              (@"http://platform.enavi.118114.cn:8081/telecomnavi/PoiSearchSv?ID=5&CX=%f&CY=%f&DV=1001")

#else

#define CHANNEL             @"besttone_enavi"
#define AOSKEY              @"hrDSK6YcN42i2E5Jb8PSdObZA5t6vzaJfJJDtlGp"
#define AOSURL_FOR_TEST     @"http://maps.dev.myamap.com/ws/mapapi/poi/info?"
#define AOSURL              (@"http://m5.amap.com/ws/mapapi/poi/info?")
#define AOSURL_BUS          (@"http://m5.amap.com/ws/mapapi/navigation/bus?")


//以下url的使用有问题  主要在函数makeBusUrlWithType中
#define BUSCITYURL              (@"http://platform.enavi.118114.cn:8081/telecomnavi/PoiSearchSv?ID=5&CX=%f&CY=%f&DV=1001")

#define BUSSCHEMEURL		(@"http://platform.enavi.118114.cn:8081/busproject/BusChangeDetailInfo?ID=70&SX=%f&SY=%f&SAC=%d&DX=%f&DY=%f&DAC=%d&BS=%@&DV=1001")
#define WALKBUSSCHEMEURL	(@"http://platform.enavi.118114.cn:8081/busproject/BusAddWalkChanageDetailInfo?ID=71&SX=%f&SY=%f&SAC=%d&DX=%f&DY=%f&DAC=%d&BS=%@&DV=1001")

#define BUSDETAILURL		(@"http://platform.enavi.118114.cn:8081/telecomnavi/BusSearchSv?ID=42&TID=%d&DV=1001")
#define WALKBUSDETAILURL	(@"http://platform.enavi.118114.cn:8081/busproject/busSearchDetailInfo?ID=45&TID=%@&DV=1001")


#endif


//反搜索，地理编码获取
#define GEOCODING_RAUNDSERCH_URL    (@"http://platform.enavi.118114.cn:8081/telecomnavi/PoiSearchSv?ID=33&CX=%f&CY=%f&QS=&RG=%d&DV=1001")



//web
#define WEB_GUANWANG          (@"http://wap.enavi.189.cn")
#define WEB_WEIBO  (@"http://weibo.cn/enavi")
#define WEB_QQWEIBO (@"http://ti.3g.qq.com/g/s?sid=AcPCLUqjhroRZfSvU8BpgOT4&r=670183&from=wap3g&aid=h&hu=enavi_")
#define WEB_WEATHER_URL         (@"http://wap.118114.cn/bst/weather/txt.jsp?colid=1000&fr=tydh&areacode=%d")
#define WEB_HANGBAN (@"http://wap.118114.cn/bst/planticket/txt.jsp?colid=2009&fr=tydh")
#define WEB_LIECHE (@"http://wap.118114.cn/bst/train/c.jsp?fr=tydh")
#define WEB_CHANNEL  (@"http://tapp1.enavi.118114.cn:8090/dttc/channel.html")
//#define WEB_CHANNEL  (@"http://202.189.1.43:8884/dttc/channel.html")
//#define WEB_FEEDBACK (@"http://platform.enavi.118114.cn:8081/UE/ue/evaluate.jsp")
#define WEB_FEEDBACK (@"http://platform.enavi.118114.cn:8081/UE/advise.jsp")

//test
//http://106.3.73.14/dttc/vista.html
//http://106.3.73.14/dttc/channel.html
#define WEB_SCENE_HOT (@"http://tapp1.enavi.118114.cn:8090/dttc/vista.html")

#define URL_COLLECTLOG  @"http://mg.enavi.118114.cn:8081/UE/IOSUserBehaviour"

//方源机器
//#define KCBServiceUrl    @"http://10.5.54.77:8080/URService/BService"
//#define KCOrderServieUrl @"http://10.5.54.77:8080/pdager_nmsc/OrderServie"

//测试地址
//#define KCBServiceUrl    @"http://119.90.33.14/URService/BService"
//#define KCOrderServieUrl @"http://119.90.33.14/pdager_nmsc/OrderServie"

//正式地址
#define KCBServiceUrl    @"http://platform.enavi.118114.cn:8081/telecomnavi/BService"
#define KCOrderServieUrl @"http://platform.enavi.118114.cn:8081/pdager_nmsc/OrderServie"

/*******************路口放大图*************************/
//测试url
//#define DOWNLOAD_CROSSURL (@"http://106.3.73.14/offonlineapp/roadDownload.do?act=getcitylist")
//正式url
#define DOWNLOAD_CROSSURL (@"http://a.enavi.189.cn/offonlineapp/roadDownload.do?act=getcitylist")
//#define DOWNLOAD_CROSSURL (@"http://116.228.55.129:8087/offonlineapp/roadDownload.do?act=getcitylist")

#define HTTP_HEADER_AGENT       (@"x-up-agent")         //代替user-agent
#define HTTP_HEADER_MDN         (@"x-up-mdn")           //代替x-up-calling-line-id
#define HTTP_HEADER_SDKVERSION  (@"x-up-sdk-version")   //sdk版本号

#define HTTP_BACKUP_POI_URL @"http://platform.enavi.118114.cn:8081/telecomnavi/BService?id=321"
#define HTTP_RECOVER_POI_URL @"http://platform.enavi.118114.cn:8081/telecomnavi/BService?id=322"

//#define HTTP_BANNER_URL @"http://platform.enavi.118114.cn:8081/banner/lists?"
#define HTTP_BANNER_URL @"http://platform.enavi.118114.cn:8081/banner/lists?"
//#define HTTP_NMSC_URL @"http://192.168.10.51:8080/pdager_nmsc"
#define HTTP_NMSC_URL @"http://platform.enavi.118114.cn:8081/pdager_nmsc"
#define HTTP_TIANYISEARCH_URL @"http://s.enavi.189.cn/mEngineTY/TianyiSearchServlet"
#define HTTP_POI_DETAIL_PAGE @"http://s.enavi.189.cn/depths/depths/depths.htm"
//#define HTTP_POI_DETAIL_PAGE @"http://192.168.10.51:8080/banner"

