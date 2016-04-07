//
//  DetailController.h
//  PracticeProject2
//
//  Created by NHNEnt on 2016. 4. 6..
//  Copyright © 2016년 NHNEnt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InvalidateDelegate.h"

@interface DetailController : UICollectionViewController <InvalidateDelegate>

@property (nonatomic) NSInteger assetIndex;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;

@end
