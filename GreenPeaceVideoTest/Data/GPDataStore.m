//
//  GPDataStore.m
//  GreenPeaceVideoTest
//
//  Created by Alexander Makarov on 24.07.15.
//  Copyright (c) 2015 Alexander Makarov. All rights reserved.
//

#import "GPDataStore.h"

@implementation GPDataStore {
    GPData *_data;
}

+ (instancetype)sharedInstance
{
    static GPDataStore* instance;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        instance = [GPDataStore new];
    });
    
    return instance;
}

-(NSArray *)objects
{
    return _data ? _data.objects : nil;
}

-(NSArray *)cameras
{
    return _data ? _data.cameras : nil;
}

-(NSArray *)typeList
{
    return _data ? _data.typeList : nil;
}


#pragma mark -

- (void)restoreDataWithMapper:(id<GPDataMappingDelegate>)dataMapper
{
    [[GPDataReceiverWizard sharedInstance] loadAllDataOnSuccessHandler:^(id responseObject) {
        NSError *error;
        NSDictionary *response = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&error];
#warning todo:обработка ошибки
        if (response && dataMapper) {
            [dataMapper mappedDataFromData:response
                         onCompleteHandler:^(GPData *gpData) {
                             _data = gpData;
                             [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_DATA_RESTORE_SUCCESS object:nil];
                         }];
        }
    }
                            onErrorHandler:^(NSError *error) {
                                _data = nil;
                                NSLog(@"Произошла ошибка при получении данных: %@", error);
                                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_DATA_RESTORE_FAIL object:nil];
                            }];
}




@end
