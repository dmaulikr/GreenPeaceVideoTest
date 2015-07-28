//
//  GPDataStore.h
//  GreenPeaceVideoTest
//
//  Created by Alexander Makarov on 24.07.15.
//  Copyright (c) 2015 Alexander Makarov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GPDataReceiverWizard.h"
#import "GPDataMappingDelegate.h"
#import "GPData.h"
#import <CoreLocation/CoreLocation.h>

#define NOTIFICATION_DATA_RESTORE_SUCCESS @"notification_data_restore_success"
#define NOTIFICATION_DATA_RESTORE_FAIL @"notification_data_restore_fail"

@interface GPDataStore : NSObject<CLLocationManagerDelegate>

+ (instancetype)sharedInstance;

@property (readonly, nonatomic) NSArray *objects;
@property (readonly, nonatomic) NSArray *cameras;
@property (readonly, nonatomic) NSArray *typeList;

@property (strong, nonatomic) CLLocation *currentLocation;

- (void)restoreDataWithMapper:(id<GPDataMappingDelegate>)dataMapper;

- (void)imageForKey:(NSString *)key isPreview:(BOOL)isPreview imageLoadType:(GPImageLoadType)imageLoadType completion:(void (^)(UIImage *image))completionBlock;

- (NSArray *)listCamerasByObject:(GPObject *)object;
- (NSArray *)objectsByFilertID:(NSNumber *)filterID;

@end
