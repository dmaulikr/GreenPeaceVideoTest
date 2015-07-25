//
//  GPDataMapper.m
//  GreenPeaceVideoTest
//
//  Created by Alexander Makarov on 25.07.15.
//  Copyright (c) 2015 Alexander Makarov. All rights reserved.
//

#import "GPDataMapper.h"
#import <Underscore.h>
#import "GPData.h"

#define CHECK_OBJ_BY_KEY(dict, key) [dict objectForKey:key] ? [dict objectForKey:key] : nil
#define CHECK_OBJ_BY_2_KEY(dict, key, twoKey) [dict objectForKey:key] ? [dict objectForKey:key] : [dict objectForKey:twoKey] ? [dict objectForKey:twoKey] : nil

@implementation GPDataMapper

#pragma mark - Mapping response data

- (void)mappedDataFromData:(NSDictionary *)data onCompleteHandler:(void (^)(GPData *))completeHandler
{
    GPData *result = [GPData new];
    
    NSDictionary *dataObj = (data && [data isKindOfClass:[NSDictionary class]]) ? CHECK_OBJ_BY_KEY(data, @"data") : nil;

    NSArray *objectsArr = dataObj ? CHECK_OBJ_BY_KEY(dataObj, @"objects") : nil;
    NSArray *camerasArr = dataObj ? CHECK_OBJ_BY_KEY(dataObj, @"cameras") : nil;
    NSArray *typeListArr = dataObj ? CHECK_OBJ_BY_2_KEY(dataObj, @"type_list", @"category_list") : nil;
    
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_async(group, dispatch_get_global_queue(0, 0), ^{
        result.objects = [self mapingObjects:objectsArr];
    });
    
    dispatch_group_async(group, dispatch_get_global_queue(0, 0), ^{
        result.cameras = [self mapingCameras:camerasArr];
    });
    
    dispatch_group_async(group, dispatch_get_global_queue(0, 0), ^{
        result.typeList = [self mapingTypeList:typeListArr];
    });
        
    dispatch_group_notify(group, dispatch_get_global_queue(0, 0), ^{
        completeHandler(result);
    });
}

- (NSArray *)mapingObjects:(NSArray *)objectsArr
{
    return Underscore.array(objectsArr).map(^GPObject* (NSDictionary *objItem) {
        GPObject *object = [GPObject new];
        object.ID = CHECK_OBJ_BY_KEY(objItem, @"id");
        object.name = CHECK_OBJ_BY_KEY(objItem, @"name");
        object.addressName = CHECK_OBJ_BY_KEY(objItem, @"addr");
        object.imageName = CHECK_OBJ_BY_KEY(objItem, @"image");
        object.logoName = CHECK_OBJ_BY_KEY(objItem, @"logo");
        object.countCameras = CHECK_OBJ_BY_KEY(objItem, @"count_cameras");
        object.geo = [objItem objectForKey:@"geo"] ? [self geoFromDictionary:[objItem objectForKey:@"geo"]] : nil;
        
        id typeList = CHECK_OBJ_BY_KEY(objItem, @"type");
        if (typeList && [typeList isKindOfClass:[NSArray class]]) {
            object.typeList = typeList;
        }
        else if (typeList && [typeList isKindOfClass:[NSString class]]) {
            object.typeName = typeList;
            object.typeList = CHECK_OBJ_BY_KEY(objItem, @"category");
        }
        else {
            object.typeList = CHECK_OBJ_BY_KEY(objItem, @"category");
        }
        
        return object;
    })
    .unwrap;
}

- (NSArray *)mapingCameras:(NSArray *)camerasArr
{
    return Underscore.array(camerasArr).map(^GPCamera* (NSDictionary *cameraItem) {
        GPCamera *camera = [GPCamera new];
        camera.ID = CHECK_OBJ_BY_KEY(cameraItem, @"id");
        camera.name = CHECK_OBJ_BY_KEY(cameraItem, @"name");
        camera.url = CHECK_OBJ_BY_KEY(cameraItem, @"url");
        camera.objID = CHECK_OBJ_BY_KEY(cameraItem, @"object_id");
        camera.imageName = CHECK_OBJ_BY_KEY(cameraItem, @"image");
        return camera;
    })
    .unwrap;
}

- (NSArray *)mapingTypeList:(NSArray *)typeListArr
{
    return Underscore.array(typeListArr).map(^GPType* (NSDictionary *typeItem) {
        GPType *type = [GPType new];
        type.ID = CHECK_OBJ_BY_KEY(typeItem, @"id");
        type.name = CHECK_OBJ_BY_KEY(typeItem, @"name");
        return type;
    })
    .unwrap;
}

- (GPGeo *)geoFromDictionary:(NSDictionary *)infoDcitionary
{
    if (!infoDcitionary) {
        return nil;
    }
    
    GPGeo *geo = [GPGeo new];
    geo.longitude = CHECK_OBJ_BY_KEY(infoDcitionary, @"lon");
    geo.latitude = CHECK_OBJ_BY_KEY(infoDcitionary, @"lat");
    return geo;
}

@end
