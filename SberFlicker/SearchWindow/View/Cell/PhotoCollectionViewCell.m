//
//  PhotoCollectionViewCell.m
//  SberFlicker
//
//  Created by Сергей Грызин on 20/04/2019.
//  Copyright © 2019 Сергей Грызин. All rights reserved.
//

#import "PhotoCollectionViewCell.h"

@implementation PhotoCollectionViewCell

+(NSString *)reuseID
{
    return @"PhotoCollectionViewCellReuseID";
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (!(self = [super initWithFrame:frame])) return nil;
    [self.contentView setBackgroundColor:UIColor.clearColor];
//    self.picView = [[UIImageView alloc] initWithFrame:frame];
    self.picView = [UIImageView new];
    [self.contentView addSubview:self.picView];
    self.picView.clipsToBounds = YES;
    self.picView.layer.cornerRadius = 10.0f;
    [self.picView setBackgroundColor:UIColor.greenColor];
    [self fillCell];
    return self;
}

- (void)fillCell
{
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.picView.frame = self.contentView.frame;
}

- (void)prepareForReuse
{
    self.picView.image = nil;
}

@end
