//
//  GPDataStore.m
//  GreenPeaceVideoTest
//
//  Created by Alexander Makarov on 24.07.15.
//  Copyright (c) 2015 Alexander Makarov. All rights reserved.
//

#import "GPDataStore.h"
#import <Underscore.h>

@implementation GPDataStore 
{
    GPData *_data;
    NSMutableDictionary *_imagesDictionary;
    CLLocationManager *_locationManager;
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

-(instancetype)init
{
    self = [super init];
    if (self) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.distanceFilter = kCLDistanceFilterNone;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
            [_locationManager requestWhenInUseAuthorization];
        
        [_locationManager startUpdatingLocation];
    }
    return self;
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


#pragma mark - data

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


#pragma mark - images

- (void)imageForKey:(NSString *)key
          isPreview:(BOOL)isPreview
      imageLoadType:(GPImageLoadType)imageLoadType
         completion:(void (^)(UIImage *))completionBlock
{
    if (!_imagesDictionary) {
        _imagesDictionary = [NSMutableDictionary new];
    }
    
    NSString *imageName = [self imageNameByKey:key isPreview:isPreview];
    if ([_imagesDictionary objectForKey:imageName]) {
        UIImage *image = [_imagesDictionary objectForKey:imageName];
        completionBlock(image);
    }
    else {
        [[GPDataReceiverWizard sharedInstance] loadImageWithName:imageName
                                                   imageLoadType:imageLoadType
                                                      completion:^(UIImage *image) {
                                                          [_imagesDictionary setObject:image forKey:imageName];
                                                          completionBlock(image);
                                                      }];
    }
}

- (NSString *)imageNameByKey:(NSString *)key isPreview:(BOOL)isPreview
{
    if (isPreview) {
        return [NSString stringWithFormat:@"thumb_%@", key];
    }
    return key;
}


#pragma mark - methods

- (NSArray *)listCamerasByObject:(GPObject *)object
{
    return Underscore.array(self.cameras).filter(^BOOL (GPCamera *camera) {
        return [camera.objID isEqualToNumber:object.ID];
    })
    .unwrap;
}

- (NSArray *)objectsByFilertID:(NSNumber *)filterID
{
    if (!filterID) {
        return self.objects;
    }
    
    return Underscore.array(self.objects).filter(^BOOL (GPObject *object) {
        return [object.typeList containsObject:filterID];
    })
    .unwrap;
}


#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"Ошибка при получении текущей позиции");
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    _currentLocation = newLocation;
}

@end
