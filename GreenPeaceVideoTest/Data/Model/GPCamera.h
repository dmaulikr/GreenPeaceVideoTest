//
//  GPCamera.h
//  GreenPeaceVideoTest
//
//  Created by Alexander Makarov on 24.07.15.
//  Copyright (c) 2015 Alexander Makarov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GPCamera : NSObject<NSCoding>

@property (strong, nonatomic) NSNumber *ID;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *url;
@property (strong, nonatomic) NSNumber *objID;
@property (strong, nonatomic) NSString *imageName;

@end
