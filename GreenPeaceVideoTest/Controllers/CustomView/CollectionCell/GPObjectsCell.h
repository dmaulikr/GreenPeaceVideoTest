//
//  GPObjectsCell.h
//
//  Created by Alexander Makarov on 11.11.14.
//
//

#import <UIKit/UIKit.h>

#define kGPObjectsCellIdentifier @"kGPObjectsCellIdentifier"

#define COLLECTION_VIEW_HEIGHT 296.0f
#define COLLECTION_VIEW_INSETS UIEdgeInsetsMake(8.0, 8.0, 8.0, 8.0)

@interface GPObjectsCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *pandaImageView;
@property (weak, nonatomic) IBOutlet UIImageView *previewImageView;
@property (weak, nonatomic) IBOutlet UIButton *locationButton;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UIButton *playButton;

@end
