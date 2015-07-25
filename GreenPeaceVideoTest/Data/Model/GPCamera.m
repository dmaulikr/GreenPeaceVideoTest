//
//  GPCamera.m
//  GreenPeaceVideoTest
//
//  Created by Alexander Makarov on 24.07.15.
//  Copyright (c) 2015 Alexander Makarov. All rights reserved.
//

#import "GPCamera.h"

#define kId @"kId"
#define kName @"kName"
#define kUrl @"kUrl"
#define kObjId @"kObjId"
#define kImageName @"kImageName"

@implementation GPCamera

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.ID forKey:kId];
    [encoder encodeObject:self.name forKey:kName];
    [encoder encodeObject:self.url forKey:kUrl];
    [encoder encodeObject:self.objID forKey:kObjId];
    [encoder encodeObject:self.imageName forKey:kImageName];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {
        _ID = [decoder decodeObjectForKey:kId];
        _name = [decoder decodeObjectForKey:kName];
        _url = [decoder decodeObjectForKey:kUrl];
        _objID = [decoder decodeObjectForKey:kObjId];
        _imageName = [decoder decodeObjectForKey:kImageName];
    }
    return self;
}

@end
