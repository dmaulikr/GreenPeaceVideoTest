//
//  GPGeo.m
//  GreenPeaceVideoTest
//
//  Created by Alexander Makarov on 24.07.15.
//  Copyright (c) 2015 Alexander Makarov. All rights reserved.
//

#import "GPGeo.h"

#define kLongitude @"kLongitude"
#define kLatitude @"kLatitude"

@implementation GPGeo

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.longitude forKey:kLongitude];
    [encoder encodeObject:self.latitude forKey:kLatitude];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {
        _longitude = [decoder decodeObjectForKey:kLongitude];
        _latitude = [decoder decodeObjectForKey:kLatitude];
    }
    return self;
}

@end
