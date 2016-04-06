//
//  GroupItem.h
//  PracticeProject2
//
//  Created by NHNEnt on 2016. 4. 5..
//  Copyright © 2016년 NHNEnt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>

@interface GroupItem : NSObject

@property (nonatomic, readonly, strong) NSString *title;
@property (nonatomic, readonly) NSInteger numberOfPhoto;
@property (nonatomic, readonly, strong) UIImage *posterThumbnail;
@property (nonatomic, readonly, strong) id originalData;

- (instancetype) initFromALAssetsGroup:(ALAssetsGroup *)group;

@end
