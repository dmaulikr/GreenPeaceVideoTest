//
//  GPType.h
//  GreenPeaceVideoTest
//
//  Created by Alexander Makarov on 24.07.15.
//  Copyright (c) 2015 Alexander Makarov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GPType : NSObject<NSCoding>

@property (strong, nonatomic) NSNumber *ID;
@property (strong, nonatomic) NSString *name;

+ (GPType *)typeWithID:(NSNumber *)ID name:(NSString *)name;

@end
