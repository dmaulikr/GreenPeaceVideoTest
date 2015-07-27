//
//  UIFont+Extension.m
//  GreenPeaceVideoTest
//
//  Created by Alexander Makarov on 25.07.15.
//  Copyright (c) 2015 Alexander Makarov. All rights reserved.
//

#define kPixelsPerPoint 2.2639

#import "UIFont+Extension.h"

@implementation UIFont (Extension)

+ (UIFont *)fontWithName:(NSString *)fontName pixelSize:(CGFloat)pixelSize
{
    CGFloat fontSize = floor(pixelSize/2.2639);
    return [UIFont fontWithName:fontName size:fontSize];
}


#pragma mark - Custom fonts

+ (UIFont *)customFont1
{
    return [UIFont fontWithName:@"HelveticaNeue" pixelSize:24.0f];
}

+ (UIFont *)customFont2
{
    return [UIFont fontWithName:@"HelveticaNeue" pixelSize:32.0f];
}

+ (UIFont *)customFont3
{
    return [UIFont fontWithName:@"HelveticaNeue" pixelSize:28.0f];
}

+ (UIFont *)customFont4
{
    return [UIFont fontWithName:@"HelveticaNeue-Medium" pixelSize:34.0f];
}

+ (UIFont *)customFont5
{
    return [UIFont fontWithName:@"HelveticaNeue" pixelSize:42.0f];
}

+ (UIFont *)customFont6
{
    return [UIFont fontWithName:@"HelveticaNeue-Medium" pixelSize:42.0f];
}

@end
