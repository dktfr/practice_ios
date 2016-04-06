//
//  GroupItem.m
//  PracticeProject2
//
//  Created by NHNEnt on 2016. 4. 5..
//  Copyright © 2016년 NHNEnt. All rights reserved.
//

#import "GroupItem.h"

@implementation GroupItem

- (instancetype) initFromALAssetsGroup:(ALAssetsGroup *)group
{
    self = [super init];
    if (self) {
        _title = [group valueForProperty:ALAssetsGroupPropertyName];
        _numberOfPhoto = [group numberOfAssets];
        _posterThumbnail = [[UIImage alloc] initWithCGImage:group.posterImage];
        _originalData = group;
    }
    return self;
}

@end
