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


#define kCollectionViewCornerRadius 6.0f


@interface GPViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (strong, nonatomic) UICollectionView *collectionView;

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
    _collectionView.layer.borderColor = [UIColor redColor].CGColor;
    _collectionView.layer.borderWidth = 1.0;
}


#pragma mark - UICollectionView Deledate & DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (![GPDataStore sharedInstance].objects) {
        return 0;
    }
    return [GPDataStore sharedInstance].objects.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GPObjectsCell *cell = (GPObjectsCell *)[collectionView dequeueReusableCellWithReuseIdentifier:kGPObjectsCellIdentifier forIndexPath:indexPath];
    
    GPObject *object = [[GPDataStore sharedInstance].objects objectAtIndex:indexPath.row];
    
    cell.layer.cornerRadius = kCollectionViewCornerRadius;
    cell.backgroundColor = [UIColor whiteColor];
//    cell.pandaImageView.image = ;
//    cell.previewImageView;
//    cell.locationImageView;
    cell.typeLabel.text = object.typeName;
    cell.titleLabel.text = object.name;
    cell.locationLabel.text = object.addressName;
    if ([object.countCameras integerValue] == 1) {
        cell.playButton.hidden = NO;
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
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


#pragma mark - SEL

- (void)dateRestoreSuccess
{
    [NSThread detachNewThreadSelector:@selector(reloadData) toTarget:self.collectionView withObject:nil];
}

- (void)dateRestoreFail
{
    
}

@end
