//
//  DetailImageCell.m
//  PracticeProject2
//
//  Created by NHNEnt on 2016. 4. 6..
//  Copyright © 2016년 NHNEnt. All rights reserved.
//

#import "DetailImageCell.h"

@implementation DetailImageCell

- (void) awakeFromNib
{
    [super awakeFromNib];
    
    self.scrollView.minimumZoomScale = 1.0f;
    self.scrollView.maximumZoomScale = 4.0f;
    self.scrollView.bouncesZoom = YES;
    self.scrollView.delegate = self;
    
    UITapGestureRecognizer *doubleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didDoubleTapped)];
    doubleTapRecognizer.numberOfTapsRequired = 2;
    [self addGestureRecognizer:doubleTapRecognizer];
}

- (void)setContentSize:(CGSize)contentSize
{
    self.scrollView.bounds = self.bounds;
    self.imageView.bounds = self.bounds;
    self.scrollView.contentSize = contentSize;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

- (void)prepareForReuse
{
    self.scrollView.zoomScale = 1.0f;
}

- (void)didDoubleTapped
{
    NSLog(@"Gesture?");
    
    if (self.scrollView.zoomScale == 1.0f)
    {
        self.scrollView.zoomScale = 2.5f;
    }
    else
    {
        self.scrollView.zoomScale = 1.0f;
    }
}

@end
