//
//  GPCamerasViewController.m
//  GreenPeaceVideoTest
//
//  Created by Alexander Makarov on 23.07.15.
//  Copyright (c) 2015 Alexander Makarov. All rights reserved.
//

#import "GPCamerasViewController.h"
#import "GPDataStore.h"
#import "UIColor+Extension.h"
#import "UIFont+Extension.h"
#import "GPCamerasCell.h"


#define kCollectionViewCornerRadius 6.0f


@interface GPCamerasViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (strong, nonatomic) UICollectionView *collectionView;

@property (strong, nonatomic) NSArray *cameras;

@end

@implementation GPCamerasViewController

- (instancetype)initWithObject:(GPObject *)object
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(orientationChanged:)
                                                     name:UIDeviceOrientationDidChangeNotification
                                                   object:nil];
        
        _cameras = [[GPDataStore sharedInstance] listCamerasByObject:object];
    }
    return self;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(NSString *)title
{
    return @"Камеры";
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImage *bgImage = [UIImage imageNamed:@"back_bttn"];
    UIButton* backButton = [[UIButton alloc] init];
    backButton.frame = CGRectMake(0, 0, 40, 40);
    [backButton setBackgroundColor:[UIColor clearColor]];
    [backButton setImage:bgImage forState:UIControlStateNormal];
    [backButton addTarget:self.navigationController action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem* buttonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = buttonItem;
    [self.navigationItem setHidesBackButton:YES animated:NO];
    
    
    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds
                                                 collectionViewLayout:[UICollectionViewFlowLayout new]];
    _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor mainColor2];
    _collectionView.scrollEnabled = YES;
    [_collectionView registerNib:[UINib nibWithNibName:@"GPCamerasCell" bundle:nil]
      forCellWithReuseIdentifier:kGPCamerasCellIdentifier];
    [self.view addSubview:_collectionView];
}

- (NSArray *)objectsByFilertID:(NSNumber *)filterID
{
    return [[GPDataStore sharedInstance] objectsByFilertID:filterID];
}


#pragma mark - UICollectionView Deledate & DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (!self.cameras) {
        return 0;
    }
    return self.cameras.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GPCamerasCell *cell = (GPCamerasCell *)[collectionView dequeueReusableCellWithReuseIdentifier:kGPCamerasCellIdentifier forIndexPath:indexPath];
    
    GPCamera *camera = [self.cameras objectAtIndex:indexPath.row];
    
    cell.layer.cornerRadius = kCollectionViewCornerRadius;
    cell.backgroundColor = [UIColor whiteColor];
    
    cell.previewImageView.layer.masksToBounds = YES;
    [[GPDataStore sharedInstance] imageForKey:camera.imageName
                                    isPreview:YES
                                imageLoadType:GPImageLoadTypeCamera
                                   completion:^(UIImage *image) {
                                       cell.previewImageView.image = image;
                                       cell.previewImageView.contentMode = UIViewContentModeScaleAspectFill;
                                   }];
    
    cell.titleLabel.text = camera.name;
    [cell.playButton addTarget:self action:@selector(didTapPlayButton:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}


#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(collectionView.bounds.size.width - COLLECTION_VIEW_INSETS.left - COLLECTION_VIEW_INSETS.right,
                      COLLECTION_VIEW_HEIGHT);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return COLLECTION_VIEW_INSETS;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 8.0f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 1.0f;
}


#pragma mark - rotation

- (void)orientationChanged:(NSNotification*)notification
{
    [self.collectionView reloadData];
}


#pragma mark - SEL

- (void)didTapPlayButton:(id)sender
{
    GPCamerasCell *cell = (GPCamerasCell *)((UIButton *)sender).superview.superview;
    if (![cell isKindOfClass:[GPCamerasCell class]]) {
        return;
    }
    
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    GPCamera *camera = [self.cameras objectAtIndex:indexPath.row];
    
    VKVideoPlayerViewController *viewController = [[VKVideoPlayerViewController alloc] init];
    [self presentViewController:viewController animated:YES completion:nil];
    [viewController playVideoWithStreamURL:[NSURL URLWithString:camera.url]];
}

@end
