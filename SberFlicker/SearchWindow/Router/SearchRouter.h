//
//  SearchRouter.h
//  SberFlicker
//
//  Created by Сергей Грызин on 20/04/2019.
//  Copyright © 2019 Сергей Грызин. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PhotoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SearchRouter : NSObject

- (void)setNavVC:(UINavigationController *) navVC;
- (void)showPushNotificationsWindow;
- (void)showCurrentPicture:(PhotoModel *)picture;

@end

NS_ASSUME_NONNULL_END
