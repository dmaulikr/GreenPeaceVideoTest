//
//  GPNavTitleButton.m
//  GreenPeaceVideoTest
//
//  Created by Alexander Makarov on 27.07.15.
//  Copyright (c) 2015 Alexander Makarov. All rights reserved.
//

#import "GPNavTitleButton.h"

#define kMarginBetweenTitleAndImage 5.0f

@implementation GPNavTitleButton

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect frameImage = self.imageView.frame;
    frameImage.origin.x = self.titleLabel.frame.origin.x + self.titleLabel.frame.size.width + kMarginBetweenTitleAndImage;
    self.imageView.frame = frameImage;
}

@end
