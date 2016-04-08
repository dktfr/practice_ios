//
//  ViewController.h
//  PracticeProject2
//
//  Created by NHNEnt on 2016. 4. 4..
//  Copyright © 2016년 NHNEnt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InvalidateDelegate.h"

@class GroupItem;

@interface PhotoGridController : UICollectionViewController <UIAlertViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, InvalidateDelegate, UIGestureRecognizerDelegate>

@property (nonatomic) NSInteger columnCount;
@property (nonatomic, strong) GroupItem *group;

@end

