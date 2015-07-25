//
//  UIColor+Extension.h
//  GreenPeaceVideoTest
//
//  Created by Alexander Makarov on 25.07.15.
//  Copyright (c) 2015 Alexander Makarov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Extension)

+ (UIColor *)mainColor1;
+ (UIColor *)mainColor2;

+ (UIColor *)textColor1;
+ (UIColor *)textColor2;

// colors from hex

+ (UIColor *)colorFromHex:(unsigned int)hex;
+ (UIColor *)colorFromHexString:(NSString *)hexString;
+ (UIColor *)colorFromHexString:(NSString *)hexString alpha:(CGFloat)alpha;

@end
