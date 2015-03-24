//
//  JYBStringHelper.m
//  JinYuanBao
//
//  Created by 易达正丰 on 14-3-25.
//  Copyright (c) 2014年 Easymob.com.cn. All rights reserved.
//

#import "JYBStringHelper.h"

@implementation JYBStringHelper

+ (BOOL)stringIsNotNull:(NSString *)string
{
    return ![string isEqual:[NSNull null]] && string != nil && string.length > 0 && ![string isEqualToString:@"<null>"];
}

+ (NSString *)safeValueOfNullString:(NSString *)string
{
    if ([self stringIsNotNull:string]) {
        return string;
    }
    return @"";
}

+ (NSString *)parserJsonString:(id)result
{
    if ([result isKindOfClass:[NSString class]]) {
        return [self safeValueOfNullString:result];
    } else if ([result isKindOfClass:[NSNumber class]]) {
        return [self safeValueOfNullString:[result stringValue]];
    }
    return nil;
}

+ (BOOL)validateMobile:(NSString *)mobileNum
{
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

/**
 *  判断字符串是否包含汉字
 */
+ (BOOL)containsChinese:(NSString *)str
{
    for(int i = 0; i < [str length]; i++) {
        int a = [str characterAtIndex:i];
        if( a > 0x4e00 && a < 0x9fff)
            return YES;
    }
    return NO;
}


+ (NSString *)conversionNumber:(NSString *)floatNum
{
    if ([floatNum floatValue] >= 1000000) {
        NSString *str = [NSString stringWithFormat:@"%.02fM", [floatNum floatValue]/1000000];
        return str;
    }
    return floatNum;
}
/**
 *  计算字符串字数,汉字算1个,英文/数字/标点算半个,对上取整
 *
 *  @param s 要检测的字符串
 *
 *  @return 字符串字数(对上取整)
 */
+ (NSInteger)CountWord:(NSString *)s
{
    
    NSInteger i,n=[s length],l=0,a=0,b=0;
    
    unichar c;
    
    for(i=0;i<n;i++){
        
        c=[s characterAtIndex:i];
        
        if(isblank(c)){
            //空白
            b++;
            
        }else if(isascii(c)){
           //ASCII
            a++;
            
        }else{
            //其他
            l++;
            
        }
        
    }
    
    if(a==0 && l==0) return 0;
    
    return l+(NSInteger)ceilf((float)(a+b)/2.0);
    
}

/**
 *  正则表达式判断字符串是否符合要求
 *
 *  @param regex  正则表达式
 *  @param string 需要匹配的字符串
 *
 *  @return 是否匹配
 */
+ (BOOL)regexString:(NSString *)regex isValidString:(NSString *)string
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    if ([predicate evaluateWithObject:string] == YES ) {
        return YES;
    }
    
    return NO;
}

/**
 *  正则匹配返回符合要求的字符串
 *
 *  @param string   需要匹配的字符串
 *  @param regexStr 正则表达式
 *
 *  @return 符合要求的字符串
 */
+ (NSString *)matchString:(NSString *)string toRegexString:(NSString *)regexStr
{
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexStr options:NSRegularExpressionCaseInsensitive error:nil];
    
    NSArray * matches = [regex matchesInString:string options:0 range:NSMakeRange(0, [string length])];
    
    for (NSTextCheckingResult *match in matches) {
        NSString *group1 = [string substringWithRange:[match rangeAtIndex:1]];
        return group1;
    }
    
    return nil;
}

/** 
 * 字符串URLEncode 
 */
+ (NSString *)urlEncode:(NSString *)string
{
    NSString *resultStr = string;
    
    CFStringRef originalString = (__bridge CFStringRef)string;
    CFStringRef leaveUnescaped = CFSTR(" ");
    CFStringRef forceEscaped = CFSTR("!*'();:@&=+$,/?%#[]");
    
    CFStringRef escapedStr;
    escapedStr = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                         originalString,
                                                         leaveUnescaped,
                                                         forceEscaped,
                                                         kCFStringEncodingUTF8);
    
    if (escapedStr)
    {
        NSMutableString *mutableStr = [NSMutableString stringWithString:(__bridge NSString *)escapedStr];
        CFRelease(escapedStr);
        
        // replace spaces with plusses
        [mutableStr replaceOccurrencesOfString:@" "
                                    withString:@"%20"
                                       options:0
                                         range:NSMakeRange(0, [mutableStr length])];
        resultStr = mutableStr;
    }
    
    return resultStr;
}


@end
