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

- (instancetype) init
{
    @throw [NSException exceptionWithName:@"Initialize Exception" reason:@"This is a singleton class. Use sharedStore class method instead." userInfo:nil];
}

- (instancetype) initPrivate
{
    self = [super init];
    _privateGroups = [[NSMutableArray alloc] init];
    _privateSelectedAssets = [[NSMutableArray alloc] init];
//    if (NSClassFromString(@"PHAssetCollection")) {
//        _shouldUseNewLib = YES;
//    } else {
        _shouldUseNewLib = NO;
        self.assetsLibrary = [[ALAssetsLibrary alloc] init];
//    }
    return self;
}

#pragma mark - Property Method

- (NSInteger) numberOfGroups
{
    return [self.privateGroups count];
}

- (NSArray *) groups
{
    NSMutableArray *convertedGroups = [[NSMutableArray alloc] init];
    for (ALAssetsGroup *group in self.privateGroups) {
        [convertedGroups addObject:[[GroupItem alloc] initFromALAssetsGroup:group]];
    }
    
    return [convertedGroups copy];
}

- (NSInteger) numberOfAssets
{
    return [self.privateSelectedAssets count];
}

- (NSArray *) selectedAssets
{
    NSMutableArray *convertedAssets = [[NSMutableArray alloc] init];
    for (ALAsset *asset in self.privateSelectedAssets) {
        [convertedAssets addObject:[[PhotoItem alloc] initFromALAsset:asset]];
    }
    return [convertedAssets copy];
}

#pragma mark - DataManage Method

- (void) loadGroupUsingCallbackBlock:(void (^)(void))callback andFailedBlock:(void (^)(NSError *))fail
{
    [self.assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll
                                      usingBlock:^(ALAssetsGroup *group, BOOL *stop)
                                            {
                                                if (group) {
                                                    [self.privateGroups addObject:group];
                                                } else {
                                                    callback();
                                                }
                                            }
                                    failureBlock:^(NSError *error)
                                            {
                                                fail(error);
                                            }];
}

- (void) loadAssetsFromGroup:(ALAssetsGroup *)group andCallbackBlock:(void (^)(void))callback
{
    [self.privateSelectedAssets removeAllObjects];
    [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
        if (result) {
            [self.privateSelectedAssets addObject:result];
        } else {
            callback();
        }
        
    }];
}

@end
