//
//  JYBMacros.h
//  JinYuanBao
//
//  Created by 易达正丰 on 14-3-13.
//  Copyright (c) 2014年 Easymob.com.cn. All rights reserved.
//

#import "JYBStringHelper.h"

#ifndef JinYuanBao_JYBMacros_h
#define JinYuanBao_JYBMacros_h

#define iOSVersion   [UIDevice currentDevice].systemVersion
#define AppVersion   (NSString *)[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]

#define iOS6         ([iOSVersion floatValue] < 7.0)
#define iOS7         ([iOSVersion floatValue] >= 7.0 && [iOSVersion floatValue] < 8.0)
#define iOS8         ([iOSVersion floatValue] >= 8.0)
#define isIpad       [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad
#define isIphone     [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone
#define UserDefaults [NSUserDefaults standardUserDefaults]
#define ResourcePath [[NSBundle mainBundle] resourcePath]

#define FilePath(NAME)   [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:NAME]

#define AppDelegate  ((JYBAppDelegate *)[UIApplication sharedApplication].delegate)
#define StatusBarStyleDefault(_style)  \
if (!iOS6) {if (_style) {[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];} else {[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];}}

#define ScreenHeight      [UIScreen mainScreen].bounds.size.height
#define ScreenWidth       [UIScreen mainScreen].bounds.size.width
#define ScreenScale       [UIScreen mainScreen].scale
#define FourInchScreen    CGRectMake(0, 0, ScreenWidth, 568)
#define LayoutWidthRatio  (ScreenWidth/320.0)
#define LayoutHeightRatio (ScreenHeight/480.0)

#define UIColorFromRGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define JYBCommonReqCount 20

#define SafeString(_str)            [JYBStringHelper safeValueOfNullString:_str]
#define StringIsNull(_str)          ![JYBStringHelper stringIsNotNull:_str]
#define StringIsNotNull(_str)       [JYBStringHelper stringIsNotNull:_str]
#define JsonValue(_v)               [JYBStringHelper parserJsonString:_v]

#define ReqServiceIs(_class)        [reqService isKindOfClass:[_class class]]
#define ReqValid                    ([serviceInfo.code integerValue] == 10000)

//** 防止Release时输出Log **
#ifndef __OPTIMIZE__
#define NSLog(...) NSLog(__VA_ARGS__)
#else
#define NSLog(...)
#endif


#endif
