//
//  MyUtils.h
//  Teabuddy_Alan
//
//  Created by smartwallit on 2018/4/2.
//  Copyright © 2018年 teabuddy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyUtils : NSObject

+(BOOL)isValidString:(NSString*)str ;

+(BOOL)isValidPhoneNum:(NSString*)str ;

+(NSString*)macStringToUpper:(NSString *)mac;
+ (double)currentTimeLong;
/**
 获取文字原始高度宽度(没有边界的)
 */
+(CGSize)getStrSize:(NSString*)str WithFontsize:(float)fontsize;

/**
  根据给定的高度来使用尽可能大的字体
 */
+(float)ajustFontToHeight:(UILabel *)label labelHeight:(float)height;
/**
 根据给定的宽度来使用尽可能大的字体
 */
+(float)ajustFontToWidth:(UILabel *)label labelWidth:(float)width;

+(NSString *) dataToHexStr: (NSData *) _data;
+(NSString *)intToHexStr:(NSInteger)value;
+(NSInteger)hexStrToInt:(NSString *)str;
+(NSData *)hexStrToData: (NSString *) str;
+(NSInteger) unsignedByteToInt:(Byte) b;
@end
