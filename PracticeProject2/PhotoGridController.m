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
@property (nonatomic, strong) UISwipeGestureRecognizer *swipeGesture;
@property (nonatomic, strong) NSMutableArray *selectedIndex;

@end

@implementation PhotoGridController
{
    UIBarButtonItem *mEditBtn;
    UIBarButtonItem *mDoneBtn;
    UIBarButtonItem *mFlexibleBtn;
    UIBarButtonItem *mPhotoBtn;
    UIBarButtonItem *mDeleteBtn;
}

static NSString * const reuseIdentifier = @"PhotoItemCell";

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
    _columnCount = 3;
    _flowLayout.minimumLineSpacing = 3.0f;
    _flowLayout.minimumInteritemSpacing = 3.0f;
    
    _swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipe)];
    _swipeGesture.direction = UISwipeGestureRecognizerDirectionLeft | UISwipeGestureRecognizerDirectionRight;
    
    _selectedIndex = [[NSMutableArray alloc] init];
    
    mFlexibleBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    mPhotoBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera
                                                              target:self
                                                              action:@selector(takePhoto)];
    mDeleteBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash
                                                               target:self
                                                               action:@selector(popupDeleteRequest)];
    mEditBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
                                                             target:self
                                                             action:@selector(toggleEdteMode)];
    mDoneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                             target:self
                                                             action:@selector(toggleEdteMode)];
    
    return [super initWithCollectionViewLayout:_flowLayout];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UINib *cellNib = [UINib nibWithNibName:@"PhotoItemCell" bundle:nil];
    [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:reuseIdentifier];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    self.title = self.group.title;
    self.navigationController.toolbarHidden = NO;
    
    [mDeleteBtn setEnabled:NO];
    self.toolbarItems = @[mPhotoBtn, mFlexibleBtn, mDeleteBtn];
    self.navigationItem.rightBarButtonItem = mEditBtn;
    
    self.flowLayout.itemSize = [self computeSizeForColumnWithContainerSize:self.collectionView.bounds.size];
    
    [self.collectionView addGestureRecognizer:self.swipeGesture];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadAssets];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    if ([self isViewLoaded] && ![[self view] window])
    {
        [self setView:nil];
    }
}

- (CGSize)computeSizeForColumnWithContainerSize:(CGSize)size
{
    CGFloat collectionViewWidth = size.width;
    CGFloat edgeLenght = (collectionViewWidth - (self.columnCount - 1) * self.flowLayout.minimumInteritemSpacing) / self.columnCount;
    return CGSizeMake(edgeLenght, edgeLenght);
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    if (UIDeviceOrientationIsPortrait(orientation))
    {
        self.columnCount = 3;
    }
    else
    {
        self.columnCount = 5;
    }
    self.flowLayout.itemSize = [self computeSizeForColumnWithContainerSize:size];
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
}

#pragma mark - Collection view data source

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [[ImageManager sharedManager] numberOfAssets];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    PhotoItem *item = [[ImageManager sharedManager].selectedAssets objectAtIndex:indexPath.row];
    
    cell.thumbnail.image = item.thumbnail;
    if ([self isEditing])
    {
        if ([self.selectedIndex indexOfObject:indexPath] != NSNotFound)
        {
            cell.selected = YES;
        }
        else
        {
            cell.selected = NO;
        }
    }
    else
    {
        cell.selected = NO;
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self isEditing])
    {
        if ([self.selectedIndex indexOfObject:indexPath] != NSNotFound)
        {
            [self.selectedIndex removeObject:indexPath];
        }
        else
        {
            [self.selectedIndex addObject:indexPath];
        }
        [self.collectionView reloadData];
    }
    else
    {
        DetailController *detailController = [[DetailController alloc] init];
        detailController.assetIndex = indexPath.row;
        [self.navigationController pushViewController:detailController animated:YES];
    }
}

- (void)loadAssets
{
    [[ImageManager sharedManager] loadAssetsFromGroup:self.group.originalData andCallbackBlock:^{
        [self.collectionView reloadData];
    }];
}

- (void)invalidateView
{
    [self loadAssets];
}

- (void)toggleEdteMode
{
    if ([self isEditing])
    {
        [self setEditing:NO];
        [self.selectedIndex removeAllObjects];
        [mPhotoBtn setEnabled:YES];
        [mDeleteBtn setEnabled:NO];
        self.navigationItem.rightBarButtonItem = mEditBtn;
    }
    else
    {
        [self setEditing:YES];
        [mPhotoBtn setEnabled:NO];
        [mDeleteBtn setEnabled:YES];
        self.navigationItem.rightBarButtonItem = mDoneBtn;
    }
    [self.collectionView reloadData];
}

- (void)didSwipe
{
    NSLog(@"swipe");
    [self setEditing:YES animated:YES];
    self.collectionView.allowsMultipleSelection = YES;
}

- (void)deleteItems
{
    if ([self isEditing])
    {
        [ImageManager sharedManager].isMyAction = YES;
        [[ImageManager sharedManager] deleteAssets:[self.selectedIndex copy] usingCallbackBlock:^{
            [self.collectionView reloadData];
            [ImageManager sharedManager].isMyAction = NO;
        }];
    }
}

- (void)popupDeleteRequest
{
    if ([self.selectedIndex count] > 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Delete!"
                                                        message:@"DeleteMessage"
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"Delete", nil];
        [alert show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        [self deleteItems];
    }
}

- (void)takePhoto
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.delegate = self;
        [ImageManager sharedManager].isMyAction = YES;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ERROR!"
                                                        message:@"User denied access camera"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [self dismissViewControllerAnimated:YES completion:nil];
    [[ImageManager sharedManager] saveImage:info[UIImagePickerControllerOriginalImage]
                                    toAlbum:self.group
                         usingCallbackBlock:^{
                             [ImageManager sharedManager].isMyAction = NO;
                         }];
}

@end
