//
//  PhotoItemCell.m
//  PracticeProject2
//
//  Created by NHNEnt on 2016. 4. 4..
//  Copyright © 2016년 NHNEnt. All rights reserved.
//

#import "PhotoItemCell.h"

@interface PhotoItemCell ()

@end

@implementation PhotoItemCell

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected
{
    super.selected = selected;
    if (selected)
        self.selectedImageView.backgroundColor = [UIColor redColor];
    else
        self.selectedImageView.backgroundColor = nil;
}

@end
