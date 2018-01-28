//
//  CustomCollectionViewCell.m
//  FlickrTableView
//
//  Created by Антон Полуянов on 23/01/2018.
//  Copyright © 2018 Антон Полуянов. All rights reserved.
//

#import "CustomCollectionViewCell.h"

@interface CustomCollectionViewCell()

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation CustomCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor whiteColor];
        
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectInset(self.bounds, 10, 10)];
        [self.contentView addSubview:self.imageView];
        
        UIView *selectedBackgroundView = [[UIView alloc] initWithFrame:CGRectZero];
        selectedBackgroundView.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.8f];
    }
    
    return self;
}

-(void)setImage:(UIImage *)image
{
    self.imageView.image = image;
}

// Here we remove all the custom stuff that we added to our subclassed cell
-(void)prepareForReuse
{
    [super prepareForReuse];
    
    // сбрасываем цвета и image
    self.backgroundColor = [UIColor whiteColor];
    self.image = nil;
}


@end
