//
//  GPCamerasCell.h
//
//  Created by Alexander Makarov on 11.11.14.
//
//

#import <UIKit/UIKit.h>

#define kGPCamerasCellIdentifier @"kGPCamerasCellIdentifier"

#define COLLECTION_VIEW_HEIGHT 296.0f
#define COLLECTION_VIEW_INSETS UIEdgeInsetsMake(8.0, 8.0, 8.0, 8.0)

@interface GPCamerasCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *previewImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *playButton;

@end
