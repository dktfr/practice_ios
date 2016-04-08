//
//  ImageManager.m
//  PracticeProject2
//
//  Created by NHNEnt on 2016. 4. 5..
//  Copyright © 2016년 NHNEnt. All rights reserved.
//

#import "ImageManager.h"
#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "GroupItem.h"
#import "PhotoItem.h"

@interface ImageManager ()

@property (nonatomic, strong) ALAssetsLibrary *assetsLibrary;
@property (nonatomic, strong) NSMutableArray *privateGroups;
@property (nonatomic, strong) NSMutableArray *privateSelectedAssets;

- (instancetype) initPrivate;

@end

@implementation ImageManager

#pragma mark - Class Method

+ (instancetype) sharedManager
{
    static ImageManager *sharedManager;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] initPrivate];
    });
    return sharedManager;
}

#pragma mark - Initialize Method

- (instancetype)init
{
    @throw [NSException exceptionWithName:@"Initialize Exception" reason:@"This is a singleton class. Use sharedStore class method instead." userInfo:nil];
}

- (instancetype)initPrivate
{
    self = [super init];
    _privateGroups = [[NSMutableArray alloc] init];
    _privateSelectedAssets = [[NSMutableArray alloc] init];
//    if (NSClassFromString(@"PHAssetCollection")) {
//        _shouldUseNewLib = YES;
//    } else {
        _shouldUseNewLib = NO;
    self.shouldUpdateGroups = YES;
    self.shouldUpdateAssets = YES;
    self.isMyAction = NO;
        self.assetsLibrary = [[ALAssetsLibrary alloc] init];
    
//    }
    return self;
}

#pragma mark - Property Method

- (NSInteger)numberOfGroups
{
    return [self.privateGroups count];
}

- (NSArray *)groups
{
    NSMutableArray *convertedGroups = [[NSMutableArray alloc] init];
    for (ALAssetsGroup *group in self.privateGroups) {
        [convertedGroups addObject:[[GroupItem alloc] initFromALAssetsGroup:group]];
    }
    
    return [convertedGroups copy];
}

- (NSInteger)numberOfAssets
{
    return [self.privateSelectedAssets count];
}

- (NSArray *)selectedAssets
{
    NSMutableArray *convertedAssets = [[NSMutableArray alloc] init];
    for (ALAsset *asset in self.privateSelectedAssets) {
        [convertedAssets addObject:[[PhotoItem alloc] initFromALAsset:asset]];
    }
    return [convertedAssets copy];
}

#pragma mark - DataManage Method

- (void)loadGroupUsingCallbackBlock:(void (^)(void))callback andFailedBlock:(void (^)(NSError *))fail
{
    if (self.shouldUpdateGroups)
    {
        [self.privateGroups removeAllObjects];
        [self.assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll
                                          usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
                                                    if (group) {
                                                        [self.privateGroups addObject:group];
                                                    }
                                                    else {
                                                        self.shouldUpdateGroups = NO;
                                                        if (callback) {
                                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                                callback();
                                                            });
                                                        }
                                                    }
                                                }
                                        failureBlock:^(NSError *error) {
                                                    if (fail) {
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            fail(error);
                                                        });
                                                    }
                                                }];
    }
}

- (void)loadAssetsFromGroup:(ALAssetsGroup *)group andCallbackBlock:(void (^)(void))callback
{
    if (self.shouldUpdateAssets)
    {
        [self.privateSelectedAssets removeAllObjects];
        [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
            if (result) {
                [self.privateSelectedAssets addObject:result];
            } else {
                self.shouldUpdateAssets = NO;
                if (callback) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        callback();
                    });
                }
            }
        }];
    }
}

- (void)saveImage:(UIImage *)image toAlbum:(GroupItem *)group usingCallbackBlock:(void (^)(void))callback
{
    [self.assetsLibrary writeImageToSavedPhotosAlbum:image.CGImage
                                         orientation:(ALAssetOrientation)image.imageOrientation
                                     completionBlock:^(NSURL *assetURL, NSError *error) {
                                         [self.assetsLibrary assetForURL:assetURL resultBlock:^(ALAsset *asset) {
                                             ALAssetsGroup *assetGroup = (ALAssetsGroup *)group.originalData;
                                             [assetGroup addAsset:asset];
                                             [self.privateSelectedAssets addObject:asset];
                                             if (callback) {
                                                 dispatch_async(dispatch_get_main_queue(), ^{
                                                     callback();
                                                 });
                                             }
                                         } failureBlock:^(NSError *error) {
                                             NSLog(@"fail to save image");
                                         }];
                                     }];
}

- (void)createGroupWithTitle:(NSString *)groupTitle usingCallbackBlock:(void (^)(void))callback
{
    __weak ImageManager *weakManager = self;
    [self.assetsLibrary addAssetsGroupAlbumWithName:groupTitle
                                        resultBlock:^(ALAssetsGroup *group) {
                                            [weakManager.privateGroups addObject:group];
                                            if (callback) {
                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                    callback();
                                                });
                                            }
                                        }
                                       failureBlock:^(NSError *error) {
                                           NSLog(@"fail to create group");
                                       }];
}

- (void)deleteAssets:(NSArray *)indexes usingCallbackBlock:(void (^)(void))callback
{
    for (NSIndexPath *indexPath in indexes) {
        __weak ALAsset *asset = self.privateSelectedAssets[indexPath.row];
        if ([asset isEditable]) {
            [asset setImageData:nil metadata:nil completionBlock:^(NSURL *assetURL, NSError *error) {
                NSLog(@"????S");
                [self.privateSelectedAssets removeObject:asset];
                if (callback) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        callback();
                    });
                }
            }];
        }
    }
}

@end
