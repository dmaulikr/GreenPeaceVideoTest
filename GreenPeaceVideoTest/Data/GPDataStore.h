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

#define NOTIFICATION_DATA_RESTORE_SUCCESS @"notification_data_restore_success"
#define NOTIFICATION_DATA_RESTORE_FAIL @"notification_data_restore_fail"

@interface GPDataStore : NSObject

+ (instancetype)sharedInstance;

@property (readonly, nonatomic) NSArray *objects;
@property (readonly, nonatomic) NSArray *cameras;
@property (readonly, nonatomic) NSArray *typeList;

- (void)restoreDataWithMapper:(id<GPDataMappingDelegate>)dataMapper;

@end
