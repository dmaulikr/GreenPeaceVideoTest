//
//  GPDataMappingDelegate.h
//  GreenPeaceVideoTest
//
//  Created by Alexander Makarov on 25.07.15.
//  Copyright (c) 2015 Alexander Makarov. All rights reserved.
//

@class GPData;

@protocol GPDataMappingDelegate  <NSObject>

- (void)mappedDataFromData:(NSDictionary *)data onCompleteHandler:(void (^)(GPData *gpData))completeHandler;

@end
