//
//  GPFilterController.m
//  GreenPeaceVideoTest
//
//  Created by Alexander Makarov on 27.07.15.
//  Copyright (c) 2015 Alexander Makarov. All rights reserved.
//

#import "GPFilterController.h"
#include "GPDataStore.h"
#import "UIFont+Extension.h"
#import "AppDelegate.h"

#define kTableViewCellHeight 44.0f
#define kTableViewCornerRadius 6.0f

#define CONTENT_INSETS UIEdgeInsetsMake(0.0, 8.0, 0.0, 8.0)
#define TRIANGLE_WIDTH 8.0f
#define TRIANGLE_HEIGHT 4.0f



#pragma mark - GPTriangleViews

@interface GPTriangleView : UIView

@end

@implementation GPTriangleView

- (void)drawRect:(CGRect)rect
{
    [[UIColor whiteColor] setFill];
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, rect.size.height)];
    [path addLineToPoint:CGPointMake(floor(rect.size.width/2), 0)];
    [path addLineToPoint:CGPointMake(rect.size.width, rect.size.height)];
    [path closePath];
    [path fill];
}

@end


#pragma mark -
#pragma mark - GPFilterViewController

@interface GPFilterViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate>

@property (strong, nonatomic) GPTriangleView *triangleView;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSArray *filterList;

@property (assign, nonatomic) CGPoint pointArrow;
@property (strong, nonatomic) NSNumber *selectedID;
@property (assign, nonatomic) id<GPFilterControllerDelegate> delegate;

@property (readonly, nonatomic) CGSize contentSize;

@end

@implementation GPFilterViewController

@synthesize contentSize = _contentSize;

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSMutableArray *tempArray = [NSMutableArray array];
        [tempArray addObject:[GPType typeWithID:nil name:@"Все"]];
        [tempArray addObjectsFromArray:[GPDataStore sharedInstance].typeList];
        _filterList = [NSArray arrayWithArray:tempArray];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGRect triangleFrame = CGRectMake(self.pointArrow.x,
                                      self.pointArrow.y,
                                      TRIANGLE_WIDTH,
                                      TRIANGLE_HEIGHT);
    _triangleView = [[GPTriangleView alloc] initWithFrame:triangleFrame];
    _triangleView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_triangleView];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(CONTENT_INSETS.left,
                                                               self.pointArrow.y + TRIANGLE_HEIGHT,
                                                               self.view.bounds.size.width - CONTENT_INSETS.left - CONTENT_INSETS.right,
                                                               self.view.bounds.size.height - self.pointArrow.y - TRIANGLE_HEIGHT)
                                              style:UITableViewStylePlain];
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView setSeparatorInset:UIEdgeInsetsZero];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.layer.cornerRadius = kTableViewCornerRadius;
    _tableView.userInteractionEnabled = YES;
    [self.view addSubview:_tableView];
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    CGRect rect = self.tableView.frame;
    rect.size.height = kTableViewCellHeight*self.filterList.count > self.view.bounds.size.height - self.pointArrow.y - TRIANGLE_HEIGHT ? self.view.bounds.size.height - self.pointArrow.y - TRIANGLE_HEIGHT : kTableViewCellHeight*self.filterList.count;
    self.tableView.frame = rect;
}


#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kTableViewCellHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.filterList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"GPTableViewCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    GPType *type = self.filterList[indexPath.row];
    
    cell.textLabel.text = type.name;
    cell.textLabel.font = [UIFont customFont2];
    BOOL isAccessoryView = (self.selectedID && type.ID && [self.selectedID isEqualToNumber:type.ID]) || (!self.selectedID && indexPath.row == 0);
    cell.accessoryView = isAccessoryView ? [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"check_icon"]] : nil;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GPType *type = self.filterList[indexPath.row];
    if ((self.selectedID && type.ID && [self.selectedID isEqualToNumber:type.ID]) || (!self.selectedID && indexPath.row == 0)) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        return;
    }
    self.selectedID = type.ID;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectFilterObjectWithID:)]) {
        [self.delegate didSelectFilterObjectWithID:type.ID];
    }
    [tableView reloadData];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
    NSInteger customSeparatorViewTag = 1000123;
    if (indexPath.row != self.filterList.count - 1) {
        if ([cell.contentView viewWithTag:customSeparatorViewTag]) {
            [[cell.contentView viewWithTag:customSeparatorViewTag] removeFromSuperview];
        }
        
        UIView *customSeparatorView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                               cell.bounds.size.height - 1,
                                                                               cell.bounds.size.width,
                                                                               1)];
        customSeparatorView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        customSeparatorView.backgroundColor = tableView.separatorColor;
        customSeparatorView.tag = customSeparatorViewTag;
        [cell.contentView addSubview:customSeparatorView];
    }
}


#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    CGPoint point = [touch locationInView:self.tableView];
    if (point.x > 0 && point.x < self.tableView.frame.size.width &&
        point.y > 0 && point.y < self.tableView.frame.size.height) {
        return NO;
    }
    return YES;
}

@end


#pragma mark - -
#pragma mark - GPFilterController

@interface GPFilterController()

@property (strong, nonatomic) GPFilterViewController *filterViewController;

@property (strong, nonatomic) UIView *lockView;

- (void)presentToController:(UIViewController *)viewController pointArrow:(CGPoint)pointArrow;

@end

static GPFilterController *filterController = nil;

@implementation GPFilterController : NSObject

- (instancetype)init
{
    self = [super init];
    if (self) {
        _filterViewController = [[GPFilterViewController alloc] init];
        
        _lockView = [[UIView alloc] init];
        _lockView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        _lockView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return self;
}

- (void)presentToController:(UIViewController *)viewController pointArrow:(CGPoint)pointArrow
{
    self.lockView.frame = viewController.view.bounds;
    self.filterViewController.pointArrow = pointArrow;
    self.filterViewController.delegate = self.delegate;
    self.filterViewController.selectedID = self.selectedID;
    
    [((AppDelegate *)[UIApplication sharedApplication].delegate).window addSubview:self.lockView];
    [((AppDelegate *)[UIApplication sharedApplication].delegate).window addSubview:self.filterViewController.view];
    
    [self.lockView setAlpha:0.0];
    [self.filterViewController.view setAlpha:0.0];
    
    [UIView animateWithDuration:0.2
                          delay:0.1
                        options:UIViewAnimationOptionShowHideTransitionViews
                     animations:^{
                         [self.lockView setAlpha:1.0];
                         [self.filterViewController.view setAlpha:1.0];
                     }
                     completion:^(BOOL finished) {
                         filterController = self;
                         
                         UITapGestureRecognizer *tapOnLockView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissFilterController)];
                         tapOnLockView.numberOfTapsRequired = 1;
                         tapOnLockView.numberOfTouchesRequired = 1;
                         tapOnLockView.delegate = self.filterViewController;
                         [self.filterViewController.view addGestureRecognizer:tapOnLockView];
                     }];
}

-(void)dismissFilterController
{
    [UIView animateWithDuration:0.2
                          delay:0.1
                        options:UIViewAnimationOptionShowHideTransitionViews
                     animations:^{
                         [self.lockView setAlpha:0.0];
                         [self.filterViewController.view setAlpha:0.0];
                     }
                     completion:^(BOOL finished) {
                         [self.filterViewController.view removeFromSuperview];
                         [self.lockView removeFromSuperview];
                         filterController = nil;
                     }];
}

@end


#pragma mark - -
#pragma mark - GPFilterController

@implementation UIViewController (GPFilterController)

- (void)presentFilterController:(GPFilterController *)filterController pointArrow:(CGPoint)pointArrow
{
    [filterController presentToController:self pointArrow:pointArrow];
}

@end


