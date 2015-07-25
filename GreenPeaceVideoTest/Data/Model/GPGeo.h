//
//  GPGeo.h
//  GreenPeaceVideoTest
//
//  Created by Alexander Makarov on 24.07.15.
//  Copyright (c) 2015 Alexander Makarov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GPGeo : NSObject<NSCoding>

@property (strong, nonatomic) NSNumber *longitude;
@property (strong, nonatomic) NSNumber *latitude;

@end
