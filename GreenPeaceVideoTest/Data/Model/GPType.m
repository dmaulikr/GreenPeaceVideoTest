//
//  GPType.m
//  GreenPeaceVideoTest
//
//  Created by Alexander Makarov on 24.07.15.
//  Copyright (c) 2015 Alexander Makarov. All rights reserved.
//

#import "GPType.h"

#define kId @"kId"
#define kName @"kName"

@implementation GPType

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.ID forKey:kId];
    [encoder encodeObject:self.name forKey:kName];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {
        _ID = [decoder decodeObjectForKey:kId];
        _name = [decoder decodeObjectForKey:kName];
    }
    return self;
}

+ (GPType *)typeWithID:(NSNumber *)ID name:(NSString *)name
{
    GPType *type = [[GPType alloc] init];
    type.ID = ID;
    type.name = name;
    return type;
}

@end
