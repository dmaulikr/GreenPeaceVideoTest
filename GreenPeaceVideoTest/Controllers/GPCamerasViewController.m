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


@interface GPCamerasViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UIActionSheetDelegate>

@property (strong, nonatomic) UICollectionView *collectionView;

@property (strong, nonatomic) NSArray *cameras;
@property (strong, nonatomic) CLLocation *targetLocation;

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
        _targetLocation = [[CLLocation alloc] initWithLatitude:[object.geo.latitude doubleValue] longitude:[object.geo.longitude doubleValue]];
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
    
    UIImage *bgLeftImage = [UIImage imageNamed:@"back_bttn"];
    UIButton* backButton = [[UIButton alloc] init];
    backButton.frame = CGRectMake(0, 0, 40, 40);
    [backButton setBackgroundColor:[UIColor clearColor]];
    [backButton setImage:bgLeftImage forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(popViewController:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    UIImage *bgRightImage = [UIImage imageNamed:@"navigation_bttn"];
    UIButton* navButton = [[UIButton alloc] init];
    navButton.frame = CGRectMake(0, 0, 40, 40);
    [navButton setBackgroundColor:[UIColor clearColor]];
    [navButton setImage:bgRightImage forState:UIControlStateNormal];
    [navButton addTarget:self action:@selector(didTapNavButton:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:navButton];
    
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
    cell.titleLabel.font = [UIFont customFont2];
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

- (void)popViewController:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didTapNavButton:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"Отмена"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Apple Maps", @"Google Maps", @"Yandex Maps", nil];
    [actionSheet showInView:self.view];
}


#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (!self.targetLocation || ![GPDataStore sharedInstance].currentLocation) {
        return;
    }
    
    NSString *urlString = nil;
    switch (buttonIndex) {
        case 0: {
            urlString = [NSString stringWithFormat:@"http://maps.apple.com/?saddr=%f,%f&daddr=%f,%f", [GPDataStore sharedInstance].currentLocation.coordinate.latitude, [GPDataStore sharedInstance].currentLocation.coordinate.longitude, self.targetLocation.coordinate.latitude, self.targetLocation.coordinate.longitude];
        }
            break;
        case 1: {
            if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"comgooglemaps://"]]) {
                urlString = [NSString stringWithFormat:@"comgooglemaps://?center=%f,%f&zoom=14&views=traffic", self.targetLocation.coordinate.latitude, self.targetLocation.coordinate.longitude];
            }
            else {
                urlString = @"https://itunes.apple.com/ru/app/google-maps/id585027354?mt=8";
            }
        }
            break;
        case 2: {
            if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"yandexmaps://"]]) {
                urlString = [NSString stringWithFormat:@"yandexmaps://build_route_on_map/?lat_from=%f&lon_from=%f&lat_to=%f&lon_to=%f", [GPDataStore sharedInstance].currentLocation.coordinate.latitude, [GPDataStore sharedInstance].currentLocation.coordinate.longitude, self.targetLocation.coordinate.latitude, self.targetLocation.coordinate.longitude];
            } else {
                urlString = @"https://itunes.apple.com/ru/app/yandex.maps/id313877526?mt=8";
            }
        }
            break;
        default:
            break;
    }
    
    NSURL *url = [NSURL URLWithString:urlString];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
    }
}

@end
