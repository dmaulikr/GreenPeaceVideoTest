//
//  GPDataReceiverWizard.h
//  GreenPeaceVideoTest
//
//  Created by Alexander Makarov on 24.07.15.
//  Copyright (c) 2015 Alexander Makarov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import "GPCache.h"

typedef enum {
    GPImageLoadTypeObject,
    GPImageLoadTypeCamera
} GPImageLoadType;

@interface GPDataReceiverWizard : NSObject

+ (instancetype)sharedInstance;

- (void)loadAllDataOnSuccessHandler:(void (^)(id responseObject))successHandler
                     onErrorHandler:(void (^)(NSError* error))errorHandler;

- (void)loadImageWithName:(NSString *)imageName imageLoadType:(GPImageLoadType)imageLoadType completion:(void (^)(UIImage *image))completionBlock;

@end
