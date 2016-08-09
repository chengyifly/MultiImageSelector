//
//  JYBStringHelper.h
//  JinYuanBao
//
//  Created by 易达正丰 on 14-3-25.
//  Copyright (c) 2014年 Easymob.com.cn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JYBStringHelper : NSObject

+ (BOOL)stringIsNotNull:(NSString *)string;
+ (NSString *)safeValueOfNullString:(NSString *)string;
+ (NSString *)parserJsonString:(id)result;
+ (BOOL)validateMobile:(NSString *)mobileNum;
/**
 *  是否包含汉字
 *
 *  @param str 字符串
 *
 *  @return 是否
 */
+ (BOOL)containsChinese:(NSString *)str;
/**
 *  超过百万数字转化为M
 *
 *  @param floatNum 原始数
 *
 *  @return 转化后的
 */
+ (NSString *)conversionNumber:(NSString *)floatNum;

+ (NSInteger)CountWord:(NSString *)s;
+ (BOOL)regexString:(NSString *)regex isValidString:(NSString *)string;
+ (NSString *)matchString:(NSString *)string toRegexString:(NSString *)regexStr;
+ (NSString *)urlEncode:(NSString *)string;

@end
