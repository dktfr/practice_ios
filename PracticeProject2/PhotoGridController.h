//
//  ViewController.h
//  PracticeProject2
//
//  Created by NHNEnt on 2016. 4. 4..
//  Copyright © 2016년 NHNEnt. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GroupItem;

@interface PhotoGridController : UICollectionViewController

@property (nonatomic) NSInteger columnCount;
@property (nonatomic, strong) GroupItem *group;

@end

