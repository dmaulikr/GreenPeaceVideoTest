//
//  GPCache.h
//  GreenPeaceVideoTest
//
//  Created by Alexander Makarov on 24.07.15.
//  Copyright (c) 2015 Alexander Makarov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GPCache : NSObject

+ (NSString *)cachesDir;
+ (NSString *)cacheFilePathNamed:(NSString *)name;
+ (BOOL)dropCacheFileNamed:(NSString *)name;
+ (NSData *)dataForCacheFileNamed:(NSString *)name;
+ (BOOL)dumpData:(NSData *)data withName:(NSString *)name;
+ (BOOL)dropCache;

@end
