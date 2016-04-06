//
//  PhotoItem.h
//  PracticeProject2
//
//  Created by NHNEnt on 2016. 4. 5..
//  Copyright © 2016년 NHNEnt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <UIKit/UIKit.h>

@interface PhotoItem : NSObject

@property (nonatomic, readonly, strong) id originData;
@property (nonatomic, readonly) UIImage *thumbnail;
@property (nonatomic, readonly) UIImage *realImage;

+ (BOOL) isNewLibObject;

- (instancetype) initFromALAsset:(ALAsset *)asset;

@end
