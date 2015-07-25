//
//  GPData.h
//  GreenPeaceVideoTest
//
//  Created by Alexander Makarov on 25.07.15.
//  Copyright (c) 2015 Alexander Makarov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GPType.h"
#import "GPCamera.h"
#import "GPObject.h"

@interface GPData : NSObject

@property (strong, nonatomic) NSArray *objects;
@property (strong, nonatomic) NSArray *cameras;
@property (strong, nonatomic) NSArray *typeList;

@end
