//
//  ScrollPresenter.h
//  SberFlicker
//
//  Created by Сергей Грызин on 20/04/2019.
//  Copyright © 2019 Сергей Грызин. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkService.h"

NS_ASSUME_NONNULL_BEGIN

@interface ScrollPresenter : NSObject

@property (nonatomic, strong) NetworkService *netwotkDelegate;

@end

NS_ASSUME_NONNULL_END
