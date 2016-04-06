//
//  ViewController.m
//  PracticeProject2
//
//  Created by NHNEnt on 2016. 4. 4..
//  Copyright © 2016년 NHNEnt. All rights reserved.
//

#import "PhotoGridController.h"
#import "PhotoItemCell.h"
#import "PhotoItem.h"
#import "ImageManager.h"
#import "GroupItem.h"
#import "DetailController.h"

@interface PhotoGridController ()

@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;

@end

@implementation PhotoGridController

static NSString * const reuseIdentifier = @"PhotoItemCell";

- (instancetype) initWithCollectionViewLayout:(UICollectionViewLayout *)layout
{
    if ([layout isKindOfClass:[UICollectionViewFlowLayout class]]) {
        self.flowLayout = (UICollectionViewFlowLayout *)layout;
    } else {
        self.flowLayout = [[UICollectionViewFlowLayout alloc] init];
    }
    
    self.columnCount = 3;
    self.flowLayout.minimumLineSpacing = 3.0f;
    self.flowLayout.minimumInteritemSpacing = 3.0f;
    return [super initWithCollectionViewLayout:self.flowLayout];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UINib *cellNib = [UINib nibWithNibName:@"PhotoItemCell" bundle:nil];
    [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:reuseIdentifier];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.title = self.group.title;
    
    self.flowLayout.itemSize = [self computeSizeForColumn];
    [[ImageManager sharedManager] loadAssetsFromGroup:self.group.originalData andCompleteBlock:^{
        [self.collectionView reloadData];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGSize)computeSizeForColumn
{
    CGFloat collectionViewWidth = CGRectGetWidth(self.collectionView.bounds);
    CGFloat edgeLenght = (collectionViewWidth - (self.columnCount - 1) * self.flowLayout.minimumInteritemSpacing) / self.columnCount;
    return CGSizeMake(edgeLenght, edgeLenght);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [[ImageManager sharedManager] numberOfAssets];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    PhotoItem *item = [[ImageManager sharedManager].assets objectAtIndex:indexPath.row];
    cell.thumbnail.image = item.thumbnail;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    DetailController *detailController = [[DetailController alloc] initWithCollectionViewLayout:layout];
    detailController.assetIndex = indexPath.row;
    [self.navigationController pushViewController:detailController animated:YES];
}

@end
