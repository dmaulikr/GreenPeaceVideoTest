//
//  GPDataReceiverWizard.m
//  GreenPeaceVideoTest
//
//  Created by Alexander Makarov on 24.07.15.
//  Copyright (c) 2015 Alexander Makarov. All rights reserved.
//

#import "GPDataReceiverWizard.h"

#define SERVER_API_URL @"http://t.appkode.ru/testcamera/api.php"

#define kCacheKey @"storedData"

@implementation GPDataReceiverWizard

+ (instancetype)sharedInstance
{
    static GPDataReceiverWizard* instance;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        instance = [GPDataReceiverWizard new];
    });
    
    return instance;
}


#pragma mark - Methods

-(void)loadAllDataOnSuccessHandler:(void (^)(id))successHandler
                    onErrorHandler:(void (^)(NSError *))errorHandler
{
    NSDictionary *parameters = [self parametersForAllData];
    [self loadDataFromAPIWithParameters:parameters
                       onSuccessHandler:^(id responseObject) {
                           dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                               NSData *cacheData = [NSKeyedArchiver archivedDataWithRootObject:responseObject];
                               [GPCache dumpData:cacheData withName:kCacheKey];
                               
                               dispatch_async(dispatch_get_main_queue(), ^{
                                   successHandler(responseObject);
                               });
                           });
                       }
                         onErrorHandler:^(NSError *error) {
                             NSData *cacheData = [GPCache dataForCacheFileNamed:kCacheKey];
                             if (cacheData) {
                                 id responseObject = [NSKeyedUnarchiver unarchiveObjectWithData:cacheData];
                                 dispatch_async(dispatch_get_main_queue(), ^{
                                     successHandler(responseObject);
                                 });
                             }
                             else {
                                 dispatch_async(dispatch_get_main_queue(), ^{
                                     errorHandler(error);
                                 });
                             }
                         }];
}

-(void)loadDataFromAPIWithParameters:(NSDictionary *)parameters
                    onSuccessHandler:(void (^)(id))successHandler
                      onErrorHandler:(void (^)(NSError *))errorHandler
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"content-type"];
    manager.responseSerializer = [AFHTTPResponseSerializer new];
    [manager GET:SERVER_API_URL
      parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             successHandler(responseObject);
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"Error: %@", error);
             errorHandler(error);
         }];
}


#pragma mark - Parameters

- (NSDictionary *)parametersForAllData
{
    return @{
             @"act" : @"getalldata"
             };
}

@end
