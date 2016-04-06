//
//  GroupItemCell.h
//  PracticeProject2
//
//  Created by NHNEnt on 2016. 4. 5..
//  Copyright © 2016년 NHNEnt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GroupItemCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *posterThumbnail;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;

@end
