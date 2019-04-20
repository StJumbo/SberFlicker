//
//  ScrollViewController.h
//  SberFlicker
//
//  Created by Сергей Грызин on 20/04/2019.
//  Copyright © 2019 Сергей Грызин. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ScrollViewController : UIViewController

- (void)setCurrentPicture:(PhotoModel *)picture;

@end

NS_ASSUME_NONNULL_END
