//
//  GPObject.m
//  GreenPeaceVideoTest
//
//  Created by Alexander Makarov on 24.07.15.
//  Copyright (c) 2015 Alexander Makarov. All rights reserved.
//

#import "GPObject.h"

#define kId @"kId"
#define kName @"kName"
#define kAddressName @"kAddressName"
#define kImageName @"kImageName"
#define kLogoName @"kLogoName"
#define kCountCameras @"kCountCameras"
#define kGeo @"kGeo"
#define kTypeList @"kTypeList"
#define kTypeName @"kTypeName"

@implementation GPObject

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.ID forKey:kId];
    [encoder encodeObject:self.name forKey:kName];
    [encoder encodeObject:self.addressName forKey:kAddressName];
    [encoder encodeObject:self.imageName forKey:kImageName];
    [encoder encodeObject:self.logoName forKey:kLogoName];
    [encoder encodeObject:self.countCameras forKey:kCountCameras];
    [encoder encodeObject:self.geo forKey:kGeo];
    [encoder encodeObject:self.typeList forKey:kTypeList];
    [encoder encodeObject:self.typeName forKey:kTypeName];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {
        _ID = [decoder decodeObjectForKey:kId];
        _name = [decoder decodeObjectForKey:kName];
        _addressName = [decoder decodeObjectForKey:kAddressName];
        _imageName = [decoder decodeObjectForKey:kImageName];
        _logoName = [decoder decodeObjectForKey:kLogoName];
        _countCameras = [decoder decodeObjectForKey:kCountCameras];
        _geo = [decoder decodeObjectForKey:kGeo];
        _typeList = [decoder decodeObjectForKey:kTypeList];
        _typeName = [decoder decodeObjectForKey:kTypeName];
    }
    return self;
}

@end
