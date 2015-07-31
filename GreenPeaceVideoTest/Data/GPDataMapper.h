//
//  GPDataMapper.h
//  GreenPeaceVideoTest
//
//  Created by Alexander Makarov on 25.07.15.
//  Copyright (c) 2015 Alexander Makarov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GPDataMappingDelegate.h"

#define OBJECTS @"objects"
#define CAMERAS @"cameras"
#define TYPE_LIST @"type_list"
#define CATEGORY_LIST @"category_list"

@interface GPDataMapper : NSObject<GPDataMappingDelegate>

@end
