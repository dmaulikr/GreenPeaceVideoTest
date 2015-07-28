//
//  GPViewController.m
//  GreenPeaceVideoTest
//
//  Created by Alexander Makarov on 23.07.15.
//  Copyright (c) 2015 Alexander Makarov. All rights reserved.
//

#import "GPViewController.h"
#import "GPDataStore.h"
#import "UIColor+Extension.h"
#import "UIFont+Extension.h"
#import "GPObjectsCell.h"
#import "GPNavTitleButton.h"
#import "GPFilterController.h"
#import "GPCamerasViewController.h"


#define kCollectionViewCornerRadius 6.0f


@interface GPViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UIPopoverControllerDelegate, GPFilterControllerDelegate, UIActionSheetDelegate>

@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) NSNumber *lastSelectedFilter;
@property (strong, nonatomic) GPFilterController *filterController;

@property (strong, nonatomic) NSArray *objects;
@property (strong, nonatomic) CLLocation *targetLocation;

@end

@implementation GPViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(dateRestoreSuccess)
                                                     name:NOTIFICATION_DATA_RESTORE_SUCCESS
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(dateRestoreFail)
                                                     name:NOTIFICATION_DATA_RESTORE_FAIL
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(orientationChanged:)
                                                     name:UIDeviceOrientationDidChangeNotification
                                                   object:nil];
    }
    return self;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(NSString *)title
{
    return @"Все";
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImage *titleImage = [UIImage imageNamed:@"drop_down_icon"];
    GPNavTitleButton *titleButton = [GPNavTitleButton buttonWithType:UIButtonTypeCustom];
    titleButton.frame = CGRectMake(0, 0, 200, 40);
    [titleButton setTitle:@"Все" forState:UIControlStateNormal];
    [titleButton setImage:titleImage forState:UIControlStateNormal];
    [titleButton setTitleColor:[UIColor textColor1] forState:UIControlStateNormal];
    [titleButton.titleLabel setFont:[UIFont customFont4]];
    [titleButton addTarget:self action:@selector(didTapTitleButton:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = titleButton;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds
                                                 collectionViewLayout:[UICollectionViewFlowLayout new]];
    _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor mainColor2];
    _collectionView.scrollEnabled = YES;
    [_collectionView registerNib:[UINib nibWithNibName:@"GPObjectsCell" bundle:nil]
      forCellWithReuseIdentifier:kGPObjectsCellIdentifier];
    [self.view addSubview:_collectionView];
}

- (NSArray *)objectsByFilertID:(NSNumber *)filterID
{
    return [[GPDataStore sharedInstance] objectsByFilertID:filterID];
}


#pragma mark - UICollectionView Deledate & DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (!self.objects) {
        return 0;
    }
    return self.objects.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GPObjectsCell *cell = (GPObjectsCell *)[collectionView dequeueReusableCellWithReuseIdentifier:kGPObjectsCellIdentifier forIndexPath:indexPath];
    
    GPObject *object = [self.objects objectAtIndex:indexPath.row];
    
    cell.layer.cornerRadius = kCollectionViewCornerRadius;
    cell.backgroundColor = [UIColor whiteColor];
    
    cell.previewImageView.layer.masksToBounds = YES;
    [[GPDataStore sharedInstance] imageForKey:object.imageName
                                    isPreview:YES
                                imageLoadType:GPImageLoadTypeObject
                                   completion:^(UIImage *image) {
                                       cell.previewImageView.image = image;
                                       cell.previewImageView.contentMode = UIViewContentModeScaleAspectFill;
                                   }];
    
    cell.pandaImageView.image = nil;
    [cell.locationButton addTarget:self action:@selector(didTapLocationButton:) forControlEvents:UIControlEventTouchUpInside];
    cell.typeLabel.text = object.typeName;
    cell.typeLabel.font = [UIFont customFont1];
    cell.typeLabel.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.54];
    cell.titleLabel.text = object.name;
    cell.titleLabel.font = [UIFont customFont2];
    cell.locationLabel.text = object.addressName;
    cell.locationLabel.font = [UIFont customFont3];
    cell.locationLabel.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.54];
    [cell.playButton addTarget:self action:@selector(didTapPlayButton:) forControlEvents:UIControlEventTouchUpInside];
    if ([object.countCameras integerValue] == 1) {
        cell.playButton.hidden = NO;
    }
    else {
        cell.playButton.hidden = YES;
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    GPObject *object = [self.objects objectAtIndex:indexPath.row];
    if ([object.countCameras integerValue] == 1) {
        return;
    }
    
    GPCamerasViewController *camerasViewController = [[GPCamerasViewController alloc] initWithObject:object];
    [self.navigationController pushViewController:camerasViewController animated:YES];
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

- (void)dateRestoreSuccess
{
    _objects = [self objectsByFilertID:self.lastSelectedFilter];
    [NSThread detachNewThreadSelector:@selector(reloadData) toTarget:self.collectionView withObject:nil];
}

- (void)dateRestoreFail
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Ошибка"
                                                        message:@"Произошла ошибка приполучении информации с сервера"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil, nil];
    [alertView show];
}

- (void)didTapPlayButton:(id)sender
{
    GPObjectsCell *cell = (GPObjectsCell *)((UIButton *)sender).superview.superview;
    if (![cell isKindOfClass:[GPObjectsCell class]]) {
        return;
    }
    
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    GPObject *object = [self.objects objectAtIndex:indexPath.row];
    
    GPCamera *camera = [[[GPDataStore sharedInstance] listCamerasByObject:object] lastObject];
    
    VKVideoPlayerViewController *viewController = [[VKVideoPlayerViewController alloc] init];
    [self presentViewController:viewController animated:YES completion:nil];
    [viewController playVideoWithStreamURL:[NSURL URLWithString:camera.url]];
}

- (void)didTapLocationButton:(id)sender
{
    GPObjectsCell *cell = (GPObjectsCell *)((UIButton *)sender).superview.superview;
    if (![cell isKindOfClass:[GPObjectsCell class]]) {
        return;
    }
    
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    GPObject *object = [self.objects objectAtIndex:indexPath.row];
    _targetLocation = [[CLLocation alloc] initWithLatitude:[object.geo.latitude doubleValue] longitude:[object.geo.longitude doubleValue]];
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"Отмена"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Apple Maps", @"Google Maps", @"Yandex Maps", nil];
    [actionSheet showInView:self.view];
}

- (void)didTapTitleButton:(id)sender
{
    if (!_filterController) {
        _filterController = [GPFilterController new];
    }
    self.filterController.selectedID = self.lastSelectedFilter;
    self.filterController.delegate = self;
    
    CGPoint pointArrow = CGPointMake(floor(self.view.bounds.size.width/2),
                                     self.navigationController.navigationBar.frame.origin.y + self.navigationController.navigationBar.frame.size.height);
    [self presentFilterController:self.filterController pointArrow:pointArrow];
}


#pragma mark - GPFilterControllerDelegate

- (void)didSelectFilterObjectWithID:(NSNumber *)filterID
{
    _lastSelectedFilter = filterID;
    [self dateRestoreSuccess];
    [self.filterController dismissFilterController];
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
