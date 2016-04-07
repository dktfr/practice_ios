//
//  ImageManager.h
//  PracticeProject2
//
//  Created by NHNEnt on 2016. 4. 5..
//  Copyright © 2016년 NHNEnt. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UIImage;
@class GroupItem;
@class ALAssetsGroup;

@interface ImageManager : NSObject

@property (nonatomic, readonly) BOOL shouldUseNewLib;
@property (nonatomic, readonly) NSInteger numberOfGroups;
@property (nonatomic, readonly) NSArray *groups;
@property (nonatomic, readonly) NSInteger numberOfAssets;
@property (nonatomic, readonly) NSArray *selectedAssets;

@property (nonatomic) BOOL shouldUpdateGroups;
@property (nonatomic) BOOL shouldUpdateAssets;
@property (nonatomic) BOOL isMyAction;

+ (instancetype) sharedManager;

- (void)loadGroupUsingCallbackBlock:(void (^)(void))callback andFailedBlock:(void (^)(NSError *))fail;
- (void)loadAssetsFromGroup:(ALAssetsGroup *)group andCallbackBlock:(void (^)(void))callback;
- (void)saveImage:(UIImage *)image toAlbum:(GroupItem *)group usingCallbackBlock:(void (^)(void))callback;
- (void)createGroupWithTitle:(NSString *)groupTitle usingCallbackBlock:(void (^)(void))callback;
- (void)deleteAssets:(NSArray *)indexes usingCallbackBlock:(void (^)(void))callback;

@end
