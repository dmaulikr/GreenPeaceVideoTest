//
//  GPCache.m
//  GreenPeaceVideoTest
//
//  Created by Alexander Makarov on 24.07.15.
//  Copyright (c) 2015 Alexander Makarov. All rights reserved.
//

#import "GPCache.h"

@implementation GPCache

+ (NSString *)cachesDir
{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"caches"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSError *dirCreationError = nil;
        [[NSFileManager defaultManager] createDirectoryAtPath:path
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:&dirCreationError];
        if (dirCreationError != nil) {
            NSLog(@"Ошибка создания папки для кэша");
            assert(0);
        }
    }
    return path;
}

+ (NSString *)cacheFilePathNamed:(NSString *)name
{
    return [[self cachesDir] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.cache", name]];
}

+ (BOOL)dropCacheFileNamed:(NSString *)name
{
    NSString *cachePath = [self cacheFilePathNamed:name];
    NSFileManager *fmanager = [NSFileManager defaultManager];
    NSError *error = nil;
    
    if ([fmanager fileExistsAtPath:cachePath]) {
        [fmanager removeItemAtPath:cachePath error:&error];
    }
    
    if (error != nil) {
        NSLog(@"Ошибка удаления кэш-файла: %@", error);
        return NO;
    }
    return YES;
}

+ (BOOL)dumpData:(NSData *)data withName:(NSString *)name
{
    NSString *cachePath = [self cacheFilePathNamed:name];
    NSError *error = nil;
    [data writeToFile:cachePath
              options:NSDataWritingAtomic
                error:&error];
    if (error != nil) {
        NSLog(@"Ошибка записи кэш-файла: %@", error);
        return NO;
    }
    return YES;
}

+ (NSData *)dataForCacheFileNamed:(NSString *)name
{
    NSString *cachePath = [self cacheFilePathNamed:name];
    return [NSData dataWithContentsOfFile:cachePath];
}

+ (BOOL)dropCache
{
    NSError *error = nil;
    [[NSFileManager defaultManager] removeItemAtPath:[self cachesDir] error:&error];
    if (error != nil) {
        NSLog(@"Ошибка удаления кэша");
        return NO;
    }
    return YES;
}

@end
