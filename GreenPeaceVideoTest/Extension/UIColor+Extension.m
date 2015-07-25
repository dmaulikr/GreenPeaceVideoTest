//
//  UIColor+Extension.m
//  GreenPeaceVideoTest
//
//  Created by Alexander Makarov on 25.07.15.
//  Copyright (c) 2015 Alexander Makarov. All rights reserved.
//

#define UIColorFromHEX(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#import "UIColor+Extension.h"

@implementation UIColor (Extension)


#pragma mark - Custom colors

+ (UIColor *)mainColor1
{
    return [UIColor colorFromHex:0xf8931d];
}

+ (UIColor *)mainColor2
{
    return [UIColor colorFromHex:0x231f20];
}

+ (UIColor *)textColor1
{
    return [UIColor colorFromHex:0xf8941d];
}

+ (UIColor *)textColor2
{
    return [UIColor colorFromHex:0xf8931d];
}


#pragma mark - Colors from hex

+ (unsigned int)intFromHexString:(NSString *)hexString
{
    unsigned int hexInt = 0;
    
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setCharactersToBeSkipped:[NSCharacterSet characterSetWithCharactersInString:@"#"]];
    [scanner scanHexInt:&hexInt];
    
    return hexInt;
}

+ (UIColor *)colorFromHex:(unsigned int)hex
{
    return UIColorFromHEX(hex);
}

+ (UIColor *)colorFromHexString:(NSString *)hexString
{
    return [self colorFromHexString:hexString alpha:1.0];
}

+ (UIColor *)colorFromHexString:(NSString *)hexString alpha:(CGFloat)alpha
{
    unsigned int hexint = [self intFromHexString:hexString];
    return UIColorFromHEX(hexint);
}

@end
