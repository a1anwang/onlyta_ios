//
//  MyUtils.m
//  Teabuddy_Alan
//
//  Created by smartwallit on 2018/4/2.
//  Copyright © 2018年 teabuddy. All rights reserved.
//

#import "MyUtils.h"

@implementation MyUtils

+(BOOL)isValidString:(NSString *)str{
    if(str==nil||str.length<=0){
        return NO;
    }
    return YES;
}

+(BOOL)isValidPhoneNum:(NSString *)str{
    NSString *pattern = @"^1+[123456789]+\\d{9}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:str];
    return isMatch;
}
+ (double)currentTimeLong{
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];//获取当前时间0秒后的时间
    NSTimeInterval time=[date timeIntervalSince1970]*1000;// *1000 是精确到毫秒，不乘就是精确到秒
 
    return time;
}

+(NSString*)macStringToUpper:(NSString *)mac{
    if(![MyUtils isValidString:mac] ){
        return nil;
    }
    if([mac containsString:@":"]){
        return [mac uppercaseString];
    }else{
        
    }
    
    NSString *newStr=[mac substringWithRange:NSMakeRange(0, 2)];
    newStr=[newStr stringByAppendingString:@":"];
    newStr=[newStr stringByAppendingString:[mac substringWithRange:NSMakeRange(2, 2)]];
    newStr=[newStr stringByAppendingString:@":"];
    newStr=[newStr stringByAppendingString:[mac substringWithRange:NSMakeRange(4, 2)]];
    newStr=[newStr stringByAppendingString:@":"];
    newStr=[newStr stringByAppendingString:[mac substringWithRange:NSMakeRange(6, 2)]];
    newStr=[newStr stringByAppendingString:@":"];
    newStr=[newStr stringByAppendingString:[mac substringWithRange:NSMakeRange(8, 2)]];
    newStr=[newStr stringByAppendingString:@":"];
    newStr=[newStr stringByAppendingString:[mac substringWithRange:NSMakeRange(10, 2)]];
    
    return [newStr uppercaseString];
    
}

+(CGSize)getStrSize:(NSString *)str WithFontsize:(float)fontsize{
     CGSize strSize = [str boundingRectWithSize:CGSizeMake(ScreenWidth, ScreenHeight) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesDeviceMetrics attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontsize]} context:nil].size;
    return strSize;
}

+(float)ajustFontToHeight:(UILabel *)label labelHeight:(float)height{
    float upFontSize=height;//先把字体设置成 和高度一样的，然后计算 在该字体下lable的高度，比较高度来决定减小字体大小还是增加字体大小，如此反复，计算出比较精确的值
    float downFontSize=0;
    float lasFontSize=0;
    CGSize size =[MyUtils getStrSize:label.text WithFontsize:upFontSize];
    
    
    if(size.height<height){
        downFontSize=upFontSize;
        lasFontSize=downFontSize;
        while (size.height<height) {//如果计算出的lable高度小于height， 增大字体2倍，再次计算
            lasFontSize=lasFontSize*2;
            size =[MyUtils getStrSize:label.text WithFontsize:lasFontSize];
        }
        if(lasFontSize>downFontSize){
            downFontSize=lasFontSize/2.0f;
        }
    }
    float delta=lasFontSize-downFontSize;
    for (int i=0; i<(delta); i++) {
       
        if(size.height>height){//如果计算出的lable高度大于 height， 减小字体大小，再次计算
            lasFontSize--;
            
            size =[MyUtils getStrSize:label.text WithFontsize:lasFontSize];
            
        }else{//如果计算出的lable高度小于height,退出计算
            
            break;
        }
        //   NSLog(@" i:%d",i);
    }
    label.font=[UIFont systemFontOfSize:lasFontSize];
     size =[MyUtils getStrSize:label.text WithFontsize:lasFontSize];
    
    NSLog(@"fontSize:%f size:%f",lasFontSize,size.height);
    return lasFontSize;
}

+(float)ajustFontToWidth:(UILabel *)label labelWidth:(float)width{
    float upFontSize=width;//先把字体设置成 和高度一样的，然后计算 在该字体下lable的高度，比较高度来决定减小字体大小还是增加字体大小，如此反复，计算出比较精确的值
    float downFontSize=0;
    float lasFontSize=0;
    CGSize size =[MyUtils getStrSize:label.text WithFontsize:upFontSize];
    
    
    if(size.width<width){
        downFontSize=upFontSize;
        lasFontSize=downFontSize;
        while (size.height<width) {//如果计算出的lable高度小于height， 增大字体2倍，再次计算
            lasFontSize=lasFontSize*2;
            size =[MyUtils getStrSize:label.text WithFontsize:lasFontSize];
        }
        if(lasFontSize>downFontSize){
            downFontSize=lasFontSize/2.0f;
        }
    }
    float delta=lasFontSize-downFontSize;
    for (int i=0; i<(delta); i++) {
        
        if(size.width>width){//如果计算出的lable高度大于 height， 减小字体大小，再次计算
            lasFontSize--;
            
            size =[MyUtils getStrSize:label.text WithFontsize:lasFontSize];
            
        }else{//如果计算出的lable高度小于height,退出计算
            
            break;
        }
        //   NSLog(@" i:%d",i);
    }
    label.font=[UIFont systemFontOfSize:lasFontSize];
    size =[MyUtils getStrSize:label.text WithFontsize:lasFontSize];
    
    NSLog(@"fontSize:%f size:%f",lasFontSize,size.height);
    return lasFontSize;
}


+(NSString *) dataToHexStr: (NSData *) _data
{
    NSMutableString *pStr = [[NSMutableString alloc] initWithCapacity: 1];
    
    UInt8 *p = (UInt8*) [_data bytes];
    NSUInteger len = [_data length];
    for(NSInteger i = 0; i < len; i ++)
    {
        [pStr appendFormat:@"%02X", *(p+i)];
    }
    return pStr;
}

+(NSInteger) unsignedByteToInt:(Byte) b {
    return ((int) b) & 0xff;
}
+(NSData *)hexStrToData: (NSString *) str
{
    if (!str || [str length] == 0) {
        return nil;
    }
    NSMutableData *hexData = [NSMutableData data];;
    NSRange range;
    if ([str length] % 2 == 0) {
        range = NSMakeRange(0, 2);
    } else {
        range = NSMakeRange(0, 1);
    }
    for (NSInteger i = range.location; i < [str length]; i += 2) {
        unsigned int anInt;
        NSString *hexCharStr = [str substringWithRange:range];
        NSScanner *scanner = [[NSScanner alloc] initWithString:hexCharStr];
        
        [scanner scanHexInt:&anInt];
        NSData *entity = [[NSData alloc] initWithBytes:&anInt length:1];
        [hexData appendData:entity];
        
        range.location += range.length;
        range.length = 2;
    }
    return hexData;
}

+(NSString *)intToHexStr:(NSInteger)value{
    NSString *str = [ [NSString alloc] initWithFormat:@"%X",value];
    if(str.length%2!=0){
        str=[@"0" stringByAppendingString:str];
    }
    return str;
}
+(NSInteger)hexStrToInt:(NSString *)str{
    str=[str uppercaseString];
    
    NSInteger length=  str.length;
    
    NSInteger value=0;
    
    for (int i=0; i<length; i++) {
        switch ([str characterAtIndex:i]) {
            case '0':
                value+=pow(16,length-1-i)*0;
                break;
            case '1':
                value+=pow(16,length-1-i)*1;
                break;
            case '2':
                value+=pow(16,length-1-i)*2;
                break;
            case '3':
                value+=pow(16,length-1-i)*3;
                break;
            case '4':
                value+=pow(16,length-1-i)*4;
                break;
            case '5':
                value+=pow(16,length-1-i)*5;
                break;
            case '6':
                value+=pow(16,length-1-i)*6;
                break;
            case '7':
                value+=pow(16,length-1-i)*7;
                break;
            case '8':
                value+=pow(16,length-1-i)*8;
                break;
            case '9':
                value+=pow(16,length-1-i)*9;
                break;
            case 'A':
                value+=pow(16,length-1-i)*10;
                break;
            case 'B':
                value+=pow(16,length-1-i)*11;
                break;
            case 'C':
                value+=pow(16,length-1-i)*12;
                break;
            case 'D':
                value+=pow(16,length-1-i)*13;
                break;
            case 'E':
                value+=pow(16,length-1-i)*14;
                break;
            case 'F':
                value+=pow(16,length-1-i)*15;
                break;
                
            default:
                break;
        }
        
        
    }
    return value;
}

@end
