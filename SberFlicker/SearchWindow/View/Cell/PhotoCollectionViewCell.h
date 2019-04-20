//
//  PhotoCollectionViewCell.h
//  SberFlicker
//
//  Created by Сергей Грызин on 20/04/2019.
//  Copyright © 2019 Сергей Грызин. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PhotoCollectionViewCell : UICollectionViewCell

@property (nonatomic) UIImageView *picView;
+(NSString *)reuseID;

@end

NS_ASSUME_NONNULL_END
