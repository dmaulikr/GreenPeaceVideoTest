//
//  GPFilterController.h
//  GreenPeaceVideoTest
//
//  Created by Alexander Makarov on 27.07.15.
//  Copyright (c) 2015 Alexander Makarov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GPType.h"

@protocol GPFilterControllerDelegate <NSObject>

- (void)didSelectFilterObjectWithID:(NSNumber *)filterID;

@end


@interface GPFilterController : NSObject

@property (strong, nonatomic) NSNumber *selectedID;
@property (assign, nonatomic) id<GPFilterControllerDelegate> delegate;

- (void)dismissFilterController;

@end


@interface UIViewController (GPFilterController)

- (void)presentFilterController:(GPFilterController *)filterController pointArrow:(CGPoint)pointArrow;

@end
