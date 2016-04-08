//
//  DetailController.m
//  PracticeProject2
//
//  Created by NHNEnt on 2016. 4. 6..
//  Copyright © 2016년 NHNEnt. All rights reserved.
//

#import "DetailController.h"
#import "ImageManager.h"
#import "DetailImageCell.h"
#import "PhotoItem.h"

@interface DetailController ()

@end

@implementation DetailController
{
    int mCurrentIndex;
}

static NSString * const reuseIdentifier = @"DetailImageCell";

- (instancetype) init
{
    return [self initWithCollectionViewLayout:nil];
}

- (instancetype) initWithCollectionViewLayout:(UICollectionViewLayout *)layout
{
    if ([layout isKindOfClass:[UICollectionViewFlowLayout class]]) {
        _flowLayout = (UICollectionViewFlowLayout *)layout;
    } else {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
    }
    
    _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _flowLayout.minimumLineSpacing = 0.0f;
    _flowLayout.minimumInteritemSpacing = 0.0f;
    
    return [super initWithCollectionViewLayout:_flowLayout];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    UINib *cellNib = [UINib nibWithNibName:@"DetailImageCell" bundle:nil];
    [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:reuseIdentifier];
    self.collectionView.pagingEnabled = YES;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                                                                           target:self
                                                                                           action:@selector(shareImage)];
    
    self.flowLayout.itemSize = self.collectionView.bounds.size;
    [self.flowLayout invalidateLayout];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.assetIndex inSection:0];
    
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
//    [self.collectionView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    if ([self isViewLoaded] && ![[self view] window])
    {
        [self setView:nil];
    }
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    CGPoint currentOffset = [self.collectionView contentOffset];
    mCurrentIndex = currentOffset.x / self.collectionView.frame.size.width;
    
    [UIView animateWithDuration:0.1f animations:^{
        [self.collectionView setAlpha:0.0f];
    }];
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    CGSize currentSize = self.collectionView.bounds.size;
    float offset = mCurrentIndex * currentSize.width;
    self.flowLayout.itemSize = currentSize;
    [self.collectionView setContentOffset:CGPointMake(offset, 0)];
    [UIView animateWithDuration:0.1f animations:^{
        [self.collectionView setAlpha:1.0f];
    }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [[ImageManager sharedManager].selectedAssets count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DetailImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    self.assetIndex = indexPath.row;
    // Configure the cell
    PhotoItem *item = [ImageManager sharedManager].selectedAssets[indexPath.row];
    UIImage *image = item.realImage;
    cell.imageView.image = image;
    return cell;
}

- (void)invalidateView
{
    
}

- (void)shareImage
{
    CGPoint currentOffset = [self.collectionView contentOffset];
    mCurrentIndex = currentOffset.x / self.collectionView.frame.size.width;
    
    PhotoItem *item = [ImageManager sharedManager].selectedAssets[mCurrentIndex];
    
    UIActivityViewController *shareContorller = [[UIActivityViewController alloc] initWithActivityItems:@[item.realImage] applicationActivities:nil];
    [self presentViewController:shareContorller animated:YES completion:nil];
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
