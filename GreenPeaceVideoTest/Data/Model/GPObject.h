//
//  GPObject.h
//  GreenPeaceVideoTest
//
//  Created by Alexander Makarov on 24.07.15.
//  Copyright (c) 2015 Alexander Makarov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GPGeo.h"

@interface GPObject : NSObject<NSCoding>

@property (strong, nonatomic) NSNumber *ID;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *addressName;
@property (strong, nonatomic) NSString *imageName;
@property (strong, nonatomic) NSString *logoName;
@property (strong, nonatomic) NSNumber *countCameras;
@property (strong, nonatomic) GPGeo *geo;
@property (strong, nonatomic) NSArray *typeList; // array of objects of type NSNumber
@property (strong, nonatomic) NSString *typeName;

@end
