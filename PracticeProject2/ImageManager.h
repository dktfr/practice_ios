//
//  ImageManager.h
//  PracticeProject2
//
//  Created by NHNEnt on 2016. 4. 5..
//  Copyright © 2016년 NHNEnt. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ALAssetsGroup;

@interface ImageManager : NSObject

@property (nonatomic, readonly) BOOL shouldUseNewLib;
@property (nonatomic, readonly) NSInteger numberOfGroups;
@property (nonatomic, readonly) NSArray *groups;
@property (nonatomic, readonly) NSInteger numberOfAssets;
@property (nonatomic, readonly) NSArray *assets;

+ (instancetype) sharedManager;

- (void) loadGroupUsingCompletedBlock:(void (^)(void))complete andFailedBlock:(void (^)(NSError *))fail;
- (void) loadAssetsFromGroup:(ALAssetsGroup *)group andCompleteBlock:(void (^)(void))complete;

@end