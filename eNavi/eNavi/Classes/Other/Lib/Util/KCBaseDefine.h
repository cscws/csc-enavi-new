//
//  KCBaseDefine.h
//  eNavi
//
//  Created by zuotoujing on 16/4/11.
//  Copyright © 2016年 csc. All rights reserved.
//

#ifndef KerCer_KCBaseDefine_h
#define KerCer_KCBaseDefine_h



#if ! __has_feature(objc_arc)
#define KCAutorelease(__v) ([__v autorelease]);
#define KCReturnAutoreleased KCAutorelease

#define KCRetain(__v) ([__v retain]);
#define KCReturnRetained KCRetain

#define KCRelease(__v) ([__v release]);

#define KCDealloc(__v) ([__v dealloc]);
#else
// -fobjc-arc
#define KCAutorelease(__v)
#define KCReturnAutoreleased(__v) (__v)

#define KCRetain(__v)
#define KCReturnRetained(__v) (__v)

#define KCRelease(__v)

#define KCDealloc(__v)
#endif




// ----------------------------------
// Option values
// ----------------------------------

#undef	__ON__
#define __ON__		(1)

#undef	__OFF__
#define __OFF__		(0)

#undef	__AUTO__

#if defined(_DEBUG) || defined(DEBUG)
#define __AUTO__	(1)
#else
#define __AUTO__	(0)
#endif

// ----------------------------------
// Global compile option
// ----------------------------------
#define __KC_MODLE_DEV__				(__OFF__)
#define __KC_MODLE_TEST__				(__OFF__)

#define __KC_LOG__						(__ON__)
#define __KC_LOG__Brief__               (__OFF__)
#define __KC_LOG__FILE__			    (__OFF__)


#pragma mark -



#endif