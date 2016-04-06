//
//  PhotoItem.m
//  PracticeProject2
//
//  Created by NHNEnt on 2016. 4. 5..
//  Copyright © 2016년 NHNEnt. All rights reserved.
//

#import "PhotoItem.h"

@implementation PhotoItem

+ (BOOL) isNewLibObject
{
    if (NSClassFromString(@"PHAsset")) {
        return YES;
    } else {
        return NO;
    }
}

- (instancetype) initFromALAsset:(ALAsset *)asset
{
    self = [super init];
    if (self) {
        _originData = asset;
    }
    return self;
}

- (UIImage *) thumbnail
{
    ALAsset *castingAsset = (ALAsset *)self.originData;
    return [[UIImage alloc] initWithCGImage:castingAsset.thumbnail];
}

- (UIImage *) realImage
{
    ALAssetRepresentation *representation = [(ALAsset *)self.originData defaultRepresentation];
    return [[UIImage alloc] initWithCGImage:representation.fullScreenImage];
}

@end
