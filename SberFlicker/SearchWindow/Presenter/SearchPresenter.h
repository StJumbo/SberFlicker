//
//  SearchPresenter.h
//  SberFlicker
//
//  Created by Сергей Грызин on 20/04/2019.
//  Copyright © 2019 Сергей Грызин. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkService.h"
#import "SearchRouter.h"

NS_ASSUME_NONNULL_BEGIN

@interface SearchPresenter : NSObject

@property (nonatomic, strong) NetworkService *netwotkDelegate;
@property (nonatomic, strong) SearchRouter *routerDelegate;

@end

NS_ASSUME_NONNULL_END
