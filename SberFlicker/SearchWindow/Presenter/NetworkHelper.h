//
//  NetworkHelper.h
//  SberFlicker
//
//  Created by Сергей Грызин on 19/04/2019.
//  Copyright © 2019 Сергей Грызин. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PhotoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface NetworkHelper : NSObject

+ (NSString *)URLFromSearchString:(NSString *)searchString;

@end

NS_ASSUME_NONNULL_END
